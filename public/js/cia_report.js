DragAndDrop = false;
FakeAttributes = false; //test mode
if(window.location.hostname=='nkcomp.dyndns.org' || window.location.hostname=='localhost') {
  FakeAttributes = true;
}

function aggregate_attributes_events() {
				   $(".attribute").unbind("mouseDown").mousedown( function(event) {
                       if(!event.ctrlKey) {
					     $("#aggregate_attributes .selected").removeClass("selected");
					     $(this).addClass("selected");
					   } else {
						   if($(this).hasClass("selected")) {
							  $(this).removeClass("selected");
						   } else {
							  $(this).addClass("selected");
						   }
					   }
				   });

              if(DragAndDrop)
			  $(".attribute").draggable(
				{
				   zIndex: 1000,
				   start: function() { 
					   var offset = $(this).offset();
					   save_prev = $(this).prev();
					   $(this).detach().appendTo($("body")).css("position","absolute").css("margin-left",offset.left).css("margin-top",offset.top) 
					},

				   stop: function() { 
					       if(save_prev.length) {
						     $(this).detach().insertAfter(save_prev);
						   } else {
						     $(this).detach().prependTo($("#aggregate_attributes"));
						   }
						   $(this).css("position","relative").css("left", 0).css("top",0).css("margin-left",0).css("margin-top",0);
						} 
			    } 
			  );

}
function aggregate_add(name,attributes,index) {
				$("#aggregates").append("<div class=aggregate index="+index+" alt='tip'>"+name+"</div>");

				$("#aggregates .aggregate").unbind("mousedown").mousedown( function() {
                   $("#aggregates .selected").removeClass("selected");
				   $(this).addClass("selected");

				   $(".attribute").remove();

				   var attr = aggregates[$(this).attr("index")][1]

				   $.each(attr, function(index,val) {
					   $("#aggregate_attributes").append("<div class=attribute>"+val+"</div>");
				   });
		           $("#aggregate_attributes .attribute").tsort();
				   aggregate_attributes_events();

				});
}



