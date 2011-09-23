/**
 * Initializes the search options for clinical annotation add view
 */
function initCcl(){
	var popupLoaded = false;
	var popupSearch = function(){
		//postData = participant collection + serialized form
		var postData = $("#popup form").serialize() + "&data%5BViewCollection%5D%5Bcollection_property%5D=participant+collection"; 
		$.post(root_url + "/inventorymanagement/collections/search/-1/true", postData, function(data){
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

	$("#collection_new").prop("checked", true);
	$("#collection_search").click(function(){
		$("#collection_search").prop("checked", false);
		$("#collection_new").prop("checked", true);
		if(popupLoaded){
			$("#popup").popup();
		}else{
			$.get(root_url + "/inventorymanagement/collections/search/0/true?t=" + new Date().getTime(), null, function(data){
				$("#popup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>");
				initDatepicker("#popup");
				initAdvancedControls("#popup");
				$("#popup form").submit(popupSearch);
				$("#popup .form.search").unbind('click').prop("onclick", null).click(popupSearch);
				$("#popup").popup();
				popupLoaded = true;
			});
		}
	});
	
	//Init the collections with an empty search
	popupSearch();
}

