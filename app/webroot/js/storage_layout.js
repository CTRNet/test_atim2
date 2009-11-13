/**
 * This script is used by the storage_layout page for drag and drop
 */

var submitted = false; //avoids internal double posts

window.onload = function(){
	//create all items
	var jsonOrgItems = eval('(' + orgItems + ')');
	for(var i = jsonOrgItems.length - 1; i >= 0; -- i){
		var appendString = "<li class='dragme " + jsonOrgItems[i].type + " { \"id\" : \"" + jsonOrgItems[i].id + "\", \"type\" : \"" + jsonOrgItems[i].type + "\"}'>"
			+ '<a href="#" title="' + removeString + '" class="ui-icon ui-icon-close" style="float: left;">' + removeString + '</a>'
			+ '<a href="#" title="' + unclassifyString + '" title="Recycle" class="ui-icon ui-icon-refresh" style="float: left;">' + removeString + '</a>'
			+ '<span class="handle">' + jsonOrgItems[i].label + '</span></li>';

		if(jsonOrgItems[i].x.length > 0){
			debug($$("#cell_" + jsonOrgItems[i].x + "_" + jsonOrgItems[i].y).size());
			if($$("#cell_" + jsonOrgItems[i].x + "_" + jsonOrgItems[i].y).size() > 0){
				$$("#cell_" + jsonOrgItems[i].x + "_" + jsonOrgItems[i].y)[0].innerHTML += appendString;
			}else{
				debug("Error: [#cell_" + jsonOrgItems[i].x + "_" + jsonOrgItems[i].y + "] not foud");	
			}
		}else{
			$("unclassified").innerHTML += appendString;
		}
	}
	
	//make them draggable
	var elements = $$(".dragme");
	for(var i = elements.length - 1; i >= 0; --i){
		debug(elements[i].childNodes[2]);
		new Draggable(elements[i], { revert: true, handle: elements[i].childNodes[2], scroll: window });
	}
	
	//create the drop zones
	elements = $$(".droppable");
	for(var i = elements.length - 1; i >= 0; --i){
		Droppables.add(elements[i], {
			hoverclass: 'ui-state-active',
	        accept: 'dragme',
	        onDrop: moveItem
		});
	}
	
	//bind delete to the close icon
	elements = $$("a.ui-icon-close");
	for(var i = elements.length - 1; i >= 0; --i){
		elements[i].setAttribute('onclick', 'deleteItem(this.parentNode);');
	}
	
	//bind recycle to the refresh icon
	elements = $$("a.ui-icon-refresh");
	for(var i = elements.length - 1; i >= 0; --i){
		elements[i].setAttribute('onclick', 'recycleItem(this.parentNode);');
	}
	
	//hide the refresh icon for the unclassified elements
	elements = $("unclassified").childNodes;
	for(var i = 0; i < elements.length; i ++){
		elements[i].childNodes[1].setStyle({ display: 'none'});
	}
	
	//bind preparePost to the submit button
	$("submitButton").setAttribute('onclick', 'return preparePost();');
	
	$("RecycleStorage").setAttribute('onclick', 'moveStorage(true);');
	$("TrashStorage").setAttribute('onclick', 'moveStorage(false);');
	$("TrashUnclassified").setAttribute('onclick', 'moveUlTo($("unclassified"), "trash");');
	$("RecycleTrash").setAttribute('onclick', 'moveUlTo($("trash"), "unclassified");');
	$("Reset").setAttribute('onclick', 'document.location="";');
}

/**
 * Called when an item is dropped in a droppable zone, moves the DOM element to the new container and updates the action
 * icons accordingly
 * @param draggable The draggable item that has been moved
 * @param droparea The drop zone where it was dropped
 * @return
 */
