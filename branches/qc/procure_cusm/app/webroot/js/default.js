var toolTarget = null;
var useHighlighting = jQuery.browser.msie == undefined || jQuery.browser.version >= 9;
var submitData = new Object();
var orgAction = null;
var removeConfirmed = false;
var contentMargin = parseInt($("#wrapper").css("border-left-width")) + parseInt($("#wrapper").css("margin-left"));
var sessionTimeout = new Object();
var checkedData = [];
var DEBUG_MODE_JS = 0;
var sessionId = "";
columnLarge = (typeof columnLarge!=='undefined')?columnLarge:false;
//window.alert = function(a){
//    console.log(a);
//}

$(document).ready(function () {
    $("#authMessage").prepend('<span class="icon16 delete mr5px"></span>');
    var $tds = $("div.pasteDisabled").closest("td");
    $tds.each(function () {
        var $td = $(this);
        var index = $td.index();
        $th = $td.closest("table").find("tr:last-child").children("th:nth-child(" + (index + 1) + ")");
        if ($th.find(".pasteDisabledBefore").length === 0) {
            $th.append("<div class='pasteDisabledBefore'></div>");
        }
    });
    if (typeof dataLimit !== 'undefined') {
        if (typeof controller !== 'undefined' && typeof action !== 'undefined') {
            checkedData = [];
            checkedData[controller] = [];
            checkedData[controller][action] = [];
        }
        $("#wrapper").find("a[href*='limit:'], a[href*='page:'], a[href*='sort:']").each(function () {
            if (!$(this).hasClass("submit")) {
                $(this).attr("data-href", $(this).prop('href'));
                $(this).prop('href', 'javascript:void(0)');
            }
        });
        $("#wrapper").delegate("a[data-href]", 'click', function () {
            var url = $(this).attr("data-href");
            $.ajax({
                type: "GET",
                url: url + "/noActions:/",
                cache: false,
                success: successFunction,
                error: errorFunction
            });
        });

        function successFunction(data) {
            if (typeof DEBUG_MODE !== 'undefined' && DEBUG_MODE > 0) {
                try {
                    var myName = arguments.callee.toString();
                    myName = myName.substr('function '.length);
                    myName = myName.substr(0, myName.indexOf('('));
                    console.log (myName);
                    if (DEBUG_MODE_JS > 0) {
                        debugger ;
                    }
                } catch (ex) {
                }
            }

            var domNodes = document.createElement('div');
            if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                saveSqlLogAjax(ajaxSqlLog);
            }
            
            $(domNodes).html(data);
            $(domNodes).find("a[href*=':']").each(function () {
                if (!$(this).hasClass("submit")) {
                    $(this).attr("data-href", $(this).prop('href'));
                    $(this).prop('href', 'javascript:void(0)');
                }
            });

            var id;
            var checkboxes = $(domNodes).find("input[name^='data[" + dataIndex + "]'][type!='hidden']");
            checkedData[controller][action].forEach(function (item) {
                $(domNodes).find("input[name^='data[" + dataIndex + "]'][type!='hidden'][value='" + item.id + "']").prop("checked", item.checked);
                $(domNodes).find("input[name^='data[" + dataIndex + "]'][type!='hidden'][value='" + item.id + "']").closest("tr").addClass("chkLine")
            });

            $(checkboxes).each(function () {
                $this = $(this);
                id = $this.val();
                checked = $this.is(':checked');
                index = checkedData[controller][action].findIndex(function (item) {
                    return item.id === id;
                });
                if (index !== -1) {
                    $this.prop("checked", true);
                }
            });


            $("#wrapper").children("form").remove();
            $("#wrapper").prepend($(domNodes).children("form").first());
            initCheckAll("#wrapper");
        }

        var errorFunction = function (jqXHR, textStatus, errorThrown) {
            //$(document).remove('#popupError');
            //var popupError = "<div id=\"popupError\"><p>" + jqXHR + "</p><p>" + textStatus + "</p><p>" + errorThrown + "</p></div>";
            //popupError = "<div id=\"popupError\"><p>" + jqXHR + "</p><p>" + textStatus + "</p><p>" + errorThrown + "</p></div>";
            //$(document).append(popupError);
//        $(popupError).popup();
            if (DEBUG_MODE_JS > 0) {
                console.log (jqXHR);
            }
        };
    }
    if (typeof duplicatedSamples !=='undefined'){
        treeTable=$("div#wrapper.wrapper.plugin_InventoryManagement.controller_Collections.action_detail .this_column_1.total_columns_2 table.columns.tree td ul.tree_root");
        findDuplicatedSamples(treeTable);
    }
});

jQuery.fn.fullWidth = function () {
    return parseInt($(this).width()) + parseInt($(this).css("margin-left")) + parseInt($(this).css("margin-right")) + parseInt($(this).css("padding-left")) + parseInt($(this).css("padding-right")) + parseInt($(this).css("border-left-width")) + parseInt($(this).css("border-right-width"));
};

if ($("#header div:first").length !== 0) {
    var header_total_width = $("#header div:first").fullWidth() + $("#header div:first").offset().left;
}

//Slide down animation (show) for action menu
var actionMenuShow = function () {
    var action_hover = $(this);
    var action_popup = action_hover.find('div.filter_menu');
    if (action_popup.length > 0) {
        //show current menu
        action_popup.slideDown(100);
    }
};

//Slide up (hide) animation for action menu.
var actionMenuHide = function () {
    var action_hover = $(this);
    var action_popup = action_hover.find('div.filter_menu');
    if (action_popup.length > 0) {
        action_popup.slideUp(100).queue(function () {
            $(this).clearQueue();
        });
    }
};

var menuMoveDistance = 174;
var actionClickUp = function () {
    var span_up = $(this);
    var move_ul = span_up.parent('div.filter_menu').find('ul');

    var position = move_ul.position();

    // only scroll if not already at edge...
    if (position.top < 0) {

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

var actionClickDown = function () {

    var span_up = $(this);
    var move_ul = span_up.parent('div.filter_menu').find('ul');

    var position = move_ul.position();


    // only scroll if not already at edge...
    if ((position.top - menuMoveDistance) > (-1 * move_ul.height())) {
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
function actionMouseweelHandler(event, delta) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    if ($(event.currentTarget).find("ul:animated").length == 0) {
        if (delta > 0) {
            $(event.currentTarget).find(".up").click();
        } else {
            $(event.currentTarget).find(".down").click();
        }
    }
    return false;
}

/**
 * Inits actions bars (main one and ajax loaded ones). Unbind the actions before rebinding them to avoid duplicate bindings
 */
function initActions() {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $('div.actions div.bottom_button').unbind('mouseenter', actionMenuShow).unbind('mouseleave', actionMenuHide).bind('mouseenter', actionMenuShow).bind('mouseleave', actionMenuHide);
    $('div.actions a.down').unbind('click', actionClickDown).click(actionClickDown);
    $('div.actions a.up').unbind('click', actionClickUp).click(actionClickUp);
    $('div.filter_menu.scroll').bind('mousewheel', actionMouseweelHandler);

    if (window.menuItems) {
        function actionDisplay(data) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}
            return '<span class="row" id="' + data.value + '"><span class="cell"><span class="icon16 ' + (data.style ? data.style : 'blank') + '"></span></span><span class="cell" style="padding-left: 5px;">' + data.label + '</span></span>';
        }

        function validateSubmit() {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}
            var errors = new Array();
            if ($("#actionsTarget input[type=hidden]").val() == "") {
                errors.push(errorYouMustSelectAnAction);
            }
            if ($(":checkbox:visible").length > 0 && $(":checkbox:checked").length == 0) {
                errors.push(errorYouNeedToSelectAtLeastOneItem);
            } else if ($("form").prop("action").indexOf("remove") != -1 && !removeConfirmed) {
                //popup do you wish do remove
                $("#popup").popup();
                return false;
            }

            if (errors.length > 0) {
                alert(errors.join("\n"));
                return false;
            }

            return true;
        }

        if (menuItems.length > 0) {
            $("#actionsTarget").fmMenu({
                data: $.parseJSON(menuItems),
                displayFunction: actionDisplay,
                defaultLabel: STR_SELECT_AN_ACTION,
                inputName: "data[Browser][search_for]",
                strBack: STR_BACK
            });
        }

        if (!window.errorYouMustSelectAnAction) {
            window.errorYouMustSelectAnAction = "js untranslated errorYouMustSelectAnAction";
        }
        if (!window.errorYouNeedToSelectAtLeastOneItem) {
            window.errorYouNeedToSelectAtLeastOneItem = "js untranslated errorYouNeedToSelectAtLeastOneItem";
        }

        orgAction = $("form").prop("action");

        $("a.submit").unbind('click').prop("onclick", "").click(function () {
            if (validateSubmit()) {
                var action = null;
                var actionTargetValue = $("#actionsTarget input[type=hidden]").val();
                if (actionTargetValue.indexOf('javascript:') >= 0) {
                    action = actionTargetValue;
                } else if (isNaN(actionTargetValue[0])) {
                    action = root_url + actionTargetValue;
                } else {
                    action = orgAction + actionTargetValue;
                }
                $(this).parents("form:first").prop("action", action).submit();
            }
            return false;
        });

        //popup to confirm removal (batchset)
        $(".button.confirm").click(function () {
            removeConfirmed = true;
            $("#popup").popup('close');
            $("form").submit();
        });
        $(".button.close").click(function () {
            $("#popup").popup('close');
        });

    }
}

function initDatepicker(scope) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $(scope).find(".datepicker").each(function () {
        var dateFields = $(this).parent().parent().find('input, select');
        var yearField = null;
        var monthField = null;
        var dayField = null;
        var date = null;
        for (var i = 0; i < dateFields.length; i++) {
            var tmpStr = $(dateFields[i]).prop("name");
            var tmpLen = tmpStr.length;
            if (dateFields[i].nodeName != "SPAN") {
                if (tmpStr.substr(tmpLen - 7) == "][year]") {
                    yearField = dateFields[i];
                } else if (tmpStr.substr(tmpLen - 8) == "][month]") {
                    monthField = dateFields[i];
                } else if (tmpStr.substr(tmpLen - 6) == "][day]") {
                    dayField = dateFields[i];
                }
            }
        }
        if ($(yearField).val().length > 0 && $(monthField).val().length > 0 && $(dayField).val().length > 0) {
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
            beforeShow: function (input, inst) {
                //put the date back in place
                //because of datagrids copy controls we cannot keep the date in tmp
                var month = parseInt($(monthField).val(), 10);
                var day = parseInt($(dayField).val(), 10);
                if (isNaN(month)) {
                    month = "";
                } else if (month < 10 && month > 0) {
                    month = "0" + month;
                }
                if (isNaN(day)) {
                    day = "";
                } else if (day < 10 && day > 0) {
                    day = "0" + day;
                }
                var tmpDate = $(yearField).val() + "-" + month + "-" + day;
                if (tmpDate.length === 10) {
                    $(this).datepicker('setDate', tmpDate);

                }
            },
            onClose: function (dateText, picker) {
                //hide the date
                $(this).val(" ");//space required for Safari and Chome or the button disappears
                var dateSplit = dateText.split(/-/);
                if (dateSplit.length === 3) {
                    $(yearField).val(dateSplit[0]);
                    $(monthField).val(dateSplit[1]);
                    $(dayField).val(dateSplit[2]);
                }
            }
        });
        //bug fix for Safari and Chrome
        $(this).click(function () {
            showDatePicker(this);
        });
    });

    $(scope).find(".tooltip").each(function () {
        $(this).find("input").each(function () {
            $(this).focus(function () {
                //fixes a datepicker issue where the calendar stays open
                $("#ui-datepicker-div").stop(true, true);
                $(".datepicker").datepicker('hide');
                $(this).parent().find("div").css("display", "inline-block");
            });
            $(this).blur(function () {
                $(this).parent().find("div").css("display", "none");
            });
        });
        $(this).find("div").addClass("ui-corner-all").css({"border": "1px solid", "padding": "3px"});
    });
}

