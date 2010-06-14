/**
 * Script to copy the fields from one line to another. The readonly fields are not copied
 */

var copyBuffer = new Object();

$(function(){
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
	
	//create buttons and bind onclick command
	enableCopyCtrl();
});

/**
 * Copies a line
 * @param line The line to read from
 * @return
 */
function copyLine(line){
	copyBuffer = new Object();
	$(line).find("input:not([type=hidden]), select").each(function(){
		var nameArray = $(this).attr("name").split("][");
		var name = nameArray[nameArray.length - 2] + "][" + nameArray[nameArray.length - 1];
		debug($(this).attr("name") + " - " + name + "- " + $(this).attr("type") + " - " + $(this).val());
		if($(this).attr("type") == "checkbox"){
			if($(this).attr("checked")){
				copyBuffer[name] = true;
			}
		}else{
			copyBuffer[name] = $(this).val();
		}
	});
}

/**
 * Pastes data into a line
 * @param line The line to paste into
 * @return
 */
function pasteLine(line){
	$(line).find("input:not([type=hidden]), select").each(function(){
		var nameArray = $(this).attr("name").split("][");
		var name = nameArray[nameArray.length - 2] + "][" + nameArray[nameArray.length - 1];
		if(!$(this).attr("readonly")){
			if($(this).attr("type") == "checkbox"){
				if(copyBuffer[name]){
					$(this).attr("checked", "checked");
				}
			}else if(copyBuffer[name]){
				$(this).val(copyBuffer[name]);
			}
		}
	});
}

/**
 * Finds all checbox with ][FunctionManagement][CopyCtrl] in their name and 
 * replaces them with copy controls
 */
function enableCopyCtrl(){
	$(":checkbox").each(function(){
		if($(this).attr("name").indexOf("][FunctionManagement][CopyCtrl]") > 5){
			$(this).parent().append("<span class='button copy'>" + copyStr + "</span><span class='button paste'>" + pasteStr + "</span>");
			$(this).parent().find(".copy").click(function(){
				copyLine(getParentRow(this));
			});
			$(this).parent().find(".paste").click(function(){
				pasteLine(getParentRow(this));
			});
			$(this).remove();
		}
	});
}

function debug(str){
//	$("#debug").append(str + "<br/>");
}