function log(s) {
	window.console && window.console.log(s)
}
$(function() {

        $('.getAttributes').click(function() {
            $('#apply').hide();
            $('#loading_bar').show();
            var url;
						
						log("report type: "+report_type)
						if(report_type=='cia') {
						  url = '/product_groups/'+group_id+'/keywords?threshold=' + $('#slider').slider("option","value");
						  if(FakeAttributes) {
							  url = url + "&test_data=1";
						  }
						}
						
						if(report_type=='trending' || report_type=='psa') {
							url = "/products/"+product_id+"/"+report_type+"_report_keywords?threshold=" + $('#slider').slider("option","value");
						}
						
						log("getting url: "+url)
						
            $.getJSON(url, 
            function(data) {
              for($j=1;$j<=$last;$j++){
                $('#checkbox'+$j).remove();
              }
              $('label').remove();
              $j=1
              $.each(data, function(key, val) {
                if (val.attr == undefined){
                  $('#pr_checkboxes').append('<span class="attr_holder"> <label for="checkbox'+$j+'" id="label'+$j+'">'+val+'</label><input name="checkbox'+$j+'" id="checkbox'+$j+'" type="checkbox" class="crirHiddenJS"  /><span/>');  
                } else {
                  $('#pr_checkboxes').append('<span class="attr_holder"> <label for="checkbox'+$j+'" id="label'+$j+'">'+val.attr+'</label><span class="attr_imp"> - '+val.importance+'%</span><input name="checkbox'+$j+'" id="checkbox'+$j+'" type="checkbox" class="crirHiddenJS"  /><span/>');
                }  
                $j++
              });
              $last = $j;
              crir.init();
              $('#loading_bar').hide();
              $('#apply').show();

              if(DragAndDrop)
			  $("#pr_checkboxes label").draggable(
				{
				   zIndex: 1000,
				   start: function() { 
					   var offset = $(this).offset();
					   save_prev = $(this).prev();
					   $(this).detach().appendTo($("body")).css("position","absolute").css("margin-left",offset.left).css("margin-top",offset.top) 
					},

				   stop: function() { 
					       if(save_prev.length) {
						     $(this).detach().insertAfter(save_prev);
						   } else {
						     $(this).detach().prependTo($("#pr_checkboxes"));
						   }
						   $(this).css("position","relative").css("left", 0).css("top",0).css("margin-left",0).css("margin-top",0);
						} 
			    } 
			  );

              $.each(aggregates, function(i,aggr) {
				  $.each(aggr[1], function(j, val) {
                     $("#pr_checkboxes span.attr_holder:contains('"+val+"')").hide();
			      });
			  });
            });

        });

   $("#Select1").after("<div id='aggregates_wrap'><div id='aggregates'></div><div id='pr_delete' class='button'>Delete </div></div>");
   $("#Select1").after("<div id='attributes_wrap'> <div id='aggregate_attributes'></div> <div id='attr_delete' class=button>Delete</div> </div>");
   $("#Select1").after("<div id='saved_notify'>Settings have been saved</div>");
   $("#Select1").hide();
   $("#pr_add").after("");


   if(DragAndDrop)
   $("#pr_checkboxes").droppable( {
     drop: function(event, ui) {
	    if(ui.draggable.hasClass("attribute")) {
					       if(save_prev.length) {
						     ui.draggable.detach().insertAfter(save_prev);
						   } else {
						     ui.draggable.detach().prependTo($("#aggregate_attributes"));
						   }
            $("#attr_delete").trigger("mousedown");
		} else {
			return false;
		}


	 }

   } );
     if(DragAndDrop)
   $("#aggregate_attributes").droppable( {
      drop: function(event,ui) {
		if(!ui.draggable.is("label")) return false;
	    var group = $("#aggregates .selected").index();
		if(group!=-1) {
		  var attribute = ui.draggable.html();
          aggregates[group][1].push(attribute);
		  $("#aggregate_attributes").append("<div class='attribute'>"+attribute+"</div>");
		  $("#aggregate_attributes .selected").removeClass("selected");
		  $("#aggregate_attributes .attribute").last().addClass("selected");
		  $("#aggregate_attributes .attribute").tsort();
		  aggregate_attributes_events();
		  aggregates_save();
		  ui.draggable.hide();
		}
	  }
     }
   );

   $("#attr_delete").mousedown( function() {
	  var group = $("#aggregates .selected").index();
	  if(group==-1) return;
	  var single = ($("#aggregate_attributes .selected").length==1)
	  if(single) {
        selected_i = $("#aggregate_attributes .selected").index();
	  }
	  $("#aggregate_attributes .selected").each( function() {
		 i = $(this).index();
		 var attr_name = aggregates[group][1][i]
         aggregates[group][1].splice(i,1)	    
		 $("#pr_checkboxes label:contains("+attr_name+")").show().removeClass("checkbox_checked").addClass("checkbox_unchecked");

	     $(this).remove();
	  });

      if(single) {
		 $("#aggregate_attributes .attribute:eq("+selected_i+")").addClass("selected");
		 if($("#aggregate_attributes .selected").length==0) {
			 $("#aggregate_attributes .attribute").last().addClass("selected");
		 }
      }
      aggregates_save();
   });

   $("#pr_delete").click( function() {
      var selected = $("#aggregates .selected");
	  if(selected.length==0) {
		  selected = $("#aggregates .aggregate").last();
	  }
	  if(selected.length==0) return;
	  var i = selected.attr("index");
	  var eq = selected.index();
	  var attributes = aggregates[i][1];
	  $.each(attributes, function(index,val) {
         $("#pr_checkboxes label:contains('"+val+"')").show().removeClass("checkbox_checked").addClass("checkbox_unchecked");
	  });
	  aggregates.splice(i,1)
	  selected.remove()
	  $(".attribute").remove();
	  aggregates_save();

	  $("#aggregates .aggregate").each( function() {
        if($(this).attr("index")>i) {
			$(this).attr("index",$(this).attr("index")-1);
		}
	  });

		 $("#aggregates .aggregate:eq("+eq+")").trigger("mousedown");
		 if($("#aggregates .selected").length==0) {
			 $("#aggregates .aggregate").last().trigger("mousedown");
		 }

   });

	 aggregates_load();
	 
   $("#pr_add").click( function() {
            if(!$('#pr_text').val()) 
                alert("Please give the aggregate a name!!");
            else{
                var attributes = [];
                aggregateName = $('#pr_text').val();
                for($j=1;$j<=$last;$j++)
                    if($('#checkbox'+$j+":checked").val()){
                        attributes.push($('#label'+$j).text());
                        //attributes.push($('#checkbox'+$j).val());
                        $('#label'+$j).hide();
                        $('#checkbox'+$j).hide();
                        $('#checkbox'+$j).attr('checked', false);

                    }
                aggregates.push([aggregateName,attributes]);
                $("#Select1").append("<option>"+$("#pr_text").val()+"</option>");

                aggregate_add($("#pr_text").val(),attributes,(aggregates.length-1));
								$("#aggregates .selected").removeClass("selected");
								$("#aggregates .aggregate").last().addClass("selected").trigger("mousedown");
								$("#aggregates .aggregate").tsort();
								aggregates_save();
								
								document.getElementById("pr_text").value = "";

            }
   });
});


function aggregates_save() {
	var url;
	switch(report_type) {
		case 'cia':
	    url = "/product_groups/"+group_id+"/aggregates_set";
			break;
		case 'psa':
		case 'trending':
			url = "/products/"+product_id+"/report_settings_set?type="+report_type;
			break;
		default:
		  return;
	}
	
	
	$.post(url, { data: serialize(aggregates), authenticity_token:  encodeURIComponent( AUTH_TOKEN ) })
	$("#saved_notify").show().delay(1000).fadeOut();
}

function aggregates_load() {
	 var url;
	 switch(report_type) {
		 case 'cia':
	     url = "/product_groups/"+group_id+"/aggregates_get";
			 break;
		 case 'trending':
		 case 'psa':
			 url = "/products/"+product_id+"/report_settings_get?type="+report_type;
			 break;
		 default:
		   return;
	 }
		
	 log("aggregates load: "+url)
   $.get(url, function(data) {
			if($.trim(data)) {
					data = unserialize(data);
					aggregates = [];
					$.each(data, function(index,val) {
				 var name = val[0];
				 var attributes = []
				 $.each(val[1],function(i,val) {
					 attributes.push(val);
								 $("#pr_checkboxes label:contains('"+val+"')").hide();
				 });
				 aggregates.push([name,attributes])
			});

			$.each(aggregates, function(index,val) {
				 aggregate_add(val[0],val[1],index);
			});
			$("#aggregates .aggregate").tsort();
	  }
   });
}
