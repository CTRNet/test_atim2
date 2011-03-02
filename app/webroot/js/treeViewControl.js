function set_at_state_in_tree_root(new_at_li, json){
	if(!window.loadingStr){
		window.loadingStr = "js untranslated loading";	
	}
	var tree_root = document.getElementById("tree_root");
	var tree_root_lis = tree_root.getElementsByTagName("li");
	for (var i=0; i<tree_root_lis.length; i++) {
		tree_root_lis[i].className = null;
	}
	$li = getParentElement(new_at_li, "LI");
	$($li).addClass("at");
	$("#frame").html("<div class='loading'>---" + loadingStr + "---</div>");
	$.get($(this).attr("href"), {}, function(data){
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
		var json = getJsonFromClass($(this).attr("class"));
		var expandButton = $(this);
		if(json.url != undefined && json.url.length > 0){
			$(this).addClass("fetching");
			var flat_url = json.url.replace(/\//g, "_");
			if(flat_url.length > 0){
				$.get(root_url + json.url, function(data){
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
				});
			}
		}
	});
}

function initTreeView(scope){
	$("a.reveal.activate").each(function(){
		var matchingUl = $(this).parent().find("ul").first();
		$(this).click(function(){
			$(matchingUl).stop().toggle("blind");
		});
	});
}
