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

$(function(){
	if($("#0FunctionManagementCopyCtrl")){
		//loop through the first line to build the array of writable fields ids
		var nodes = $("#0FunctionManagementCopyCtrl").parent().parent().children();
		for(var i = 0; i < $("#0FunctionManagementCopyCtrl").parent().parent().children().length; i ++){
			var current = nodes[i];
			if(current == "[object HTMLTableCellElement]"){
				var children = $(current).children();
				for(var j = 0; j < $(current).children().length; j ++){
					if($(children)[j] != "[object Text]" 
							&& $(children)[j] != "[object Comment]" 
							&& $($(children)[j]).attr("type") != "hidden"	
							&& ($($(children)[j]).attr("class") == null
								|| $($(children)[j]).attr("class").indexOf("readonly") == -1)
							&& ($(children)[j].id == null
								|| $(children)[j].id.indexOf("CopyPrevLine") == -1)){
						if($(children)[j].id != null){
							if($(children)[j].id.indexOf("0") == 0){
								componentsArray.push($(children)[j].id.substr(1));
							}else if($(children)[j].id.indexOf("row") == 0){
								debug($(children)[j].id + " --&gt;" + $(children)[j].id.substr(4));
								rowComponentsArray.push($(children)[j].id.substr(4));
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
		while($("#" + rowCount + componentsArray[0]).length > 0){
			++ rowCount;
		}
	}else{
		while($("#row" + rowCount + rowComponentsArray[0]).length > 0){
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
		debug(i);
		$("#" + i + "FunctionManagementCopyCtrl").parent().append("<span class='button' id='" + i + "copy' >" + copyStr + "</span><span class='button' id='" + i + "paste' >" + pasteStr + "</span><span style='margin-left: 10px;' id='" + i + "copying'></span>");
		$("#" + i + "FunctionManagementCopyCtrl").css("display", 'none');
		$("#" + i + "copy").click(function(){
			copyLine(i - 1);
		});
		$("#" + i + "paste").click(function (){
			pasteLine(i - 1);
		});
	}
	
});

/**
 * Copies a line
 * @param index The index of the line to copy
 * @return
 */
function copyLine(index){
	//disabled as this could get confusing
//	for(var i = 0; i < rowCount; i ++){
//		if($(i + "copying")){
//			$(i + "copying").innerHTML = "";
//		}
//	}
	
//	$(index + "copying").innerHTML = copyingStr;
	for(var i = 0; i < componentsArray.length; i ++){
		if($("#" + index + componentsArray[i]).length == 0){
			debug("empty [" + index + "][" + componentsArray[i] + "]");
		}else{
			componentsArrayCopy[i] = $("#" + index + componentsArray[i]).val();
		}
	}
	for(var i = 0; i < rowComponentsArray.length; i ++){
		if($("#row" + index + rowComponentsArray[i]).length == 0){
			debug("empty [row][" + index +  "][" + rowComponentsArray[i] + "]");
		}else{
			rowComponentsArrayCopy[i] = $("#row" + index + rowComponentsArray[i]).val();
		}
	}
	debug("--------");
	debug(componentsArrayCopy);
	debug(rowComponentsArrayCopy);
}

/**
 * Pastes data into a line
 * @param index The index of the line to paste into
 * @return
 */
function pasteLine(index){
	for(var i = 0; i < componentsArray.length; i ++){
		$("#" + index + componentsArray[i]).val(componentsArrayCopy[i]);
	}
	for(var i = 0; i < rowComponentsArray.length; i ++){
		$("#row" + index + rowComponentsArray[i]).val(rowComponentsArrayCopy[i]);
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
	lineId = "#" + lineId;
	if($(lineId)){
		for(var i = 0; i <= $(lineId).children().length; i ++){
			if($(lineId).children()[i] == "[object HTMLTableCellElement]"){
				//iterate table cells
				var currentCell = $(lineId).children()[i];
				for(var j = 0; j <= $(currentCell).children().length; j ++){
					if($(currentCell).children()[j] == "[object HTMLSelectElement]"
							|| $(currentCell).children()[j] == "[object HTMLInputElement]"){
						if($(currentCell).children()[j].id.indexOf("FunctionManagementCopyCtrl") > -1){
							//it's the copy control cell
							$(currentCell).html("<span class='button' id='" + rowCount + "copy' >" + copyStr + "</span><span class='button' id='" + rowCount + "paste' >" + pasteStr + "</span><span style='margin-left: 10px;' id='" + rowCount + "copying'></span>");
							var currentRow = rowCount;
							$("#" + currentRow + "copy").click(function(){
								copyLine(currentRow);
							});
							$("#" + currentRow + "paste").click(function(){
								pasteLine(currentRow);
							});
						}else{
							//update the ids when it's not a "row" prefix 
							if($(currentCell).children()[j].id.indexOf("0") == 0){
								$($(currentCell).children()[j]).attr("id", rowCount + $(currentCell).children()[j].id.substr(1));
							}
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
//	$("#debug").append(str + "<br/>");
}