class TrendingReportGenerator < ReportGenerator

  def run(threshold = '0.0075', mapping = '')
    paths = self.class.create_output_dir(self.product_id, self.user_id)
    product = Product.find(self.product_id)
    self.class.generate_map_file(mapping, paths[:map_file])

    quarters = self.class.generate_quarters

    self.class.generate_config(product.name, paths[:reviews_path], product, quarters, paths[:report_output_path], paths[:config_file], paths[:map_file], paths[:output_dir_prefix], paths[:map_output], threshold, mapping)

    quarters.each{|q|
      product_reviews_path = File.join(paths[:reviews_path], q[2])
      system("mkdir -p #{product_reviews_path}")
      self.class.dump_reviews(product, product_reviews_path, q[0], q[1])
    }

    self.class.generate_report(paths[:config_file])
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