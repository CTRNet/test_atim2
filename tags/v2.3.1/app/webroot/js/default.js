var toolTarget = null;
var useHighlighting = jQuery.browser.msie == undefined || jQuery.browser.version >= 9;

function initSummary(){
	var open = function(){
		var summary_hover = $(this);
		var summary_popup = summary_hover.find('ul');
		if ( summary_popup.length>0 ) {
			summary_popup.stop(true, true).slideDown(100);
		}
	};
	var close = function(){
		var summary_hover = $(this);
		var summary_popup = summary_hover.find('ul');
		if ( summary_popup.length>0 ) {
			summary_popup.delay(101).slideUp(100);
		}
	};
	$('#menu #summary').hover(open, close);
}

//Slide down animation (show) for action menu
var actionMenuShow = function(){
	var action_hover = $(this);
	var action_popup = action_hover.find('div.filter_menu');
	if ( action_popup.length > 0 ) {
		//show current menu
		action_popup.slideDown(100);
	}
};
	
//Slide up (hide) animation for action menu.
var actionMenuHide = function(){
	var action_hover = $(this);
	var action_popup = action_hover.find('div.filter_menu');
	if (action_popup.length > 0) {
		action_popup.slideUp(100).queue(function(){
			$(this).clearQueue();
		});
	}
};

var menuMoveDistance = 174;
var actionClickUp = function() {
	var span_up = $(this);
	var move_ul = span_up.parent('div.filter_menu').find('ul');
	
	var position = move_ul.position();
	
	// only scroll if not already at edge...
	if ( position.top < 0 ) {
		
		move_ul.animate(
			{
				top: '+=' + menuMoveDistance
			},
			150,
			'linear'
		);
		
	}
	
	return false;
};

var actionClickDown = function() {
	
	var span_up = $(this);
	var move_ul = span_up.parent('div.filter_menu').find('ul');
	
	var position = move_ul.position();
	
	
	// only scroll if not already at edge...
	if ( (position.top - menuMoveDistance) > (-1 * move_ul.height()) ) {
		move_ul.animate(
			{
				top: '-=' + menuMoveDistance
			},
			150,
			'linear'
		);
	}
	
	return false;
};

/**
 * Handling mouse scroll on action menus. Sending up/down commands if there is
 * no ongoing animations
 * @param event
 * @param delta
 * @returns false so that the page never scrolls
 */
function actionMouseweelHandler(event, delta){
	if($(event.currentTarget).find("ul:animated").length == 0){
		if(delta > 0){
			$(event.currentTarget).find(".up").click();
		}else{
			$(event.currentTarget).find(".down").click();
		}
	}
	return false;
}

/**
 * Inits actions bars (main one and ajax loaded ones). Unbind the actions before rebinding them to avoid duplicate bindings
 */
