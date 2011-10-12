/**
 * This script is used by the storage_layout page for drag and drop
 */

var submitted = false; //avoids internal double posts

function initStorageLayout(){
	var id = document.URL.match(/[0-9]+/g);
	$("#firstStorageRow").data('storageId', id.pop());
	//load the top storage loayout
	$.get(document.URL, function(data){
		data = $.parseJSON(data);
		if(data.valid){
			initRow($("#firstStorageRow"), data);
		}
	});
	
	//bind preparePost to the submit button
	$("#submit_button_link").click(function(){
		window.onbeforeunload = null;
		preparePost();
		return false;
	});
	
	window.onbeforeunload = function(event) {
		if($("#saveWarning:visible").length){
			return STR_NAVIGATE_UNSAVED_DATA;
		}
	};
	
	//handle the "pick a storage to drag and drop to" button and popup
	$.get(root_url + '/storagelayout/storage_masters/search/', function(data){
		var isVisible = $("#default_popup:visible").length;
		$("#default_popup").html('<div class="wrapper"><div class="frame">' + data + '</div></div>');
		globalInit($("#default_popup"));
		
		if(isVisible){
			//recenter popup
			$("#default_popup").popup('close');
			$("#default_popup").popup();
		}
		
		$("#default_popup input.submit").click(function(){
			//search results into popup
			$.post($("#default_popup form").attr("action") + '/1', $("#default_popup form").serialize(), function(data){
				$("body").append("<div class='hidden tmpSearchForm'></div>");
				$(".tmpSearchForm").append($("#default_popup .wrapper"));
				data = $.parseJSON(data);
				var isVisible = $("#default_popup:visible").length;
				$("#default_popup").html('<div class="wrapper"><div class="frame">' + data.page + '</div></div>');
				if(isVisible){
					//recenter popup
					$("#default_popup").popup('close');
					$("#default_popup").popup();
				}
				
				$("#default_popup a.form.detail").click(function(){
					//handle selection buttons
					$("#secondStorageRow").html("");
					var id = $(this).attr("href").match("[0-9]+(/)*$")[0];
					if(id != $("#firstStorageRow").data("storageId")){
						//if not the same storage
						$("#secondStorageRow").data("storageId", id);
						$.get(root_url + '/storagelayout/storage_masters/storageLayout/' + id, function(data){
							data = $.parseJSON(data);
							if(data.valid){
								initRow($("#secondStorageRow"), data);
							}
						});
					}
					return false;
				});
			});
			return false;
		});
	});
	
	$("#btnPickStorage").click(function(){
		$("#default_popup").popup();
	});
}

