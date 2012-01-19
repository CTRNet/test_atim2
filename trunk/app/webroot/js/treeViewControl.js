function set_at_state_in_tree_root(new_at_li, json){
	if(!window.loadingStr){
		window.loadingStr = "js untranslated loading";	
	}
	$(".tree_root").find("div.treeArrow").hide();
	$(".tree_root").find("div.rightPart").removeClass("at");
	$li = getParentElement(new_at_li, "LI");
	$($li).find("div.rightPart:first").addClass("at");
	$($li).find("div.treeArrow:first").show();
	$("#frame").html("<div class='loading'>---" + loadingStr + "---</div>");
	$.get($(this).prop("href") + "?t=" + new Date().getTime(), {}, function(data){
		$("#frame").html(data);
		initActions();
	});
}

/**
 * When a node is displayed for the first time, updates it's children
 * @param scope - The scope to init on
 */
function initAjaxTreeView(scope){
	$(scope).find(".reveal.notFetched").click(function(){
		$(this).removeClass("notFetched").unbind('click');
		var json = $(this).data("json");
		var expandButton = $(this);
		if(json.url != undefined && json.url.length > 0){
			$(this).addClass("fetching");
			var flat_url = json.url.replace(/\//g, "_");
			if(flat_url.length > 0){
				$.get(root_url + json.url + "?t=" + new Date().getTime(), function(data){
					$("body").append("<div id='" + flat_url + "' style='display: none'>" + data + "</div>");
					if($("#" + flat_url).find("ul").length == 1){
						var currentLi = getParentElement(expandButton, "LI");
						$(currentLi).append("<ul>" + $("#" + flat_url).find("ul").html() + "</ul>");
						initAjaxClass($(currentLi).find("ul"));
						initAjaxTreeView(currentLi);
						$(expandButton).click(function(){
							$(currentLi).find("ul").first().stop().toggle("blind");
						});
					}
					$(expandButton).removeClass("fetching");
					$("#" + flat_url).remove();
					
					if(window.initTree){
						initTree($(currentLi));
					}
				});
			}
		}
	});
}

function initTreeView(scope){
	$("a.reveal.activate").each(function(){
		var matchingUl = getParentElement($(this), "LI"); 
		matchingUl	= $(matchingUl).children().filter("ul").first();
		$(this).click(function(){
			$(matchingUl).stop().toggle("blind");
		});
	});
	
	var element = $(scope).find(".tree_root input[type=radio]:checked");
	if(element.length == 1){
		var lis = $(element).parents("li");
		lis[0] = null;
		$(lis).find("a.reveal.activate:first").click();
	}
}
