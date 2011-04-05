/**
 * Initialises the search options for clinical annotation add view
 */
function initCcl(){
	var popupLoaded = false;
	var popupSearch = function(){
		//postData = participant collection + serialized form
		var postData = "data%5BViewCollection%5D%5Bcollection_property%5D=participant+collection&" + $("#popup form").serialize(); 
		$.post(root_url + "/inventorymanagement/collections/search/true", postData, function(data){
			$("#collection_frame").html(data);
			$("#collection_loading").hide();
		});
		if(popupLoaded){
			$("#popup").popup('close');
		}
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
				initDatepicker("#popup .datepicker");
				initAdvancedControls("#popup");
				$("#popup form").submit(popupSearch);
				$("#popup .form.search").unbind('click').attr("onclick", null).click(popupSearch);
				$("#popup").popup();
				popupLoaded = true;
			});
		}
	});
	
	//Init the collections with an empty search
	popupSearch();
}

