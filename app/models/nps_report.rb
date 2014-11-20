#require 'prawn/format'

class NpsReport < ActiveRecord::Base
  self.table_name = "prm_product_reports"

  has_many :report_manufacturers,  :foreign_key => 'report_id', :dependent => :destroy
  has_many :manufacturers, :through => :report_manufacturers
  
  has_many :report_product_filters, :foreign_key => 'report_id', :dependent => :destroy
  has_many :filtered_products, :through => :report_product_filters
  
  belongs_to :product_category, :polymorphic => true #, :foreign_key => 'product_category_id'
  belongs_to :user

  has_many :sent_reports, :as => :usage

  validates_presence_of :product_category, :message => "is not selected"

  per_page = 20
  filtered = false
  
  NumberOfReviewsOptions = [{:id => 1, :name => 'All'}, {:id => 2, :name => '&gt; 100'}, {:id => 4, :name => '&gt; 50'}, {:id => 5, :name => '&gt; 25'},  {:id => 3, :name => '&lt; 100'}]
  NpsOptions = [{:id => 1, :name => 'All'}, {:id => 2, :name => 'Positive', :sql => ' < 50'}, {:id => 3, :name => 'Negative', :sql => ' > 50'}]
  RatingOptions = [{:id => 1, :name => 'All'}, {:id => 4, :name => 'Does not equal 0', :sql => ' != 0' }, {:id => 2, :name => '&lt; 0', :sql => ' < 0'}, {:id => 3, :name => '&gt; 0', :sql => ' > 0'}]
  SortMethod = [{:id => 1, :name => 'Customer Satisfaction Index Score', :field=> 'product.csi_score'}, {:id => 2, :name => 'Product Functionality Score', :field=> 'product.functionality_score'}, {:id => 3, :name => 'Product Reliability Score', :field=> 'product.reliability_score'}, {:id => 4, :name => 'Product Support Score', :field=> 'product.support_score'}, {:id => 5, :name => 'Product name', :field=> 'product.name'}, {:id => 6, :name => 'Manufacturer', :field=> 'manufacturer.name'}, {:id => 7, :name => 'Number of reviews', :field=> 'all_reviews_count'}]
  SortMethodNps = [{:id => 3, :name => 'Net Promoter Score', :field=> 'product.nps_score'}, {:id => 1, :name => 'Product name', :field=> 'product.name'}, {:id => 2, :name => 'Manufacturer', :field=> 'manufacturer.name'},{:id => 4, :name => 'Last Update', :field=> 'product.last_update'}, {:id => 5, :name => 'Number of reviews', :field=> 'all_reviews_count'}]
  SortOrder = [{:id => 2, :name => 'Descending'}, {:id => 1, :name => 'Ascending'}]
  LAST_UPDATED_FILTER_OPTIONS = [{:id => 1, :name => 'All'}, {:id => 2, :name => 'within 30 days'}, {:id => 3, :name => 'within 90 days'}, {:id => 4, :name => 'within a year'}]

  include ActionView::Helpers::NumberHelper

  def items_per_page
    (per_page.blank? || per_page <=0) ? 20 : per_page
  end
  
  #Re-defining the default association method as at this point the product and report_product_filters tables are in separate DBs.
  #Should be removed as they are merged. Weird, right?
  def filtered_products
    @filtered_products ||= Product.find(self.report_product_filters.map{|e| e.product_id})
  end
  
  def filtered_product_ids
    filtered_product_ids ||= self.report_product_filters.map{|e| e.product_id}
  end
  
  def add_filtered_product_ids (values)
    products = Product.find(values)
    products.each{|product|
      ReportProductFilter.create!(:report_id => id, :product_id => product.id)
    }
  end
  
  def products(page, per_page)
    @products ||= find_products(page, per_page)
  end
  
  def toggle_sorting_order
    update_attribute('sorting_order', sorting_order == 1 ? 2 : 1)
  end
  
  def filtered?
    attributes['filtered'] == true
  end
  
  def reset_filter
    ReportProductFilter.destroy_all(["report_id = ?", id])
    update_attribute('filtered', false)
  end
  
  def enable_filter
    update_attribute('filtered', true)    
  end 
              
  #TODO: should be removed after DB merge
