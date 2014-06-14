class CiaReportGenerator < ReportGenerator
  has_value :product_ids

  def run(threshold = '0.0075', mapping = '')
    Rails.logger.info "CiaReportGenerator.run"
    paths = self.class.create_output_dir(self.product_ids.first, self.user_id)
    products = Product.find(self.product_ids)
    self.class.generate_map_file(mapping, paths[:map_file])
    self.class.generate_config(products.first.name, paths[:reviews_path], products, paths[:report_output_path], paths[:config_file], paths[:map_file], paths[:output_dir_prefix], paths[:map_output], threshold, mapping)
    products.each{|p|
      product_reviews_path = File.join(paths[:reviews_path], p.id)
      system("mkdir -p #{product_reviews_path}")
      self.class.dump_reviews(p, product_reviews_path)
    }
    self.class.generate_report(paths[:config_file])
    paths
  end


  def self.generate_config(report_name, reviews_path, products, report_output_path, output_file, map_file, output_dir_prefix, map_output, threshold = nil, mapping = nil)

    products_xml = ""
    products.each{|p|
      products_xml += "<PRODUCT NAME=\"#{p.name.parameterize}\"
         DIR=\"#{reviews_path}/#{p.id}\"/>"
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
<PARAM NAME="REPORT_NAME" VALUE="Product: #{report_name.gsub('"', "''").gsub('&', "&amp;")}"/>

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
  
end