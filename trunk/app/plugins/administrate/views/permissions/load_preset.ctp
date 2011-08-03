<?php
$structures->build($atim_structure, array(
	'type' => 'index', 
	'data' => array(
		array('PermissionsPreset' => array('name' => __('readonly', true), 'description' => __('atim_preset_readonly', true), 'link' => 'javascript:applyPreset("readonly");')),
		array('PermissionsPreset' => array('name' => __('reset', true), 'description' => __('atim_preset_reset', true), 'link' => 'javascript:applyPreset("reset");'))),
	'links' => array('index' => array('detail' => '%%PermissionsPreset.link%%')), 
	'settings' => array(
		'header' => __('atim presets', true), 
		'pagination' => false,
		'actions' => false,
		'form_bottom' => false)
	)
);

$can_delete = $structures->checkLinkPermission($this->data[0]['PermissionPreset']['delete']);

$structures->build($atim_structure, array(
	'type' => 'index', 
	'data' => $this->data, 
	'links' => array(
		'index' => array('detail' => '%%PermissionsPreset.link%%', 'delete' => $can_delete ? '%%PermissionsPreset.delete%%' : '/underdev/'),
		'bottom' => array(
			__('save preset', true) => array('link' => 'javascript:savePresetPopup();', 'icon' => 'submit')
		)
	), 
	'settings' => array(
		'header' => __('saved presets', true), 
		'pagination' => false)
	)
	//TODO: validate the delete link and the save link before using them
);
?>
<script>
initDeleteConfirm();
function deletePreset(id){
	$("#deleteConfirmPopup").popup('close');
	$("#frame").html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
	$.post(root_url + "administrate/permissions/deletePreset/" + id, "", function(data){
		$.get(root_url + "administrate/permissions/loadPreset/", null, function(data){
			$("#frame").html(data);
		});
	});
}

function applyPreset(data){
	if(data == "reset"){
		//built-in reset
		$("#tree_root").find("select").val("");
		$("#tree_root").find("select").first().val(1);
	}else if(data == "readonly"){
		//built-in readonly
		$("#tree_root").find("select").each(function(){
			var selectElement = this;
			$($(this).parent().parent().children()[2]).each(function(){
				var html = $(this).html();
				if(html.indexOf("add") > -1
					|| html.indexOf("edit") > -1
					|| html.indexOf("delete") > -1
					|| html.indexOf("define") > -1
					|| html.indexOf("realiquot") > -1
					|| html.indexOf("remove") > -1
					|| html.indexOf("save") > -1
					|| html.indexOf("batch") > -1
				){
					$(selectElement).val(-1);
				}else{
					$(selectElement).val("");
				}
			});
		});
		$("#tree_root").find("select").first().val(1);
	}else{
		//acos ids operations
		data = $.parseJSON(data);
		data.allow = data.allow.split(",");
		data.deny = data.deny.split(",");

		$("#tree_root").find("select").val("");
		for(var i in data.allow){
			$("#tree_root").find("select[name=data\\[" + data.allow[i] + "\\]\\[Aco\\]\\[state\\]]").val(1);
		}
		for(var i in data.deny){
			$("#tree_root").find("select[name=data\\[" + data.deny[i] + "\\]\\[Aco\\]\\[state\\]]").val(-1);
		}
	}
	$("#loadPresetPopup").popup('close');
}

function savePresetPopup(){
	if($("#savePresetPopup").length == 0){
		buildDialog("savePresetPopup", null, null, null);
		$("#savePresetPopup").find("div").first().html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
		$.get(root_url + "administrate/permissions/savePreset/", null, function(data){
			var isOpened = $("#savePresetPopup:visible").length; 
			$("#savePresetPopup").popup('close');
			$("#savePresetPopup").find("div").first().html(data);
			if(isOpened){
				$("#savePresetPopup").popup();
			}
		});
	}

	$("#savePresetPopup").popup();
}

function savePreset(){
	$("#tree_root").find("a.submit").hide();
	var allow = new Array();
	var deny = new Array();
	$("#tree_root").find("select").each(function(){
		if($(this).val() == 1){
			allow.push($(this).attr("name").match("[0-9]+")[0]);
		}else if($(this).val() == -1){
			deny.push($(this).attr("name").match("[0-9]+")[0]);
		}
	});
	$("#savePresetPopup").find("form").append(
		"<input name='data[0][allow]' type='hidden' value='" + allow.join(",") + "'/>" +
		"<input name='data[0][deny]' type='hidden' value='" + deny.join(",") + "'/>"
	);
	$.post(root_url + "administrate/permissions/savePreset/", $("#savePresetPopup").find("form").serialize(), function(data){
		if(data == 200){
			$("#savePresetPopup").popup('close');
			$("#savePresetPopup").remove();
			loadPresetFrame();
		}else{
			var isVisible = $("#savePresetPopup:visible").length;
			$("#savePresetPopup").popup('close');
			$("#savePresetPopup").find("div").first().html(data);
			if(isVisible){
				$("#savePresetPopup").popup();
			}
		}
	});
}
</script>