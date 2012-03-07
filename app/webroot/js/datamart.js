var orgAction = null;
var removeConfirmed = false;

function initDatamartActions(){
	if(!window.errorYouMustSelectAnAction){
		window.errorYouMustSelectAnAction = "js untranslated errorYouMustSelectAnAction";	
	}
	if(!window.errorYouNeedToSelectAtLeastOneItem){
		window.errorYouNeedToSelectAtLeastOneItem = "js untranslated errorYouNeedToSelectAtLeastOneItem";	
	}

	orgAction = $("form").prop("action");

	if($("#search_for").length == 1){ 
		$(".form.submit").unbind('click').prop("onclick", "").click(function(){
			if(validateSubmit()){
				$("form").submit();
			}
			return false;
		});
	}

	$('#hierarchy').addClass("jquery_cupertino").advMenu({
		content: $('#hierarchy').next().html(),
		backLink: false,
		flyOut: true,
		directionV: 'down',
		callback: function(item){
			var json = getJsonFromClass($(item).prop("class"));
			if(json != null){
				if(json.value.length > 0){
					$('#hierarchy').find(".label").html(json.label);
					$('#search_for').val(json.value);
					$("form").prop("action", typeof(json.action) != 'undefined' ? json.action : orgAction + json.value);
				}
			}
		}
	});
	
	var selectToReplace = null;
	$("select").each(function(){
		if($(this).prop("name") == "data[Browser][search_for]"){
			selectToReplace = this;
			return;
		}
	});
	if(selectToReplace != null){
		var parent = $(selectToReplace).parent();
		$(selectToReplace).remove();
		parent.append($("#hierarchy")).append($("#search_for"));
		getParentElement($("#hierarchy"), "TD").css("width", "100%");
	}
	
	//popup to confirm removal (batchset)
	$(".button.confirm").click(function(){
		removeConfirmed = true;
		$("#popup").popup('close');
		$("form").submit();
	});
	$(".button.close").click(function(){
		$("#popup").popup('close');
	});
}
function validateSubmit(){
	var errors = new Array();
	if($("#search_for").val() == ""){
		errors.push(errorYouMustSelectAnAction);
	}
	if($(":checkbox").length > 0 && $(":checkbox[checked=true]").length == 0){
		errors.push(errorYouNeedToSelectAtLeastOneItem);
	}else if($("form").prop("action").indexOf("remove") != -1 && !removeConfirmed){
		//popup do you wish do remove
		$("#popup").popup();
		return false;
	}
	
	if(errors.length > 0){
		alert(errors.join("\n"));
		return false;
	}
	
	return true;
}