/**
 * Script to copy the fields from one line to another. The readonly fields are not copied
 */

var copyBuffer = new Object();

function initCopyControl(){
	//create buttons and bind onclick command
	enableCopyCtrl();
	
	var pasteAllButton = '<span class="button paste pasteAll"><a class="paste" title="' + STR_PASTE_ON_ALL_LINES + '" href="#no"><span class="icon16 paste"></span>' + STR_PASTE_ON_ALL_LINES + '</a></span>';
	if($(".copy").length > 0){
		//add copy all button into a new tfoot
		$(".copy").each(function(){
			var table = $(this).parents("table:first");
			if(!$(table).data("copyAllLinesEnabled")){
				var tableWidth = $(table).first("tr").find("th").length;
				$(table).append("<tfoot><tr><td colspan='" + tableWidth + "' align='right'>" + pasteAllButton + "</td></tr></tfoot>");
				$(table).data("copyAllLinesEnabled", true);
			}
		});
	}
	$(".pasteAll").click(function(){
		var table = $(this).parents("table:first");
		$(table).find("tbody tr").each(function(){
			pasteLine(this);
		});
		return false;
	});
	
	if($(".pasteAll").length > 1){
		$("div.section:last").after('<div style="text-align: right;"><span id="pasteAllOfAll" class="button paste"><a class="paste" title="' + STR_PASTE_ON_ALL_LINES + '" href="#no"><span class="icon16 paste"></span>' + STR_PASTE_ON_ALL_LINES_OF_ALL_SECTIONS + '</a></span></div>');
		$("#pasteAllOfAll").click(function(){
			$("table.columns.index tbody tr").each(function(){
				if($(this).find("input.addLineCount").length == 0){
					pasteLine(this);
				}
			});
			return false;
		});
	}
	
}

/**
 * Copies a line
 * @param line The line to read from
 * @return
 */
function copyLine(line){
        $(line).closest("table").find("*").removeClass("copy-cell");

	copyBuffer = new Object();
	$(line).find("input:not([type=hidden], .pasteDisabled), select:not(.pasteDisabled), textarea:not(.pasteDisabled), input.accuracy").each(function(){
                $(this).closest("td").addClass("copy-cell");

		var nameArray = $(this).prop("name").split("][");
		var name = nameArray[nameArray.length - 2] + "][" + nameArray[nameArray.length - 1];
                if($(this).prop("type") == "checkbox"){
			name += $(this).val();
			copyBuffer[name] = $(this).prop("checked");
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
        $(line).closest("table").find("*").removeClass("copy-cell");
    
	$(line).find("input:not([type=hidden], .pasteDisabled), select:not(.pasteDisabled), textarea:not(.pasteDisabled), input.accuracy").each(function(){

		if(!$(this).prop("readonly") && !$(this).prop("disabled")){
                    $(this).closest("td").addClass("paste-cell");
			var nameArray = $(this).prop("name").split("][");
			var name = nameArray[nameArray.length - 2] + "][" + nameArray[nameArray.length - 1];
                        if($(this).prop("type") == "checkbox"){
				name += $(this).val(); 
				if(copyBuffer[name] != undefined){
                                        var oldValue = $(this).prop("checked");
					$(this).prop("checked", copyBuffer[name]);
                                        if (oldValue !=copyBuffer[name]){
                                            $(this).trigger("change");
                                        }
				}
			}else if(copyBuffer[name] != undefined){
                                var oldValue = $(this).val();
				$(this).val(copyBuffer[name]);
                                if (oldValue !=copyBuffer[name]){
                                    $(this).trigger("change", "autoTriger");
                                }
                                
			}
			
			if(name.indexOf("][month]") != -1){
				var accuracyName = name.substr(0, name.length - 6) + "year_accuracy]";
				if((copyBuffer[accuracyName] != undefined && $(this).is(":visible"))
					|| (copyBuffer[accuracyName] == undefined && !$(this).is(":visible"))
				){
					var cell = $(this).parents("td:first");
					$(cell).find(".accuracy_target_blue").click();
				}
			}
		}
	});

        var $tds = $(line).find("td.paste-cell");
        setTimeout(function(){
            $tds.removeClass("paste-cell");
            $tds.addClass("paste-cell-fade-out");
        }, 3000);
        
        
}

/**
 * Finds all checbox with ][FunctionManagement][CopyCtrl] in their name and 
 * replaces them with copy controls
 */
function enableCopyCtrl(){
	//$(":hidden")
	$("input[type='hidden']").each(function(){
		if($(this).prop("name") != undefined && $(this).prop("name").indexOf("][FunctionManagement][CopyCtrl]") > 5){
			$(this).parent().append("<span class='button copy'><a class='icon16 copy' title='" + STR_COPY + "'></a></span><span class='button paste'><a class='icon16 paste' title='" + STR_PASTE + "'></a></span>");
			bindCopyCtrl($(this).parent());
			$(this).remove();
		}
	});
}

function bindCopyCtrl(scope){
	$(scope).find(".button.copy").click(function(){
		copyLine($(this).parents("tr:first"));
	});
	$(scope).find(".button.paste").click(function(event){
		pasteLine($(this).parents("tr:first"));
	});
}

function debug(str){
	//$("#debug").append(str + "<br/>");
}