function showDatePicker(e) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $(e).datepicker('show');
}

function setFieldSpan(clickedButton, spanClassToDisplay) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $(clickedButton).parent().find("a").show();
    $(clickedButton).hide();
    $(clickedButton).parent().children("span").hide().each(function () {
        //store all active field names into their data and remove the name
        $(this).find("input, select").each(function () {
            if ($(this).prop('name').length > 0) {
                $(this).data('name', $(this).prop('name')).prop('name', '');
            }
        });
    });
    $(clickedButton).parent().find("span." + spanClassToDisplay).show().find('input, select').each(function () {
        //activate names of displayed fields
        $(this).prop('name', $(this).data('name'));
    });
}

/**
 * Advanced controls are search OR options and RANGE buttons
 */
function initAdvancedControls(scope) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    //for each add or button
    $(scope).find(".btn_add_or").each(function () {
        var $field = $(this).prev();
        //non range value, the OR is made to allow fields with CSV to be renamed but not cloned
        if ($($field).find("input, select").length == 1 || ($($field).find("input").length == 2 && $($($field).find("input")[1]).prop("type") == "file")) {
            $($field).find("input, select").first().each(function () {
                $(this).prop("name", $(this).prop("name") + "[]");
            });

            if ($($field).find("input").length == 2) {
                //rename complete, hide and bail out
                $(this).remove();
                return;
            }
            //when we click
            $(this).click(function () {
                //html template for that field
                var fieldHTML = $($field).html();
                //append it into the text field with "or" string + btn_remove
                $(this).parent().append("<span class='adv_ctrl " + $($field).prop("class") + "' style='" + $($field).prop("style") + "'>" + STR_OR + " " + fieldHTML + "<a href='#' onclick='return false;' class='adv_ctrl btn_rmv_or icon16 delete_mini'></a></span> ");
                //find the newly generated input
                var $newField = $(this).parent().find("span.adv_ctrl:last");

                initDatepicker($newField);

                initAutocomplete($newField);
                initToolPopup($newField);

                //bind the remove command to the remove button
                $(this).parent().find(".btn_rmv_or:last").click(function () {
                    $(this).parent().remove();
                });
                //move the add button to the end
                $(this).parent().append($(this));

                if (useHighlighting) {
                    //reset the highlighting
                    $('form').highlight('tr');
                }
            });
        } else {
            //range values, no add options
            $(this).remove();
        }
    });

    if ($(scope).find(".btn_add_or:first").length === 1) {
        var tabindex = null;
        
        var td, cell, tag;
        $(scope).find("td.content").each(function(){
            td=this;
            $(td).find(">span").each(function(){
                tag=$(this).find("span.tag");
                tag.insertBefore($(this));
                $(this).wrap("<span class='span-content'></span>");
            });
        });
        
        $(scope).find(".range").each(function () {
            //uses .btn_add_or to know if this is a search form and if advanced controls are on
//            cell = $(this).parent().parent().parent();
            cell = $(this).closest("span.span-content");
            $(cell).append(" <a href='#' class='icon16 range range_btn' title='" + STR_RANGE + "'></a> " +
                    "<a href='#' class='icon16 specific specific_btn'></a>").data('mode', 'specific').find(".specific_btn").hide();
            $(cell).find("span:first").addClass("specific_span");

            var baseName = $(cell).find("input").prop("name");
            if (baseName.substr(baseName.length-3,baseName.length-1)=="][]"){
                baseName = baseName.substr(0, baseName.length - 3);
            }else{
                baseName = baseName.substr(0, baseName.length - 1);
            }
            tabindex = $(cell).find("input").prop("tabindex");
            $(cell).prepend("<span class='range_span hidden'><input type='text' tabindex='" + tabindex + "' name='" + baseName + "_start]'/> "
                    + STR_TO
                    + " <input type='text' tabindex='" + tabindex + "' name='" + baseName + "_end]'/></span>");
        });
        
        $(scope).find(".file").each(function () {
//            cell = $(this).parent().parent().parent();
            cell = $(this).closest("span.span-content");
            $(cell).append(" <a href='#' class='icon16 csv_upload file_btn'></a>").data('mode', 'specific');

            if ($(cell).find(".specific_btn").length === 0) {
                $(cell).append(" <a href='#' class='icon16 specific specific_btn'></a>").find(".specific_btn").hide();
                $(cell).find("span:first").addClass("specific_span");
                tabindex = $(cell).find("input").prop("tabindex");
            }
//            var name = $(cell).find("input:last").prop("name");
            var name = $(this).prop("name");
            name = name.substr(0, name.length - 3) + "_with_file_upload]";
            $(cell).prepend("<span class='file_span hidden'><input type='file' tabindex='" + tabindex + "' name='" + name + "'/></span>");

        });
        //store hidden field names into their data
        $(scope).find("span.range_span input, span.file_span input").each(function () {
            $(this).data('name', $(this).prop('name')).prop('name', "");
        });

        //trigger buttons
        $(scope).find(".range_btn").click(function () {
            setFieldSpan(this, "range_span");
            return false;
        });
        $(scope).find(".specific_btn").click(function () {
            setFieldSpan(this, "specific_span");
            return false;
        });
        $(scope).find(".file_btn").click(function () {
            setFieldSpan(this, "file_span");
            return false;
        });
        
    }
}

/**
 * Remove the row that contains the element
 * @param element The element contained within the row to remove
 */
function removeParentRow(element) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    element = $(element).parents("tr:first");

    if ($(element)[0].nodeName == "TR") {
        $(element).remove();
    }
}

function initAutocomplete(scope) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $(scope).find(".jqueryAutocomplete").each(function () {
//        var element = $(this);
        var url=(root_url == "/" ? "" : root_url) + $(this).attr("url");
        $(this).autocomplete({
            //if the generated link is ///link it doesn't work. That's why we have a "if" statement on root_url
//            source: (root_url == "/" ? "" : root_url) + $(this).attr("url"),
                    //alternate source for debugging
            source: function(request, response) {
                    $.get(url, request, function(data){
                        if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                            var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                            data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                            saveSqlLogAjax(ajaxSqlLog);
                        }                        
                        response(JSON.parse(data));
                    });
            }
        });
    });
}

function initAliquotVolumeCheck() {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    var checkFct = function () {
        var fctMod = function (param) {
            return parseFloat(param.replace(/,/g, "."));
        };
        var denom = fctMod($("#AliquotMasterCurrentVolume").val());
        var nom = fctMod($("#AliquotUseUsedVolume").val());
        if ($("#AliquotUseUsedVolume").val().length > 0 && nom > denom) {
            $("input, textarea, a").blur();
            $("#popup").popup();
            return false;
        } else {
            $("#submit_button").click();
        }
    };

    $("form").submit(checkFct);
    $(".form.submit").unbind('click').prop("onclick", "return false;");
    $(".form.submit").click(checkFct);

    $(".button.confirm").click(function () {
        $("#popup").popup('close');
        $("#submit_button").click();
    });
    $(".button.close").click(function () {
        $("#popup").popup('close');
    });
}

function refreshTopBaseOnAction() {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $("form").prop("action", root_url + actionControl + $("#0Action").val());
}

function initActionControl(actionControl) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $($(".adv_ctrl.btn_add_or")[1]).parent().parent().find("select").change(function () {
        refreshTopBaseOnAction(actionControl);
    });
    $(".adv_ctrl.btn_add_or").remove();
    refreshTopBaseOnAction(actionControl);
}

/**
 * Initialises check/uncheck all controls
 * @param scope The scope where to look for those controls. In a popup, the scope will be the popup box
 */
function initCheckAll(scope) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $(scope).find(".checkAll").each(function () {
        var elemParent = $(this).parents("table:first");
        $(this).click(function () {
            if (typeof dataLimit !== 'undefined') {
                var data = $(elemParent).find('input[type=checkbox]');
                data.each(function () {
                    if (!$(this).is(":checked")) {
                        $(this).prop("checked", true);
                        if (!checkData($(this), dataLimit, null, true)) {
                            $(this).prop("checked", false);
                            return false;
                        }
                    }

                    $(this).parents("tr:first").addClass("chkLine");
                });
            } else {
                $(elemParent).find('input[type=checkbox]').prop("checked", true);
                $(elemParent).find('input[type=checkbox]:first').parents("tr:first").addClass("chkLine").siblings().addClass("chkLine");
            }
            return false;
        });
        $(elemParent).find(".uncheckAll").click(function () {
            if (typeof dataLimit !== 'undefined') {
                $(elemParent).find('input[type=checkbox]').each(function () {
                    var id, checked, index;
                    id = $(this).val();
                    checked = $(this).is(":checked");
                    if (checked) {
                        index = checkedData[controller][action].findIndex(function (item) {
                            return item.id === id;
                        });
                        if (index !== -1) {
                            checkedData[controller][action].splice(index, 1);
                        }
                    }
                });
            }
            $(elemParent).find('input[type=checkbox]').prop("checked", false);
            $(elemParent).find('input[type=checkbox]:first').parents("tr:first").removeClass("chkLine").siblings().removeClass("chkLine");

            return false;
        });
    });
}

/**
 * @param id
 * @param title
 * @param content
 * @param buttons Array containing json containing keys icon, label and action
 */
function buildDialog(id, title, content, buttons) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    var buttonsHtml = "";
    if (buttons != null && buttons.length > 0) {
        for (i in buttons) {
            buttonsHtml +=
                    '<div id="' + id + i + '" class="bottom_button"><a href="javascript:void(0)" class="' + buttons[i].icon + '"><span class="icon16 ' + buttons[i].icon + '"></span>' + buttons[i].label + '</a></div>';
        }
        buttonsHtml = '<div class="actions split">' + buttonsHtml + '</div>';
    }
    $("#" + id).remove();
    $("body").append('<div id="' + id + '" class="std_popup question">' +
            '<div class="wrapper">' +
            '<h4>' + title + '</h4>' +
            (content == null ? '' : ('<div style="padding: 10px; background-color: #fff;">' + content + '</div>')) +
            buttonsHtml +
            '</div>' +
            '</div>');

    for (i in buttons) {
        $("#" + id + i).click(buttons[i].action);
    }
}

