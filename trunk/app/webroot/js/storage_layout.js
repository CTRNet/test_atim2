/**
 * This script is used by the storage_layout page for drag and drop
 */

var submitted = false; //avoids internal double posts

window.onload = function(){
	//create all items
	var jsonOrgItems = eval('(' + orgItems + ')');
	for(var i = jsonOrgItems.length - 1; i >= 0; -- i){
		var appendString = "<li class='dragme { \"id\" : \"" + jsonOrgItems[i].id + "\", \"type\" : \"" + jsonOrgItems[i].type + "\"}'>"
			+ '<a href="#" title="Delete" class="ui-icon ui-icon-trash" style="float: left;">Delete</a>'
			+ '<a href="#" title="Delete this image" title="Recycle" class="ui-icon ui-icon-refresh" style="float: left;">Recycle</a>'
			+ jsonOrgItems[i].label + '</li>';

		if(jsonOrgItems[i].x.length > 0){
			$("debug").innerHTML += $$("#cell_" + jsonOrgItems[i].x + "_" + jsonOrgItems[i].y).size() + "<br/>";
			if($$("#cell_" + jsonOrgItems[i].x + "_" + jsonOrgItems[i].y).size() > 0){
				$$("#cell_" + jsonOrgItems[i].x + "_" + jsonOrgItems[i].y)[0].innerHTML += appendString;
			}else{
				$("debug").innerHTML += "Error<br/>";	
			}
		}else{
			$("unclassified").innerHTML += appendString;
		}
	}
	
	var elements = $$(".dragme");
	for(var i = elements.length - 1; i >= 0; --i){
		new Draggable(elements[i], { revert: true});
	}
	
	elements = $$(".droppable");
	for(var i = elements.length - 1; i >= 0; --i){
		Droppables.add(elements[i], {
			hoverclass: 'ui-state-active',
	        accept: 'dragme',
	        onDrop: moveItem
		});
	}
	
	elements = $$("a.ui-icon-trash");
	for(var i = elements.length - 1; i >= 0; --i){
		elements[i].setAttribute('onclick', 'deleteItem(this.parentNode);');
	}
	
	elements = $$("a.ui-icon-refresh");
	for(var i = elements.length - 1; i >= 0; --i){
		elements[i].setAttribute('onclick', 'recycleItem(this.parentNode);');
		elements[i].setStyle({ display: 'none'});
	}
	
	$("submitButton").setAttribute('onclick', 'return preparePost();');
}

function moveItem( draggable,droparea){
	if(draggable.parentNode != droparea){
		draggable.parentNode.removeChild(draggable);
		if(droparea.childNodes[0] == "[object HTMLUListElement]"){
			//for unclassified and trash
			droparea.childNodes[0].appendChild(draggable);
		}else if(droparea.childNodes[1] == "[object HTMLUListElement]"){
			//for table cells
			droparea.childNodes[1].appendChild(draggable);
		}
	}
}

function deleteItem(item) {
//	item.fadeOut(function() {
//		var $list = $('ul', $("#trash")).length ? $('ul', $("#trash")) : $('<ul/>').appendTo($("#trash"));
//		item.children("a.ui-icon-trash").hide();
//		item.children("a.ui-icon-refresh").show();
//		item.appendTo($list).fadeIn();
//	});
	
	item.parentNode.removeChild(item);
	item.childNodes[0].setStyle({ display: 'none'});//hide trash can
	item.childNodes[1].setStyle({ display: 'block'});//show recycle
	$("trash").appendChild(item);
	
	return false;
}

// image recycle function
function recycleItem(item) {
//	item.fadeOut(function() {
//		var $list = $('ul', $("#unclassified")).length ? $('ul', $("#unclassified")) : $('<ul/>').appendTo($("#unclassified"));
//		$(item).children("a.ui-icon-trash").show();
//		$(item).children("a.ui-icon-refresh").hide();
//		item.appendTo($list).fadeIn();
//	});
	
	item.parentNode.removeChild(item);
	item.childNodes[0].setStyle({ display: 'block'});//show trash can
	item.childNodes[1].setStyle({ display: 'none'});//hide recycle
	$("unclassified").appendChild(item);
	
	return false;
}

function preparePost(){
	if(!submitted){
		submitted = true;
		var cells = '';
		var elements = $$(".dragme");
		for(var i = elements.length - 1; i >= 0; --i){
			var tmpIndex = elements[i].getAttribute("class").indexOf('{');
			var itemData = elements[i].getAttribute("class").substr(tmpIndex, elements[i].getAttribute("class").lastIndexOf('}') - tmpIndex + 1);
			itemData = eval("(" + itemData + ")");
			
			if(elements[i].parentNode.getAttribute("id").indexOf("cell_") == 0){
				var cellId = elements[i].parentNode.getAttribute("id");
				var index1 = cellId.indexOf("_") + 1;
				var index2 = cellId.lastIndexOf("_");
				cells += '{"id" : "' + itemData.id + '", "type" : "' + itemData.type + '", "x" : "' + cellId.substr(index1, index2 - index1) + '", "y" : "' + cellId.substr(index2 + 1) + '"},'; 
			}else if(elements[i].parentNode.getAttribute("id").indexOf("trash") == 0){
				cells += '{"id" : "' + itemData.id + '", "type" : "' + itemData.type + '", "x" : "t", "y" : "t"},';
			}else{
				//unclassified
				cells += '{"id" : "' + itemData.id + '", "type" : "' + itemData.type + '", "x" : "u", "y" : "u"},';
			}
		}
		if(cells.length > 0){
			cells = cells.substr(0, cells.length - 1);
		}
		$("data").setAttribute("value", '[' + cells + ']');
		$("debug").innerHTML += $("data").getAttribute("value") + "<br/>";
	}else{
		return false;
	}
}

function debug(str){
	$("debug").innerHTML += str + "<br/>";
}
