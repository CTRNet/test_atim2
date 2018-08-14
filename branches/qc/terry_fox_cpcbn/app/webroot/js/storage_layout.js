/**
 * This script is used by the storage_layout page for drag and drop
 */
var dragging = false;//counter Chrome text selection issue
var modified = false;//if true, save warning

function initStorageLayout(mode){
	var id = document.URL.match(/[0-9]+/g);
	id = id.pop();
	$("#firstStorageRow").data('storageId', id);
	$("#default_popup").clone().attr("id", "otherPopup").appendTo("body");
	$("#default_popup").clone().attr("id", "csvDialogPopup").appendTo("body");
	
	//bind preparePost to the submit button
	$("input.submit").first().siblings("a").click(function(){
		if(!$(this).find('span').hasClass('fetching')){
			$(this).find('span').addClass('fetching');
			window.onbeforeunload = null;
			preparePost();
		}
		return false;
	});
	
	//load the top storage loayout
	ctrls = $("#firstStorageRow").data("ctrls");
        if (typeof $("#firstStorageRow").data("storageUrl") !=='undefined'){
            $.get($("#firstStorageRow").data("storageUrl") + '/1/ctrls:' + ctrls, function(data){
                    var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                    saveSqlLogAjax(ajaxSqlLog);
                    data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                    data = $.parseJSON(data);
                    if(data.valid){
                            initRow($("#firstStorageRow"), data, ctrls);
                            $("form #firstStorageRow").find("td.droppable").off('click').on('click', addAliquotByClick);
                            if(!ctrls){
                                    $(".clear-loaded-barcodes").remove();
                                    $(".LoadCSV").remove();
                                    $(".RecycleStorage").remove();
                                    $(".TrashStorage").remove();
                                    $(".trash_n_unclass").remove();
                                    $("#firstStorageRow").find(".dragme").removeClass("dragme");
                            }
                    }
                    $("#firstStorageRow").find(".dragme").data("top", true);
                    $("#firstStorageRow").find(".droppable").data("top", true);
                    $("#firstStorageRow").data('checkConflicts', data.check_conflicts);
                    $('#LoadCSVFile').on('change', csvOpen);
                    $('.clear-loaded-barcodes').on('click', clearLoadedBarcodes);
                    flyOverComponents();
            });
        }
        
	window.onbeforeunload = function(event) {
		if(modified){
			return STR_NAVIGATE_UNSAVED_DATA;
		}
	};
	
        if (mode!=='detail'){
            //handle the "pick a storage to drag and drop to" button and popup
            $.post(root_url + 'StorageLayout/StorageMasters/search/', function(data){
                    var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                    saveSqlLogAjax(ajaxSqlLog);
                    data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                
                    var isVisible = $("#default_popup:visible").length;
                    $("#default_popup").html('<div class="wrapper"><div class="frame">' + data + '</div></div>');
                    $("#default_popup form").append("<input type='hidden' name='data[current_storage_id]' value='" + id + "'/>");
                    globalInit($("#default_popup"));

                    if(isVisible){
                            //recenter popup
                            $("#default_popup").popup('close');
                            $("#default_popup").popup();
                    }

                    $("#default_popup input.submit").click(function(){
                            //search results into popup
                            $("body").append("<div class='hidden tmpSearchForm'></div>");
                            $(".tmpSearchForm").append($("#default_popup .wrapper"));
                            $("#default_popup").html("<div class='loading'>---" + STR_LOADING + "---</div>").popup();
                            $.post($(".tmpSearchForm form").attr("action") + '/1', $(".tmpSearchForm form").serialize(), function(data){
                                    data = $.parseJSON(data);
                                    saveSqlLogAjax(data);
                                    var isVisible = $("#default_popup:visible").length;
                                    $("#default_popup").html('<div class="wrapper"><div class="frame">' + data.page + '</div></div>');
                                    if(isVisible){
                                            //recenter popup
                                            $("#default_popup").popup('close');
                                            $("#default_popup").popup();
                                    }

                                    $("#default_popup a.detail").click(function(){
                                            //handle selection buttons
                                            $("#secondStorageRow").html("");
                                            var id = $(this).attr("href").match("[0-9]+(/)*$")[0];
                                            if(id != $("#firstStorageRow").data("storageId")){
                                                    //if not the same storage
                                                    $("#secondStorageRow").data("storageId", id);
                                                    $("#secondStorageRow").html("<div class='loading' style='display: table-cell; min-width: 1px;'>---" + STR_LOADING + "---</div>");
                                                    $.get(root_url + 'StorageLayout/StorageMasters/storageLayout/' + id + '/1', function(data){
                                                            var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                                                            saveSqlLogAjax(ajaxSqlLog);
                                                            data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                                                        
                                                            data = $.parseJSON(data);
                                                            if(data.valid){
                                                                    initRow($("#secondStorageRow"), data, true);
                                                                    $("#secondStorageRow .clear-loaded-barcodes").remove();
                                                                    $("#secondStorageRow .LoadCSV").remove();

                                                                    $("#secondStorageRow").find(".dragme").data("top", false);
                                                                    $("#secondStorageRow").find(".droppable").data("top", false);
                                                                    $("#secondStorageRow").data('checkConflicts', data.check_conflicts);
                                                            }
                                                        flyOverComponents();
                                                    });
                                            }
                                            return false;
                                    });
                                flyOverComponents();        
                            });
                            return false;
                    });

                    $("#default_popup").popup("close");
                    flyOverComponents();
            });
        }

	$("#btnPickStorage").click(function(){
		$("#default_popup").popup();
	});
	
	//IE9 fix
	//$("a[href='#']").click(function (e) { e.preventDefault(); });
        
}

