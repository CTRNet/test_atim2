function initDropdownConfig(){
	$("input[type=radio]").each(function(){
		$(this).parent().append("<input type='hidden' name='data[0][option_id][]' value='" + $(this).val() + "'/>");
		$(this).remove();
	});
	
	var checkboxId = "alphabetical";
	var dragNDropTable = $("form tbody table");
	var disableDradNDropTable = function(event){
		event.stopPropagation();
		return false;
	};
	
	$("form tfoot").append("<tr><td colspan=5 style='padding-top: 20px;'>" + alphabeticalOrderingStr + "<input type='checkbox' name='data[0][default_order] value='1' id='" + checkboxId + "' " + (alphaOrderChecked ? "checked" : "") + "/></td></tr>");
	
	function refreshDisplay(){
		if($("#" + checkboxId).attr("checked")){
			$(dragNDropTable).find("tbody tr").removeClass("draggableRow").css("cursor", "default");
			$(dragNDropTable).find("tbody td").mousedown(disableDradNDropTable);
		}else{
			$(dragNDropTable).find("tbody tr").addClass("draggableRow").css("cursor", "move");
			$(dragNDropTable).find("tbody td").unbind('mousedown', disableDradNDropTable);
		}
	}
	
	$("#" + checkboxId).click(refreshDisplay);
	
	$(dragNDropTable).find("thead tr, tfoot tr").addClass("nodrop nodrag");
	$(dragNDropTable).tableDnD({
	    onDragClass: "draggedRow"
	});
	
	refreshDisplay();
}