function buildConfirmDialog(id, question, buttons) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    buildDialog(id, question, null, buttons);
}

//tool_popup
function initToolPopup(scope) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $(scope).find(".tool_popup").click(function () {
        var parent_elem = $(this).parent().children();
        toolTarget = null;
        for (var i = 0; i < parent_elem.length; i++) {
            //find the current element
            if (parent_elem[i] == this) {
                for (var j = i - 1; j >= 0; j--) {
                    //find the previous input
                    if (parent_elem[j].nodeName == "INPUT") {
                        toolTarget = parent_elem[j];
                        break;
                    }
                }
                break;
            }
        }
        $.get($(this).prop("href"), null, function (data) {
            if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                saveSqlLogAjax(ajaxSqlLog);
            }
            
            $("#default_popup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>").popup();
            $("#default_popup input[type=text]").first().focus();
        });
        return false;
    });
}

function initFlyOverCellsLines(newLines) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    totalColspan = $(".floatingBckGrnd").data("totalColspan");
    $(newLines).each(function (index, element) {
        for (var i = 0; i <= totalColspan; ++i) {
            putIntoRelDiv(i, $(element).find("td:nth-child(" + i + ")"));
        }
    })
}

function initAddLine(scope) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $(scope).find(".addLineLink").each(function () {
        //get the table row
        var table = $(this).parents("table:first");
        var tableBody = $(table).find("tbody");
        var lastLine = $(tableBody).find("tr:last");
        var templateLineHtml = lastLine.html();
        $(lastLine).remove();
        var lineIncrement = $(tableBody).find("tr").length;
        $(this).click(function () {
            var counter = $(table).find(".addLineCount").length == 1 ? $(table).find(".addLineCount").val() : 1;
            while (counter > 0) {
                $(tableBody).append("<tr class='newLine'>" + templateLineHtml.replace(/\[%d\]\[/g, '[' + lineIncrement++ + '][') + "</tr>");
                counter--;
            }
            var newLines = $(tableBody).find("tr.newLine");
            if (newLines.length) {
                initAutocomplete(newLines);
                initDatepicker(newLines);
                initToolPopup(newLines);
                initCheckboxes(newLines);
                $('form').highlight('td');
                if (window.copyControl) {
                    bindCopyCtrl(newLines);
                }
                if (window.labBookFields) {
                    initLabBook(newLines);
                }
                initAccuracy(newLines);
                resizeFloatingBckGrnd($(table).find(".floatingBckGrnd"));
                initFlyOverCellsLines(newLines);
                flyOverComponents();


                $(newLines).removeClass("newLine");
            }
            return false;
        });
    });

    $(scope).find(".addLineCount").keydown(function (e) {
        if (e.keyCode == 13) {
            return false;
        }
    }).keyup(function (e) {
        if (e.keyCode == 13) {
            $(this).siblings(".addLineLink").click();
            return false;
        }
    });

    if ($(".jsChronology").length > 0) {
        $(".jsChronology").each(function () {
            var href = $(this).attr("href");
            if (href.indexOf('/Participants/') != -1) {
                $(this).addClass('participant');
            } else if (href.indexOf('/DiagnosisMasters/') != -1) {
                $(this).addClass('diagnosis');
            } else if (href.indexOf('/TreatmentMasters/') != -1) {
                $(this).addClass('treatments');
            } else if (href.indexOf('/Collections/') != -1) {
                $(this).addClass('collection');
            } else if (href.indexOf('/EventMasters/') != -1) {
                $(this).addClass('annotation');
            } else if (href.indexOf('/ConsentMasters/') != -1) {
                $(this).addClass('consents');
            }
        }).click(function () {
            $(".this_column_1.total_columns_2").css("width", "1%")
            var link = this;
            //remove highlighted stuff
            var td = $(".at").removeClass("at").find("td:last-child");
            $(td).html($(td).data('content'));
            var tr = $(link).parents("tr").first().addClass("at");
            td = $(tr).find("td").last();
            $(td).data('content', $(td).html());
            $(td).html('<div style="position: relative;">' + $(td).html() + '<div class="treeArrow" style="display: block"></div></div>');

            if ($(link).data('cached_result')) {
                $("#frame").html($(link).data('cached_result'));
                initActions();
                dynamicHeight = $("#dynamicHeight");
                frame =  $("#frame");
                frameHeight = frame.height();
                tr = $(link).parents("tr").first().addClass("at");
                td = $(tr).find("td").last();

                var topValue = $(td).position().top - frameHeight;
                if (topValue<0){
                        topValue=0;
                }
                dynamicHeight.css("height", topValue);

            } else {
                $("#frame").html("<div class='loading'></div>");
                $.get($(this).attr("href") + "?t=" + new Date().getTime(), function (data) {
                    if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                        var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                        data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                        saveSqlLogAjax(ajaxSqlLog);
                    }
                    
                    $("#frame").html(data);
                    $(link).data('cached_result', data);
                    initActions();
                    
                    dynamicHeight = $("#dynamicHeight");
                    frame =  $("#frame");
                    frameHeight = frame.height();
                    tr = $(link).parents("tr").first().addClass("at");
                    td = $(tr).find("td").last();

                    var topValue = $(td).position().top - frameHeight;
                    if (topValue<0){
                            topValue=0;
                    }
                    dynamicHeight.css("height", topValue);
                    
                });
            }
            return false;
        });
        columnLarge = (typeof columnLarge!='undefined')?columnLarge:false;
        if (!columnLarge){
            $(".this_column_1.total_columns_1").removeClass("total_columns_1").addClass("total_columns_2").css("width", "1%").parent().append(
                    '<td class="this_column_2 total_columns2"><div id="frame"></td>'
                    );
        }else{
            $(".this_column_1.total_columns_1").removeClass("total_columns_1").addClass("total_columns_2").css("width", "100%").parent().append(
                    '<td class="this_column_2 total_columns2"><div id="dynamicHeight"></div><div id="frame"></div></td>'
                    );
        }

    }
}

function resizeFloatingBckGrnd(floatingBckGrnd) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    table = $(floatingBckGrnd).parents("table:first");
    computeSum = function (obj, cssArr) {
        total = 0;
        for (var i in cssArr) {
            total += parseFloat(obj.css(cssArr[i]));
        }
        return total;
    };
    psSize = function (obj, direction) {
        arr = ["margin-%s", "padding-%s", "border-%s-width"];
        newArr = [];
        for (var i in arr) {
            newArr.push(arr[i].replace("%s", direction));
        }
        return computeSum(obj, newArr);
    };
    var totalColspan = $(floatingBckGrnd).data("totalColspan");
    if (typeof totalColspan !=='undefined'){
        var lastTd = $(table).find("tbody tr:last td:nth-child(" + totalColspan + ")").eq(0);
        if (!lastTd.length) {
            //no more rows
            lastTd = $(table).find("thead tr:last th:nth-child(" + totalColspan + ")").eq(0);
        }
        var firstTh = $(table).find("th.floatingCell:last").parent().find("th:first").eq(0);
        width = lastTd.width() + lastTd.position().left + psSize(lastTd, "right") - firstTh.position().left + psSize(firstTh, "left") + 1;
        height = Math.ceil(lastTd.position().top + lastTd.outerHeight() - firstTh.position().top);
        if ($(floatingBckGrnd).data("onlyDimension") == undefined) {
            $(floatingBckGrnd).data("onlyDimension", true);
            $(floatingBckGrnd).css({
                "top": "-" + ($(floatingBckGrnd).offset().top - $(floatingBckGrnd).parents("th:first").offset().top - $(floatingBckGrnd).position().top) + "px",
                "left": "-" + ($(floatingBckGrnd).offset().left - $(firstTh).offset().left) + "px",
                "width": width + "px",
                "height": height + "px"
            });
        } else {
            $(floatingBckGrnd).css({
                "width": width + "px",
                "height": height + "px"
            });
        }
    }
}

function removeLine(event) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    var floatingBckGrnd = $(event.target).parents("table:first").find(".floatingBckGrnd");
    $(event.target).parents("tr:first").remove();
    resizeFloatingBckGrnd(floatingBckGrnd);
    return false;
}

function initAjaxClass(scope) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    //ajax controls
    //evals the json within the class of the element and calls the method defined in callback
    //the callback method needs to take this and json as parameters
    $(scope).find(".ajax").click(function () {
        try {
            json = $(this).data('json');
            var fct = eval("(" + json.callback + ")");
            fct.apply(this, [this, json]);
        } catch (e) {
            console.log(e);
        }
        return false;
    });
}

function initLabBook(scope) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    var fields = new Array();
    var checkbox = null;
    var codeInputField = null;

    $(scope).find("input, select, textarea").each(function () {
        var currName = $(this).prop("name");
        for (var i in labBookFields) {
            if (labBookFields[i].length == 0) {
                continue;
            }
            if (currName.indexOf(labBookFields[i]) > -1) {
                fields.push($(this));
                var parentTd = $(this).parents("td:first");
                if ($(parentTd).find(".labBook").length == 0) {
                    $(this).after("<span class='labBook'>[" + STR_LAB_BOOK + "]</span>");
                }
                fields.push($(parentTd).find(".datepicker, .accuracy_target_blue"));
            }
        }
        if (currName.indexOf("[sync_with_lab_book]") > 0) {
            checkbox = $(this);
        } else if (currName.indexOf("[lab_book_master_code]") > 0) {
            codeInputField = $(this);
        }
    });

    var tmpFunc = function () {
        labBookFieldsToggle(scope, fields, codeInputField, checkbox);
    };

    if (checkbox != null) {
        $(checkbox).click(tmpFunc);
    }
    if (codeInputField != null) {
        $(codeInputField).change(tmpFunc).keyup(tmpFunc).blur(tmpFunc);
    }

    if (window.labBookHideOnLoad) {
        $(fields).toggle();
        $(scope).find(".labBook").show();
    } else {
        tmpFunc();
    }
}

function labBookFieldsToggle(scope, fields, codeInputField, checkbox) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    var toggle = false;
    if ($(scope).find(".labBook:visible").length == 0) {
        //current input are visible, see if we need to hide
        if ((checkbox != null && $(checkbox).prop("checked")) || (codeInputField != null && $(codeInputField).val().length > 0)) {
            toggle = true;
        }
    } else {
        //current input are hidden, see if we need to display
        if ((checkbox == null || !$(checkbox).prop("checked")) && (codeInputField == null || $(codeInputField).val().length == 0)) {
            toggle = true;
        }
    }
    if (toggle) {
        $(fields).toggle();
        $(scope).find(".labBook").toggle();
    }
}

function initLabBookPopup() {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $("div.bottom_button a:not(.not_allowed).add").first().click(function () {
        $.get($(this).prop("href"), labBookPopupAddForm);
        return false;
    });
}