function csvConfig(){
    $('#csvPopupConfiguration').popup('close');
    $('#csvPopupConfiguration').closest('.popup_outer').remove();

    var form = '<div id="csvPopupConfiguration" class="std_popup question" style="margin: auto; position: relative; display: block;"><div class="wrapper"><h4>CSV</h4><div style="padding: 10px; background-color: #fff;"><div><table class="structure" cellspacing="0"><tbody><tr><td class="this_column_1 total_columns_1"><table class="columns detail" cellspacing="0"><tbody><tr><td class="label">Separator</td><td class="content"><span><span class="nowrap"><input name="data[Config][define_csv_separator]" class=" required" value="'+CSV_SEPARATOR+'" tabindex="2" size="3" maxlength="1" required="required" type="text"> </span></span></td><td class="help"><span class="icon16 help">&nbsp;&nbsp;&nbsp;&nbsp;<div>When exporting data to file from the Query Tool this value is used as a separator between fields.</div></span></td></tr></tbody></table></td></tr></tbody></table><div class="submitBar"><div class="flyOverSubmit"><div class="bottom_button"><input class="submit" type="submit" value="Submit" style="display: none;"><a href="javascript:setSeparator()" tabindex="6" class="submit"><span class="icon16 submit"></span>Submit</a></div></div></div></div></div></div></div>';
    $(form).popup();
    $("#csvPopupConfiguration").siblings(".popup_close").off("click").on("click", function(){
        $('#csvPopupConfiguration').popup('close');
    });
    $('#csvPopupConfiguration input').keypress(function (e) {
     var key = e.which;
     if(key == 13)  // the enter key code
      {
        $('#csvPopupConfiguration').popup('close');
        setSeparator();
        return false;  
      }
    }); 
}
csvSeparator = null;
function setSeparator(){
    csvSeparator = $("input[name='data[Config][define_csv_separator]'").val();
    $('#csvPopupConfiguration').popup('close');
    document.getElementById('LoadCSVFile').click();
}

