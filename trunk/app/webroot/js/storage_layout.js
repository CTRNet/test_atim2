/**
 * This script is used by the storage_layout page for drag and drop
 */

var submitted = false; //avoids internal double posts

function initStorageLayout(){
	//create all items
	var jsonOrgItems = eval('(' + orgItems + ')');
	for(var i = jsonOrgItems.length - 1; i >= 0; -- i){
		var appendString = "<li class='dragme " + jsonOrgItems[i].type + " { \"id\" : \"" + jsonOrgItems[i].id + "\", \"type\" : \"" + jsonOrgItems[i].type + "\"}'>"
			//ajax view button
			+ '<a href="#popup" title="' + detailString + '" class="form ' + jsonOrgItems[i].icon_name + ' ajax {\'callback\' : \'showInPopup\', \'load\' : \'' + jsonOrgItems[i].link + '\'}" style="text-decoration: none;">&nbsp;</a>'
			//DO NOT ADD A DETAIL BUTTON! It's too dangerous to edit and click it by mistake
			+ '<span class="handle">' + jsonOrgItems[i].label + '</span></li>';

		if(jsonOrgItems[i].x.length > 0){
			debug($("#cell_" + jsonOrgItems[i].x + "_" + jsonOrgItems[i].y).size());
			if($("#cell_" + jsonOrgItems[i].x + "_" + jsonOrgItems[i].y).size() > 0){
				$("#cell_" + jsonOrgItems[i].x + "_" + jsonOrgItems[i].y[0]).append(appendString);
			}else{
				$("#unclassified").append(appendString);
				debug("Error: [#cell_" + jsonOrgItems[i].x + "_" + jsonOrgItems[i].y + "] not foud");	
			}
		}else{
			$("#unclassified").append(appendString);
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
	
	//bind preparePost to the submit button
	$("#submit_button_link").click(function(){
		window.onbeforeunload = null;
		preparePost();
		return false;
	});
	
	$("#RecycleStorage").click(function(){
		moveStorage(true);
	});
	$("#TrashStorage").click(function(){
		moveStorage(false);
	});
	$("#TrashUnclassified").click(function(){
		moveUlTo("unclassified", "trash");
	});
	$("#RecycleTrash").click(function(){
		moveUlTo("trash", "unclassified");
	});
	$("#Reset").click(function(){
		document.location="";
	});
	
	window.onbeforeunload = function(event) {
		console.log(event.srcElement);
		if($("#saveWarning:visible").length){
			return STR_NAVIGATE_UNSAVED_DATA;
		}
	};
}

/**
 * Called when an item is dropped in a droppable zone, moves the DOM element to the new container and updates the action
 * icons accordingly
 * @param draggable The draggable item that has been moved
 * @param droparea The drop zone where it was dropped
 * @return
 */
function moveItem(draggable, droparea){
	if($(draggable).parent().attr("id") != $(droparea).children("ul:first")[0].id){
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
 * @param item The item to move
 * @return false to avoid browser redirection
 */
function deleteItem(item) {
	$(item).fadeOut(200, function(){
		$(this).appendTo($("#trash"));
		$(this).fadeIn();
	});
	$('#saveWarning').show();
	return false;
}


/**
 * Moves an item to the unclassified area and updates the icons accordingly
 * @param item The item to move
 * @return false to avoid browser redirection
 */
function recycleItem(item) {
	$(item).fadeOut(200, function(){
		$(this).appendTo($("#unclassified"));
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
			itemData = getJsonFromClass($(elements[i]).attr("class"));
			if($(elements[i]).parent().attr("id").indexOf("cell_") == 0){
				//normal cell
				var cellId = $(elements[i]).parent().attr("id");
				var index1 = cellId.indexOf("_") + 1;
				var index2 = cellId.lastIndexOf("_");
				cells += '{"id" : "' + itemData.id + '", "type" : "' + itemData.type + '", "x" : "' + cellId.substr(index1, index2 - index1) + '", "y" : "' + cellId.substr(index2 + 1) + '"},'; 
			}else if($(elements[i]).parent().attr("id").indexOf("trash") == 0){
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
		debug($("#data").val());
		$("form").submit();
	}else{
		return false;
	}
}

/**
 * Moves all storage's items
 * @param recycle If true, the items go to the unclassified box, otherwise they go to the trash
 * @return
 */
function moveStorage(recycle){
	var elements = $("ul");
	for(var i = 0; i < elements.length; ++ i){
		var id = elements[i].id;
		if(id != null && id.indexOf("cell_") == 0){
			for(var j = $(elements[i]).children().length - 1; j >= 0; -- j){
				if(recycle){
					recycleItem($(elements[i]).children()[j]);
				}else{
					deleteItem($(elements[i]).children()[j]);
				}
			}
		}
	}
}

/**
 * Moves an unordered list's items towards a destination
 * @param ulArray The unordered list which items needs to be moved
 * @param destination The destination where to move the items
 * @return
 */
function moveUlTo(ulId, destinationId){
	var liArray = $("#" + ulId).children();
	for(var j = liArray.length - 1; j >= 0; -- j){
		if(destinationId == "trash"){
			deleteItem(liArray[j]);
		}else{
			recycleItem(liArray[j]);
		}
	}	
}

function showInPopup(element, json){
	if(!window.loadingStr){
		window.loadingStr = "js untranslated loading";	
	}
	$("#default_popup").html("<div class='loading'>---" + loadingStr + "---</div>");
	$("#default_popup").popup();
	$.get(json.load, {}, function(data){
		 $("#default_popup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>");
		 $("#default_popup").popup();
	});
}