function initActions(){
	$('div.actions div.bottom_button').unbind('mouseenter', actionMenuShow).unbind('mouseleave', actionMenuHide).bind('mouseenter', actionMenuShow).bind('mouseleave', actionMenuHide);
	$('div.actions a.down').unbind('click', actionClickDown).click(actionClickDown);
	$('div.actions a.up').unbind('click', actionClickUp).click(actionClickUp);
	$('div.filter_menu.scroll').bind('mousewheel', actionMouseweelHandler);
}

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

	function initDatepicker(scope){
		$(scope).find(".datepicker").each(function(){
			var dateFields = $(this).parent().parent().find('input, select');
			var yearField = null;
			var monthField = null;
			var dayField = null;
			var date = null;
			for(var i = 0; i < dateFields.length; i ++){
				var tmpStr = $(dateFields[i]).attr("name");
				var tmpLen = tmpStr.length;
				if(dateFields[i].nodeName != "SPAN"){
					if(tmpStr.substr(tmpLen - 7) == "][year]"){
						yearField = dateFields[i];
					}else if(tmpStr.substr(tmpLen - 8) == "][month]"){
						monthField = dateFields[i];
					}else if(tmpStr.substr(tmpLen - 6) == "][day]"){
						dayField = dateFields[i];
					}
				}
			}
			if($(yearField).val().length > 0 && $(monthField).val().length > 0 && $(dayField).val().length > 0){
				date = $(yearField).val() + "-" + $(monthField).val() + "-" + $(dayField).val();
				//set the current field date into the datepicker
				$(this).data(date);
			}
			
			$(this).datepicker({
				changeMonth: true,
				changeYear: true,
				dateFormat: 'yy-mm-dd',
				maxDate: '2100-12-31',
				yearRange: '-100:+100',
				firstDay: 0,
				beforeShow: function(input, inst){
					//put the date back in place
					//because of datagrids copy controls we cannot keep the date in tmp
					var month = $(monthField).val();
					var day = $(dayField).val();
					if(month < 10 && month > 0){
						month = "0" + month;
					}
					if(day < 10 && day > 0){
						day = "0" + day;
					}	
					var tmpDate = $(yearField).val() + "-" + month + "-" + day;
					if(tmpDate.length == 10){
						$(this).datepicker('setDate', tmpDate);
					}
				},
				onClose: function(dateText,picker) {
					//hide the date
					$(this).val(" ");//space required for Safari and Chome or the button disappears
					var dateSplit = dateText.split(/-/);
					if(dateSplit.length == 3){
						$(yearField).val(dateSplit[0]); 
			        	$(monthField).val(dateSplit[1]);
			        	$(dayField).val(dateSplit[2]);
					}
			    }
			});
			
			//bug fix for Safari and Chrome
			$(this).click(function(){
				$(this).datepicker('show');
			});
		});
	}
	
	function setFieldSpan(clickedButton, spanClassToDisplay){
		$(clickedButton).parent().find("a").show();
		$(clickedButton).hide();
		$(clickedButton).parent().children("span").hide().each(function(){
			//store all active field names into their data and remove the name
			$(this).find("input, select").each(function(){
				if($(this).attr('name').length > 0){
					$(this).data('name', $(this).attr('name')).attr('name', ''); 
				}
			});
		});
		$(clickedButton).parent().find("span." + spanClassToDisplay).show().find('input, select').each(function(){
			//activate names of displayed fields
			$(this).attr('name', $(this).data('name'));
		});
	}
	
	/**
	 * Advanced controls are search OR options and RANGE buttons
	 */
	function initAdvancedControls(scope){
		//for each add or button
		$(scope).find(".btn_add_or").each(function(){
			var $field = $(this).prev();
			//non range value, the OR is made to allow fields with CSV to be renamed but not cloned
			if($($field).find("input, select").length == 1 || ($($field).find("input").length == 2 && $($($field).find("input")[1]).attr("type") == "file")){
				$($field).find("input, select").first().each(function(){
					$(this).attr("name", $(this).attr("name") + "[]");
				});
				
				if($($field).find("input").length == 2){
					//rename complete, hide and bail out
					$(this).remove();
					return;
				}
				//html template for that field
				var fieldHTML = $($field).html();
				
				//when we click
				$(this).click(function(){
					//append it into the text field with "or" string + btn_remove
					$(this).parent().append("<span class='adv_ctrl " + $($field).attr("class") + "' style='" + $($field).attr("style") + "'>" + STR_OR + " " + fieldHTML + "<a href='#' onclick='return false;' class='adv_ctrl btn_rmv_or delete_10x10'></a></span> ");
					//find the newly generated input
					var $newField = $(this).parent().find("span.adv_ctrl:last");
					
					initDatepicker($newField);
					
					initAutocomplete($newField);
					initToolPopup($newField);
					
					//bind the remove command to the remove button
					$(this).parent().find(".btn_rmv_or:last").click(function(){
						$(this).parent().remove();
					});
					//move the add button to the end
					$(this).parent().append($(this));
					
					if(useHighlighting){
						//reset the highlighting
						$('form').highlight('tr');
					}
				});
			}else{
				//range values, no add options
				$(this).remove();
			}
		});
		
		if($(scope).find(".btn_add_or:first").length == 1){
			var tabIndex = null;
			$(scope).find(".range").each(function(){
				//uses .btn_add_or to know if this is a search form and if advanced controls are on
				var cell = $(this).parent().parent().parent(); 
				$(cell).append(" <a href='#' class='range_btn' title='" + STR_RANGE + "'></a> " +
						"<a href='#' class='specific_btn'></a>").data('mode', 'specific').find(".specific_btn").hide();
				$(cell).find("span:first").addClass("specific_span");
				
				var baseName = $(cell).find("input").attr("name");
				baseName = baseName.substr(0, baseName.length - 3);
				tabindex = $(cell).find("input").attr("tabindex");
				$(cell).prepend("<span class='range_span hidden'><input type='text' tabindex='" + tabindex + "' name='" + baseName + "_start]'/> " 
						+ STR_TO 
						+ " <input type='text' tabindex='" + tabindex + "' name='" + baseName + "_end]'/></span>");					
			});
			
			$(scope).find(".file").each(function(){
				var cell = $(this).parent().parent().parent();
				$(cell).append(" <a href='#' class='file_btn'></a>").data('mode', 'specific');
				
				if($(cell).find(".specific_btn").length == 0){
					$(cell).append(" <a href='#' class='specific_btn'></a>").find(".specific_btn").hide();
					$(cell).find("span:first").addClass("specific_span");
					tabindex = $(cell).find("input").attr("tabindex");
				}
				var name = $(cell).find("input:last").attr("name");
				name = name.substr(0, name.length -3) + "_with_file_upload]";
				$(cell).prepend("<span class='file_span hidden'><input type='file' tabindex='" + tabindex + "' name='" + name + "'/></span>");
			});
			//store hidden field names into their data
			$(scope).find("span.range_span input, span.file_span input").each(function(){
				$(this).data('name', $(this).attr('name')).attr('name', "");
			});
			
			//trigger buttons
			$(scope).find(".range_btn").click(function(){
				setFieldSpan(this, "range_span");
				return false;
			});
			$(scope).find(".specific_btn").click(function(){
				setFieldSpan(this, "specific_span");
				return false;
			});
			$(scope).find(".file_btn").click(function(){
				setFieldSpan(this, "file_span");
				return false;
			});
		}
	}
	
	function initTooltips(scope){
		$(scope).find(".tooltip").each(function() {
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
			$(this).find("div").addClass("ui-corner-all").css({"border" : "1px solid", "padding" : "3px"});
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
	
	function initAutocomplete(scope){
		$(scope).find(".jqueryAutocomplete").each(function(){
			$(this).autocomplete({
				//if the generated link is ///link it doesn't work. That's why we have a "if" statement on root_url
				source: (root_url == "/" ? "" : root_url + "/") + $(this).attr("url")
				//alternate source for debugging
//				source: function(request, response) {
//					$.post(root_url + "/" + $(element).attr("url"), request, function(data){
//						alert(data);
//					});
//				}
			});
		});
	}
	
	function initAliquotVolumeCheck(){
		var checkFct = function(){
			var fctMod = function(param){ return parseFloat(param.replace(/,/g, ".")); };
			var denom = fctMod($("#AliquotMasterCurrentVolume").val());
			var nom = fctMod($("#AliquotUseUsedVolume").val());
			if($("#AliquotUseUsedVolume").val().length > 0 && nom > denom){
				$("input, textarea, a").blur();
				$("#popup").popup();
				return false;
			}else{
				$("#submit_button").click();
			}
		};
		
		$("form").submit(checkFct);
		$(".form.submit").unbind('click').attr("onclick", "return false;");
		$(".form.submit").click(checkFct);

		$(".button.confirm").click(function(){
			$("#popup").popup('close');
			$("#submit_button").click();
		});
		$(".button.close").click(function(){
			$("#popup").popup('close');
		});
	}
	
	function refreshTopBaseOnAction(){
		$("form").attr("action", root_url + actionControl + $("#0Action").val());
	}
	
	function initActionControl(actionControl){
		$($(".adv_ctrl.btn_add_or")[1]).parent().parent().find("select").change(function(){
			refreshTopBaseOnAction(actionControl);
		});
		$(".adv_ctrl.btn_add_or").remove();
		refreshTopBaseOnAction(actionControl);
	}
	
	/**
	 * Initialises check/uncheck all controls
	 * @param scope The scope where to look for those controls. In a popup, the scope will be the popup box
	 */
	function initCheckAll(scope){
		var elem = $(scope).find(".checkAll");
		if(elem.length > 0){
			parent = getParentElement(elem, "TBODY");
			$(elem).click(function(){
				$(parent).find('input[type=checkbox]').attr("checked", true);
				return false;
			});
			$(scope).find(".uncheckAll").click(function(){
				$(parent).find('input[type=checkbox]').attr("checked", false);
				return false;
			});
		}
	}
	
	function getParentElement(currElement, parentName){
		do{
			currElement = $(currElement).parent();
			nodeName = currElement[0].nodeName;
		}while(nodeName != parentName && nodeName != "undefined");
		return currElement;
	}
	
	//Delete confirmation dialog
	function initDeleteConfirm(){
		if($(".action .form.delete").length > 0){
			$("body").append('<div id="deleteConfirmPopup" class="std_popup question">' +
				'<div style="background: #FFF;">' +
					'<h4>' + STR_DELETE_CONFIRM + '</h4>' +
					'<span class="button deleteConfirm">' +
						'<a class="form detail">' + STR_YES + '</a>' +
					'</span>' +
					'<span class="button deleteClose">' +
						'<a class="form delete">' + STR_NO + '</a>' +
					'</span>' +
				'</div>' +
				'<input type="hidden" id="deleteLink" value=""/>' +
			'</div>');
			
			$(".form.delete").click(function(){
				$("#deleteConfirmPopup").popup();
				$("#deleteLink").val($(this).attr("href"));
				return false;
			});
			$("#deleteConfirmPopup .deleteConfirm").click(function(){
				document.location = $("#deleteLink").val(); 
			});
			$("#deleteConfirmPopup .deleteClose, #deleteConfirmPopup .delete").click(function(){
				$("#deleteConfirmPopup").popup('close');
			});
		}
	}
	//tool_popup
	function initToolPopup(scope){
		$(scope).find(".tool_popup").click(function(){
//			if((new Date).getTime() > sessionExpiration){
//				document.location = "";
//			}
			var parent_elem = $(this).parent().children();
			toolTarget = null;
			for(var i = 0; i < parent_elem.length; i ++){
				//find the current element
				if(parent_elem[i] == this){
					for(var j = i - 1; j >= 0; j --){
						//find the previous input
						if(parent_elem[j].nodeName == "INPUT"){
							toolTarget = parent_elem[j];
							break;
						}
					}
					break;
				}
			}
			$.get($(this).attr("href"), null, function(data){
				$("#default_popup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>").popup();
				$("#default_popup input[type=text]").first().focus();
			});
			return false;
		});
	}
	
	function initAddLine(scope){
		$(scope).find(".addLineLink").each(function(){
			//get the table row
			var table = $(getParentElement(this, "TABLE"));
			var tableBody = $(table).find("tbody");
			var lastLine = $(tableBody).find("tr:last");
			var templateLineHtml = lastLine.html();
			$(lastLine).remove();
			var lineIncrement = $(tableBody).find("tr").length;
			$(this).click(function(){
				var counter = $(table).find(".addLineCount").length == 1 ? $(table).find(".addLineCount").val() : 1;
				while(counter > 0){
					$(tableBody).append("<tr class='newLine'>" + templateLineHtml.replace(/\[%d\]\[/g, '[' + lineIncrement ++ + '][') + "</tr>");
					counter --;
				}
				var newLines = $(tableBody).find("tr.newLine");
				initRemoveLine(newLines);
				initAutocomplete(newLines);
				initDatepicker(newLines);
				initToolPopup(newLines);
				initTooltips(document);
				initCheckboxes(newLines);
				if(window.copyControl){
					bindCopyCtrl(newLines);
				}
				if(window.labBookFields){
					initLabBook(newLines);
				}
				initAccuracy(newLines);
				$(newLines).removeClass("newLine");
				return false;
			});
		});
		
		$(scope).find(".addLineCount").keydown(function(e){
			if(e.keyCode == 13){
				return false;
			}
		}).keyup(function(e){
			if(e.keyCode == 13){
				$(this).siblings(".addLineLink").click();
				return false;
			}
		});
	}
	
	function initRemoveLine(scope){
		$(scope).find(".removeLineLink").click(function(){
			$(getParentElement(this, "TR")).remove();
			return false;
		});
	}
	
	function initAjaxClass(scope){
		//ajax controls
		//evals the json within the class of the element and calls the method defined in callback
		//the callback method needs to take this and json as parameters
		$(scope).find(".ajax").click(function(){
			var json = getJsonFromClass($(this).attr("class"));
			var fct = eval("(" + json.callback + ")");
			fct.apply(this, [this, json]);
			return false;
		});
	}
	
	function initLabBook(scope){
		var fields = new Array();
		var checkbox = null;
		var codeInputField = null;
		$(scope).find("input, select, textarea").each(function(){
			var currName = $(this).attr("name");
			for(var i in labBookFields){
				if(labBookFields[i].length == 0){
					continue;
				}
				if(currName.indexOf(labBookFields[i]) > -1){
					fields.push($(this));
					var parentTd = getParentElement(this, "TD");
					if($(parentTd).find(".labBook").length == 0){
						$(this).after("<span class='labBook'>[" + STR_LAB_BOOK + "]</span>");
						fields.push($(parentTd).find(".datepicker"));
					}
				}
			}
			if(currName.indexOf("[sync_with_lab_book]") > 0){
				checkbox = $(this);
			}else if(currName.indexOf("[lab_book_master_code]") > 0){
				codeInputField = $(this);
			}
		});
		
		if(checkbox != null){
			$(checkbox).click(function(){
				labBookFieldsToggle(scope, fields, codeInputField, checkbox);
			});
		}
		if(codeInputField != null){
			$(codeInputField).change(function(){
				labBookFieldsToggle(scope, fields, codeInputField, checkbox);
			});
		}
		
		if(window.labBookHideOnLoad){
			$(fields).toggle();
			$(scope).find(".labBook").toggle();
		}else{
			labBookFieldsToggle(scope, fields, codeInputField, checkbox);
		}
	}
	
	function labBookFieldsToggle(scope, fields, codeInputField, checkbox){
		var toggle = false;
		if($(scope).find(".labBook:visible").length == 0){
			//current input are visible, see if we need to hide
			if((checkbox != null && $(checkbox).attr("checked")) || (codeInputField != null && $(codeInputField).val().length > 0)){
				toggle = true;
			}
		}else{
			//current input are hidden, see if we need to display
			if((checkbox == null || !$(checkbox).attr("checked")) && (codeInputField == null || $(codeInputField).val().length == 0)){
				toggle = true;
			}
		}
		if(toggle){
			$(fields).toggle();
			$(scope).find(".labBook").toggle();
		}
	}
	
	function initLabBookPopup(){
		$("div.bottom_button a:not(.not_allowed).add").first().click(function(){
			$.get($(this).attr("href"), labBookPopupAddForm);
			return false;
		});
	}
	
	function labBookPopupAddForm(data){
		$("#default_popup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>").popup();
		initDatepicker("#default_popup");
		initTooltips("#default_popup");
		initAccuracy("#default_popup");
		$("#default_popup a.form.submit").unbind('click').attr('onclick', '').click(function(){
			$(this).hide();
			$.post($("#default_popup form").attr("action"), $("#default_popup form").serialize(), function(data2){
				if(data2.length < 100){
					//saved
					$("#default_popup").popup('close');
					$("input, select").each(function(){
						if($(this).attr("name").indexOf('lab_book_master_code') != -1){
							$(this).val(data2);
						}
					});
				}else{
					//redisplay
					labBookPopupAddForm(data2);
				}
			});
			return false;
		});
		$("#default_popup form").submit(event, function(){
			event.preventDefault();
			return false;
		});
		$("#default_popup input[type=text]").first().focus();
	}
	
	function initCheckboxes(scope){
		$(scope).find("input[type=checkbox]").each(function(){
			if(!$(this).data("exclusive")){
				var checkboxes = $(this).parent().find("input[type=checkbox]");
				$(checkboxes).each(function(){
					$(this).data("exclusive", true);
				});
				$(checkboxes).click(function(){
					var checked = $(this).attr("checked"); 
					$(checkboxes).attr("checked", false);
					$(this).attr("checked", checked);
				});
			}
		});
	}
	
	function initAccuracy(scope){
		$(scope).find(".accuracy_target_blue").click(function(){
			if($(this).find("input").length == 0){
				//accuracy going to year
				$(this).parent().find("input, select").each(function(){
					if($(this).attr("name").indexOf("year") == -1){
						$(this).hide();
					}
				});
				var name = $(this).parent().find("input, select").first().attr("name");
				$(this).html("<input type='hidden' class='accuracy' name='" + name.substr(0, name.lastIndexOf("[")) + "[year_accuracy]' value='1'/>");
			}else{
				//accuracy going to manual
				$(this).html("");
				$(this).parent().find("input, select").show();
			}
			return false;
		});
		
		$(scope).find(".accuracy_target_blue").each(function(){
			if($(this).siblings().find(".labBook:visible").length > 0){
				$(this).hide();
			}else{
				var current_accuracy_btn = this;
				$(this).parent().find("input, select").each(function(){
					if($(this).attr("name").indexOf("year") != -1 && $(this).hasClass('year_accuracy')){
						$(this).removeClass('year_accuracy');
						$(current_accuracy_btn).click();
					}
				});
			}
		});
	}
	
	function flyOverSubmit(){
		$(".flyOverSubmit").css("right", (Math.max($(".submitBar").width() - $(window).width() - $(document).scrollLeft() + 20, 0)) + "px");
	}
	
	function initAutoHideVolume(){
		$("input[type=radio]").click(function(){
			if(jQuery.inArray($(this).val(), volumeIds) > -1){
				$("input[name=data\\[QualityCtrl\\]\\[used_volume\\]]").attr("disabled", false);
			}else{
				$("input[name=data\\[QualityCtrl\\]\\[used_volume\\]]").attr("disabled", true).val("");
			}
		});
		$("input[type=radio]:checked").click();
	}
	
	function initJsControls(){
		if(window.storageLayout){
			initStorageLayout();
		}
		if(window.datamartActions){
			initDatamartActions();
		}
		if(window.copyControl){
			initCopyControl();
		}
		if(window.aliquotVolumeCheck){
			initAliquotVolumeCheck();
		}
		if(window.actionControl){
			initActionControl(window.actionControl);
		}
		if(window.ccl){
			initCcl();
		}
		if(window.batchSetControls){
			initBatchSetControls();
		}
		if(window.ajaxTreeView){
			initAjaxTreeView(document);
		}
		if(window.treeView){
			initTreeView(document);
		}
		if(window.labBookFields){
			initLabBook(document);
		}
		if(window.labBookPopup){
			initLabBookPopup();
		}
		if(window.dropdownConfig){
			initDropdownConfig();
		}
		if(window.volumeIds){
			initAutoHideVolume();
		}
		
		if(window.realiquotInit){
			$("a.submit").attr("onclick", "").unbind('unclick').click(function(){
				if($("select").val().length > 0){
					$("form").submit();
				}
				return false;
			});
		}
		
		initDeleteConfirm();
		
		initAutocomplete(document);
		initAdvancedControls(document);
		initToolPopup(document);
		initActions();
		initSummary();
		initAjaxClass(document);
		initAccuracy(document);
		initAddLine(document);//must be before datepicker
		
		//calendar controls
		$.datepicker.setDefaults($.datepicker.regional[locale]);
		initDatepicker(document);
		
		initTooltips(document);
		initCheckAll(document);
		initRemoveLine(document);
		initCheckboxes(document);
		
		$(document).ajaxError(function(event, xhr, settings, exception){
			if(xhr.status == 403){
				//access denied, most likely a session timeout
				document.location = "";
			}
		});
		
		//focus on first field
		$("input, select, textarea").first().focus();
		
		//on login page, displays a warning if the server is more than ~2 min late compared to the client
		if(window.serverClientTimeDiff && window.serverClientTimeDiff < -120){
			$("#timeErr").show();
		}
		
		if(useHighlighting){
			//field highlighting
			if($("#table1row0").length == 1){
				//gridview
				$('form').highlight('td');
			}else{
				$('form').highlight('tr');
			}
		}
		
		//fly over submit button, always in the screen
		flyOverSubmit();
		$(window).scroll(flyOverSubmit);
		$(window).resize(flyOverSubmit);
	}
	

	function debug(str){
//		$("#debug").append(str + "<br/>");
	}