function csvOpen(e) {
    if (this.files.length !== 0) {
        var file = this.files[0];
        if (file.size > maxUploadFileSize) {
            alert(maxUploadFileSizeError);
            return false;
        }
        var data = new FormData();
        data.append('media', file);
        data.append('csvSeparator', csvSeparator);
        var storageId = $("#LoadCSVFile").closest("form").attr("action").split("/").pop();
        var url = root_url + "StorageLayout/StorageMasters/getCsvFile/" + storageId;
        $("#csvDialogPopup").html("<div class='loading'>---" + STR_LOADING + "---</div>").popup();
        $.ajax({
            url: url,
            type: "POST",
            cache: false,
            contentType: false,
            processData: false,
            data: data,
            success: function (data) {
                ajaxSqlLog = {'sqlLog': [$(data.substring(data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                saveSqlLogAjax(ajaxSqlLog);
                data = data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                var $html = $('<div />', {html: data});
                $html.find(".actions").eq(0).remove();
                $html.find("div.descriptive_heading").css("margin", "0");
                $html.find(".pop-up-csv-barcode li").each(function () {
                    if (typeof $(this).attr("data-aliquot")!=='undefined' && $(this).attr("data-aliquot")!=""){
                        barcodeNumber = $.parseJSON($(this).attr("data-aliquot"))["barcode"];
                        message = $.parseJSON($(this).attr("data-aliquot"))["message"];
                        dupMessage = DUPLICATED_ALIQUOT;
                        var existe = false;
                        if (message.search("dupMessage") == -1) {
                            $(".just-added span.handle").each(function () {
                                if ($(this).text() == barcodeNumber) {
                                    existe = true;
                                    return;
                                }
                            });
                        }
                        if (existe) {
                            $.parseJSON($(this).attr("data-aliquot"))["message"] = message + "," + dupMessage;
                            $(this).text($(this).text() + ", " + dupMessage);
                            $(this).closest("ul").removeClass("confirm").addClass("warning");
                        }
                    }
                });

                data = $html.html();
                $("#csvDialogPopup").popup('close');
                $("#csvDialogPopup").html('<div class="wrapper"><div class="frame">' + data + '</div></div>').popup();
                $("#csvDialogPopup .actions a.cancel").off("click").on("click", function () {
                    $("#csvDialogPopup").popup('close');
                });
                $("#csvDialogPopup .actions a.add").off("click").on("click", csvToLayout);
                flyOverComponents();
            }
        });
    }

    var li = $("#LoadCSVFile").parents().eq(0);
    li.find("#LoadCSVFile").remove();
    li.prepend('<input type="file" style="display:none;" id="LoadCSVFile" name="CSVFile" accept=".xlsx, .xls, .csv">')
    $('#LoadCSVFile').on('change', csvOpen);
}

function csvToLayout(){
    confirms = $("#csvDialogPopup").find("ul.confirm:not(.hidden-ul) li");
    errors = $("#csvDialogPopup").find("ul.error li");
    warnings = $("#csvDialogPopup").find("ul.warning li");
    $html = "<li class='dragme AliquotMaster ui-draggable just-added csv-just-added' data-json='{ \"id\" : \"\", \"type\" : \"AliquotMaster\"}' style='position: relative;' title = ''>\n" +
            "<a href='javascript:void(0)' data-popup-link='' title='Detail' class='icon16 aliquot popupLink' style='text-decoration: none;'>&nbsp;</a>" +
            "<span class='handle' data-barcode = ''></span>" +
            "</li>";
    $title = "";
    for (var i = 0; i < confirms.length; i++) {
        var aliquotData = $.parseJSON($(confirms[i]).attr("data-aliquot"));
        aliquotClass = "new-aliquot";
        var li = $('<div />', {html: $html});
        var url = root_url + "InventoryManagement/AliquotMasters/detail/" + aliquotData['collectionId'] + "/" + aliquotData['sampleMasterId'] + "/" + aliquotData['id'] + "/2";
        var label = (aliquotData['label']!="")?aliquotData['label']:"";
        var message = (aliquotData['message']!="" && label!="")?label+", "+ aliquotData['message']:label+ aliquotData['message'];
        li.find("li").addClass(aliquotClass).attr("data-json", '{"id": "' + aliquotData['id'] + '", "type" : "AliquotMaster"}').attr("title", message);
        if ($(confirms[i]).attr("data-class-name")!==""){
            li.find("li").addClass($(confirms[i]).attr("data-class-name"));
        }
        li.find('a').attr("data-popup-link", url);
        li.find('span').attr("data-barcode", aliquotData['barcode']);
//        li.find('span').text((aliquotData['label'] != "") ? aliquotData['label'] : aliquotData['barcode']);
        li.find('span').text(aliquotData['barcode']);
        var storageId = $("#LoadCSVFile").closest("form").attr("action").split("/").pop();
        ulId = "#s_" + storageId + "_c_" + aliquotData["x"] + "_" + ((aliquotData["y"] == -1) ? "1" : aliquotData["y"]);
        destination = $("#firstStorageRow").find(ulId).append(li.html());

        destination.find("li:last-child").off("dblclick").on("dblclick", function () {
            var $td = $(this).closest("td");
            var val = $(this).find("span.handle").attr("data-barcode");
            if ($td.find(".barcode_scanner").length!==0){
                $td.find(".barcode_scanner").trigger("focusout");
            }
            $(this).remove();
            createInput($td);
            $td.find(".barcode_scanner").val(val);
            $td.find(".barcode_scanner").select();
        });

        //make them draggable
        destination.find("li:last-child").draggable({
            revert: 'invalid',
            zIndex: 1,
            scroll: false,
            start: function (event, ui) {
                dragging = true;
            }, stop: function (event, ui) {
                dragging = false;
            }
        });

        //create the drop zones
        destination.find("li:last-child").droppable({
            hoverClass: 'ui-state-active',
            tolerance: 'pointer',
            drop: function (event, ui) {
                moveItem(ui.draggable, this);
            }
        });


    }

    for (var i = 0; i < warnings.length; i++) {
        var aliquotData = $.parseJSON($(warnings[i]).attr("data-aliquot"));
        aliquotClass = "warning-aliquot";
        if (aliquotData==null || typeof aliquotData["OK"] === "undefined" || aliquotData["OK"]==0){
            continue;
        }
        var li = $('<div />', {html: $html});
        var url = root_url + "InventoryManagement/AliquotMasters/detail/" + aliquotData['collectionId'] + "/" + aliquotData['sampleMasterId'] + "/" + aliquotData['id'] + "/2";
        var label = (aliquotData['label']!="")?aliquotData['label']:"";
        var message = (aliquotData['message']!="" && label!="")?label+", "+ aliquotData['message']:label+ aliquotData['message'];
        li.find("li").addClass(aliquotClass).attr("data-json", '{"id": "' + aliquotData['id'] + '", "type" : "AliquotMaster"}').attr("title", message);
        if ($(warnings[i]).attr("data-class-name")!==""){
            li.find("li").addClass($(warnings[i]).attr("data-class-name"));
        }
        li.find('a').attr("data-popup-link", url);
        li.find('span').attr("data-barcode", aliquotData['barcode']);
//        li.find('span').text((aliquotData['label'] != "") ? aliquotData['label'] : aliquotData['barcode']);
        li.find('span').text(aliquotData['barcode']);
        var storageId = $("#LoadCSVFile").closest("form").attr("action").split("/").pop();
        ulId = "#s_" + storageId + "_c_" + aliquotData["x"] + "_" + aliquotData["y"];
        destination = $("#firstStorageRow").find(ulId).append(li.html());

        destination.find("li:last-child").off("dblclick").on("dblclick", function () {
            var $td = $(this).closest("td");
            var val = $(this).find("span.handle").attr("data-barcode");
            if ($td.find(".barcode_scanner").length!==0){
                $td.find(".barcode_scanner").trigger("focusout");
            }
            $(this).remove();
            createInput($td);
            $td.find(".barcode_scanner").val(val);
            $td.find(".barcode_scanner").select();
        });

        //make them draggable
        destination.find("li:last-child").draggable({
            revert: 'invalid',
            zIndex: 1,
            scroll: false,
            start: function (event, ui) {
                dragging = true;
            }, stop: function (event, ui) {
                dragging = false;
            }
        });

        //create the drop zones
        destination.find("li:last-child").droppable({
            hoverClass: 'ui-state-active',
            tolerance: 'pointer',
            drop: function (event, ui) {
                moveItem(ui.draggable, this);
            }
        });
    }

    $("#csvDialogPopup").popup("close");
    $("#firstStorageRow").find("a").off("click").on("click", function(){
        var $this = $(this);
        if ($this.data("popup-link")!==""){
            showInPopup($this.data("popup-link"));
        }
    });
    checkDuplicatedBarcode();
}

function initRow(row, data, ctrls){
	var jsonOrgItems = data.positions;
	row.html(data.content);
	id = row.data('storageId');
	//display items in the proper cells
	for(var i = jsonOrgItems.length - 1; i >= 0; -- i){
		var appendString = "<li class='dragme " + jsonOrgItems[i].type + "' data-json='{ \"id\" : \"" + jsonOrgItems[i].id + "\", \"type\" : \"" + jsonOrgItems[i].type + "\"}'>"
			//ajax view button
			+ '<a href="javascript:void(0)" data-popup-link="' + jsonOrgItems[i].link + '\" title="' + detailString + '" class="icon16 ' + jsonOrgItems[i].icon_name + ' popupLink" style="text-decoration: none;">&nbsp;</a>'
			//DO NOT ADD A DETAIL BUTTON! It's too dangerous to edit and click it by mistake
			+ '<span class="handle" data-barcode = "'+jsonOrgItems[i].barcode+'">' + jsonOrgItems[i].label + '</span></li>';
		if(jsonOrgItems[i].x.length > 0){
			if($("#s_" + id + "_c_" + jsonOrgItems[i].x + "_" + jsonOrgItems[i].y).size() > 0){
				$("#s_" + id + "_c_" + jsonOrgItems[i].x + "_" + jsonOrgItems[i].y).append(appendString);
			}else{
				row.find(".unclassified").append(appendString);
			}
		}else{
			row.find(".unclassified").append(appendString);
		}
	}
	
	if(ctrls){
		$(row).find(".dragme").mouseover(function(){
			document.onselectstart = function(){ return false; };
		}).mouseout(function(){
			if(!dragging){
				document.onselectstart = null;
			}
		});
		
		//make them draggable
		$(row).find(".dragme").draggable({
			revert : 'invalid',
			zIndex: 1,
                        scroll: false,
			start: function(event, ui){
				dragging = true;
			}, stop: function(event, ui){
				dragging = false;
			}
		});
		
		//create the drop zones
		$(row).find(".droppable").droppable({
			hoverClass: 'ui-state-active',
			tolerance: 'pointer',
			drop: function(event, ui){
				moveItem(ui.draggable, this);
			}
		});
	}
	
	var secondRow = row[0] == $("#secondStorageRow")[0];
	row.find(".RecycleStorage").click(function(){
		moveStorage(row, true);
		if(secondRow){
			$("#btnPickStorage").hide();
		}
	});
	row.find(".TrashStorage").click(function(){
		moveStorage(row, false);
		if(secondRow){
			$("#btnPickStorage").hide();
		}
	});
	row.find(".TrashUnclassified").click(function(){
		moveUlTo(row, "unclassified", "trash");
		if(secondRow){
			$("#btnPickStorage").hide();
		}
	});
	row.find(".RecycleTrash").click(function(){
		moveUlTo(row, "trash", "unclassified");
		if(secondRow){
			$("#btnPickStorage").hide();
		}
	});
	
	row.find(".popupLink").click(function(){
    if ($(this).data("popup-link")!==""){
		showInPopup($(this).data("popup-link"));
    }
    return false;
	});
}

function searchBack(){
	$("#default_popup").html("").append($(".tmpSearchForm .wrapper"));
	$(".tmpSearchForm").remove();
	var isVisible = $("#default_popup:visible").length;
	if(isVisible){
		//recenter popup
		$("#default_popup").popup('close');
		$("#default_popup").popup();
	}
}

/**
 * Called when an item is dropped in a droppable zone, moves the DOM element to
 * the new container
 * @param draggable The draggable item that has been moved
 * @param droparea The drop zone where it was dropped
 * @return
 */
function moveItem(draggable, droparea){
        if (draggable.hasClass("just-added") && ($(droparea).find("ul.unclassified").length!=0 ||$(droparea).find("ul.trash").length!=0 || $(droparea).closest("#secondStorageRow").length!=0)){
		$(draggable).draggable({ revert : true });
        }   
	else if($(draggable).parent()[0] != $(droparea).children("ul:first")[0]){
		if($(droparea).children().length >= 4 && $(droparea).children()[3].id == "trash"){
			deleteItem(draggable);
		}else if($(droparea).children().length >= 4 && $(droparea).children()[3].id == "unclassified"){
			recycleItem(draggable);
		}else{
			$(draggable).appendTo($(droparea).children("ul:first"));
			modified = true;
			$("div.validation ul.confirm").remove();
		}
		$(draggable).css({"top" : "0px", "left" : "0px"});
		if(!$(droparea).data("top") || !draggable.data("top")){
			//as soon as we drag from bottom or drop bottom, hide button
			$("#btnPickStorage").hide();
		}
	}else{
		$(draggable).draggable({ revert : true });
	}
}

/**
 * Moves an item to the Trash area and updates the icons accordingly
 * @param scope The scope of the item to move
 * @param item The item to move
 * @return false to avoid browser redirection
 */
function deleteItem(scope, item) {
	$(item).fadeOut(200, function(){
		$(this).appendTo(scope.find(".trash"));
		$(this).fadeIn();
	});
	modified = true;
	$("div.validation ul.confirm").remove();
	return false;
}

/**
 * Moves an item to the unclassified area and updates the icons accordingly
 * @param scope The scope of the item to move
 * @param item The item to move
 * @return false to avoid browser redirection
 */
function recycleItem(scope, item) {
	$(item).fadeOut(200, function(){
		$(this).appendTo(scope.find(".unclassified"));
		$(this).fadeIn();
	});
	modified = true;
	$("div.validation ul.confirm").remove();
	return false;
}

/**
 * Right before submitting, builds a JSON string and places it into the form's hidden field 
 * @return true on first attemp, false otherwise
 */
function preparePost(){
	//check conflicts
	var idStr = '';
	if($('#firstStorageRow').data('checkConflicts') == 2){
		idStr = '#firstStorageRow';
	}
	if($('#secondStorageRow').data('checkConflicts') == 2){
		idStr += ',#secondStorageRow';
	}
	var gotConflicts = false;
	$(idStr).find("table ul").each(function(){
		if($(this).find('li').length > 1){
			$(this).parent().css('background-color', 'lightCoral');
			gotConflicts = true;
		}else{
			$(this).parent().css('background-color', 'transparent');
		}
	});
	
	if(gotConflicts){
		if($('#conflictPopup').length == 0){
			buildDialog('conflictPopup', STR_VALIDATION_ERROR, STR_STORAGE_CONFLICT_MSG, [{label : STR_OK, icon : 'detail', action : function(){ 
                                    $('#conflictPopup').popup('close'); 
                                } }]);
		}
                $("#firstStorageRow").closest("form").find("a.submit span").removeClass("fetching");
		$('#conflictPopup').popup();
	}else{
		var cells = '';
		var elements = $(".dragme");
		for(var i = elements.length - 1; i >= 0; --i){
			itemData = $(elements[i]).data("json");
			var info = $(elements[i]).parent().prop("id").match(/s\_([^\_]+)\_c\_([^\_]+)\_([^\_]+)/);
			cells += '{"id" : "' + itemData.id + '", "type" : "' + itemData.type + '", "s" : "' + info[1] + '", "x" : "' + info[2] + '", "y" : "' + info[3] + '"},'; 
		}
		if(cells.length > 0){
			cells = cells.substr(0, cells.length - 1);
		}
		var form = $("#firstStorageRow").parents("form:first");
		$("input.submit").first().siblings("a").find('span').removeClass("fetching");
		$(form).append("<input type='hidden' name='data' value='[" + cells + "]'/>").submit();
		
	}
}

/**
 * Moves all storage's items
 * @param scope The scope of the move
 * @param recycle If true, the items go to the unclassified box, otherwise they go to the trash
 * @return
 */
function moveStorage(scope, recycle){
	var elements = scope.find("table.storageLayout ul");
	for(var i = 0; i < elements.length; ++ i){

		var id = elements[i].id;
		if(id != null && id.indexOf("s_") == 0){
			for(var j = $(elements[i]).children().length - 1; j >= 0; -- j){
                            $elements = $(elements[i]).children().eq(j);
                            if ($elements.hasClass("just-added")){
                                continue;
                            }
				if(recycle){
					recycleItem(scope, $(elements[i]).children()[j]);
				}else{
					deleteItem(scope, $(elements[i]).children()[j]);
				}
			}
		}
	}
}

/**
 * Moves an unordered list's items towards a destination
 * @parem scope The scope of the move
 * @param sourceClass The source class
 * @param destinationClass The destination class
 * @return
 */
function moveUlTo(scope, sourceClass, destinationClass){
	var liArray = scope.find("." + sourceClass).children();
	for(var j = liArray.length - 1; j >= 0; -- j){
		if(destinationClass == "trash"){
			deleteItem(scope, liArray[j]);
		}else{
			recycleItem(scope, liArray[j]);
		}
	}	
}

function showInPopup(link){
	$("#otherPopup").html("<div class='loading'>---" + STR_LOADING + "---</div>").popup();
	$.get(link + "?t=" + new Date().getTime(), {}, function(data){
                var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                saveSqlLogAjax(ajaxSqlLog);
                data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
            
                $("#otherPopup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>").popup();
                flyOverComponents();
	});
}

function createInput($this){
    $input = $("<input type = 'text'>");
    $input.attr("class", "barcode_scanner");
    $input.css({"display": "inline-block", "width": "90%"});
    $this.append($input);
    var ul = $this.find('ul');
    if (ul.find("li").length==0){
        ul.css("min-height", "0px");
    }
    $input.focus();
    checkDuplicatedBarcode();
    $input.off("keydown").on("keydown", function (e) {
        var $td = $(this).closest("td");
        var index = $("#firstStorageRow").find("td.droppable").index($td);
        var length = $("#firstStorageRow").find("td.droppable").length;
        if ((e.keyCode == 9 && !e.shiftKey) || (e.keyCode == 13)) {
            if (index < length - 1) {
                var $next = $("#firstStorageRow").find("td.droppable").eq(index + 1);
                if ($next.length != 0) {
                    $next.trigger('click');
                }
                return false;
            } 
        }
    });

    $input.off("focusout").on("focusout", function () {
        $this = $(this).closest("td");
        var value = $this.find(".barcode_scanner").val();
        if (value == "") {
            $this.find(".barcode_scanner").remove();
            var ul = $this.find('ul');
            if (ul.find("li").length==0){
                ul.css("min-height", "25px");
            }
        checkDuplicatedBarcode();
        } else {
            checkAliquotBarcode($this);
        }
        return false;
    });
    
}

function addAliquotByClick(e){
    var $this = $(this);
    if ((e.target == this || e.target.nodeName == "UL") && $(this).find(".barcode_scanner").length == 0) {
        createInput($this);
        return false;
    }
}

function checkDuplicatedBarcode(li){
    if (typeof li !== 'undefined'){
        barcodeValue = li.find('span.handle').attr("data-barcode");
        searchByBarcode = $("#firstStorageRow").find("span:[data-barcode = '"+barcodeValue+"']");
        if (searchByBarcode.length>1){
            searchByBarcode.each(function(){
                var lii = $(this).closest("li");
                if (!lii.hasClass("warning-aliquot")){
                    lii.removeClass("new-aliquot");
                    lii.addClass("warning-aliquot");
                }
            });
        }
    }
    
    searchByBarcode = $("#firstStorageRow").find("li:not(.error-aliquot) span.handle");
//    searchByBarcode = $("#firstStorageRow").find("li:not(.error-aliquot):not(.duplicated-aliquot) span.handle");
    searchByBarcodeText = [];
    searchByBarcode.each(function(){
        if ($(this).attr("data-barcode")!=""){
            searchByBarcodeText.push($(this).attr("data-barcode"));
        }
    });

    var sorted_arr = searchByBarcodeText.sort();

    searchDifferentBarcodeText = sorted_arr.filter(function(item){
        return sorted_arr.lastIndexOf(item) === sorted_arr.indexOf(item);
    });
    searchDifferentBarcodeText.forEach(function(item){
        $liParent = $("#firstStorageRow").find("li:not(.error-aliquot) span.handle[data-barcode='"+item+"']").closest("li");
        $liParent.each(function(){
            if (!$(this).hasClass("duplicated-aliquot")){
                $(this).removeClass("warning-aliquot");
                if ($(this).hasClass("just-added")){
                    $(this).addClass("new-aliquot");
                }
            }
        });
        
    });

    searchSameBarcodeText = sorted_arr.filter(function(item){
        return sorted_arr.lastIndexOf(item) !== sorted_arr.indexOf(item);
    });

    searchSameBarcodeText.forEach(function(item){
        $liParent = $("#firstStorageRow").find("li:not(.error-aliquot) span.handle[data-barcode='"+item+"']").closest("li");
        $liParent.removeClass("new-aliquot").addClass("warning-aliquot");
    });

}

function checkAliquotBarcode($this) {
    var barcode = $this.find(".barcode_scanner").val();
    $this.find(".barcode_scanner").replaceWith("<span class=\"icon16 fetching\"></span>");
    var strorageId = $this.find("ul").attr("id").split("_")[1];
    var url = root_url+"StorageLayout/StorageMasters/getAliquotDetail/"+strorageId+"/"+barcode;
    $.get(url, function (data){
        var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
        saveSqlLogAjax(ajaxSqlLog);
        data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
        data = $.parseJSON(data);
        $this.find(".fetching").remove();
        $this.find("ul").append(data.page);
        var li = $this.find("ul li:last-child");
        
        checkDuplicatedBarcode(li);
        
        li.find("a").off("click").on("click", function(){
            var $this = $(this);
            if ($this.data("popup-link")!==""){
                showInPopup($this.data("popup-link"));
            }
        });
        li.mouseover(function(){
            document.onselectstart = function(){ return false; };
        }).mouseout(function(){
            if(!dragging){
                document.onselectstart = null;
            }
        });

        //make them draggable
        li.draggable({
                revert : 'invalid',
                zIndex: 1,
                scroll: false,
                start: function(event, ui){
                        dragging = true;
                }, stop: function(event, ui){
                        dragging = false;
                }
        });

        //create the drop zones
        li.droppable({
                hoverClass: 'ui-state-active',
                tolerance: 'pointer',
                drop: function(event, ui){
                        moveItem(ui.draggable, this);
                }
        });
        
        li.off("dblclick").on("dblclick", function(){
            var $td = $(this).closest("td");
            var val = $(this).find("span.handle").attr("data-barcode");
            if ($td.find(".barcode_scanner").length!==0){
                $td.find(".barcode_scanner").trigger("focusout");
            }
            $(this).remove();
            createInput($td);
            $td.find(".barcode_scanner").val(val);
            $td.find(".barcode_scanner").select();
        });
        flyOverComponents();
    });
}

function clearLoadedBarcodes(){
    $("li.just-added").remove();
    checkDuplicatedBarcode();
}