function labBookPopupAddForm(data) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}
    if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
        var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
        data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
        saveSqlLogAjax(ajaxSqlLog);
    }

    $("#default_popup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>").popup();
    initDatepicker("#default_popup");
    initAccuracy("#default_popup");
    $("#default_popup a.submit").unbind('click').prop('onclick', '').click(function () {
        $(this).hide();
        $.post($("#default_popup form").prop("action"), $("#default_popup form").serialize(), function (data2) {
            if (data2.length < 100) {
                //saved
                $("#default_popup").popup('close');
                $("input, select").each(function () {
                    if ($(this).prop("name").indexOf('lab_book_master_code') != -1) {
                        $(this).val(data2);
                    }
                });
            } else {
                //redisplay
                labBookPopupAddForm(data2);
            }
        });
        return false;
    });
    $("#default_popup form").submit(event, function () {
        event.preventDefault();
        return false;
    });
    $("#default_popup input[type=text]").first().focus();
}

function initCheckboxes(scope) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $(scope).find("input[type=checkbox]").each(function () {
        if (!$(this).data("exclusive")) {
            var checkboxes = $(this).parent().find("input[type=checkbox]");
            $(checkboxes).each(function () {
                $(this).data("exclusive", true);
            });
            $(checkboxes).click(function () {
                var checked = $(this).prop("checked");
                $(checkboxes).prop("checked", false);
                $(this).prop("checked", checked);
            });
        }
    });
    
    $(scope).find("input[type=checkbox]").each(function(){
        $(this).click(function(){
            $currentCheckBox=$(this);            
            $parent=$currentCheckBox.parent();
            $checkBoxesChildren = $parent.children('input[type=checkbox]');

            $required=false;
            $checkBoxesChildren.each(function () {
                if ($(this).prop('required')) {
                    $required=true;
                    $(this).prop('required', false);
                }
            });
            
            if ($required){
                $currentCheckBox.prop('required', true);
            }
        });
    });
}

function initAccuracy(scope) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $(scope).find(".accuracy_target_blue").click(function () {
        if ($(this).find("input").length == 0) {
            //accuracy going to year
            $(this).parent().find("input, select").each(function () {
                if ($(this).prop("name").indexOf("year") == -1) {
                    $(this).hide();
                }
            });
            var name = $(this).parent().find("input, select").first().prop("name");
            $(this).html("<input type='hidden' class='accuracy' name='" + name.substr(0, name.lastIndexOf("[")) + "[year_accuracy]' value='1'/>");
        } else {
            //accuracy going to manual
            $(this).html("");
            $(this).parent().find("input, select").show();
        }
        return false;
    });

    $(scope).find(".accuracy_target_blue").each(function () {
        if ($(this).siblings().find(".labBook:visible").length > 0) {
            $(this).hide();
        } else {
            var current_accuracy_btn = this;
            $(this).parent().find("input, select").each(function () {
                if ($(this).prop("name").indexOf("year") != -1 && $(this).hasClass('year_accuracy')) {
                    $(this).removeClass('year_accuracy');
                    $(current_accuracy_btn).click();
                }
            });
        }
    });
}

/**
 * Moves the submit button so that it always appear in the screen.
 * Moves the top right menu so that it's almost always in the screen. It 
 * will not overlap with the title.
 */
function flyOverComponents() {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		//console.log (myName);
		if (DEBUG_MODE_JS>0){
		   //debugger ;
		}
	}catch(ex){
	}
}

    var scrollLeft = $(document).scrollLeft();
    //submit
    $(".flyOverSubmit").each(function () {
        if ($(this).parents(".popup_container:first").length == 0) {
            $(this).css("right", (Math.max($(".submitBar").width() - $(window).width() - scrollLeft + 20, 0)) + "px");
        }
    });

    //top menu
    var r_pos = $(document).width() - $(window).width() - $(document).scrollLeft() + 10;
    var l_pos = $(window).width() + scrollLeft - $(".root_menu_for_header").width();
    if (l_pos < header_total_width) {
        r_pos -= header_total_width - l_pos;
    }

    $(".root_menu_for_header, .main_menu_for_header").css("right", r_pos);

    //cells
    if (scrollLeft > contentMargin) {
        $(".floatingBckGrnd .left").css("opacity", 1);
    } else {
        $(".floatingBckGrnd .left").css("opacity", 0);
    }
    $(".floatingBckGrnd .right div").css("opacity", Math.min(15, scrollLeft) * 0.03);
    $(".testScroll").css("left", scrollLeft);
}

function initAutoHideVolume() {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $("input[type=radio]").click(function () {
        if ($.inArray($(this).val(), volumeIds) > -1) {
            $("input[name=data\\[QualityCtrl\\]\\[used_volume\\]]").attr("disabled", false);
        } else {
            $("input[name=data\\[QualityCtrl\\]\\[used_volume\\]]").attr("disabled", true).val("");
        }
    });
    $("input[type=radio]:checked").click();
}

function handleSearchResultLinks() {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $(".ajax_search_results thead a, .ajax_search_results tfoot a").click(function () {
        $(".ajax_search_results").html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
        $.get($(this).attr("href"), function (data) {
            try {
                data = $.parseJSON(data);
                saveSqlLogAjax(data);
                
                $(".ajax_search_results").html(data.page);
                history.replaceState(data.page, "foo");//storing result in history
                handleSearchResultLinks();
            } catch (exception) {
                //simply submit the form then
                document.location = $(this).attr("href");
            }
        });
        return false;
    });
}

function databrowserToggleSearchBox(cell) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $(cell).parent().find("span, a").toggle();
    return false;
}

function warningMoreInfoClick(event) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    //only called on the first click of each element, then toggle function handles it
    if ($(event.target).data('opened')) {
        $(this).html("[+]").siblings("pre.warningMoreInfo").hide();
        $(event.target).data('opened', false);
    } else {
        $(this).html("[-]").siblings("pre.warningMoreInfo").show();
        $(event.target).data('opened', true);
    }
}

function getTime(){
    $(function () {
      $.ajax({
        type: 'GET',
        cache: false,
        url: location.href,
        complete: function (req, textStatus) {
          var dateString = req.getResponseHeader('Date');
          if (dateString.indexOf('GMT') === -1) {
            dateString += ' GMT';
          }
          var date = new Date(dateString);
        console.log(["server time:", localDate]);
        }
      });
      var localDate = new Date();
      console.log(["local time:", localDate]);
    });    
}



function sessionExpired() {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    if ($("#loginPopup").length == 0) {
        $("body").append("<div id='loginPopup' class='std_popup'><div class='loading'>--- " + STR_LOADING + " ---</div></div>");
    }
    var submitFunction = function () {
        $.post(root_url + "Users/Login/login:/", $("#loginPopup form").serialize(), function (data) {
            if (data.indexOf('ok') == 0) {
                $.get(root_url + "Menus", function () {
                    //dumb call to refresh cookies
                    $("#loginPopup").popup('close');
                });
            } else if (data.indexOf('nok') == 0){
                window.location = root_url + "Menus";
            }else {
                $("#loginPopup").html("<div class='wrapper'>" + data + "</div>");
                $("#loginPopup").popup();
                $("#loginPopup a.submit").click(submitFunction);
            }
        });
        $("#loginPopup").html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
        return false;
    };

    $.get(root_url + "Users/Login/login:/", function (data) {
        if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
            data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
        }
        
        $("#loginPopup").html("<div class='wrapper'>" + data + "</div>");
        $("#loginPopup").popup();
        $("#loginPopup form").submit(submitFunction);
    });
    $("#loginPopup").popup({closable: false, background: "black"});
}

function cookieWatch() {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		//console.log (myName);
		if (DEBUG_MODE_JS>0){
		   //debugger ;
		}
	}catch(ex){
	}
}
    if ($.cookie("session_expiration")) {
        if (!sessionTimeout.lastRequest || sessionTimeout.lastRequest !== $.cookie("last_request")+ sessionTimeout.serverOffset) {
            //5 to 1 second earlier expiration (due to 4 secs error margin)

            sessionTimeout.lastRequest = $.cookie("last_request")+ sessionTimeout.serverOffset;
            sessionTimeout.expirationTime =  ($.cookie("session_expiration") * 1000)+ sessionTimeout.serverOffset;
        }
        if (sessionTimeout.expirationTime > new Date().getTime() && $("#loginPopup:visible").length === 1) {
            $.post(root_url + "Users/getUserId", function (data) {
                if (data!=sessionId){
                    window.location = root_url + "Menus";
                }else{
                    $("#loginPopup").popup('close');
                }
            });
        }
    }

    if (sessionTimeout.expirationTime && sessionTimeout.expirationTime <= new Date().getTime() && $("#loginPopup:visible").length === 0) {
        sessionId = $.cookie("sessionId");
        sessionExpired();
    }

    setTimeout(cookieWatch, 1000);//1 seconds error margin
}

function initFileOptions(scope) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $(scope).find("input.fileOption[value=replace]").each(function () {
        // $(this).next("input") is not working, so using next().next()
        $(this).data("browse-html", $(this).next().next()[0].outerHTML);
        $(this).next().next().remove();
        $(this).data("replace-html", $(this).next()[0].outerHTML);
    });
    $(scope).find("input.fileOption").click(function (event) {
        if ($(this).val() == 'replace') {
            $(this).next().remove();
            $(this).after($(this).data("browse-html"));
        } else {
            $(this).parent().find("input.fileOption[value=replace]").each(function () {
                $(this).next().remove();
                $(this).after($(this).data("replace-html"));
            });
        }
    });
}