function initRow(row, data){
	var jsonOrgItems = data.positions;
	row.html(data.content);
	id = row.data('storageId');
	//display items in the proper cells
	for(var i = jsonOrgItems.length - 1; i >= 0; -- i){
		var appendString = "<li class='dragme " + jsonOrgItems[i].type + " { \"id\" : \"" + jsonOrgItems[i].id + "\", \"type\" : \"" + jsonOrgItems[i].type + "\"}'>"
			//ajax view button
			+ '<a href="#popup" title="' + detailString + '" class="form ' + jsonOrgItems[i].icon_name + ' ajax {\'callback\' : \'showInPopup\', \'load\' : \'' + jsonOrgItems[i].link + '\'}" style="text-decoration: none;">&nbsp;</a>'
			//DO NOT ADD A DETAIL BUTTON! It's too dangerous to edit and click it by mistake
			+ '<span class="handle">' + jsonOrgItems[i].label + '</span></li>';
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
	
	//make them draggable
	$(".dragme").draggable({
		revert : 'invalid',
		start: function(event, ui){
			//for easier dragging, convert the item display to inline-block
			$(this).css("display", "inline-block");
		},stop: function(event, ui){
			//put back original display property
			$(this).css("display", "list-item");
		}
	});
	
	//create the drop zones
	$(".droppable").droppable({
		hoverClass: 'ui-state-active',
		drop: function(event, ui){
			moveItem(ui.draggable, this);
		}
	});
	
	row.find(".RecycleStorage").click(function(){
		moveStorage(row, true);
	});
	row.find(".TrashStorage").click(function(){
		moveStorage(row, false);
	});
	row.find(".TrashUnclassified").click(function(){
		moveUlTo(row, "unclassified", "trash");
	});
	row.find(".RecycleTrash").click(function(){
		moveUlTo(row, "trash", "unclassified");
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
 * Called when an item is dropped in a droppable zone, moves the DOM element to the new container and updates the action
 * icons accordingly
 * @param draggable The draggable item that has been moved
 * @param droparea The drop zone where it was dropped
 * @return
 */
function moveItem(draggable, droparea){
	if($(draggable).parent().prop("id") != $(droparea).children("ul:first")[0].id){
		if($(droparea).children().length >= 4 && $(droparea).children()[3].id == "trash"){
			deleteItem(draggable);
		}else if($(droparea).children().length >= 4 && $(droparea).children()[3].id == "unclassified"){
			recycleItem(draggable);
		}else{
			$($(draggable).children()[0]).css("display", 'inline-block');//show trash can
			$($(draggable).children()[1]).css("display", 'inline-block');//show recycle
			$(draggable).appendTo($(droparea).children("ul:first"));
			$('#saveWarning').show();
		}
		$(draggable).css({"top" : "0px", "left" : "0px"});
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
	$('#saveWarning').show();
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
	$('#saveWarning').show();
	return false;
}

/**
 * Right before submitting, builds a JSON string and places it into the form's hidden field 
 * @return true on first attemp, false otherwise
 */
function preparePost(){
	if(!submitted){
		submitted = true;
		var cells = '';
		var elements = $(".dragme");
		debug("JOY" + elements.length);
		for(var i = elements.length - 1; i >= 0; --i){
			itemData = getJsonFromClass($(elements[i]).prop("class"));
			if($(elements[i]).parent().prop("id").indexOf("cell_") == 0){
				//normal cell
				var cellId = $(elements[i]).parent().prop("id");
				var index1 = cellId.indexOf("_") + 1;
				var index2 = cellId.lastIndexOf("_");
				cells += '{"id" : "' + itemData.id + '", "type" : "' + itemData.type + '", "x" : "' + cellId.substr(index1, index2 - index1) + '", "y" : "' + cellId.substr(index2 + 1) + '"},'; 
			}else if($(elements[i]).parent().prop("id").indexOf("trash") == 0){
				//trash, x and y are set to "t"
				cells += '{"id" : "' + itemData.id + '", "type" : "' + itemData.type + '", "x" : "t", "y" : "t"},';
			}else{
				//unclassified, x and y are set to "u"
				cells += '{"id" : "' + itemData.id + '", "type" : "' + itemData.type + '", "x" : "u", "y" : "u"},';
			}
		}
		if(cells.length > 0){
			cells = cells.substr(0, cells.length - 1);
		}
		$("#data").val('[' + cells + ']');
		$("form").submit();
	}else{
		return false;
	}
}

/**
 * Moves all storage's items
 * @param scope The scope of the move
 * @param recycle If true, the items go to the unclassified box, otherwise they go to the trash
 * @return
 */
function moveStorage(scope, recycle){
	var elements = scope.find("ul");
	for(var i = 0; i < elements.length; ++ i){
		var id = elements[i].id;
		if(id != null && id.indexOf("s_") == 0){
			for(var j = $(elements[i]).children().length - 1; j >= 0; -- j){
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

function showInPopup(element, json){
	if(!window.loadingStr){
		window.loadingStr = "js untranslated loading";	
	}
	$("#default_popup").html("<div class='loading'>---" + loadingStr + "---</div>");
	$("#default_popup").popup();
	$.get(json.load + "?t=" + new Date().getTime(), {}, function(data){
		 $("#default_popup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>");
		 $("#default_popup").popup();
	});
}
