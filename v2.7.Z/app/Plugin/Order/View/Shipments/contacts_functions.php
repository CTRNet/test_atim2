<script>

function successFunction(data) {
    var domNodes = document.createElement('div');
    if ($(data)[$(data).length - 1].id === "ajaxSqlLog") {
        var ajaxSqlLog = {'sqlLog': [$(data.substring(data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
        data = data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
        saveSqlLogAjax(ajaxSqlLog);
    }

    $(domNodes).html(data);

    $(domNodes).find("a[href*='limit:'], a[href*='page:'], a[href*='sort:']").each(function () {
        if ($(this).prop('href').indexOf('javascript:') == -1)  {
            $(this).attr("data-href", $(this).prop('href'));
            $(this).prop('href', 'javascript:void(0)');
        }
    });

    $("#manageContactPopup").find("table").first().html($(domNodes).children("table"));
    $("#manageContactPopup").find("div").first().find("a.detail").click(function () {
        var row = $(this).parents("tr:first");
        var cells = $(row).find("td");
        if (cells.length > 7) {
            var clean = function (str) {
                str = str.trim();
                return str == "-" ? "" : str;
            };

            var fields = ['recipient', 'delivery_phone_number', 'facility', 'delivery_department_or_door', 'delivery_street_address', 'delivery_city', 'delivery_province', 'delivery_postal_code', 'delivery_country'];
            for (i in fields) {
                $("input[name=data\\[Shipment\\]\\[" + fields[i] + "\\]]").val(clean($(cells[parseInt(i) + 1]).children().eq(0).html()));
            }
            $("textarea[name=data\\[Shipment\\]\\[delivery_notes\\]]").html(clean($(cells[fields.length + 1]).children().eq(0).html().replace(/<br(\/)?>/g, "\n")));
        }
        $("#manageContactPopup").popup('close');
    });
    container = $("#manageContactPopup").find("div").closest('.popup_container').eq(0);
    container.css({"top": $(window).height() / 2 - container.height() / 2 + "px"})

    $("#manageContactPopup a.cancel").closest("div.bottom_button").click(function () {
        $("#manageContactPopup").popup('close');
        $("#manageContactPopup").remove();
        manageContacts();
    });

}

function doSearchContact() {
        var data = $("#manageContactPopup form").serialize();
        $("#manageContactPopup").find("div").first().html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
        $("#manageContactPopup").popup('center');
        $.post(root_url + "Order/Shipments/manageContact/-2", data, function (data) {
            var ajaxSqlLog = {'sqlLog': [$(data.substring(data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
            saveSqlLogAjax(ajaxSqlLog);
            data = data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
            $("#manageContactPopup").find("div").first().html(data);
            $("#manageContactPopup").popup('center');

            $("#manageContactPopup").find("div").first().find("a.detail").click(function () {
                var row = $(this).parents("tr:first");
                var cells = $(row).find("td");
                if (cells.length > 7) {
                    var clean = function (str) {
                        str = str.trim();
                        return str == "-" ? "" : str;
                    };

                    var fields = ['recipient', 'delivery_phone_number', 'facility', 'delivery_department_or_door', 'delivery_street_address', 'delivery_city', 'delivery_province', 'delivery_postal_code', 'delivery_country'];
                    for (i in fields) {
                        $("input[name=data\\[Shipment\\]\\[" + fields[i] + "\\]]").val(clean($(cells[parseInt(i) + 1]).children().eq(0).html()));
                    }
                    $("textarea[name=data\\[Shipment\\]\\[delivery_notes\\]]").html(clean($(cells[fields.length + 1]).children().eq(0).html().replace(/<br(\/)?>/g, "\n")));
                }
                $("#manageContactPopup").popup('close');
            });

            $("#manageContactPopup").find("a[href*='limit:'], a[href*='page:'], a[href*='sort:']").each(function () {
                if ($(this).prop('href').indexOf('javascript:') == -1)  {
                    $(this).attr("data-href", $(this).prop('href'));
                    $(this).prop('href', 'javascript:void(0)');
                }
            });

            $("#manageContactPopup a.cancel").closest("div.bottom_button").click(function () {
                $("#manageContactPopup").popup('close');
                $("#manageContactPopup").remove();
                manageContacts();
            });


            $("#manageContactPopup").delegate("a[data-href]", 'click', function () {
                var url = $(this).attr("data-href");
                if (url.indexOf('javascript:')==-1){
                    $.ajax({
                        type: "GET",
                        url: url + "/noActions:/",
                        cache: false,
                        success: successFunction
                    });
                }
            });

            flyOverComponents();
        });

        return false;

    }

function searchContactsForm() {
        $.get(root_url + "Order/Shipments/manageContact/", function (data) {
            if ($(data)[$(data).length - 1].id === "ajaxSqlLog") {
                var ajaxSqlLog = {'sqlLog': [$(data.substring(data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                data = data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                saveSqlLogAjax(ajaxSqlLog);
            }
            var isVisible = $("#manageContactPopup:visible").length == 1;
            $("#manageContactPopup").popup('close');
            $("#manageContactPopup").find("div").first().html(data);

            globalInit($("#manageContactPopup"));

            container = $("#manageContactPopup").find("div").closest('.popup_container').eq(0);
            // fix issue #3685: Manage recipients : Issue linked to the icon to close the contact information pop-up
            container.css({"max-height": $(window).height()});

            $("#manageContactPopup a.cancel").closest("div.bottom_button").click(function () {
                $("#manageContactPopup").popup('close');
            });

            if (isVisible) {
                $("#manageContactPopup").popup();
            }

            $("#manageContactPopup input.submit").on('click', doSearchContact);
        });

    }

function manageContacts() {
        if ($("#manageContactPopup").length == 0) {
            buildDialog("manageContactPopup", null, null, null);
            $("#manageContactPopup").find("div").first().html("<div class='loading'>--- " + STR_LOADING + " ---</div>");

            searchContactsForm();

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
        var searchResult = $("#manageContactPopup").find("div").first().html();
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