function initJsControls() {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    if (history.replaceState) {
        if (!history.state) {
            history.replaceState(new Object(), "foo");
        }
    }

    if (window.storageLayout) {
        initStorageLayout(window.storageLayout);
    }
    if (window.copyControl) {
        initCopyControl();
    }
    if (window.aliquotVolumeCheck) {
        initAliquotVolumeCheck();
    }
    if (window.actionControl) {
        initActionControl(window.actionControl);
    }
    if (window.ccl) {
        initCcl();
    }
    if (window.batchSetControls) {
        initBatchSetControls();
    }
    if (window.treeView) {
        initTreeView(document);
    }
    if (window.labBookFields) {
        initLabBook(document);
    }
    if (window.labBookPopup) {
        initLabBookPopup();
    }
    if (window.dropdownConfig) {
        initDropdownConfig();
    }
    if (window.volumeIds) {
        initAutoHideVolume();
    }
    if (window.permissionPreset) {
        loadPresetFrame();
    }
    if (window.wizardTreeData) {
        drawTree($.parseJSON(window.wizardTreeData));
    }
    if ($(".ajax_search_results").length == 1) {
        if (history.replaceState) {
            //doesn't work for IE < 10
            //TODO: prevent over clicking the submit btn
            beforeSubmitFct = function () {
                $("#footer").height(Math.max($("#footer").height(), $(".ajax_search_results").height()));//made to avoid page movement
                $(".ajax_search_results").html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
                $(".ajax_search_results").parent().show();
                flyOverComponents();
            };
            successFct = function (data) {
                try {
                    data = $.parseJSON(data);
                    saveSqlLogAjax(data);
                    $(".ajax_search_results").html(data.page)
                    history.replaceState(data.page, "foo");//storing result in history
                    //update the form action
                    $("form").attr("action", $("form").attr("action").replace(/[0-9]+(\/)*$/, data.new_search_id + "$1"));
                    handleSearchResultLinks();
                    //stop submit button animation
                    $("input.submit").siblings("a").find("span").removeClass('fetching');
                    flyOverComponents();
                } catch (exception) {
                    $(".ajax_search_results").html(data)
                    $("input.submit").siblings("a").find("span").removeClass('fetching');
                }
            };

            $("form").ajaxForm({
                url: $("form").attr("action"),
                success: successFct,
                beforeSubmit: beforeSubmitFct,
                error: function () {
                    console.log("ERROR");
                    //$("input.submit").siblings("a").find("span").removeClass('fetching');
                }
            });
        }
    }

    if (history.replaceState) {
        window.onpopstate = function (event) {
            //retrieving result from history
            if (event.state == null || typeof (event.state) == "object") {
                //new / refresh
                initIndexZones(false);
            } else {
                //back/forward
                $(".ajax_search_results_default").remove();
                $(".ajax_search_results").html(event.state);
                $(".ajax_search_results").parent().show();
                handleSearchResultLinks();
                initIndexZones(true);
            }
        };

        $(".ajax_search_results").html($(".ajax_search_results_default").html());
        $(".ajax_search_results").parent().show();
        $(".ajax_search_results_default").remove();
        handleSearchResultLinks();
        initIndexZones(false);
    } else {
        //unknown, always consider new
        initIndexZones(false);
    }

    if (window.realiquotInit) {
        $("a.submit").prop("onclick", "").unbind('unclick').click(function () {
            if ($("select").val().length > 0) {
                $("form").submit();
            }
            return false;
        });
    }

    initAutocomplete(document);
    initAdvancedControls(document);
    initToolPopup(document);
    initActions();
    initAjaxClass(document);
    initAccuracy(document);
    initAddLine(document);//must be before datepicker

    //calendar controls
    $.datepicker.setDefaults($.datepicker.regional[locale]);
    initDatepicker(document);

    initCheckAll(document);
    initCheckboxes(document);
    initFileOptions(document);

    $(document).ajaxError(function (event, xhr, settings, exception) {
        if (xhr.status == 403) {
            //access denied, most likely a session timeout
            document.location = "";
        }
    });

    if (useHighlighting) {
        //field highlighting
        if ($("table.structure.addgrid, table.structure.editgrid").length == 1) {
            //gridview
            $('form').highlight('td');
        } else {
            $('form').highlight('tr');
        }
    }

    //focus on first field
    $("input:visible, select:visible, textarea:visible").first().focus();

    //fly over submit button, always in the screen
    flyOverComponents();
    $(window).scroll(flyOverComponents).resize(flyOverComponents);

    if (window.initPage) {
        initPage();
    }
    $("a.databrowserMore").click(function () {
        $(this).parent().find("span:not(:visible), a").toggle();
        return false;
    });

    $(document).delegate("a.submit", 'click', clickSubmitButton
            ).delegate("form", "submit", standardSubmit
            ).delegate(".jsApplyPreset", "click", function () {
        applyPreset($(this).data("json"));
        return false;
    }).delegate("a.delete:not(.noPrompt)", "click", openDeleteConfirmPopup
            ).delegate(".reveal.notFetched", "click", treeViewNodeClick
            ).delegate(".sectionCtrl", "click", sectionCtrl
            ).delegate("a.warningMoreInfo", "click", warningMoreInfoClick
            ).delegate("td.checkbox input[type=checkbox]", "click", checkboxIndexFunction
            ).delegate(".lineHighlight table tbody tr", "click", checkboxIndexLineFunction
            ).delegate(".removeLineLink", "click", removeLine
            ).delegate("div.selectItemZone span.button", "click", selectedItemZonePopup
            ).delegate("input.upload", "change", checkBrowseFile
            ).delegate("p.bottom_button_load", "click", loadClearSearchData
            ).delegate(".minus-button", 'click', closeLog);

    $("p.wraped-text").hover(showHint);
    $("span.default-value-template").hover(showDefaultValues);
    $(window).bind("pageshow", function (event) {
        //remove the fetching class. Otherwise hitting Firefox back button still shows the loading animation
        //don't bother using console.log, console is not ready yet
        $(document).find('a.submit span.fetching').removeClass('fetching');

        //on login page, displays a warning if the server is more than ~2 min late compared to the client
        if (window.loginPage != undefined) {
            //adding date to the request URL to fool IE caching
            $.get(root_url + 'Users/login/1?t=' + (new Date().getTime()), function (data) {
                data = $.parseJSON(data);
                saveSqlLogAjax(data);
                
                if (data.logged_in == 1) {
                    document.location = root_url;
                } else {
                    var foo = new Date;
                    if (data.server_time - parseInt(foo.getTime() / 1000) < -120) {
                        $("#timeErr").show();
                    }
                }
            });
        }
    });
    initFlyOverCells(document);

    if ($.cookie("session_expiration")) {
        sessionTimeout.serverOffset = new Date().getTime() - $.cookie('last_request') * 1000;
        if (!window.loginPage) {
            cookieWatch();
        }
    }
    flyOverComponents();
    initPostData();
}

function loadClearSearchData()
{
    var flag = $(this).data('bottom_button_load');
    $(this).data('bottom_button_load', 1 - flag);
    var message=loadSearchDataMessage[flag];
    $(this).find('span.button_load_text').html(message);
    $(this).find('span.icon16').toggleClass('load-search').toggleClass('reset-search');
    var form=$(this).parents('form')[0];
    form.reset();
    $(form).find('a.btn_rmv_or, a.specific.specific_btn').each(function(){
        $(this).click();
    });
    if (flag === 1) {
        if (typeof jsPostData !== 'undefined' && (jsPostData.constructor === Object || jsPostData.constructor === Array)) {
            if (typeof jsPostData['exact_search'] === 'undefined'){
                $("input[type='checkbox'][name*='data[exact_search']").prop('checked', false);
            }
            var model = "", modelValues = "", value = "", field = "";
            //$("input[name*='data[Participant][participant_identifier][]']");
            for (model in jsPostData) {
                modelValues = jsPostData[model];
                if (modelValues.constructor === Object) {
                    for (field in modelValues) {
                        value = modelValues[field];
                        if (value.constructor === Array) {
                            $("[name*='data[" + model + "][" + field + "][]']").eq(0).val(value[0]);
                            if (value.length > 1) {
                                for (var i = 1; i < value.length; i++) {
                                    $("[name*='data[" + model + "][" + field + "][]']").first().parent().siblings(".btn_add_or").click();
                                    $("[name*='data[" + model + "][" + field + "][]']").eq(i).val(value[i]);
                                }
                            }
                        } else if (value.constructor === Object) {
                            for (var i in value) {
                                $("[name*='data[" + model + "][" + field + "][" + i + "]']").val(value[i]);
                            }
                        } else if (value.constructor === String) {
                            if ($("[name*='data[" + model + "][" + field + "]']").length === 0) {
                                if (field.search("_start") == field.length - 6) {
                                    $("[name*='data[" + model + "][" + field.replace("_start", "") + "]']").closest("span.specific_span").siblings("a.range.range_btn").eq(0).trigger("click");
                                } else if (field.search("_end") == field.length - 4) {
                                    $("[name*='data[" + model + "][" + field.replace("_end", "") + "]']").closest("span.specific_span").siblings("a.range.range_btn").eq(0).trigger("click");
                                }
                            }
                            $("[name*='data[" + model + "][" + field + "]']").val(value);
                        }
                    }
                } else if (modelValues.constructor === String) {
                    if (modelValues === "on") {
                        $("input[type='checkbox'][name*='data[" + model + "]']").prop('checked', true);
                    }
                }
            }
        }
    }
}

function initPostData() {
    if (typeof jsPostData !== 'undefined' && (jsPostData.constructor === Object || jsPostData.constructor === Array)) {
        $this = $('p.bottom_button_load');
        $this.css('display', 'inline-block');
    }
}

function checkBrowseFile()
{
    if (this.files.length===1){
        if (this.files[0].size> maxUploadFileSize){
            alert(maxUploadFileSizeError);
            this.value="";
            return false;
        }
    }
    return true;
}

function isJSON(text) {
    try {
        if (typeof text !== "string") {
            return false;
        } else {
            $.parseJSON(text);
            return true;
        }
    } catch (error) {
        return false;
    }
}

function normalisedAjaxData(data){
    var response = {'data': [], 'sqlLog': {'sqlLog': undefined, 'sqlLogInformations': undefined}};
    if (typeof data !== 'undefined'){
        if (data.indexOf("ajaxSqlLog")>-1 ||  data.indexOf("\"sqlLog\":")>-1 ){
            if (isJSON(data)){
                data = $.parseJSON(data);
                if (typeof data.sqlLog !== 'undefined'){
                    response.sqlLog.sqlLog = data.sqlLog;
                }
                if (typeof data.sqlLogInformations !== 'undefined'){
                    response.sqlLog.sqlLogInformations = data.sqlLogInformations;
                }
                if (typeof data.page !== 'undefined'){
                    response.data = data.page;
                }
            }else if($(data)[$(data).length-1].id==="ajaxSqlLog"){
                response.data = data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                response.sqlLog = {'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
            }
        }else if (data.indexOf("ajaxSqlLog")===-1){
            response.data = data;
            response.sqlLog = undefined;
        }
    }else{
            response.data = undefined;
            response.sqlLog = undefined;
    }
    return response;
}

function saveSqlLogAjax(data){
    if (data && data.sqlLog && typeof DEBUGKIT !=="undefined"){
        var debugKit=$("div#debug-kit-toolbar ul#panel-tabs");
        var logs='';
        data.sqlLog.forEach(function(log){
            if (!log){
                return false;
            }
            var infoIndex=log.lastIndexOf('<div id="ajaxSqlLogInformation"');
            if (infoIndex>-1){
                info=log.substring(infoIndex, log.indexOf('</div>', infoIndex))+'</div>';
                var t=new Date().toLocaleTimeString()+' ,'+$(info).text();
            }else if(typeof data.sqlLogInformations !=='undefined'){
                var t=new Date().toLocaleTimeString()+' ,'+data.sqlLogInformations;
            }
            logs+='<div class="sql-log-panel-query-log cake-debug-output">'+
                    '<div class="minus-button"><a href="javascript:void(0)" class="debug-button">-</a> '+t+'</div>'+
                    '<div>'+log+'</div></div>';
        });
        if (debugKit.find("div#ajax_sql_log-tab").length>0){
            var logNode=debugKit.find("div#ajax_sql_log-tab div.panel-content-data").first();
            if ($(logNode).children("div.sql-log-panel-query-log").length===0){
                $(logNode).append(logs);
            }else{
                $(logNode).children("div.sql-log-panel-query-log").first().before(logs);
            }
        }
    }
}

function closeLog(event) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
    event.stopPropagation();
}

    a = $(this).children("a").first();
    $(this).siblings().toggle(200);
    if ($(a).text() === "-") {
        $(a).text("+");
    } else if ($(a).text() === "+") {
        $(a).text("-");
    }
}

