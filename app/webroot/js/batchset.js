function initBatchSetFormAction(){
	setBatchSetFormAction($("#BatchSetProcess").val());
	$("#BatchSetProcess").change(function(){
		setBatchSetFormAction($(this).val());
	});
}

function setBatchSetFormAction(action){
	if(action.length == 0){
		$("#submit_button").unbind('click');
		$("#submit_button").click(function(){
			alert(batchSetFormActionMsg);
			return false;
		});
	}else{
		action = root_url + action;
		$("#submit_button").unbind('click');
		$("#submit_button").click(function(){
			if($("input:checked").length == 0){
				alert(batchSetFormActionMsg);
				return false;
			}
		});
	}
	$("form").attr("action", action);
}
