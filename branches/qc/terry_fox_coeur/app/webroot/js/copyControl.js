/**
 * Script to copy the fields from one line to another. The readonly fields are not copied
 */

var copyBuffer = new Object();

function initCopyControl(){
	//create buttons and bind onclick command
	enableCopyCtrl();
	
	var pasteAllButton = '<span class="button paste pasteAll"><a class="form paste" title="' + STR_PASTE_ON_ALL_LINES + '" href="#no">' + STR_PASTE_ON_ALL_LINES + '</a></span>';
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
	$(line).find("input:not([type=hidden], .pasteDisabled), select:not(.pasteDisabled), textarea:not(.pasteDisabled)").each(function(){
		var nameArray = $(this).attr("name").split("][");
		var name = nameArray[nameArray.length - 2] + "][" + nameArray[nameArray.length - 1];
		if($(this).attr("type") == "checkbox"){
			copyBuffer[name] = $(this).attr("checked");
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
				if(copyBuffer[name] != undefined){
					$(this).attr("checked", copyBuffer[name]);
				}
			}else if(copyBuffer[name] != undefined){
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
	$(":hidden").each(function(){
		if($(this).attr("name") != undefined && $(this).attr("name").indexOf("][FunctionManagement][CopyCtrl]") > 5){
			$(this).parent().append("<span class='button copy'><a class='form copy' title='" + STR_COPY + "'></a></span><span class='button paste'><a class='form paste' title='" + STR_PASTE + "'></a></span>");
			bindCopyCtrl($(this).parent());
			$(this).remove();
		}
	});
}

function bindCopyCtrl(scope){
	$(scope).find(".button.copy").click(function(){
		copyLine(getParentRow(this));
	});
	$(scope).find(".button.paste").click(function(event){
		pasteLine(getParentRow(this));
	});
}

function debug(str){
	//$("#debug").append(str + "<br/>");
}