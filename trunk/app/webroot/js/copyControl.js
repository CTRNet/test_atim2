/**
 * Script to copy the fields from one line to another. The readonly fields are not copied
 * The script will not properly work if:
 * -ids are shared among fields (patched on line add with enableCopyCtrl by updating the ids) 
 * -fields are not having a line number (Datetime hour, minutes and AM/PM are having this issue)
 */

var componentsArray = new Array();
var rowComponentsArray = new Array();

var componentsArrayCopy = new Array();
var rowComponentsArrayCopy = new Array();

var rowCount = 0;

window.onload = function(){
	if($("0FunctionManagementCopyCtrl")){
		//loop through the first line to build the array of writable fields ids
		for(var i = 0; i < $("0FunctionManagementCopyCtrl").parentNode.parentNode.childNodes.length; i ++){
			var current = $("0FunctionManagementCopyCtrl").parentNode.parentNode.childNodes[i];
			if(current == "[object HTMLTableCellElement]"){
				for(var j = 0; j < current.childNodes.length; j ++){
					if(current.childNodes[j] != "[object Text]" 
							&& current.childNodes[j] != "[object Comment]" 
							&& current.childNodes[j].getAttribute("type") != "hidden"	
							&& (current.childNodes[j].getAttribute("class") == null
								|| current.childNodes[j].getAttribute("class").indexOf("readonly") == -1)
							&& (current.childNodes[j].getAttribute("id") == null
								|| current.childNodes[j].getAttribute("id").indexOf("CopyPrevLine") == -1)){
						if(current.childNodes[j].getAttribute("id") != null){
							if(current.childNodes[j].getAttribute("id").indexOf("0") == 0){
								componentsArray.push(current.childNodes[j].getAttribute("id").substr(1));
							}else if(current.childNodes[j].getAttribute("id").indexOf("row") == 0){
//								debug(current.childNodes[j].getAttribute("id") + " --&gt;" + current.childNodes[j].getAttribute("id").substr(4));
								rowComponentsArray.push(current.childNodes[j].getAttribute("id").substr(4));
							}
						}else{
							debug("Unknown entity found");
						}
					}
				}
			}
		}
	}
	debug("components: " + componentsArray);
	debug("row: " + rowComponentsArray);
	
	//count the number of rows
	if(componentsArray.length > 0){
		while($(rowCount + componentsArray[0])){
			++ rowCount;
			
		}
	}else{
		while($("row" + rowCount + rowComponentsArray[0])){
			++ rowCount;		
		}
	}
	debug("count:" + rowCount);
	if(!window.copyStr){
		window.copyStr = "js untranslated copy";	
	}
	if(!window.pasteStr){
		window.pasteStr = "js untranslated paste";	
	}
	if(!window.copyingStr){
		window.copyingStr = "js untranslated copying";	
	}
	if(window.debug){
		debug("yay");
	}
	//bind onclick command and refresh lines
	for(var i = 0; i < rowCount; i ++){
		$(i + "FunctionManagementCopyCtrl").parentNode.innerHTML += "<span class='copyCtrl' id='" + i + "copy' >" + copyStr + "</span><span class='copyCtrl' id='" + i + "paste' >" + pasteStr + "</span><span style='margin-left: 10px;' id='" + i + "copying'></span>";
		$(i + "FunctionManagementCopyCtrl").setStyle({ display: 'none'});
		$(i + "copy").setAttribute('onclick', 'copyLine(' + i + ');');
		$(i + "paste").setAttribute('onclick', 'pasteLine(' + i + ');');
	}
	
};

/**
 * Copies a line
 * @param index The index of the line to copy
 * @return
 */
function copyLine(index){
	for(var i = 0; i < rowCount; i ++){
		$(i + "copying").innerHTML = "";
	}
	
	//disabled as this could get confusing
	//$(index + "copying").innerHTML = copyingStr;

	for(var i = 0; i < componentsArray.length; i ++){
		componentsArrayCopy[i] = $F(index + componentsArray[i]);
	}
	for(var i = 0; i < rowComponentsArray.length; i ++){
		if($("row" + index + rowComponentsArray[i]) == null){
			alert("[row][" + index +  "][" + rowComponentsArray[i] + "]");
		}
		rowComponentsArrayCopy[i] = $("row" + index + rowComponentsArray[i]).selectedIndex;
	}
}

/**
 * Pastes data into a line
 * @param index The index of the line to paste into
 * @return
 */
function pasteLine(index){
	for(var i = 0; i < componentsArray.length; i ++){
		$(index + componentsArray[i]).setValue(componentsArrayCopy[i]);
	}
	for(var i = 0; i < rowComponentsArray.length; i ++){
		$("row" + index + rowComponentsArray[i]).selectedIndex = rowComponentsArrayCopy[i];
	}
}

/**
 * Used when add line is called. Replaces the copy control check box with buttons.
 * Since the add line method does not correct the id, it'll be done here.
 * TODO: Remove id update part then the line add function ids the fields properly
 * @param lineId
 * @return
 */
function enableCopyCtrl(lineId){
	if($(lineId)){
		for(var i = 0; i <= $(lineId).childNodes.length; i ++){
			if($(lineId).childNodes[i] == "[object HTMLTableCellElement]"){
				//iterate table cells
				var currentCell = $(lineId).childNodes[i];
				for(var j = 0; j <= currentCell.childNodes.length; j ++){
					if(currentCell.childNodes[j] == "[object HTMLSelectElement]"
							|| currentCell.childNodes[j] == "[object HTMLInputElement]"){
						if(currentCell.childNodes[j].getAttribute("id").indexOf("FunctionManagementCopyCtrl") > -1){
							//it's the copy control cell
							currentCell.innerHTML = "<span class='copyCtrl' id='" + rowCount + "copy' >" + copyStr + "</span><span class='copyCtrl' id='" + rowCount + "paste' >" + pasteStr + "</span><span style='margin-left: 10px;' id='" + rowCount + "copying'></span>";
							$(rowCount + "copy").setAttribute('onclick', 'copyLine(' + rowCount + ');');
							$(rowCount + "paste").setAttribute('onclick', 'pasteLine(' + rowCount + ');');
						}else{
							//update the ids when it's not a "row" prefix 
							if(currentCell.childNodes[j].getAttribute("id").indexOf("0") == 0){
								currentCell.childNodes[j].setAttribute("id", rowCount + currentCell.childNodes[j].getAttribute("id").substr(1)); 
							}
							debug(currentCell.childNodes[j].getAttribute("id"));
						}
					}
				}
			}
		}
	}else{
		debug("ERROR: " + lineId + " was not found");
	}
	debug("rowCount: " + rowCount);
	++ rowCount;
}

function debug(str){
//	$("debug").innerHTML += str + "<br/>";
}