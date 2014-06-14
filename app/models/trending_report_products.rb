class TrendingReportProducts < ReportGenerator

  has_value :product_group_id

  def self.create_output_dir(product_group_id, user_id)
    time = Time.now.to_i.to_s
    ret = {}
    path = "/reports/#{user_id.to_s}/#{time}/#{product_group_id.to_s}"
    ret[:time] = time
    ret[:path] = path
    ret[:user_id] = user_id
    ret[product_group_id] = product_group_id
    ret[:work_dir] = File.join(RAILS_ROOT.to_s, 'tmp', 'reports', user_id.to_s, time.to_s, product_group_id.to_s)
    ret[:report_output_path] = File.join(RAILS_ROOT, 'public', 'reports', user_id.to_s, time.to_s, product_group_id.to_s)
    ret[:public_path] = "#{path}"
    ret[:output_dir_prefix] = "#{APP_CONFIG['hostname']}#{path}"
    system("mkdir -p #{ret[:work_dir]}")
    system("mkdir -p #{ret[:report_output_path]}")
    ret
  end

  def self.create_output_generator_dir(ret, product_id)
    output_path = {}
    output_path[:map_output] = File.join(ret[:work_dir], product_id, 'map_output.txt')
    output_path[:reviews_path] = File.join(ret[:work_dir], product_id, 'reviews')
    output_path[:config_file] = File.join(ret[:work_dir], product_id, 'REPORT_PARAMS.xml')
    output_path[:map_file] = File.join(ret[:work_dir], product_id, 'map.txt')
    output_path[:report_output_path] = File.join(ret[:report_output_path], product_id)
    system("mkdir -p #{output_path[:reviews_path]}")
    system("mkdir -p #{output_path[:report_output_path]}")
    output_path
  end

  def run(threshold = '0.0075', mapping = '')
    paths = self.class.create_output_dir(self.product_group_id, self.user_id)
    products = ProductGroup.find(self.product_group_id).products

    unenough_history_product = ""
    quarters = self.class.generate_quarters
    
    products.each do |product|
      if product.reviews.exists?(['recieve_date <= ? AND recieve_date >= ?', self.class.generate_quarters.first[1], self.class.generate_quarters.last[1]])
        output_generator_paths = self.class.create_output_generator_dir(paths, product.id)
        self.class.generate_map_file(mapping, output_generator_paths[:map_file])

        self.class.generate_config(product.name, output_generator_paths[:reviews_path],
          product, quarters, output_generator_paths[:report_output_path], output_generator_paths[:config_file],
          output_generator_paths[:map_file], paths[:output_dir_prefix], output_generator_paths[:map_output],
          threshold, mapping
        )

        quarters.each{|q|
          product_reviews_path = File.join(output_generator_paths[:reviews_path], q[2])
          system("mkdir -p #{product_reviews_path}")
          self.class.dump_reviews(product, product_reviews_path, q[0], q[1])
        }

        self.class.generate_report(output_generator_paths[:config_file])
      else
        unenough_history_product += product.name + "|"
      end
    end

    unless unenough_history_product == ""
      File.open("#{RAILS_ROOT}/public/#{paths[:public_path]}/unenough_history_product.txt", 'w') do |f|
        f.puts unenough_history_product
      end
    end

    paths[:public_path]
  end


  def self.generate_config(product_name, reviews_path, product, quarters, report_output_path, output_file, map_file, output_dir_prefix, map_output, threshold = nil, mapping = nil)

    products_xml = ""
    quarters.each{|q|
      products_xml += "<PRODUCT NAME=\"#{q[2]}\"
         DIR=\"#{reviews_path}/#{q[2]}\"/>"
    }

    params = <<eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<REPORT_REQUEST>

<!-- the program uses product name  as a part of file names, so better to use only letters and digits and _ ! -->
<!-- DIR is a dir with review files if files contan more than one review separate it with line
#end
-->
<PRODUCTS>
#{ products_xml }

</PRODUCTS>
<PARAMS>
<!-- Any information to display in the top (2 string) of  REPORT.HTML file(date, name etc) -->
<PARAM NAME="REPORT_NAME" VALUE="Product: #{product_name.gsub('"', "''").gsub('&', "&amp;")}"/>

<!-- OUTPUT FORMAT may be XML or HTML -->
<PARAM NAME="REPORT_FORMAT" VALUE="HTML" />

<!-- REPORT_TYPE POSSIBLE VALUES: MANY_PRODUCTS, ONE_PRODUCT -->
<!-- IN THIS PRODUCTION VERSION WE ARE PLANING TO USE ONE_PRODUCT ONLY -->
<PARAM NAME="REPORT_TYPE" VALUE="MANY_PRODUCTS" />

<!-- Output dir for all report files  -->
<!-- The program can create this dir but it does not delete any existing files from it  -->
<PARAM NAME="OUTPUT_DIR" VALUE="#{report_output_path}/"/>

<!-- These map files are optional. Can be used for merging and renaming atributes in report by the user  -->
<!-- It can contain user specific attribute names mapping   " oldname => newname " -->
<!-- INPUT_MAP_FILE contains lines with all processing attributes in form "name => name" -->
<!-- OUTPUT_MAP_FILE can be used fo futher manual editing   -->
<PARAM NAME="INPUT_MAP_FILE" VALUE="#{map_file}"/>
<PARAM NAME="OUTPUT_MAP_FILE" VALUE="#{map_output}"/>

<!-- prefix to add to table.csv file  -->
<PARAM NAME="OUTPUT_DIR_PREFIX" VALUE="#{output_dir_prefix}/"/>
in REPORT_PARAMS.xml file


<!-- ATTRIBUTES_SET VALUES: ALL (low level attributes), RFS (reliability, functionality support attributes only) -->
<PARAM NAME="ATTRIBUTES_SET" VALUE="ALL" />

<!-- minimal snippets in dispayed atribute: reasonable values from 0.0035 to 0.02  -->
<!-- 0.01 for example means that all attributes with less than 1% snippets will be merged in "other attributes" attribute -->
<PARAM NAME="MIN_ATTRIBUTE" VALUE="#{threshold.blank? ? '0.0075' : threshold}" />
</PARAMS>
</REPORT_REQUEST>
eos


    File.open(output_file, 'w') {|f| f.write(params) }

  end

  def self.generate_quarters
    quarters = []
    q = Date.today.beginning_of_quarter
    6.times {
      q = q - 3.months

      if q.month <= 3
        name = 'Q1'
      elsif q.month <= 6
        name = 'Q2'
      elsif q.month <=9
        name = 'Q3'
      else
        name = 'Q4'
      end
      name = "#{q.year}#{name}"
      quarters << [q.beginning_of_quarter, q.end_of_quarter, name]
    }
    quarters
  end

end