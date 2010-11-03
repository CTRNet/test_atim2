/**
 * Initialises the search options for clinical annotation add view
 */
function initCcl(){
	var popupLoaded = false;
	var popupSearch = function(){
		$.post(root_url + "/inventorymanagement/collections/search/true", $("#popup form").serialize(), function(data){
			$("#collection_frame").html(data);
			$("#collection_loading").hide();
		});
		$("#popup").popup('close');
		$("#collection_loading").show();
		$("#collection_frame").html("");
		return false;
	};
	
	$("#collection_new").attr("checked", true);
	$("#collection_search").click(function(){
		$("#collection_search").attr("checked", false);
		$("#collection_new").attr("checked", true);
		if(popupLoaded){
			$("#popup").popup();
		}else{
			$.get(root_url + "/inventorymanagement/collections/index/true", null, function(data){
				$("#popup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>");
				$("#popup .datepicker").each(function(){
					initDatepicker(this);
				});
				initAdvancedControls("#popup");
				$("#popup form").submit(popupSearch);
				$("#popup form").append("" +
						"<input type='hidden' name='data[ViewCollection][collection_property]' value='participant collection'/>" +
						"<input type='hidden' name='data[ViewCollection][participant_id]' value='2'/>");
				$("#popup .form.search").unbind('click').attr("onclick", null).click(popupSearch);
				$("#popup").popup();
				popupLoaded = true;
			});
		}
	});
	
	//Init the collections with an empty search
	popupSearch();
}

