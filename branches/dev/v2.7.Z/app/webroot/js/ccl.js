/**
 * Initializes the search options for clinical annotation add view
 */
function initCcl(){
	var popupLoaded = false;
	var popupSearch = function(){
		//postData = participant collection + serialized form
		var postData = $("#popup form").serialize() + "&data%5BViewCollection%5D%5Bcollection_property%5D=participant+collection";
		$.post(root_url + "InventoryManagement/collections/search/-1/true", postData, function(data){
                    if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                        var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                        data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                        saveSqlLogAjax(ajaxSqlLog);
                    }
			var json = $("#collection_new").data("json");
			$("#collection_frame").html(data);
			if(json.id){
				$("input[type=radio][name=data\\\[Collection\\\]\\[id\\\]][value=" + json.id +"]").attr("checked", "checked");
			}
			$(".loading").hide();
		});
		if(popupLoaded){
			$("#popup").popup('close');
		}
		$(".loading").show();
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
			$.get(root_url + "InventoryManagement/collections/search/0/true?t=" + new Date().getTime(), null, function(data){
                            if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                                var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                                data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                                saveSqlLogAjax(ajaxSqlLog);
                            }
				$("#popup").html("<div class='wrapper'><div class='frame'>" + data + "</div></div>");
				initDatepicker("#popup");
				initAdvancedControls("#popup");
				$("#popup form").submit(popupSearch);
				$("#popup a.submit").unbind('click').prop("onclick", null).click(popupSearch);
				$("#popup").popup();
				popupLoaded = true;
			});
		}
		
		return false;
	});
	
	//Init the collections with an empty search
	popupSearch();
}