function showHint(event) {
    if (event.type === "mouseenter") {
        if (countLines(this) >= 3) {
            this.title = $(this).text().replace(/\s&\s/g, "\n");
        } else if ($(this).text().indexOf(" + ")>-1){
            this.title = $(this).text().replace(/\s&\s/g, "\n");
        } else {
            this.title = "";
        }
    } else if (event.type === "mouseleave") {
        this.title = "";
    }
}

function showDefaultValues(event) {
    if (event.type === "mouseenter") {
        this.title = $(this).text().replace(/\s&\s/g, "\n");
    } else if (event.type === "mouseleave") {
        this.title = "";
    }
}

function countLines(item) {
    var divHeight = $(item).outerHeight();
    var lineHeight = parseInt($(item).css("lineHeight"));
    var lines = Math.round(divHeight / lineHeight);
    return lines;
}

function putIntoRelDiv(index, elem) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    var temp = $('<div></div>').addClass('testScroll');
    $(elem).before(temp);
    while ($(elem).contents().length > 0) {
        temp.append($(elem).contents()[0]);
    }
    $(elem).append(temp);

//$(elem).append($("<div class='testScroll'>" +$(elem).html() +"</div>"));


//    $(elem).delegate(".datepicker", "click", showDatePicker);
//    $(elem).html(
//            "<div class='testScroll'>" +
//            $(elem).html() +
//            "</div>");
}

function initFlyOverCells(scope) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $(scope).find("table.structure").each(function () {
        //make cells float
        if ($(this).find("th.floatingCell:first").length == 0) {
            return true;
        }
        totalColspan = 0;

        var putAndCount = function (index, elem) {
            var colspan = $(elem).attr("colspan");
            if (colspan === undefined) {
                ++totalColspan;
            } else {
                totalColspan += colspan * 1;
            }
            putIntoRelDiv(index, elem);
        };
        $(this).find("th.floatingCell:last").each(function (index, elem) {
            putAndCount(index, elem);
            $(this).prevAll().each(putAndCount);
            for (var j = 1; j <= totalColspan; ++j) {
                $(this).parents("table").eq(0)
                        .find("tbody td:nth-child(" + j + ")")
                        .each(putIntoRelDiv);
            }
        });
        $(this).find("th.floatingCell:last").parent().find("th:first").each(function () {
            var firstTh = $(this);
            var lastTd = $(this).parents("table:first")
                    .find("tbody tr:last td:nth-child(" + totalColspan + ")").eq(0);
            $(this).find(".testScroll").each(function () {
                var currHtml = $(this).html();
                $(this).html(
                        '<span style="z-index: 2; position: relative;">'
                        + currHtml
                        + '</span>'
                        + '<div class="floatingBckGrnd">'
                        + '<div class="right"><div></div></div>'
                        + '<div class="left"></div>'
                        + '</div>');
                $(this).find(".floatingBckGrnd").data("totalColspan", totalColspan);
                resizeFloatingBckGrnd($(this).find(".floatingBckGrnd"));
            });
        });
    });
}

function globalInit(scope) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    if (window.copyControl) {
        initCopyControl();
    }
    initAddLine(scope);
    initDatepicker(scope);
    initAutocomplete(scope);
    initCheckAll(scope);
    initCheckboxes(scope);
    initAccuracy(scope);
    initAdvancedControls(scope);
    initFlyOverCells(scope);

    if (window.labBookFields) {
        initLabBook(scope);
    }

}

function treeViewNodeClick(event) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    var element = event.currentTarget;
    $(element).removeClass("notFetched").unbind('click');
    var json = $(element).data("json");
    var expandButton = $(element);
    if (json.url != undefined && json.url.length > 0) {
        $(element).addClass("fetching");
        var flat_url = json.url.replace(/\//g, "_");
        if (flat_url.length > 0) {
            $.get(root_url + json.url + "?t=" + new Date().getTime(), function (data) {
                if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                    var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                    data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                    saveSqlLogAjax(ajaxSqlLog);
                }
                $("body").append("<div id='" + flat_url + "' style='display: none'>" + data + "</div>");
                if ($("#" + flat_url).find("ul").length == 1) {
                    var currentLi = $(expandButton).parents("li:first");
                    $(currentLi).append("<ul>" + $("#" + flat_url).find("ul").html() + "</ul>");
                    initAjaxClass($(currentLi).find("ul"));
                    $(expandButton).click(function () {
                        $(currentLi).find("ul").first().stop().toggle("blind");
                    });
                }
                $(expandButton).removeClass("fetching");
                $("#" + flat_url).remove();

                if (window.initTree) {
                    initTree($(currentLi));
                }
                currentUl=currentLi.children("ul").first();
                if (typeof duplicatedSamples !=='undefined'){
                    findDuplicatedSamples(currentUl);
                }
            });
        }
    }
}

function findDuplicatedSamples(currentUl){
    var oldItemsNum=duplicatedSamples.length, url;
    currentUl.children('li').each(function(index, li){
        url=($(li).find("div div.rightPart span a.ajax").first().attr('href')!=='undefined'?$(li).find("div div.rightPart span a.ajax").first().attr('href'):"").toLowerCase();
        $(li).addClass("notHighLightDuplicatedItem");
        duplicatedSamples.push({item: $(li), url: url, duplicated: []});
    });
    for (var i=0; i<oldItemsNum; i++){
        c=duplicatedSamples[i];
        for (var j=oldItemsNum; j<duplicatedSamples.length; j++){
            d=duplicatedSamples[j];
            if (c.url===d.url){
                d.duplicated.push(c.item);
                d.duplicated=d.duplicated.concat(c.duplicated).sort();
                d.duplicated=d.duplicated.filter(function(value,pos) {return d.duplicated.indexOf(value) === pos;});
                d.item.data("duplicated", d.duplicated);
                c.duplicated.push(d.item);
                c.item.data("duplicated", c.duplicated);
                d.item.mouseover(function(){
                    highLightDuplicatedItem($(this), $(this).data("duplicated"), 1);
                });

                c.item.mouseover(function(){
                    highLightDuplicatedItem($(this), $(this).data("duplicated"), 1);
                });
                
                d.item.mouseleave(function(){
                    highLightDuplicatedItem($(this), $(this).data("duplicated"), 0);
                });

                c.item.mouseleave(function(){
                    highLightDuplicatedItem($(this), $(this).data("duplicated"), 0);
                });
                
            }
        }
    }
}

function highLightDuplicatedItem($this, duplicated, mode){
    if (mode===1){
        $this.addClass('highLightDuplicatedItem');
        $this.removeClass('notHighLightDuplicatedItem');
        duplicated.forEach(function(item){
            item.addClass('highLightDuplicatedItem');
            item.removeClass('notHighLightDuplicatedItem');
        });
    }else if (mode===0){
        $this.addClass('notHighLightDuplicatedItem');
        $this.removeClass('highLightDuplicatedItem');
        duplicated.forEach(function(item){
            item.addClass('notHighLightDuplicatedItem');
            item.removeClass('highLightDuplicatedItem');
        });
    }
}

/**
 * Called when a detail view is displayed in within the same page as the tree view
 * @param new_at_li
 * @param json
 */
function set_at_state_in_tree_root(new_at_li, json) {
    $(".tree_root").find("div.treeArrow").hide();
    $(".tree_root").find("div.rightPart").removeClass("at");
    $li = $(new_at_li).parents("li:first");
    $($li).find("div.rightPart:first").addClass("at");
    $($li).find("div.treeArrow:first").show();
    $("#frame").html("<div class='loading'>---" + STR_LOADING + "---</div>");
    $.get($(this).prop("href") + "?t=" + new Date().getTime(), {}, function (data) {
        if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
            var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
            data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
            saveSqlLogAjax(ajaxSqlLog);
        }
        
        $("#frame").html(data);
        initActions();
    });
}

/**
 * Called for tree views listing radio buttons (such as treatments, to select a dx)
 * to display the selected element.
 * @param scope
 */
function initTreeView(scope) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $("a.reveal.activate").each(function () {
        var matchingUl = $(this).parents("li:first").children().filter("ul").first();
        $(this).click(function () {
            $(matchingUl).stop().toggle("blind");
        });
    });

    var element = $(scope).find(".tree_root input[type=radio]:checked");
    if (element.length === 1) {
        var lis = $(element).parents("li");
        lis[0] = null;
        $(lis).find("a.reveal.activate:first").click();
    }
}

function openDeleteConfirmPopup(event) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    if ($("#deleteConfirmPopup").length == 0) {
        var yes_action = function () {
            document.location = $("#deleteConfirmPopup").data('link');
            return false;
        };
        var no_action = function () {
            $("#deleteConfirmPopup").popup('close');
            return false;
        };

        buildConfirmDialog('deleteConfirmPopup', STR_DELETE_CONFIRM, new Array({label: STR_YES, action: yes_action, icon: "detail"}, {label: STR_NO, action: no_action, icon: "delete noPrompt"}));
    }

    $("#deleteConfirmPopup").popup();
    $("#deleteConfirmPopup").data('link', $(event.currentTarget).prop("href"));
    return false;
}

function openSaveBrowsingStepsPopup(link) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $.get(root_url + link, null, function (data) {
        data = $.parseJSON(data);
        saveSqlLogAjax(data);
        
        $("#default_popup").html("<div class='wrapper'><div class='frame'>" + data.page + "</div></div>").popup();
        $("#default_popup input[type=text]").first().focus();
        $("#default_popup form").attr("action", 'javascript:popupSubmit("' + $("#default_popup form").attr("action") + '");');
    });
}

function popupSubmit(url) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $.post(url, $("#default_popup form").serialize(), function (data) {
        if (isJSON(data)){
            data = $.parseJSON(data);
            saveSqlLogAjax(data);
        }else{
            var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
            data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
            data = $.parseJSON(data);
            saveSqlLogAjax(ajaxSqlLog);
        }

        if (data.type == 'form') {
            $("#default_popup").html("<div class='wrapper'><div class='frame'>" + data.page + "</div></div>").popup();
            $("#default_popup input[type=text]").first().focus();
            $("#default_popup form").attr("action", 'javascript:popupSubmit("' + $("#default_popup form").attr("action") + '");');
        } else if (data.type == 'message') {
            $("#message").remove();
            buildDialog("message", data.message, null, [{icon: 'detail', action: function () {
                        $("#message").popup('close');
                        $("#default_popup").popup('close');
                        return false;
                    }, label: STR_OK}]);
            $("#message").popup();
        }
    });
}

/**
 * Will see if the last_request time has changed in order to stop the rotating beam. Used by CSV download.
 */
function fetchingBeamCheck() {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		//console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    if (submitData.lastRequest != $.cookie('last_request')) {
        $(document).find('a.submit span.fetching').removeClass('fetching');
    } else {
        submitData.callBack = setTimeout(fetchingBeamCheck, 1000);
    }
}

/*
 * Toggles display of batch entry sections
 */

