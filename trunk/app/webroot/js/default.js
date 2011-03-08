var toolTarget = null;
var useHighlighting = jQuery.browser.msie == undefined || jQuery.browser.version >= 9;

function initSummary(){
	var open = function(){
		var summary_hover = $(this);
		var summary_popup = summary_hover.find('ul');
		var summary_label = summary_hover.find('span');
		if ( summary_popup.length>0 ) {
			summary_popup.stop(true, true).slideDown(100);
		}
	};
	var close = function(){
		var summary_hover = $(this);
		var summary_popup = summary_hover.find('ul');
		var summary_label = summary_hover.find('span');
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
 * Inits actions bars (main one and ajax loaded ones). Unbind the actions before rebinding them to avoid duplicate bindings
 */
function initActions(){
	$('div.actions div.bottom_button').unbind('mouseenter', actionMenuShow).unbind('mouseleave', actionMenuHide).bind('mouseenter', actionMenuShow).bind('mouseleave', actionMenuHide);
	$('div.actions a.down').unbind('click', actionClickDown).click(actionClickDown);
	$('div.actions a.up').unbind('click', actionClickUp).click(actionClickUp);
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

	function initDatepicker(elements){
		$(elements).each(function(){
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

			//activate fake_datepicker in case there is a problem with z-index
			$(this).parent().children("img").click(function(){
				$(this).datepicker('show');
			});

			//bug fix for Safari and Chrome
			$(this).click(function(){
				$(this).datepicker('show');
			});
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
					$(this).parent().append("<span class='adv_ctrl " + $($field).attr("class") + "' style='" + $($field).attr("style") + "'>" + STR_OR + " " + fieldHTML + "<a href='#' onclick='return false;' class='adv_ctrl btn_rmv_or'>(-)</a></span> ");
					//find the newly generated input
					var $newField = $(this).parent().find("span.adv_ctrl:last");
					
					initDatepicker($($newField).find(".datepicker"));
					
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
		
		$(scope).find(".range").each(function(){
			//uses .btn_add_or to know if this is a search form and if advanced controls are on
			$(this).parent().parent().parent().append(" <a href='#' class='range_btn'>(" + STR_RANGE + ")</a>");
		});
		$(scope).find(".range_btn").toggle(function(){
			var cell = getParentElement(this, "TD");
			$(cell).find("input").val("");
			if($(cell).find(".range_span").length == 0){
				var baseName = $(cell).find("input").attr("name");
				baseName = baseName.substr(0, baseName.length - 3);
				$(cell).find("span:first").addClass("adv_ctrl");
				$(cell).prepend("<span class='range_span'><input type='text' name='" + baseName + "_start]'/> " + STR_TO + " <input type='text' name='" + baseName + "_end]'/></span>");
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
			var fctMod = function(param){ return parseFloat(param.replace(/,/g, ".")) };
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
			for(i = 0; i < parent_elem.length; i ++){
				//find the current element
				if(parent_elem[i] == this){
					for(j = i - 1; j >= 0; j --){
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
				initToolPopup(newLines);
				if(window.copyControl){
					bindCopyCtrl(newLines);
				}
				initLabBook(newLines);
				$(newLines).removeClass("newLine");
				return false;
			});
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
		$(scope).find("input, select, textarea").each(function(){
			for(var i in labBookFields){
				var currName = $(this).attr("name"); 
				if(currName.indexOf(labBookFields[i]) > -1){
					fields.push($(this));
					$(this).after("<span class='labBook'>[" + STR_LAB_BOOK + "]</span>");
				}else if(currName == "data[DerivativeDetail][sync_with_lab_book]"){
					checkbox = $(this);
				}
			}
		});
		if(checkbox != null){
			$(checkbox).click(function(){
				$(fields).toggle();
				$(scope).find(".labBook").toggle();
			});
			if($(checkbox).attr("checked")){
				$(fields).toggle();
				$(scope).finds(".labBook").toggle();
			}
		}
		if(window.labBookHideOnLoad){
			$(fields).toggle();
			$(scope).find(".labBook").toggle();
		}
	}
	
	function initLabBookPopup(){
		$("div.rightCell a:not(.not_allowed)").first().click(function(){
			$.get($(this).attr("href"), labBookPopupAddForm);
			return false;
		});
	}
	
	function labBookPopupAddForm(data){
		$("#default_popup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>").popup();
		initDatepicker("#default_popup .datepicker");
		$("#default_popup a.form.submit").unbind('click').attr('onclick', '').click(function(){
			$(this).hide();
			$.post($("#default_popup form").attr("action"), $("#default_popup form").serialize(), function(data2){
				if(data2.length < 100){
					console.log(data2);
					//saved
					$("#default_popup").popup('close');
					$("input, select").each(function(){
						if($(this).attr("name") == 'data[DerivativeDetail][lab_book_master_code]'){
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
		
		if(window.realiquotInit){
			$("a.submit").attr("onclick", "").unbind('unclick').click(function(){
				if($("select").val().length > 0){
					$("form").submit();
				}
				return false;
			});
		}
		
		initDeleteConfirm();
		
		if(useHighlighting){
			//field highlighting
			if($("#table1row0").length == 1){
				//gridview
				$('form').highlight('td');
			}else{
				$('form').highlight('tr');
			}
		}
		initAutocomplete(document);
		initAdvancedControls(document);
		initToolPopup(document);
		initTooltips();
		initActions();
		initSummary();
		initAjaxClass(document);
		
		//calendar controls
		$.datepicker.setDefaults($.datepicker.regional[locale]);
		initDatepicker(".datepicker");
		
		initCheckAll(document);
		
		initAddLine(document);
		initRemoveLine(document);
		
		$(document).ajaxError(function(event, xhr, settings, exception){
			if(xhr.status == 403){
				//access denied, most likely a session timeout
				document.location = "";
			}
		});
		
		//focus on first field
		$("input, select, textarea").first().focus();
	}

	function debug(str){
//		$("#debug").append(str + "<br/>");
	}
