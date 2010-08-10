$('#menu #summary').hover( 
	function() {
		
		var summary_hover = $(this);
		var summary_popup = summary_hover.find('ul');
		var summary_label = summary_hover.find('span');
		
		if ( summary_popup.length>0 ) {
			
			summary_popup.slideToggle(
				100, 	
				function () {
					if ( $('#dimForActionPopup').css('display')=='block' ) {
						$('#dimForActionPopup').fadeOut(100);
						
						summary_hover.css('position','absolute').css('z-index',50);
						summary_popup.css('z-index',100);
						summary_label.css('z-index',100);
					} else {
						$('#dimForActionPopup').fadeIn(2000);
						
						summary_label.css('z-index',200);
						summary_hover.css('position','absolute').css('z-index',150);
						summary_popup.css('z-index',150);
					}
				}
			);
			
			return false;
			
		}
		
	}
);

$('#wrapper div.actions ul ul.filter li').hover( 
	function() {
		
		var action_hover = $(this);
		var action_popup = action_hover.find('div.filter_menu');
		
		if ( action_popup.length>0 ) {
			
			action_popup.slideToggle(
				100, 
				function () {
					$('#dimForActionPopup').stop(true,true);
					
					if ( $('#dimForActionPopup').css('display')=='block' ) {
						$('#dimForActionPopup').fadeOut(100);
						
						action_hover.css('position','relative').css('z-index',50);
						action_popup.css('z-index',100);
					} else {
						$('#dimForActionPopup').fadeIn(2000);
						
						action_hover.css('position','relative').css('z-index',150);
						action_popup.css('z-index',150);
					}
				}
			);
			
			return false;
			
		}
		
	}
);

$('#wrapper div.actions ul ul.filter div a.up').click( 
	function() {
		
		var span_up = $(this);
		var move_ul = span_up.parent('div.filter_menu').find('ul');
		
		var position = move_ul.position();
		
		// only scroll if not already at edge...
		if ( 1==1 ) {
			move_ul.animate(
				{
					top: '-=200'
				},
				150,
				'linear'
			);
		}
				
		return false;
	}
);

$('#wrapper div.actions ul ul.filter div a.down').click( 
	function() {
		
		var span_up = $(this);
		var move_ul = span_up.parent('div.filter_menu').find('ul');
		
		var position = move_ul.position();
		
		// only scroll if not already at edge...
		if ( position.top < 0 ) {
			
			move_ul.animate(
				{
					top: '+=200'
				},
				150,
				'linear'
			);
			
		}
		
		return false;
	}
);

var availableTags = ["c++", "java", "php", "coldfusion", "javascript", "asp", "ruby", "python", "c", "scala", "groovy", "haskell", "perl"];

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
		if(startIndex > -1){
			return eval ('(' + cssClass.substr(startIndex, cssClass.lastIndexOf("}") - startIndex + 1) + ')');
		}
		return null;
	}

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
			//if the generated link is ///link it doesn't work. That's why we have a "if" statement on root_url
			source: (root_url == "/" ? "" : root_url + "/") + $(element).attr("url")
			//alternate source for debugging
//			source: function(request, response) {
//				$.post(root_url + "/" + $(element).attr("url"), request, function(data){
//					alert(data);
//				});
//			}
		});
	}
	
	/**
	 * Advanced controls are search OR options and RANGE buttons
	 */
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
		
		$(".range").each(function(){
			//uses .btn_add_or to know if this is a search form and if advanced controls are on
			$(this).parent().parent().find(".btn_add_or").parent().append(" <a href='#' class='range_btn'>(" + STR_RANGE + ")</a>");
		});
		$(".range_btn").toggle(function(){
			var cell = getParentElement(this, "TD");
			$(cell).find("input").val("");
			if($(cell).find(".range_span").length == 0){
				$(cell).find("span:first").addClass("adv_ctrl");
				$(cell).prepend("<span class='range_span'><input type='text' name='data[MiscIdentifier][identifier_value_start]'/> " + STR_TO + " <input type='text' name='data[MiscIdentifier][identifier_value_end]'/></span>");
			}else{
				$(cell).find(".range_span").show();
				//restore names
				$(cell).find(".range_span input").each(function(){
					$(this).attr("name", $(this).attr("name").substr(1));
				});
			}
			$(this).html("(" + STR_SPECIFIC + ")");
			$(cell).find(".adv_ctrl").hide();
			//obfuscate names
			$(cell).find(".adv_ctrl input").each(function(){
				$(this).attr("name", "x" + $(this).attr("name"));
			});
		}, function(){
			var cell = getParentElement(this, "TD");
			$(cell).find("input").val("");
			$(this).html("(" + STR_RANGE + ")");
			$(cell).find(".range_span").hide();
			$(cell).find(".adv_ctrl").show();
			//restore input names
			$(cell).find(".adv_ctrl input").each(function(){
				$(this).attr("name", $(this).attr("name").substr(1));
			});
			//obfuscate input names
			$(cell).find(".range_span input").each(function(){
				$(this).attr("name", "x" + $(this).attr("name"));
			});
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
	
	/**
	 * Remove the row that contains the element
	 * @param element The element contained within the row to remove
	 */
	function removeParentRow(element){
		element = getParentElement(element, "TR");
		
		if($(element)[0].nodeName == "TR"){
			$(element).remove();
		}
	}
	
	function getParentRow(element){
		return getParentElement(element, "TR");
	}
	
	function initAutocomplete(){
		$(".jqueryAutocomplete").each(function(){
			var json = getJsonFromClass($(this).attr("class"));
			var fct = eval("(" + json.callback + ")");
			fct.apply(this, [this, json]);
		});
	}
	
	function getParentElement(currElement, parentName){
		do{
			currElement = $(currElement).parent();
			nodeName = currElement[0].nodeName;
		}while(nodeName != parentName && nodeName != "undefined");
		return currElement;
	}
	
	function initJsControls(){
		//field highlighting
		if($("#table1row0").length == 1){
			//gridview
			$('form').highlight('td');
		}else{
			$('form').highlight('tr');
		}
		
		//tree view controls
		$(".reveal:not(.not_allowed)").each(function(){
			var cssClass = $(this).attr("class");
			if(cssClass.indexOf("{") > -1){
				var json = getJsonFromClass(cssClass);
				$(this).toggle(function(){
					$("#tree_" + json.tree).stop(true, true);
					$("#tree_" + json.tree).show("blind", {}, 350);
				}, function(){
					$("#tree_" + json.tree).stop(true, true);
					$("#tree_" + json.tree).hide("blind", {}, 350);
				});
			}
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
		
		initAutocomplete();
		initAdvancedControls();
		initTooltips();
		
		//calendar controls
		$.datepicker.setDefaults($.datepicker.regional[locale]);
		$(".datepicker").each(function(){
			initDatepicker(this);
		});
	}
