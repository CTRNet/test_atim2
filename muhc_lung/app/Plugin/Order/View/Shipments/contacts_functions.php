<script>
function manageContacts(){
	if($("#manageContactPopup").length == 0){
		buildDialog("manageContactPopup", null, null, null);
		$("#manageContactPopup").find("div").first().html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
		$.get(root_url + "Order/Shipments/manageContact/", function(data){
            if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                saveSqlLogAjax(ajaxSqlLog);
            }                    

			var isVisible = $("#manageContactPopup:visible").length == 1;
			$("#manageContactPopup").popup('close');
			$("#manageContactPopup").find("div").first().html(data);
			$("#manageContactPopup").find("div").first().find("a.detail").click(function(){
				var row = $(this).parents("tr:first");
				var cells = $(row).find("td");
				if(cells.length > 7){
					var clean = function(str){
                                            str = str.trim();
						return str == "-" ? "" : str;
					};

					var fields = ['recipient', 'delivery_phone_number', 'facility', 'delivery_department_or_door', 'delivery_street_address', 'delivery_city', 'delivery_province', 'delivery_postal_code', 'delivery_country'];
					for(i in fields){
						//console.log(i + " - " + fields[i]);
						//console.log($("input[name=data\\[Shipment\\]\\[" + fields[i] + "\\]]"));
						$("input[name=data\\[Shipment\\]\\[" + fields[i] + "\\]]").val(clean($(cells[parseInt(i) + 1]).children().eq(0).html()));
					}
					$("textarea[name=data\\[Shipment\\]\\[delivery_notes\\]]").html(clean($(cells[fields.length + 1]).children().eq(0).html().replace(/<br(\/)?>/g, "\n")));
				}
				$("#manageContactPopup").popup('close');
			});
			if(isVisible){
				$("#manageContactPopup").popup();
			}
		});
	}
	$("#manageContactPopup").popup();
}

function saveContact(){
	buildDialog("saveContactPopup", null, null, null);
	$("#saveContactPopup").find("div").first().html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
	$("#saveContactPopup").popup();
	$.post(root_url + "Order/Shipments/saveContact/", $("form").serialize(), function(data){
            if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                saveSqlLogAjax(ajaxSqlLog);
            }                    

		var isVisible = $("#saveContactPopup:visible").length == 1;
		$("#saveContactPopup").popup('close');
		buildDialog("saveContactPopup", data, null, new Array({ "label" : STR_OK, "icon" : "detail", "action" : function(){$('#saveContactPopup').popup('close');} }));
		if(isVisible){
			$("#saveContactPopup").popup();
		}
		$("#manageContactPopup").remove();
	});
}

function deleteContact(id){
	$("#deleteConfirmPopup").popup('close');
	$("div.popup_outer:not(:visible)").remove();
	$("#manageContactPopup").popup('close');
	$("#manageContactPopup").find("div").first().html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
	$("#manageContactPopup").popup();
	$.get(root_url + "Order/Shipments/deleteContact/" + id, function(data){
            if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                saveSqlLogAjax(ajaxSqlLog);
            }                    

		var isVisible = $("#manageContactPopup:visible").length == 1;
		$("#manageContactPopup").popup('close');
		$("#manageContactPopup").remove();
		if(isVisible){
			manageContacts();
		}
	});
}
</script>