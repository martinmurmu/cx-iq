class ReportGenerator < Valuable

  has_value :user_id
  has_value :product_id

  def run(threshold = '0.0075', mapping = '')
    paths = self.class.create_output_dir(self.product_id, self.user_id)
    product = Product.find(self.product_id)
    self.class.generate_map_file(mapping, paths[:map_file])
    self.class.generate_config(product.name, paths[:reviews_path], paths[:report_output_path], paths[:config_file], paths[:map_file], paths[:output_dir_prefix], paths[:map_output], threshold, mapping)
    self.class.dump_reviews(product, paths[:reviews_path])
    self.class.generate_report(paths[:config_file])
    paths[:public_path]
  end

  def self.process_output_map(file)
    out = ''
    f = File.open(file)
    f.each_line{|line|
      out += line if line.include? '=>'
    }
    out
  end

  def self.dump_reviews(product, output_dir, date_from = nil, date_to = nil)
    i = 0
    if date_from.nil? && date_to.nil?
      reviews = product.reviews
    else
      reviews = product.reviews.find(:all, :conditions => ['recieve_date <= ? AND recieve_date >= ?', date_to, date_from])
    end
    reviews.each{|r|
      File.open(File.join(output_dir, "review_#{i+=1}.txt"), 'w') {|f| f.write("##{r.id} , #{r.reviewer_name} , #{r.recieve_date} , #{r.source_url} \n#{r.text}") }
    }
  end

  def self.generate_report(config_file)
    Rails.logger.info "ReportGenerator::generate_report"
    classpath = "#{File.join(APP_CONFIG[:report_generator], 'lib', 'TextLabY2.jar')}:#{File.join(APP_CONFIG[:report_generator], 'lib', 'Chart2D.jar')}"
    cmd = "cd #{APP_CONFIG[:report_generator]} ; java -Xms400m -Xmx1300m -classpath '#{classpath}' report.ReportBuilderMain #{config_file}"
    Rails.logger.info "calling external report generator, running command: #{cmd}"
    system(cmd)
  end

  def self.create_output_dir(product_id, user_id)
    time = Time.now.to_i.to_s
    ret = {}
    path = "/reports/#{user_id.to_s}/#{time}/#{product_id.to_s}"
    ret[:time] = time
    ret[:path] = path
    ret[:user_id] = user_id
    ret[:product_id] = product_id
    ret[:work_dir] = File.join(RAILS_ROOT.to_s, 'tmp', 'reports', user_id.to_s, time.to_s, product_id.to_s)
    ret[:map_output] = File.join(ret[:work_dir], 'map_output.txt')
    ret[:report_output_path] = File.join(RAILS_ROOT, 'public', 'reports', user_id.to_s, time.to_s, product_id.to_s)
    ret[:reviews_path] = File.join(ret[:work_dir], 'reviews')
    ret[:config_file] = File.join(ret[:work_dir], 'REPORT_PARAMS.xml')
    ret[:map_file] = File.join(ret[:work_dir], 'map.txt')
    ret[:public_path] = "#{path}/REPORT.html"
    ret[:output_dir_prefix] = "#{APP_CONFIG['hostname']}#{path}"
    system("mkdir -p #{ret[:work_dir]}")
    system("mkdir -p #{ret[:report_output_path]}")
    system("mkdir -p #{ret[:reviews_path]}")
    ret
  end

  def self.generate_map_file(content, output_file)
    File.open(output_file, 'w') {|f| f.write(content) }
  end

  def self.generate_config(product_name, reviews_path, report_output_path, output_file, map_file, output_dir_prefix, map_output, threshold = nil, mapping = nil)

    params = <<eos
<?xml version="1.0" encoding="ISO-8859-1"?>
<REPORT_REQUEST>

<!-- the program uses product name  as a part of file names, so better to use only letters and digits and _ ! -->
<!-- DIR is a dir with review files if files contan more than one review separate it with line
#end
-->
<PRODUCTS>
<PRODUCT NAME="#{product_name.parameterize}"
         DIR="#{reviews_path}"/>
</PRODUCTS>

<PARAMS>
<!-- Any information to display in the top (2 string) of  REPORT.HTML file(date, name etc) -->
<PARAM NAME="REPORT_NAME" VALUE="Product: #{product_name.gsub('"', "''").gsub('&', "&amp;")}"/>

<!-- OUTPUT FORMAT may be XML or HTML -->
<PARAM NAME="REPORT_FORMAT" VALUE="HTML" />

<!-- REPORT_TYPE POSSIBLE VALUES: MANY_PRODUCTS, ONE_PRODUCT -->
<!-- IN THIS PRODUCTION VERSION WE ARE PLANING TO USE ONE_PRODUCT ONLY -->
<PARAM NAME="REPORT_TYPE" VALUE="ONE_PRODUCT" />

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
end
