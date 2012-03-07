var toolTarget = null;
var useHighlighting = jQuery.browser.msie == undefined || jQuery.browser.version >= 9;
var submitData = new Object();

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
	
	//TODO: REMOVE
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
				var tmpStr = $(dateFields[i]).prop("name");
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
					var month = parseInt($(monthField).val(), 10);
					var day = parseInt($(dayField).val(), 10);
					if(isNaN(month)){
						month = "";
					}else if(month < 10 && month > 0){
						month = "0" + month;
					}
					if(isNaN(day)){
						day = "";
					}else if(day < 10 && day > 0){
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
				if($(this).prop('name').length > 0){
					$(this).data('name', $(this).prop('name')).prop('name', ''); 
				}
			});
		});
		$(clickedButton).parent().find("span." + spanClassToDisplay).show().find('input, select').each(function(){
			//activate names of displayed fields
			$(this).prop('name', $(this).data('name'));
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
			if($($field).find("input, select").length == 1 || ($($field).find("input").length == 2 && $($($field).find("input")[1]).prop("type") == "file")){
				$($field).find("input, select").first().each(function(){
					$(this).prop("name", $(this).prop("name") + "[]");
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
					$(this).parent().append("<span class='adv_ctrl " + $($field).prop("class") + "' style='" + $($field).prop("style") + "'>" + STR_OR + " " + fieldHTML + "<a href='#' onclick='return false;' class='adv_ctrl btn_rmv_or icon16 delete_mini'></a></span> ");
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
			var tabindex = null;
			$(scope).find(".range").each(function(){
				//uses .btn_add_or to know if this is a search form and if advanced controls are on
				var cell = $(this).parent().parent().parent(); 
				$(cell).append(" <a href='#' class='icon16 range range_btn' title='" + STR_RANGE + "'></a> " +
						"<a href='#' class='icon16 specific specific_btn'></a>").data('mode', 'specific').find(".specific_btn").hide();
				$(cell).find("span:first").addClass("specific_span");
				
				var baseName = $(cell).find("input").prop("name");
				baseName = baseName.substr(0, baseName.length - 3);
				tabindex = $(cell).find("input").prop("tabindex");
				$(cell).prepend("<span class='range_span hidden'><input type='text' tabindex='" + tabindex + "' name='" + baseName + "_start]'/> " 
						+ STR_TO 
						+ " <input type='text' tabindex='" + tabindex + "' name='" + baseName + "_end]'/></span>");					
			});
			
			$(scope).find(".file").each(function(){
				var cell = $(this).parent().parent().parent();
				$(cell).append(" <a href='#' class='icon16 csv_upload file_btn'></a>").data('mode', 'specific');
				
				if($(cell).find(".specific_btn").length == 0){
					$(cell).append(" <a href='#' class='specific_btn'></a>").find(".specific_btn").hide();
					$(cell).find("span:first").addClass("specific_span");
					tabindex = $(cell).find("input").prop("tabindex");
				}
				var name = $(cell).find("input:last").prop("name");
				name = name.substr(0, name.length -3) + "_with_file_upload]";
				$(cell).prepend("<span class='file_span hidden'><input type='file' tabindex='" + tabindex + "' name='" + name + "'/></span>");
			});
			//store hidden field names into their data
			$(scope).find("span.range_span input, span.file_span input").each(function(){
				$(this).data('name', $(this).prop('name')).prop('name', "");
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
//			var element = $(this);
			$(this).autocomplete({
				//if the generated link is ///link it doesn't work. That's why we have a "if" statement on root_url
				source: (root_url == "/" ? "" : root_url) + $(this).attr("url")
				//alternate source for debugging
//				source: function(request, response) {
//					$.post(root_url + "/" + $(element).attr("url"), request, function(data){
//						console.log(data);
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
		$(".form.submit").unbind('click').prop("onclick", "return false;");
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
		$("form").prop("action", root_url + actionControl + $("#0Action").val());
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
			parent = getParentElement(elem, "FORM");
			$(elem).click(function(){
				$(parent).find('input[type=checkbox]').prop("checked", true);
				return false;
			});
			$(scope).find(".uncheckAll").click(function(){
				$(parent).find('input[type=checkbox]').prop("checked", false);
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
	
	/**
	 * @param id
	 * @param title
	 * @param content
	 * @param buttons Array containing json containing keys icon, label and action
	 */
	function buildDialog(id, title, content, buttons){
		var buttonsHtml = "";
		if(buttons != null && buttons.length > 0){
			for(i in buttons){
				buttonsHtml += 
					'<div id="' + id + i +'" class="bottom_button"><a href="#" class="' + buttons[i].icon + '"><span class="icon16 ' + buttons[i].icon + '"></span>' + buttons[i].label + '</a></div>';
			}
			buttonsHtml = '<div class="actions">' + buttonsHtml + '</div>';
		}
		$("#" + id).remove();
		$("body").append('<div id="' + id + '" class="std_popup question">' +
			'<div class="wrapper">' +
				'<h4>' + title + '</h4>' +
				(content == null ? '' : ('<div style="padding: 10px; background-color: #fff;">' + content + '</div>')) +
				buttonsHtml +
			'</div>' +
		'</div>');
		
		for(i in buttons){
			$("#" + id + i).click(buttons[i].action);
		}
	}
	
	function buildConfirmDialog(id, question, buttons){
		buildDialog(id, question, null, buttons);
	}
	
	//tool_popup
	function initToolPopup(scope){
		$(scope).find(".tool_popup").click(function(){
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
			$.get($(this).prop("href"), null, function(data){
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
				$('form').highlight('td');
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
		
		if($(".jsChronology").length > 0){
			$(".jsChronology").each(function(){
				var href = $(this).attr("href");
				if(href.indexOf('/Participants/') != -1){
					$(this).addClass('participant');
				}else if(href.indexOf('/DiagnosisMasters/') != -1){
					$(this).addClass('diagnosis');
				}else if(href.indexOf('/TreatmentMasters/') != -1){
					$(this).addClass('treatments');
				}else if(href.indexOf('/Collections/') != -1){
					$(this).addClass('collection');
				}else if(href.indexOf('/EventMasters/') != -1){
					$(this).addClass('annotation');
				}else if(href.indexOf('/ConsentMasters/') != -1){
					$(this).addClass('consents');
				}
			}).click(function(){
				var link = this;
				//remove highlighted stuff
				var td = $(".at").removeClass("at").find("td:last-child");
				$(td).html($(td).data('content'));
				var tr = $(link).parents("tr").first().addClass("at");
				td = $(tr).find("td").last();
				console.log(td);
				$(td).data('content', $(td).html());
				$(td).html('<div style="position: relative;">' + $(td).html() + '<div class="treeArrow" style="display: block"></div></div>');
				
				if($(link).data('cached_result')){
					$("#frame").html($(link).data('cached_result'));
				}else{
					$("#frame").html("<div class='loading'></div>");
					$.get($(this).attr("href") + "?t=" + new Date().getTime(), function(data){
						$("#frame").html(data);
						$(link).data('cached_result', data);
					});
				}
				return false;
			});
			$(".this_column_1.total_columns_1").removeClass("total_columns_1").addClass("total_columns_2").css("width", "1%").parent().append(
					'<td class="this_column_2 total_columns2"><div id="frame"></td>'
			);
			
		}
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
			try{
				json = $(this).data('json');
				var fct = eval("(" + json.callback + ")");
				fct.apply(this, [this, json]);
			}catch(e){
				console.log(e);
			}
			return false;
		});
	}
	
	function initLabBook(scope){
		var fields = new Array();
		var checkbox = null;
		var codeInputField = null;
		
		$(scope).find("input, select, textarea").each(function(){
			var currName = $(this).prop("name");
			for(var i in labBookFields){
				if(labBookFields[i].length == 0){
					continue;
				}
				if(currName.indexOf(labBookFields[i]) > -1){
					fields.push($(this));
					var parentTd = getParentElement(this, "TD");
					if($(parentTd).find(".labBook").length == 0){
						$(this).after("<span class='labBook'>[" + STR_LAB_BOOK + "]</span>");
					}
					fields.push($(parentTd).find(".datepicker, .accuracy_target_blue"));
				}
			}
			if(currName.indexOf("[sync_with_lab_book]") > 0){
				checkbox = $(this);
			}else if(currName.indexOf("[lab_book_master_code]") > 0){
				codeInputField = $(this);
			}
		});
		
		var tmpFunc = function(){
			labBookFieldsToggle(scope, fields, codeInputField, checkbox);
		}; 
		
		if(checkbox != null){
			$(checkbox).click(tmpFunc);
		}
		if(codeInputField != null){
			$(codeInputField).change(tmpFunc).keyup(tmpFunc).blur(tmpFunc);
		}
		
		if(window.labBookHideOnLoad){
			$(fields).toggle();
			$(scope).find(".labBook").show();
		}else{
			tmpFunc();
		}
	}
	
	function labBookFieldsToggle(scope, fields, codeInputField, checkbox){
		var toggle = false;
		if($(scope).find(".labBook:visible").length == 0){
			//current input are visible, see if we need to hide
			if((checkbox != null && $(checkbox).prop("checked")) || (codeInputField != null && $(codeInputField).val().length > 0)){
				toggle = true;
			}
		}else{
			//current input are hidden, see if we need to display
			if((checkbox == null || !$(checkbox).prop("checked")) && (codeInputField == null || $(codeInputField).val().length == 0)){
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
			$.get($(this).prop("href"), labBookPopupAddForm);
			return false;
		});
	}
	
	function labBookPopupAddForm(data){
		$("#default_popup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>").popup();
		initDatepicker("#default_popup");
		initTooltips("#default_popup");
		initAccuracy("#default_popup");
		$("#default_popup a.form.submit").unbind('click').prop('onclick', '').click(function(){
			$(this).hide();
			$.post($("#default_popup form").prop("action"), $("#default_popup form").serialize(), function(data2){
				if(data2.length < 100){
					//saved
					$("#default_popup").popup('close');
					$("input, select").each(function(){
						if($(this).prop("name").indexOf('lab_book_master_code') != -1){
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
					var checked = $(this).prop("checked"); 
					$(checkboxes).prop("checked", false);
					$(this).prop("checked", checked);
				});
			}
		});
	}
	
	function initAccuracy(scope){
		$(scope).find(".accuracy_target_blue").click(function(){
			if($(this).find("input").length == 0){
				//accuracy going to year
				$(this).parent().find("input, select").each(function(){
					if($(this).prop("name").indexOf("year") == -1){
						$(this).hide();
					}
				});
				var name = $(this).parent().find("input, select").first().prop("name");
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
					if($(this).prop("name").indexOf("year") != -1 && $(this).hasClass('year_accuracy')){
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
				$("input[name=data\\[QualityCtrl\\]\\[used_volume\\]]").prop("disabled", false);
			}else{
				$("input[name=data\\[QualityCtrl\\]\\[used_volume\\]]").prop("disabled", true).val("");
			}
		});
		$("input[type=radio]:checked").click();
	}
	
	function handleSearchResultLinks(){
		$(".ajax_search_results thead a, .ajax_search_results tfoot a").click(function(){
			$(".ajax_search_results").html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
			$.get($(this).attr("href"), function(data){
				try{
					data = $.parseJSON(data);
					$(".ajax_search_results").html(data.page);
					history.replaceState(data.page, "foo");//storing result in history
					handleSearchResultLinks();
				}catch(exception){
					//simply submit the form then
					document.location = $(this).attr("href"); 
				}				
			});
			return false;
		});
	}
	
	function databrowserToggleSearchBox(cell){
		$(cell).parent().find("span, a").toggle();
		return false;
	}
	
	function loadUses(url){
		$.post(document.URL, {data : ["uses"]}, function(data){
			var origHeight = $("div.uses").height();
			$("div.uses").html(data);
			var newHeight = $("div.uses").height();
			$("div.uses").css('height', origHeight).animate({height: newHeight}, 500);
		});
	}
	
	function loadStorageHistory(url){
		$.post(url, {data : ["storage_history"]}, function(data){
			var origHeight = $("div.storage_history").height();
			$("div.storage_history").html(data);
			var newHeight = $("div.storage_history").height();
			$("div.storage_history").css('height', origHeight).animate({height: newHeight}, 500);
		});
	}
	
	function loadRealiquotedParent(url){
		matches = url.match(/(\/[\d]+)(\/[\d]+)(\/[\d]+)/);
		$.get(root_url + "InventoryManagement/AliquotMasters/listAllRealiquotedParents/" + matches[1] + "/" + matches[2] + "/" + matches[3] + "?t=" + new Date().getTime(), function(data){
			$(".realiquoted_parents").html(data);
		});
	}
	
	function warningMoreInfoClick(event){
		$(event.srcElement).toggle(function(){$(this).html("[+]");}, function(){$(this).html("[-]");}).siblings("pre.warningMoreInfo").toggle();
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
		if(window.permissionPreset){
			loadPresetFrame();
		}
		if(window.wizardTreeData){
			drawTree($.parseJSON(window.wizardTreeData));
		}
		if($(".ajax_search_results").length == 1){
			$(".ajax_search_results").parent().hide();
			$("input.submit").click(function(){
				var submit_button = $(this);
				$("#footer").height(Math.max($("#footer").height(), $(".ajax_search_results").height()));//made to avoid page movement
				$(".ajax_search_results").html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
				$(".ajax_search_results").parent().show();
				successFct = function(data){
					try{
						data = $.parseJSON(data);
						$(".ajax_search_results").html(data.page);
						history.replaceState(data.page, "foo");//storing result in history
						//update the form action
						$("form").attr("action", $("form").attr("action").replace(/[0-9]+(\/)*$/, data.new_search_id + "$1"));
						handleSearchResultLinks();
						//stop submit button animation
						$(submit_button).siblings("a").find("span").removeClass('fetching');
					}catch(exception){
						//simply submit the form then
						$("form").submit();
					}
				};
				$.ajax({
					type	: "POST",
					url		: $("form").attr("action"),
					data	: $("form").serialize(),
					success	: successFct,
					error	: function(){ $("form").submit(); }
				});
				return false;
			});
			
			window.onpopstate = function(event) {
				//retrieving result from history
				//try html5 storage? http://diveintohtml5.org/storage.html
				if(event.state != null){
					$(".ajax_search_results").html(event.state);
					$(".ajax_search_results").parent().show();
					handleSearchResultLinks();
				}
			};
		}
		
		if(window.realiquotInit){
			$("a.submit").prop("onclick", "").unbind('unclick').click(function(){
				if($("select").val().length > 0){
					$("form").submit();
				}
				return false;
			});
		}
		
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
		
		if(useHighlighting){
			//field highlighting
			if($("table.structure.addgrid, table.structure.editgrid").length == 1){
				//gridview
				$('form').highlight('td');
			}else{
				$('form').highlight('tr');
			}
		}
		
		//focus on first field
		$("input:visible, select:visible, textarea:visible").first().focus();
		
		//fly over submit button, always in the screen
		flyOverSubmit();
		$(window).scroll(flyOverSubmit);
		$(window).resize(flyOverSubmit);
		
		if(window.initPage){
			initPage();
		}
		$("a.databrowserMore").click(function(){
			$(this).parent().find("span, a").toggle();
			return false;
		});
		
		$(document).delegate("a.submit", 'click', function(){
			//Search button loading animation
			if(!$(this).find('span').hasClass('fetching')){
				//trigger submit form (will go through validations)
				$(this).siblings("input.submit").click();
				
			}
			return $(this).attr("href").indexOf("javascript:") == 0;
		}).delegate("form", "submit", function(){
			//submitting form
			$(this).find('a.submit span').last().addClass('fetching');
			submitData.lastRequest = $.cookie('last_request');
			submitData.callBack = setTimeout(fetchingBeamCheck, 1000);//check every second (needed for CSV download)
			return true;
		}).delegate(".jsApplyPreset", "click", function(){
			applyPreset($(this).data("json"));
			return false;
		}).delegate("a.delete:not(.noPrompt)", "click", openDeleteConfirmPopup
		).delegate(".reveal.notFetched", "click", treeViewNodeClick
		).delegate(".sectionCtrl", "click", sectionCtrl
		).delegate("a.warningMoreInfo", "click", warningMoreInfoClick);
		
		$(window).bind("pageshow", function(event){
			//remove the fetching class. Otherwise hitting Firefox back button still shows the loading animation
			//don't bother using console.log, console is not ready yet
			$(document).find('a.submit span.fetching').removeClass('fetching');
			
			//on login page, displays a warning if the server is more than ~2 min late compared to the client
			if(window.loginPage != undefined){
				//adding date to the request URL to fool IE caching
				$.get(root_url + 'Users/login/1?t=' + (new Date().getTime()), function(data){
					data = $.parseJSON(data);
					if(data.logged_in == 1){
						document.location = root_url;
					}else{ 
						var foo = new Date;
						if(data.server_time - parseInt(foo.getTime() / 1000) < -120){
							$("#timeErr").show();
						}
					}
				});
			}
		});
		
		//URL based events
		if(document.URL.match(/InventoryManagement\/AliquotMasters\/detail\/([0-9]+)\/([0-9]+)\/([0-9]+)/)){
			loadUses(document.URL);
			loadStorageHistory(document.URL);
			loadRealiquotedParent(document.URL);
		}
	}

	function globalInit(scope){
		if(window.copyControl){
			initCopyControl();
		}
		initAddLine(scope);
		initDatepicker(scope);
		initTooltips(scope);
		initAutocomplete(scope);
		initCheckAll(scope);
		initRemoveLine(scope);
		initCheckboxes(scope);
		initAccuracy(scope);
		initAdvancedControls(scope);

		if(window.labBookFields){
			initLabBook(scope);
		}
		
	}

	function debug(str){
//		$("#debug").append(str + "<br/>");
	}
	
	function treeViewNodeClick(event){
		var element = event.currentTarget;
		$(element).removeClass("notFetched").unbind('click');
		var json = $(element).data("json");
		var expandButton = $(element);
		if(json.url != undefined && json.url.length > 0){
			$(element).addClass("fetching");
			var flat_url = json.url.replace(/\//g, "_");
			if(flat_url.length > 0){
				$.get(root_url + json.url + "?t=" + new Date().getTime(), function(data){
					$("body").append("<div id='" + flat_url + "' style='display: none'>" + data + "</div>");
					if($("#" + flat_url).find("ul").length == 1){
						var currentLi = getParentElement(expandButton, "LI");
						$(currentLi).append("<ul>" + $("#" + flat_url).find("ul").html() + "</ul>");
						initAjaxClass($(currentLi).find("ul"));
						$(expandButton).click(function(){
							$(currentLi).find("ul").first().stop().toggle("blind");
						});
					}
					$(expandButton).removeClass("fetching");
					$("#" + flat_url).remove();
					
					if(window.initTree){
						initTree($(currentLi));
					}
				});
			}
		}
	}
	
	/**
	 * Called when a detail view is displayed in within the same page as the tree view
	 * @param new_at_li
	 * @param json
	 */
	function set_at_state_in_tree_root(new_at_li, json){
		$(".tree_root").find("div.treeArrow").hide();
		$(".tree_root").find("div.rightPart").removeClass("at");
		$li = getParentElement(new_at_li, "LI");
		$($li).find("div.rightPart:first").addClass("at");
		$($li).find("div.treeArrow:first").show();
		$("#frame").html("<div class='loading'>---" + STR_LOADING + "---</div>");
		$.get($(this).prop("href") + "?t=" + new Date().getTime(), {}, function(data){
			$("#frame").html(data);
			initActions();
		});
	}
	
	/**
	 * Called for tree views listing radio buttons (such as treatments, to select a dx)
	 * @param scope
	 */
	function initTreeView(scope){
		$("a.reveal.activate").each(function(){
			var matchingUl = getParentElement($(this), "LI"); 
			matchingUl	= $(matchingUl).children().filter("ul").first();
			$(this).click(function(){
				$(matchingUl).stop().toggle("blind");
			});
		});
		
		var element = $(scope).find(".tree_root input[type=radio]:checked");
		if(element.length == 1){
			var lis = $(element).parents("li");
			lis[0] = null;
			$(lis).find("a.reveal.activate:first").click();
		}
	}
	
	function openDeleteConfirmPopup(event){
		if($("#deleteConfirmPopup").length == 0){
			var yes_action = function(){
				document.location = $("#deleteConfirmPopup").data('link');
				return false;
			};
			var no_action = function(){
				$("#deleteConfirmPopup").popup('close');
				return false;
			}; 
			
			buildConfirmDialog('deleteConfirmPopup', STR_DELETE_CONFIRM, new Array({label : STR_YES, action: yes_action, icon: "detail"}, {label : STR_NO, action: no_action, icon: "delete noPrompt"}));
		}
		
		$("#deleteConfirmPopup").popup();
		$("#deleteConfirmPopup").data('link', $(event.currentTarget).prop("href"));
		return false;
	}

	function openSaveBrowsingStepsPopup(link){
		$.get(root_url + link, null, function(data){
			data = $.parseJSON(data);
			$("#default_popup").html("<div class='wrapper'><div class='frame'>" + data.page + "</div></div>").popup();
			$("#default_popup input[type=text]").first().focus();
			$("#default_popup form").attr("action", 'javascript:popupSubmit("' + $("#default_popup form").attr("action") + '");');
		});
	}
	
	function popupSubmit(url){
		$.post(url, $("#default_popup form").serialize(), function(data){
			console.log(data);
			data = $.parseJSON(data);
			if(data.type == 'form'){
				$("#default_popup").html("<div class='wrapper'><div class='frame'>" + data.page + "</div></div>").popup();
				$("#default_popup input[type=text]").first().focus();
				$("#default_popup form").attr("action", 'javascript:popupSubmit("' + $("#default_popup form").attr("action") + '");');
			}else if(data.type == 'message'){
				$("#message").remove();
				buildDialog("message", data.message, null, [{icon : 'detail', action : function(){ $("#message").popup('close'); return false; }, label : STR_OK}]);
				$("#message").popup();
			}
		});
	}
	
	/**
	 * Will see if the last_request time has changed in order to stop the rotating beam. Used by CSV download.
	 */
	function fetchingBeamCheck(){
		if(submitData.lastRequest != $.cookie('last_request')){
			$(document).find('a.submit span.fetching').removeClass('fetching');
		}else{
			submitData.callBack = setTimeout(fetchingBeamCheck, 1000);
		}
	}
	
	function sectionCtrl(event){
		if($(event.srcElement).hasClass('delete')){
			//hide the content in the button data
			$(event.srcElement).parents(".descriptive_heading:first").nextAll(".section:first").appendTo("body").hide();
			$(event.srcElement).data("section", $("body .section:last"));
			$(event.srcElement).parents(".descriptive_heading:first").css("text-decoration", "line-through");
			$(event.srcElement).removeClass('delete').addClass('redo');
		}else{
			$(event.srcElement).parents(".descriptive_heading:first").after($(event.srcElement).data("section").show());
			$(event.srcElement).parents(".descriptive_heading:first").css("text-decoration", "none");
			$(event.srcElement).addClass('delete').removeClass('redo');
		}
		
		if($(".descriptive_heading a.sectionCtrl.delete").length == 0){
			$(".flyOverSubmit").hide();
		}else{
			$(".flyOverSubmit").show();
		}
		
		flyOverSubmit();
		return false;
	}