#  def category
#    product_category
#  end
  
  def generate_csv
    @products = products(1, 999999)
    @manufacturers = Manufacturer.names_by_ids(@products.map{|p| p.attributes['manufacturer']})
    @products.to_comma(:style => :nps, :custom_data => {:manufacturers => @manufacturers})

  end
  
  def generate_pdf(user)
    @products = products(1, 999999)
    @manufacturers = Manufacturer.names_by_ids(@products.map{|p| p.attributes['manufacturer']})
    @report = self
    
    pdf = Prawn::Document.new( :page_layout => :landscape,
                                    :info => {
                                      :Title => "", :Author => "Amplified Analytics Inc.", :Subject => "NPS Report",
                                      :Keywords => "", :Creator => "Amplified Analytics Inc.", 
                                      :Producer => "", :CreationDate => Time.now, :Grok => "Amplified Analytics Inc."
                                    }
                              ) do |pdf|
      pdf.header pdf.margin_box.top_left do 
          stef = "#{RAILS_ROOT}/public/images/pdf_logo.png"
          pdf.image stef, :at => [530, 550], :scale => 0.5
      end   

      # pdf.footer [pdf.margin_box.left, pdf.margin_box.bottom + 10] do
      #     pdf.text "Page #{pdf.page_count}", :size  => 8, :align => :center  
      # end

      pdf.text "NPS® Report for #{@report.category}, Prepared for #{user.full_name}, #{user.company}  #{Date.today.strftime("%B %d,%Y")}"


      items = @products.map do |item|
        [
          item.name,
          @manufacturers[item.attributes['manufacturer']],
          number_with_delimiter(item.nps_score, :delimiter => ','),
          item.last_update.strftime("%m-%d-%Y"),
          number_with_delimiter(item.reviews_count, :delimiter => ',')
        ]
      end

      pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 50], :width  => pdf.bounds.width, :height => pdf.bounds.height - 60) do
        pdf.table items, :border_style => :grid,
          :row_colors => ["FFFFFF","DDDDDD"],
          :position => :center,
          :headers => ["<b>Product Name</b>", "<b>Manufacturer</b>", "<b>NPS</b>","<b>Last Update</b>", "<b>No. of Reviews</b>"],
          :align => { 0 => :left, 1 => :right, 2 => :right, 3 => :right, 4 => :right },
          :column_widths => { 0 => 470, 1 => 96, 2 => 52, 3 => 52, 4=>52 },
          :font_size  => 8

          pdf.move_down 20
          pdf.text 	"NPS®, Net Promoter and Net Promoter Score are registered trademarks of Satmetrix Systems, Inc., Bain & Company and Fred Reichheld."
          pdf.move_down 20
          pdf.text  "These scores are the result of aggregation and analysis of the unsolicited, online customer reviews processed with Opinion Miner® software. No survey was conducted and no questions were asked."
          pdf.move_down 20
          pdf.text "The study is continuous. The score stated was gathered from reviews posted  #{last_updated_filter_string}"
          pdf.move_down 20
          pdf.text "#{number_with_delimiter(@report.category.number_of_product_reviews, :delimiter => ',')} customers contributed their reviews for this analysis"



          pdf.move_down 20
          pdf.text  "Glossary", :style => :bold  
          pdf.stroke_horizontal_rule
          pdf.move_down 4
          pdf.text  "The NPS &#174; is a weighted ratio of Promoters vs Detractors, calculated in accordance to the Net Promoter Score methodology."


      end
    end
    pdf.render
  end
  
  def manufacturer_ids
    ReportManufacturer.find(:all, :conditions => ["report_id = ?", id]).map{|man| man.manufacturer_id}
  end

  def category
    product_category
  end

  def category=(val)
    self.product_category=val
  end


  private

  def find_products(page, per_page)
    #TODO should be revised to use count(*)
    total = Product.joins(:manufacturer).where(conditions).select("product.id").group("product.id").order(order_field_and_type).group("product.all_reviews_count, product.nps_score").size
    Product.joins(:manufacturer).where(conditions).select("product.id").group("product.id").order(order_field_and_type).group("product.all_reviews_count, product.nps_score").paginate(total_entries: total, page: page, per_page: per_page)
    #Product.paginate(:total_entries => total, :joins => [:manufacturer], :select => "product.*", :group => "product.id", :conditions => conditions, :order => order_field_and_type, :page => page, :per_page => per_page, :group => "product.all_reviews_count, product.nps_score")
  end
  
  def order_field_and_type
    order = "#{get_sort_field_name_by_id(sorting_field)}"
    unless order.blank?
      if sorting_order == 2
        order += " DESC"
      else
        order += " ASC"
      end
    end
  end
  
  def get_sort_field_name_by_id(id)
    SortMethodNps.each{|e|
      return e[:field] if e[:id] == id
    }
    ""
  end
  
  def get_rating_option_by_id(id)
    RatingOptions.each{|e|
      return e if e[:id] == id
    }
    {}
  end

  def get_pos_option_by_id(id)
    NpsOptions.each{|e|
      return e if e[:id] == id
    }
    {}
  end



  def manufacturer_conditions
    if report_manufacturers.size > 0
      options = []
      report_manufacturers.each{|man|
        options << ["product.manufacturer = '#{man.manufacturer_id}'"]
      }
      return ["(" + options.join(' OR ') + ")"]
    end
  end
  
  def category_conditions
    if product_category_id > 0
      ["product.id IN (#{product_category.product_ids.map{|p| "'#{p}'"}.join(',')})"]
      #["product.id IN (SELECT product_id from product_category where category_id=#{product_category_id})"]
    end
  end
  
  def product_conditions
    if filtered?
      ids = "('" + filtered_product_ids.join("' , '") + "')"
      ["product.id IN #{ids}"]
    end
  end

  def csi_conditions
    opt = get_rating_option_by_id(csi_range)
    ["product.csi_score #{opt[:sql]}"] unless opt[:sql].blank?
  end


  def nps_conditions
    opt = get_rating_option_by_id(nps_range)
    ["product.nps_score #{opt[:sql]}"] unless opt[:sql].blank?
  end

  def pfs_conditions
    opt = get_rating_option_by_id(pfs_range)
    ["product.functionality_score #{opt[:sql]}"] unless opt[:sql].blank?
  end

  def prs_conditions
    opt = get_rating_option_by_id(prs_range)
    ["product.reliability_score #{opt[:sql]}"] unless opt[:sql].blank?
  end
  
  def pss_conditions
    opt = get_rating_option_by_id(pss_range)
    ["product.support_score #{opt[:sql]}"] unless opt[:sql].blank?
  end
  
  def number_of_reviews_conditions
    if number_of_reviews == 2
      return ["all_reviews_count > 100"]
    elsif number_of_reviews == 3
      return ["all_reviews_count < 100"]
    elsif number_of_reviews == 4
      return ["all_reviews_count > 50"]
    elsif number_of_reviews == 5
      return ["all_reviews_count > 25"]
    end
  end

  def last_updated_filter_conditions
    if last_updated_filter == 2
      return ["product.last_update > '#{(Date.today - 30.days).to_s(:db)}'"]
    elsif last_updated_filter == 3
      return ["product.last_update > '#{(Date.today - 90.days).to_s(:db)}'"]
    elsif last_updated_filter == 4
      return ["product.last_update > '#{(Date.today - 1.year).to_s(:db)}'"]
    end
  end

  def last_updated_filter_string
    if last_updated_filter == 2
      return "within 30 days"
    elsif last_updated_filter == 3
      return "within 90 days"
    elsif last_updated_filter == 4
      return "within a year"
    else
      return "from the launch date"
    end
  end

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end

end
