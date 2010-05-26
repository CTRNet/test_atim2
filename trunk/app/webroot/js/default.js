function checkAll( $div ) {
	
	// check compatibility
	if ( !document.getElementsByTagName ) return false;
	if ( !document.getElementById ) return false;
	
	// check existing IDs and attributes
	if ( !document.getElementById( $div ) ) return false;
	
	allInputs = document.getElementById( $div ).getElementsByTagName( 'input' );
	for ( var i=0; i<allInputs.length; i++ ) {
		if ( allInputs[i].getAttribute('type')=='checkbox' ) {
			// allInputs[i].setAttribute('checked', 'checked');
			allInputs[i].checked = true;
		}
		
	}
	
}

function uncheckAll( $div ) {
	
	// check compatibility
	if ( !document.getElementsByTagName ) return false;
	if ( !document.getElementById ) return false;
	
	// check existing IDs and attributes
	if ( !document.getElementById( $div ) ) return false;
	
	allInputs = document.getElementById( $div ).getElementsByTagName( 'input' );
	for ( var i=0; i<allInputs.length; i++ ) {
		if ( allInputs[i].getAttribute('type')=='checkbox' ) {
			allInputs[i].checked = false;
		}
		
	}
	
}
	
/*
	admin editors, expandable list of elements
	individual elements should be wrapped in p tags, and those p tags wrapped in a containing div
	fields (input, etc) should obviously have array names as they will be exact clones
*/

	function clone_fields(containing_div) {
		
		div = document.getElementById(containing_div); // div containing add artist selects/inputs
		ps = div.getElementsByTagName("p"); // ps is array of p tags in div
		
		new_p = ps[ps.length-1].cloneNode(true); // make copy of last p tag and all elements it contains
		
		div.appendChild(new_p); // append newly copied p tag inside div
		
	}
	
	function remove_fields(p) {
	
		a = p.parentNode; // a tag is parent of onclick attribute
		div = a.parentNode; // div is parent of a tag
		
		ps = div.getElementsByTagName("p"); // ps is array of p tags in div
		
		if ( ps.length>1 ) { // if more than one p tag in div...
			div.removeChild(a); // remove p tag that a tag is in
		} else {
			alert('Sorry, you cannot remove all of these field sets.'); // alert message
		}
		
	}
	
	function getJsonFromClass(cssClass){
		var startIndex = cssClass.indexOf("{");
		return eval ('(' + cssClass.substr(startIndex, cssClass.lastIndexOf("}") - startIndex + 1) + ')');
	}
	
	$(function(){
		//field highlighting
		if($("#table1row0").length == 1){
			//gridview
			$('form').highlight('td');
		}else{
			$('form').highlight('tr');
		}
		
		//tree view controls
		$(".reveal:not(.not_allowed)").each(function(){
			var json = getJsonFromClass($(this).attr("class"));
			$(this).toggle(function(){
				$("#tree_" + json.tree).stop(true, true);
				$("#tree_" + json.tree).show("blind", {}, 350);
			}, function(){
				$("#tree_" + json.tree).stop(true, true);
				$("#tree_" + json.tree).hide("blind", {}, 350);
			});
		});
		
		//ajax controls
		//evals the json within the class of the element and calls the method defined in callback
		//the callback method needs to take this and json as parameters
		$(".ajax").click(function(){
			var json = getJsonFromClass($(this).attr("class"));
			var fct = eval("(" + json.callback + ")");
			fct.apply(this, [this, json]);
			return false;
		});
		
		//autocomplete controls
		$(".jqueryAutocomplete").each(function(){
			var json = getJsonFromClass($(this).attr("class"));
			var fct = eval("(" + json.callback + ")");
			fct.apply(this, [this, json]);
			return false;
		});

		initAdvancedControls();
		initTooltips();
		
		//calendar controls
		$.datepicker.setDefaults($.datepicker.regional[locale]);
		$(".datepicker").each(function(){
			initDatepicker(this);
		});
		//datepicker style
		$("#ui-datepicker-div").addClass("jquery_cupertino");
		//autocomplete style
		$(".ui-autocomplete").addClass("jquery_cupertino");
		
	});

	function initDatepicker(element){
		var tmpId = element.id.substr(0, element.id.indexOf("_button"));
		var tmpSuffix = element.id.indexOf("_button_") != -1 ? "_" + element.id.substr(element.id.indexOf("_button_") + 8) : "";
		if($('#' + tmpId + tmpSuffix).val().length > 0 && $('#' + tmpId + "-mm" + tmpSuffix).val().length > 0 && $('#' + tmpId + "-dd" + tmpSuffix).val().length > 0){
			//set the current field date into the datepicker
			$(element).data('val', $('#' + tmpId + tmpSuffix).val() + "-" + $('#' + tmpId + "-mm" + tmpSuffix).val() + "-" + $('#' + tmpId + "-dd" + tmpSuffix).val());
		}
		$(element).datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: 'yy-mm-dd',
			maxDate: '2100-12-31',
			yearRange: '-100:+10',
			firstDay: 0,
			beforeShow: function(input, inst){
				//put the date back in place
				//because of datagrids copy controls we cannot keep the date in tmp
				var tmpDate = $('#' + tmpId + tmpSuffix).val() + "-" + $('#' + tmpId + "-mm" + tmpSuffix).val() + "-" + $('#' + tmpId + "-dd" + tmpSuffix).val();
				if(tmpDate.length == 10){
					$(this).datepicker('setDate', tmpDate);
				}
				//show fake button to hide real button value
				var item = $(this).parent().children("img")[0];
//				$(item).css("z-index", "1");
			},
			onClose: function(dateText,picker) {
				//hide the date
				$(this).val(" ");//space required for Safari and Chome or the button disappears
				var dateSplit = dateText.split(/-/);
				if(dateSplit.length == 3){
					$('#' + tmpId + tmpSuffix).val(dateSplit[0]); 
		        	$('#' + tmpId + "-mm" + tmpSuffix).val(dateSplit[1]);
		        	$('#' + tmpId + "-dd" + tmpSuffix).val(dateSplit[2]);
				}
	        	//hide fake button
	        	var item = $(this).parent().children("img")[0];
//				$(item).css("z-index", "-1");
		    }
		});
		
		//activate fake_datepicker in case there is a problem with z-index
		$(element).parent().children("img").click(function(){
			$(element).datepicker('show');
		});
		
		//bug fix for Safari and Chrome
		$(element).click(function(){
			$(element).datepicker('show');
		});
	}
	
	function autoComplete(element, json){
		$(element).autocomplete({
			source: root_url + "/" + $(element).attr("url")
			//alternate source for debugging
//			source: function(request, response) {
//				$.post(root_url + "/" + $(element).attr("url"), request, function(data){
//					alert(data);
//				});
//			}
		});
	}
	
	function initAdvancedControls(){
		//for each add or button
		$(".btn_add_or").each(function(){
			var $field = $(this).parent().parent().find("span:first");
			if($($field).find("input, select").length == 1){
				$($field).find("input, select").each(function(){
					$(this).attr("name", $(this).attr("name") + "[]");
				});
				//html template for that field
				var fieldHTML = $($field).html();
				
				//update its id
				var idIncrement = 1;
				$($field).find("input, select").each(function(){
					$(this).attr("id", $(this).attr("id") + "_0");
				});
				
				//when we click
				$(this).click(function(){
					//append it into the text field with "or" string + btn_remove
					$(this).parent().parent().append("<span class='adv_ctrl'>" + STR_OR + fieldHTML + "<a href='#' onclick='return false;' class='adv_ctrl btn_rmv_or'>(-)</a></span> ");
					//find the newly generated input
					var $newField = $(this).parent().parent().find("span.adv_ctrl:last");
					//update its id
					$($newField).find("input, select").each(function(){
						$(this).attr("id", $(this).attr("id") + "_" + idIncrement);
					});
					++ idIncrement;
					
					$($newField).find(".datepicker").each(function(){
						initDatepicker(this);
					});
					
					
					//bind the remove command to the remove button
					$(this).parent().parent().find(".btn_rmv_or:last").click(function(){
						$(this).parent().remove();
					});
					//move the add button to the end
					$(this).parent().parent().append($(this).parent());
					
					//reset the highlighting
					$('form').highlight('tr');
				});
			}else{
				//range values, no add options
				$(this).remove();
			}
		});
	}
	
	function initTooltips(){
		$(".tooltip").each(function() {
			$(this).find("input").each(function(){
				$(this).focus(function(){
					//fixes a datepicker issue where the calendar stays open
					$("#ui-datepicker-div").stop(true, true);
					$(".datepicker").datepicker('hide');
					$(this).parent().find("div").css("display", "inline-block");
				});
				$(this).blur(function(){
					$(this).parent().find("div").css("display", "none");
				});
			});
			$(this).find("div").addClass("ui-corner-all").css({"border" : "1px solid", "padding" : "3px"})
		});	
	}
