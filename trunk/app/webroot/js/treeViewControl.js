function set_at_state_in_tree_root(new_at_li, json) {
	
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
	$(scope).find(".reveal.notFetched").each(function(){
		$(this).removeClass("notFetched");
		var json = getJsonFromClass($(this).attr("class"));
		var expandButton = $(this);
		if(json.url != undefined && json.url.length > 0){
			$(this).addClass("fetching");
			var flat_url = json.url.replace(/\//g, "_");
			if(flat_url.trim().length > 0)
			$.get(root_url + json.url, function(data){
				$("body").append("<div id='" + flat_url + "' style='display: none'>" + data + "</div>");
				if($("#" + flat_url).find("ul").length == 1){
					var currentLi = getParentElement(expandButton, "LI");
					$(currentLi).append("<ul style='display: none;'>" + $("#" + flat_url).find("ul").html() + "</ul>");
					initAjaxClass($(currentLi).find("ul"));
					$(expandButton).removeClass("not_allowed").data("new", true).click(function(){
						$(currentLi).find("ul").first().toggle(); 
						if($(this).data("new")){
							$(this).data("new", false);
							initAjaxTreeView($(currentLi).find("ul").first());
						}
					});
				}
				$(expandButton).removeClass("fetching");
				$("#" + flat_url).remove();
			});
		}
	});
}

function activateNodeExpandButton(scope){
	$(scope).find(".reveal:not(.not_allowed)").each(function(){
		var cssClass = $(this).attr("class");
		if(cssClass.indexOf("{") > -1){
			var json = getJsonFromClass(cssClass);
			$(this).toggle(function(){
				$("#tree_" + json.tree).stop(true, true);
				$("#tree_" + json.tree).show("blind", {}, 350);
			}, function(){
				$("#tree_" + json.tree).stop(true, true);
				$("#tree_" + json.tree).hide("blind", {}, 350);
			});
		}
	});
}
