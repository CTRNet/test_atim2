var removeConfirmed = false;

function initBatchSetControls(){
	setBatchSetFormAction($("#batchsetProcess").val());
	$("#batchsetProcess").change(function(){
		setBatchSetFormAction($(this).val());
	});
	
	//popup to confirm removal
	$(".button.confirm").click(function(){
		removeConfirmed = true;
		$("#popup").popup('close');
		$("#submit_button").click();
	});
	$(".button.close").click(function(){
		$("#popup").popup('close');
	});
}

function setBatchSetFormAction(action){
	if(action.length == 0){
		$("#submit_button").unbind('click');
		$("#submit_button").click(function(){
			//msg select an option for the process batch set field
			alert(batchSetFormActionMsgSelectAnOption);
			return false;
		});
	}else{
		action = root_url + action;
		$("#submit_button").unbind('click');
		$("#submit_button").click(function(){
			if($("input:checked").length == 0){
				//msg you need to check at least an item
				alert(batchSetFormActionMsgSelectAtLeast);
				return false;
			}else if($("#batchsetProcess").val().indexOf("remove") != -1 && !removeConfirmed){
				//popup do you wish do remove
				$("#popup").popup();
				return false;
			}
		});
	}
	$("form").attr("action", action);
}
