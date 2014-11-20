jQuery.noConflict();
jQuery(document).ready(function(){
  jQuery("#product").autocomplete({url: "/products/auto_complete_for_product_name", minChars: 3});
})