function sectionCtrl(event) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    element = event.target;
    if ($(element).hasClass('delete')) {
        //hide the content in the button data
        $(element).parents(".descriptive_heading:first").nextAll(".section:first").appendTo("body").hide();
        $(element).data("section", $("body .section:last"));
        $(element).parents(".descriptive_heading:first").css("text-decoration", "line-through");
        $(element).removeClass('delete').addClass('redo');
    } else {
        $(element).parents(".descriptive_heading:first").after($(element).data("section").show());
        $(element).parents(".descriptive_heading:first").css("text-decoration", "none");
        $(element).addClass('delete').removeClass('redo');
    }

    resizeFloatingBckGrnd(null);

    if ($(".descriptive_heading a.sectionCtrl.delete").length == 0) {
        $(".flyOverSubmit").hide();
    } else {
        $(".flyOverSubmit").show();
    }

    flyOverComponents();
    return false;
}

/**
 * When a checkbox is checked/unchecked, toggles line coloring. Support of shiftkey to select multiple lines.
 * @param event
 * @param orgEvent
 */
function checkboxIndexFunction(event, orgEvent) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $this = $(this);
    if (typeof dataLimit !== 'undefined') {
        if (!checkData($this, dataLimit)) {
            return false;
        }
    }
    var shiftKey = orgEvent ? false : event.originalEvent.shiftKey;
    if (shiftKey) {
        marking = true;
        checked = $(event.currentTarget).prop("checked");
        markingFct = function () {
            if (marking) {
                $(this).find("td.checkbox input[type=checkbox]").attr("checked", checked);
                if (checked) {
                    if (typeof dataLimit !== 'undefined') {
                        $this = $(this).find("td.checkbox input[type=checkbox]");
                        if (!checkData($this, dataLimit, null, true)) {
                            $(this).find("td.checkbox input[type=checkbox]").attr("checked", false);
                            return false;
                        }
                    }
                    $(this).addClass("chkLine");
                } else {
                    $(this).removeClass("chkLine");
                }
                if ($(this).hasClass("checkboxIndexFunctionMark")) {
                    marking = !marking;
                }
            }
        };
        if ($(event.currentTarget).parents("tr:first").nextAll(".checkboxIndexFunctionMark").length) {
            $(event.currentTarget).parents("tr:first").nextAll().each(markingFct);
        } else if ($(event.currentTarget).parents("tr:first").prevAll(".checkboxIndexFunctionMark").length) {
            $(event.currentTarget).parents("tr:first").prevAll().each(markingFct);
        }
    }
    $(".checkboxIndexFunctionMark").removeClass("checkboxIndexFunctionMark");
    $(event.currentTarget).parents("tr:first").addClass("checkboxIndexFunctionMark");
    if (orgEvent ? !$(event.currentTarget).prop("checked") : $(event.currentTarget).prop("checked")) {
        $(event.currentTarget).parents("tr:first").addClass("chkLine");
    } else {
        $(event.currentTarget).parents("tr:first").removeClass("chkLine");
    }
    if (typeof dataLimit !== 'undefined') {
        saveCheckedToArray("#wrapper", checkedData[controller][action]);
    }
    event.stopPropagation();
    return true;
}

/*Save the items that checked in to an array*/
function saveCheckedToArray(scope, checkedData) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    var checkboxes = $(scope).find("input[name^='data[" + dataIndex + "]'][type!='hidden']");
    var index, id, checked, $this;
    checkboxes.each(function () {
        $this = $(this);
//        checkedData["ID: "+$(this).val()]=$(this).is(':checked');
        index = checkedData.findIndex(function (item) {
            return item.id === $this.val();
        });
        id = $this.val();
        checked = $this.is(':checked');
        if (index === -1 && checked) {
            index = checkedData.length;
            checkedData[index] = {id: id, checked: checked};
        } else if (index !== -1 && !checked) {
            checkedData.splice(index, 1);
        }
    });
}

/**
 * Clicking on a line with a checkbox will check/uncheck it. No suport for shiftKey.
 * @param event
 */
function checkboxIndexLineFunction(event) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    if ($(event.currentTarget)[0].nodeName == "TR" && !event.originalEvent.shiftKey && event.target.nodeName != 'A') {
        //line clicked, toggle it's checkbox (don't support shift click, as it is for text selection
        if (typeof dataLimit !== 'undefined') {
            $this = $(this).find('input[type=checkbox]');
            $(this).prop("checked", !$(this).is(":checked"));
            if (!checkData($this, dataLimit)) {
                $(this).prop("checked", false);
                return false;
            }
            $(this).closest("tr").toggleClass("chkLine");
            return false;
        } else {
            $(event.currentTarget).find("td.checkbox:first input[type=checkbox]").trigger("click", [event]);
            event.stopPropagation();
        }
    }
}

/**
 * Hides the confirm msgs div, but keeps it in the display to avoid having page content moving. 
 */
function dataSavedFadeout() {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $("ul.confirm").animate({opacity: 0}, 700);
}

function setCsvPopup(target) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}
    if ($("#csvPopup").length == 0) {
        buildDialog('csvPopup', 'CSV', "<div class='loading'>--- " + STR_LOADING + " ---</div>", null);
        $.get(root_url + 'Datamart/Csv/csv/popup:/', function (data) {
            if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                saveSqlLogAjax(ajaxSqlLog);
            }
           
            var visible = $("#csvPopup:visible").length == 1;
            $("#csvPopup:visible").popup('close');
            $("#csvPopup h4 + div").html(data);

            $("#csvPopup form").attr("action", root_url + target);
            $("#csvPopup a.submit").click(function () {
                $("#csvPopup form input[type=hidden]").remove();
                $("form:first input[type=checkbox]:checked").each(function () {
                    $("#csvPopup form").append('<input type="hidden" name="' + this.name + '" value="' + this.value + '"/>');
                });
                $(".databrowser .selectableNode.selected").each(function () {
                    $("#csvPopup form").append('<input type="hidden" name="data[0][singleLineNodes][]" value="' + $(this).parent("a").data("nodeId") + '"/>');
                });
            });

            $("#csvPopup form").submit(function () {
                $("#csvPopup form input[type=hidden]").remove();
                $("form:first input[type=checkbox]:checked").each(function () {
                    $("#csvPopup form").append('<input type="hidden" name="' + this.name + '" value="' + this.value + '"/>');
                });
                $(".databrowser .selectableNode.selected").each(function () {
                    $("#csvPopup form").append('<input type="hidden" name="data[0][singleLineNodes][]" value="' + $(this).parent("a").data("nodeId") + '"/>');
                });
            });

            //option to select some browsing tree nodes
            if ($(".databrowser").length == 1) {
                //keep the single line option + bind command
                $("#csvPopup table:last").append("<tr><td colspan=3><span style='padding-bottom: 5px; display: inline-block;'>" + STR_NODE_SELECTION + "</span></td></tr>");
                var lastLine = $("#csvPopup table:last tr:last").hide();
                $(".databrowser").clone(false).appendTo($("#csvPopup table:last td:last"));

                var browserTable = $("#csvPopup .databrowser");
                browserTable.find("a.icon16.link").hide();//hide table + merge links
                browserTable.find("a > span.icon16").css("opacity", 0.05);
                browserTable.find("a").click(function () {
                    return false;
                }).css("cursor", "default");

                //put all nodes in an object
                var browsingNodes = new Object();
                browserTable.find("a").each(function () {
                    var id = $(this).attr("href").match(/\/browse\/([\d]+)\/$/);
                    if (id != null && "1" in id) {
                        browsingNodes[id[1]] = this;
                        $(this).data("nodeId", id[1]);
                    }
                });

                var nodeToggle = function (event) {
                    var span = $(event.currentTarget).find("span:first");
                    var nodeId = $(event.currentTarget).data("nodeId");
                    span.toggleClass("selected");
                    if (span.hasClass("selected")) {
                        //disable other similar structure id
                        var structureId = null;
                        if (nodeId in csvMergeData.flat_children) {
                            structureId = csvMergeData.flat_children[nodeId].BrowsingResult.browsing_structures_id;
                        } else {
                            structureId = csvMergeData.parents[nodeId].BrowsingResult.browsing_structures_id;
                        }
                        for (i in csvMergeData.parents) {
                            if (i != nodeId && csvMergeData.parents[i].BrowsingResult.browsing_structures_id == structureId) {
                                if ($(browsingNodes[i]).find("span:first").hasClass("selected")) {
                                    $(browsingNodes[i]).click();
                                }
                            }
                        }

                        for (i in csvMergeData.flat_children) {
                            if (i != nodeId && csvMergeData.flat_children[i].BrowsingResult.browsing_structures_id == structureId) {
                                if ($(browsingNodes[i]).find("span:first").hasClass("selected")) {
                                    $(browsingNodes[i]).click();
                                }
                            }
                        }
                    } else {
                        if (nodeId in csvMergeData.parents) {
                            //disable all parents
                            var parentId = csvMergeData.parents[nodeId].BrowsingResult.parent_id;
                            if (parentId in csvMergeData.parents && $(browsingNodes[parentId]).find("span:first").hasClass("selected")) {
                                $(browsingNodes[parentId]).click();
                            }
                        } else {
                            //disable all children
                            for (i in csvMergeData.flat_children) {
                                if (csvMergeData.flat_children[i].BrowsingResult.parent_id == nodeId && $(browsingNodes[i]).find("span:first").hasClass("selected")) {
                                    $(browsingNodes[i]).click();
                                }
                            }
                        }
                    }

                };

                //for all "csv mergeable nodes", raise opacity
                csvMergeData = $.parseJSON(csvMergeData);
                for (i in csvMergeData.parents) {
                    var node = browsingNodes[i];
                    $(node).find("span.icon16").css("opacity", "").addClass("selectableNode").parent("a").css("cursor", "").click(nodeToggle);
                }
                for (i in csvMergeData.flat_children) {
                    var node = browsingNodes[i];
                    $(node).find("span.icon16").css("opacity", "").addClass("selectableNode").parent("a").css("cursor", "").click(nodeToggle);
                }

                //current not is opaque
                var node = browsingNodes[csvMergeData.current_id];
                $(node).find("span.icon16").css("opacity", 1);

                $("select[name=data\\[0\\]\\[redundancy\\]]").change(function () {
                    if ($(this).val() == "same") {
                        lastLine.show();
                    } else {
                        lastLine.hide();
                    }
                    $("#csvPopup").popup('close');
                    $("#csvPopup").popup();
                });

            } else {
                //remove single line option
                $("select[name=data\\[0\\]\\[redundancy\\]]").parents("tr:first").remove();
            }

            if (visible) {
                $("#csvPopup").popup();
            }
            
        });
    }
    $("#csvPopup").popup();
    $("input.submit").siblings("a").find("span").removeClass('fetching');
}

