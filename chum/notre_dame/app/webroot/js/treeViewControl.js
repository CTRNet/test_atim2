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
