var orgAction = null;
function initBrowser(){
	orgAction = $("form").attr("action");

	if($("#search_for").length == 1){ 
		$("#submit_button").click(function(){
			return validateSubmit();
		});
	}

	$('#hierarchy').addClass("jquery_cupertino").advMenu({
		content: $('#hierarchy').next().html(),
		backLink: false,
		flyOut: true,
		callback: function(item){
			var json = getJsonFromClass($(item).attr("class"));
			if(json != null){
				if(json.value.length > 0){
					$('#hierarchy').find(".label").html(json.label);
					$('#search_for').val(json.value);
					$("form").attr("action", typeof(json.action) != 'undefined' ? json.action : orgAction + json.value);
				}
			}
		}
	});

	if($("#BrowserSearchFor").length == 1){
		var parent = $("#BrowserSearchFor").parent();
		$("#BrowserSearchFor").remove();
		parent.append($("#hierarchy")).append($("#search_for"));
		getParentElement($("#hierarchy"), "TD").css("width", "100%");
	}
}

function validateSubmit(){
	var errors = new Array();
	if($("#search_for").val() == ""){
		errors.push(errorYouMustSelectAnAction);
	}
	if($(":checkbox").length > 0 && $(":checkbox[checked=true]").length == 0){
		errors.push(errorYouNeedToSelectAtLeastOneItem);
	}
	
	if(errors.length > 0){
		alert(errors.join("\n"));
		return false;
	}
	
	return true;
}