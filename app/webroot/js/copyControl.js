/**
 * Script to copy the fields from one line to another. The readonly fields are not copied
 * Only tested with /order/order_items/edit/
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
							&& current.childNodes[j].getAttribute("id").indexOf("CopyPrevLine") == -1){
						if(current.childNodes[j].getAttribute("id").indexOf("0") == 0){
							componentsArray.push(current.childNodes[j].getAttribute("id").substr(1));
						}else{
							rowComponentsArray.push(current.childNodes[j].getAttribute("id").substr(4));
						}
					}
				}
			}
		}
	}
	
	
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
	
	//bind onclick command and refresh lines
	for(var i = 0; i < rowCount; i ++){
		$(i + "FunctionManagementCopyCtrl").parentNode.innerHTML += "<input type='button' id='" + i + "copy' value='" + copyStr + "'/><input type='button' id='" + i + "paste' value='" + pasteStr + "'/><span style='margin-left: 10px;' id='" + i + "copying'></span>";
		$(i + "FunctionManagementCopyCtrl").setStyle({ display: 'none'});
		$(i + "copy").setAttribute('onclick', 'copyLine(' + i + ');');
		$(i + "paste").setAttribute('onclick', 'pasteLine(' + i + ');');
	}
	
};

function copyLine(index){
	for(var i = 0; i < rowCount; i ++){
		$(i + "copying").innerHTML = "";
	}
	
	$(index + "copying").innerHTML = copyingStr;

	for(var i = 0; i < componentsArray.length; i ++){
		componentsArrayCopy[i] = $F(index + componentsArray[i]);
	}
	for(var i = 0; i < rowComponentsArray.length; i ++){
		rowComponentsArrayCopy[i] = $("row" + index + rowComponentsArray[i]).selectedIndex;
	}
}

function pasteLine(index){
	for(var i = 0; i < componentsArray.length; i ++){
		$(index + componentsArray[i]).setValue(componentsArrayCopy[i]);
	}
	for(var i = 0; i < rowComponentsArray.length; i ++){
		$("row" + index + rowComponentsArray[i]).selectedIndex = rowComponentsArrayCopy[i];
	}
}

function debug(str){
//	$("debug").innerHTML += str + "<br/>";
}