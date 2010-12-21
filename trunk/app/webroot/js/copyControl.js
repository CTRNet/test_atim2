/**
 * Script to copy the fields from one line to another. The readonly fields are not copied
 */

var copyBuffer = new Object();

function initCopyControl(){
	if(!window.copyStr){
		window.copyStr = "js untranslated copy";	
	}
	if(!window.pasteStr){
		window.pasteStr = "js untranslated paste";	
	}
	if(!window.copyingStr){
		window.copyingStr = "js untranslated copying";	
	}
	if(!window.pasteOnAllLinesStr){
		window.pasteOnAllLinesStr = "js unstranslated pasteOnAllLines";
	}
	
	//create buttons and bind onclick command
	enableCopyCtrl();
	
	var pasteAllButton = '<span class="button paste pasteAll"><a class="form paste" title="' + window.pasteOnAllLinesStr + '" href="#no">' + window.pasteOnAllLinesStr + '</a></span>';
	if($(".copy").length > 0){
		//add copy all button into a new tfoot
		$(".copy").each(function(){
			var table = getParentElement($(this), "TABLE");
			if(!$(table).data("copyAllLinesEnabled")){
				var tableWidth = $(table).first("tr").find("th").length;
				$(table).append("<tfoot><tr><td colspan='" + tableWidth + "' align='right'>" + pasteAllButton + "</td></tr></tfoot>");
				$(table).data("copyAllLinesEnabled", true);
			}
		});
	}
	$(".pasteAll").click(function(){
		var table = getParentElement(this, "TABLE");
		$(table).find("tbody tr").each(function(){
			pasteLine(this);
		});
		return false;
	});
	
}

/**
 * Copies a line
 * @param line The line to read from
 * @return
 */
function copyLine(line){
	copyBuffer = new Object();
	$(line).find("input:not([type=hidden]), select, textarea").each(function(){
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
	$(line).find("input:not([type=hidden]), select, textarea").each(function(){
		if(!$(this).attr("readonly") && !$(this).attr("disabled")){
			var nameArray = $(this).attr("name").split("][");
			var name = nameArray[nameArray.length - 2] + "][" + nameArray[nameArray.length - 1];
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
			$(this).parent().append("<span class='button copy'><a class='form copy' title='" + copyStr + "'></a></span><span class='button paste'><a class='form paste' title='" + pasteStr + "'></a></span>");
			bindCopyCtrl($(this).parent());
			$(this).remove();
		}
	});
}

function bindCopyCtrl(scope){
	$(scope).find(".copy").click(function(){
		copyLine(getParentRow(this));
	});
	$(scope).find(".paste").click(function(){
		pasteLine(getParentRow(this));
	});
}

function debug(str){
	//$("#debug").append(str + "<br/>");
}