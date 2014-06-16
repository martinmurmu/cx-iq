require 'prawn/format' 

pdf.header pdf.margin_box.top_left do 
    stef = "#{RAILS_ROOT}/public/images/pdf_logo.png"
    pdf.image stef, :at => [530, 550], :scale => 0.5
end   
              
pdf.footer [pdf.margin_box.left, pdf.margin_box.bottom + 10] do
    pdf.text "Page #{pdf.page_count}", :size  => 8, :align => :center  
end

pdf.text "Product Reputation Market Intelligence Report for #{@report.category}", :style => :bold
pdf.text "Prepared for #{current_user.full_name}, #{current_user.company}"
pdf.text Date.today.strftime("%B %d, %Y")


items = @products.map do |item|
  [
    item.name,
    @manufacturers[item.attributes['manufacturer']],
    item.csi_score.to_s[0,4],
    item.functionality_score.to_s[0,4],
    item.reliability_score.to_s[0,4],
    item.support_score.to_s[0,4],
    item.reviews_count
  ]
end

pdf.bounding_box([pdf.bounds.left, pdf.bounds.top - 50], :width  => pdf.bounds.width, :height => pdf.bounds.height - 60) do
  pdf.table items, :border_style => :grid,
    :row_colors => ["FFFFFF","DDDDDD"],
    :position => :center,
    :headers => ["<b>Product Name</b>", "<b>Manufacturer</b>", "<b>CSI</b>", "<b>PFS</b>", "<b>PRS</b>", "<b>PSS</b>", "<b>No. of Reviews</b>"],
    :align => { 0 => :left, 1 => :right, 2 => :right, 3 => :right, 4 => :right, 5 => :right, 6 => :right },
    :column_widths => { 0 => 470, 1 => 96, 2 => 26, 3 => 26, 4 => 26, 5 => 26, 6 => 50 },
    :font_size  => 8
    
    pdf.move_down 20
    
    pdf.text  "As of #{Date.today.strftime("%B %d, %Y")} the #{@report.category} category contains metrics for #{@report.category.products.size} products based on the analysis of #{pluralize(@report.category.number_of_product_reviews, 'customer review')}", :style => :italic, :align => :center 
    
    pdf.move_down 20
    pdf.text  "Glossary", :style => :bold  
    pdf.stroke_horizontal_rule
    pdf.move_down 4
    pdf.text  "<b>CSI (Customer Satisfaction Index)</b> - The Customer Satisfaction Index is an aggregate measurement of the delta between a customer's expectation of a product and their actual experience with it."
    pdf.move_down 8
    pdf.text  "<b>PFS (Product Functionality Score)</b> - The Product Functionality Score measures the gap between customer expectations of a product and their actual experience with it."
    pdf.move_down 8
    pdf.text  "<b>PRS (Product Reliability Score)</b> - The Product Reliability Score measures the gap between the customer's expectations of a product's performance over its life-cycle and their actual experience with that product. A low reliability score points a Product Manager to potential problems in either the manufacturing or packaging processes that can be addressed before the erosion of their brand value begins."
    pdf.move_down 8
    pdf.text  "<b>PSS (Product Support Score)</b> - The Product Support Score measures the delta between the customer's expectations of a product's support against their actual experience. Currently it is an aggregate score that measures performance of a channel, delivery, and technical support organizations combined."
    
end                            