function selectedItemZonePopup(event) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    var button = $(event.currentTarget);
    var popup = null;
    if (!(popup = button.data('popup'))) {
        popup = $("#default_popup").clone().attr("id", null);
        popup.appendTo("body");
        button.data('popup', popup);
        popup.html("<div class='wrapper'><div class='frame'>");
        popup.frame = popup.find(".frame");
        popup.click(function () {
            popup.popup('center');
        });
    }
    popup.frame.html("<div class='loading'>---" + STR_LOADING + "---</div>");
    popup.popup();

    var fctLinksToAjax = function (scope) {
        $scope=$(scope);
        $(scope).find("a:not(.detail)").click(function(){
            if ($(this).attr("href").indexOf("javascript:") >= 0 || $(this).attr("href")==="#") {
                return true;
            }
            var isSubmit= $(this).hasClass("submit");
            var method = "GET"
            var url=$(this).attr("href");
            var data=undefined;
            if (isSubmit){
                var form=$scope.find("form");
                method=form.attr("method");
                url=form.attr("action");
                data=form.serialize();
            }


            popup.frame.html("<div class='loading'>---" + STR_LOADING + "---</div>");
            popup.popup('center');

            $.ajax({
                type: method,
                url: url,
                data: data, 
                success: function (data) {
                    if (isJSON(data)){
                        data = $.parseJSON(data);
                        saveSqlLogAjax(data);
                        popup.frame.html(data.page);
                    }else{
                        var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                        data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                        data = $.parseJSON(data);
                        saveSqlLogAjax(ajaxSqlLog);
                        popup.frame.html(data);
                    }

//                    if (data.indexOf("{") == 0) {
//                        data = $.parseJSON(data);
//                        popup.frame.html(data.page);
//                    } else {
//                        popup.frame.html(data);
//                    }

                    popup.popup('center');
                    fctLinksToAjax(popup.frame);
                }
            });

            return false;            
        });
        $(scope).find("a.detail").click(function(){
            //selection
            popup.popup('close');
            var targetDiv = button.parents(".selectItemZone:first").find(".selectedItem");
            targetDiv.html("<div class='loading'>---" + STR_LOADING + "---</div>");
            var targetHref = $(this).attr("href");
            $.get(targetHref + '/type:index/noActions:/noHeader:/', function (data) {
                if (data.indexOf("{") == 0) {
                    data = $.parseJSON(data);
                    saveSqlLogAjax(data);
                    
                    targetDiv.html(data.page);
                } else {
                    if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                        var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                        data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                        saveSqlLogAjax(ajaxSqlLog);
                    }
                    
                    targetDiv.html(data);
                }
                targetDiv.append('<input type="hidden" name="' + button.data('name') + '" value="' + targetHref + '"/>');
            });

            return false;
        });
    };

    $.get(root_url + button.data('url') + '/noActions:', function (data) {
        if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
            var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
            data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
            saveSqlLogAjax(ajaxSqlLog);
        }
        
        popup.frame.html(data);
        initAdvancedControls(popup);
        initDatepicker(popup);
        popup.popup('center');
        popup.find("form").submit(function () {
            submitChecks(this);
            $.post(popup.find("form").attr("action") + '/forSelection:/', popup.find("form").serialize(), function (data) {
                if (data.indexOf("{") == 0) {
                    data = $.parseJSON(data);
                    saveSqlLogAjax(data);
                    
                    popup.frame.html(data.page);
                } else {
                    popup.frame.html(data);
                }
                popup.popup('center');
                fctLinksToAjax(popup.frame);
            });
            return false;
        });
        fctLinksToAjax(popup.frame);
    });


    return false;
}

function submitChecks(scope) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    $(scope).find('a.submit span').last().addClass('fetching');
    submitData.lastRequest = $.cookie('last_request');
}

function initIndexZones(useCache) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    var fctLinksToAjax = function (scope) {
        $(scope).find("a:not(.icon16)").click(function () {
            if ($(this).attr("href").indexOf("javascript:") >= 0) {
                return true;
            }
            scope.html("<div class='loading'>---" + STR_LOADING + "---</div>");
            $.get($(this).attr("href"), function (data) {
                var page = null;
                if (data.indexOf("{") == 0) {
                    data = $.parseJSON(data);
                    saveSqlLogAjax(data);
                    
                    page = data.page;
                } else {
                    if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                        var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                        data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                        saveSqlLogAjax(ajaxSqlLog);
                    }

                    page = data;
                }
                scope.html(page);
                fctLinksToAjax(scope);

                if (history.state) {
                    history.state.indexZone[scope.data("url")] = page;
                    history.replaceState(history.state, "foo");
                }
            });

            return false;
        });
    };

    if (history.state && !history.state.indexZone) {
        history.state.indexZone = new Object();
    }

    $(".indexZone").each(function () {
        var indexZone = $(this);
        var url = indexZone.data('url');
        if (useCache && history.state.indexZone[url]) {
            indexZone.html(history.state.indexZone[url]);
            fctLinksToAjax(indexZone);
        } else {
            indexZone.html("<div class='loading'>---" + STR_LOADING + "---</div>");
            var successFct = function (data) {
                var page = null;
                if (data.indexOf("{") === 0) {
                    data = $.parseJSON(data);
                    saveSqlLogAjax(data);
                    page = data.page;
                    indexZone.html(data.page);
                } else {
                    if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                        var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                        data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                        saveSqlLogAjax(ajaxSqlLog);
                    }                    
                    page = data;
                }
                indexZone.html(page);
                fctLinksToAjax(indexZone);

                history.state.indexZone[url] = page;
                history.replaceState(history.state, "foo");
            };
            var errorFct = function (jqXHR, textStatus, errorThrown) {
                indexZone.html(errorThrown);
            };

            $.ajax({
                type: "GET",
                url: root_url + url + "/noActions:/",
                cache: false,
                success: successFct,
                error: errorFct
            });
        }
    });
}

function arrayObjSizeCheck($this, arr, min, max, showAlert)
{
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    if (undef(min)){
        min=1;
    }
    if (undef(max)){
        max=null;
    }
    if (undef(showAlert)){
        showAlert=true;
    }

    if (arr instanceof jQuery) {
        arr = $.makeArray(arr);
    } else if (!$.isArray(arr)) {
        return false;
    }
    if ($this === null) {
        var length = checkedData[controller][action].length;
        if (min <= length && length <= max) {
            return true;
        } else {
            if (showAlert) {
                alert("Selected items should be between " + min + " & " + max);
            }
            return false;
        }
    }
    var index, id, checked;
    checked = $this.is(":checked");
    id = $this.val();
    index = checkedData[controller][action].findIndex(function (item) {
        return item.id === id;
    });
    if (index !== -1 && !checked) {
        $this.prop("checked", false);
        checkedData[controller][action].splice(index, 1);
        return true;
    } else if (index !== -1 && checked) {
        $this.prop("checked", true);
        return true;
    } else {
        length = checkedData[controller][action].length;
        if ((max === null && length < min) || (min <= length && length < max)) {
            checkedData[controller][action][length] = {id: id, checked: true};
            $this.prop("checked", true);
            return true;
        } else if (max === null) {
            max = min;
            min = 1;
            $this.prop("checked", false);
        }
        if (showAlert) {
            alert("Selected items should be between " + min + " & " + max);
        }
    }
    return false;
}

function checkData($this, min, max, showAlert)
{
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    if (undef(min)){
        min=1;
    }
    if (undef(max)){
        max=null;
    }
    if (undef(showAlert)){
        showAlert=true;
    }
    
    data = $("input[name^='data[" + dataIndex + "]'][type!='hidden']");
    if (!arrayObjSizeCheck($this, data, min, max, showAlert)) {
        return false;
    }
    return true;
}

/**
 * Will popup a confirmation message if defined. If the message is opened
 * or if no message is defined, will submit and replace the disk icon with
 * a rotating beam. Submiting is blocked when the rotating icon is present.
 * @returns {Boolean}
 */
function standardSubmit()
{
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    if (typeof dataLimit !== 'undefined') {
        if (!checkData(null, 1, dataLimit)) {
            return false;
        }
        data = $("input[name^='data[" + dataIndex + "]'][type!='hidden']:checked");
        var checkedDataInOtherPages = [];
        checkedDataInOtherPages = checkedData[controller][action].filter(function (item) {
            isInOtherPages = true;
            data.each(function () {
                if ($(this).val() === item.id) {
                    isInOtherPages = false;
                    return false;
                }
            });
            return isInOtherPages;
        });
        checkedDataInOtherPages.forEach(function (item) {
            $("#wrapper").find("form").append('<input type="hidden" name="data[OrderItem][id][]" value="' + item.id + '">');
        });
    }

    //submitting form
    var submitButton = $(this).find("a.submit");
    var form = $(this);
    if (!$(submitButton).find('span').hasClass('fetching')) {
        if ($(submitButton).data('confirmation-msg') && (!$(form).data('confirmation-popup') || $(form).data('confirmation-popup').find(":visible:first").length == 0)) {
            if ($(form).data('confirmation-popup')) {
                $(form).data('confirmation-popup').popup();
            } else {
                //function buildConfirmDialog(id, question, buttons){
                var yes_action = function () {
                    form.submit();
                    form.data('confirmation-popup').popup('close');
                    return false;
                };
                var no_action = function () {
                    form.data('confirmation-popup').popup('close');
                    return false;
                };
                buildConfirmDialog('tmp', $(submitButton).siblings("span.confirmationMsg").html(), [{label: STR_YES, action: yes_action, icon: "detail"}, {label: STR_NO, action: no_action, icon: "delete noPrompt"}]);
                var popup = $("#tmp").attr("id", null);
                $(form).data('confirmation-popup', popup);
                popup.popup();
            }
        } else {
            submitChecks(this);
            submitData.callBack = setTimeout(fetchingBeamCheck, 0);//check every second (needed for CSV download)
            return true;
        }
    }
    return false;
}

function clickSubmitButton() {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    if ($(this).attr("href").indexOf("javascript:") >= 0 || $(this).attr("href")==="#") {
        return true;
    }

    $(this).siblings("input.submit").click();
    return false;
}

function miscIdPopup(participant_id, ctrl_id) {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    buildConfirmDialog('miscIdPopup', STR_MISC_IDENTIFIER_REUSE, new Array(
            {label: STR_NEW, action: function () {
                    document.location = root_url + "ClinicalAnnotation/MiscIdentifiers/add/" + participant_id + "/" + ctrl_id + "/";
                    return false;
                }, icon: "add"},
            {label: STR_REUSE, action: function () {
                    document.location = root_url + "ClinicalAnnotation/MiscIdentifiers/reuse/" + participant_id + "/" + ctrl_id + "/";
                    return false;
                }, icon: "redo"})
            );
    $("#miscIdPopup").popup();
}

function dataBrowserHelp() {
if (typeof DEBUG_MODE !=='undefined' && DEBUG_MODE>0){
	try{
		var myName = arguments.callee.toString();
		myName = myName.substr('function '.length);
		myName = myName.substr(0, myName.indexOf('('));
		console.log (myName);
		if (DEBUG_MODE_JS>0){
		   debugger ;
		}
	}catch(ex){
	}
}

    var diagram_url = root_url + 'app/webroot/img/dataBrowser/datamart_structures_relationships_' + STR_LANGUAGE + '.png';
    $("#default_popup").html('<form enctype="multipart/form-data"><div class="descriptive_heading"><h4>' + STR_DATAMART_STRUCTURE_RELATIONSHIPS + '</h4><p></p></div><div style="padding: 10px; background-color: #fff;"><img src="' + diagram_url + '"/></div></form>');
    $("#default_popup").find("img").on("load", function () {
        $("#default_popup").popup();
    });
}

function undef(x){
    return (typeof x === 'undefined');
}