function moveItem( draggable,droparea){
	if(draggable.parentNode.parentNode != droparea){
		if(droparea.childNodes.length >= 3 && droparea.childNodes[3].getAttribute("id") == "trash"){
			deleteItem(draggable);
		}else if(droparea.childNodes.length >= 3 && droparea.childNodes[3].getAttribute("id") == "unclassified"){
			recycleItem(draggable);
		}else{
			draggable.childNodes[0].setStyle({ display: 'block'});//show trash can
			draggable.childNodes[1].setStyle({ display: 'block'});//show recycle
			draggable.parentNode.removeChild(draggable);
			var li = Builder.node('li');
			li.setAttribute('class', draggable.getAttribute('class'));
			li.setAttribute('id', draggable.getAttribute('id'));
			li.setAttribute('style', 'display: none;');
			li.innerHTML = draggable.innerHTML;
			new Draggable(li, { revert: true, scroll: window});
			droparea.childNodes[1].appendChild(li);
			li.appear();
			$('saveWarning').appear();
		}
	}
}

/**
 * Moves an item to the Trash area and updates the icons accordingly
 * @param item The item to move
 * @return false to avoid browser redirection
 */
function deleteItem(item) {
	item.parentNode.removeChild(item);
	item.childNodes[0].setStyle({ display: 'none'});//hide trash can
	item.childNodes[1].setStyle({ display: 'block'});//show recycle
	item.setAttribute('style', 'display: none; position: relative;');
	$("trash").appendChild(item);
	item.appear();
	$('saveWarning').appear();
	
	return false;
}


/**
 * Moves an item to the unclassified area and updates the icons accordingly
 * @param item The item to move
 * @return false to avoid browser redirection
 */
function recycleItem(item) {
	item.parentNode.removeChild(item);
	item.childNodes[0].setStyle({ display: 'block'});//show trash can
	item.childNodes[1].setStyle({ display: 'none'});//hide recycle
	item.setAttribute('style', 'display: none; position: relative;');
	$("unclassified").appendChild(item);
	item.appear();
	$('saveWarning').appear();
	
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
		var elements = $$(".dragme");
		for(var i = elements.length - 1; i >= 0; --i){
			var tmpIndex = elements[i].getAttribute("class").indexOf('{');
			var itemData = elements[i].getAttribute("class").substr(tmpIndex, elements[i].getAttribute("class").lastIndexOf('}') - tmpIndex + 1);
			itemData = eval("(" + itemData + ")");
			
			if(elements[i].parentNode.getAttribute("id").indexOf("cell_") == 0){
				//normal cell
				var cellId = elements[i].parentNode.getAttribute("id");
				var index1 = cellId.indexOf("_") + 1;
				var index2 = cellId.lastIndexOf("_");
				cells += '{"id" : "' + itemData.id + '", "type" : "' + itemData.type + '", "x" : "' + cellId.substr(index1, index2 - index1) + '", "y" : "' + cellId.substr(index2 + 1) + '"},'; 
			}else if(elements[i].parentNode.getAttribute("id").indexOf("trash") == 0){
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
		$("data").setAttribute("value", '[' + cells + ']');
		debug($("data").getAttribute("value"));
	}else{
		return false;
	}
//	return false;
}

/**
 * Moves all storage's items
 * @param recycle If true, the items go to the unclassified box, otherwise they go to the trash
 * @return
 */
function moveStorage(recycle){
	var elements = $$("ul");
	for(var i = 0; i < elements.length; ++ i){
		var id = elements[i].getAttribute("id");
		if(id != null && id.indexOf("cell_") == 0){
			for(var j = elements[i].childNodes.length - 1; j >= 0; -- j){
				if(recycle){
					recycleItem(elements[i].childNodes[j]);
				}else{
					deleteItem(elements[i].childNodes[j]);
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
function moveUlTo(ulArray, destination){
	for(var j = ulArray.childNodes.length - 1; j >= 0; -- j){
		if(destination == "trash"){
			deleteItem(ulArray.childNodes[j]);
		}else{
			recycleItem(ulArray.childNodes[j]);
		}
	}	
}

function debug(str){
//	$("debug").innerHTML += str + "<br/>";
}
