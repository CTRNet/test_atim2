<script>
function manageContacts(){
	if($("#manageContactPopup").length == 0){
		buildDialog("manageContactPopup", null, null, null);
		$("#manageContactPopup").find("div").first().html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
		$.get(root_url + "Order/Shipments/manageContact/", function(data){
			var isVisible = $("#manageContactPopup:visible").length == 1;
			$("#manageContactPopup").popup('close');
			$("#manageContactPopup").find("div").first().html(data);
			$("#manageContactPopup").find("div").first().find("a.detail").click(function(){
				var row = $(this).parents("tr:first");
				var cells = $(row).find("td");
				if(cells.length > 7){
					var clean = function(str){
						return str == "- " ? "" : str;
					};
					$("input[name=data\\[Shipment\\]\\[recipient\\]]").val(clean($(cells[1]).html()));
					$("input[name=data\\[Shipment\\]\\[facility\\]]").val(clean($(cells[2]).html()));
					$("input[name=data\\[Shipment\\]\\[delivery_street_address\\]]").val(clean($(cells[3]).html()));
					$("input[name=data\\[Shipment\\]\\[delivery_city\\]]").val(clean($(cells[4]).html()));
					$("input[name=data\\[Shipment\\]\\[delivery_province\\]]").val(clean($(cells[5]).html()));
					$("input[name=data\\[Shipment\\]\\[delivery_postal_code\\]]").val(clean($(cells[6]).html()));
					$("input[name=data\\[Shipment\\]\\[delivery_country\\]]").val(clean($(cells[7]).html()));
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
	$.get(root_url + "Order/Shipments/deleteContact/" + id, function(){
		var isVisible = $("#manageContactPopup:visible").length == 1;
		$("#manageContactPopup").popup('close');
		$("#manageContactPopup").remove();
		if(isVisible){
			manageContacts();
		}
	});
}
</script>