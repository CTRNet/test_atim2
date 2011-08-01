<?php
	// ATiM tree
	
	
	$structure_links = array(
		'top'	=> '/administrate/permissions/tree/'.join('/',array_filter($atim_menu_variables)),
		'bottom' => array(
			__('load preset', true) => array('link' => 'javascript:loadPreset();', 'icon' => 'detail'),
			__('save as preset', true) => array('link' => 'javascript:savePresetPopup();', 'icon' => 'submit')
		)
	);
	$description = __("you can find help about permissions %s", true);
	$description = sprintf($description, $help_url);
	
	$structures->build($permissions2, array("type" => "edit", "data" => $group_data, 'links' => $structure_links, "settings" => array("form_bottom" => false, 'actions' => false, 'header' => array ('title' => __('permissions control panel', true), 'description' => $description))));
	
	$structures->build( 
		array("Aco" => $atim_structure),
		array(
			'data'		=> $this->data,
			'type'		=> 'tree', 
			'links'		=> $structure_links, 
			
			'settings'	=> array (
				'form_top' => false,
				'tree'	=> array(
					'Aco'	=> 'Aco'
				)
			)
		) 
	);
?>
<script>
	var treeView = true;
	function loadPreset(){
		if($("#loadPresetPopup").length == 0){
			buildDialog("loadPresetPopup", null, null, null);
			$("#loadPresetPopup").find("div").first().html("<div class='loading'>--- loading ---</div>");
			$.get(root_url + "administrate/permissions/loadPreset/", null, function(data){
				var isVisible = $("#loadPresetPopup:visible").length;
				$("#loadPresetPopup").find("div").first().html(data);
				if(isVisible){
					$("#loadPresetPopup:visible").popup();
				}
			});
			/*buildDialog(
				"loadPresetPopup", 
				"select a preset to load",
				"<?php echo str_replace("\n", "\\n", addslashes($this->Form->input("selectPreset", array('type' => 'select', 'id' => 'selectPreset', 'label' => false, 'options' => array('' => '', 'reset' => __('reset', true), 'readonly' => __('readonly', true)))))); ?>", 
				new Array(
					{label : "<?php __('load'); ?>", action: function(){ applyPreset(); $("#loadPresetPopup").popup('close'); return false; }, icon: "detail"},
					{label : "<?php __('cancel'); ?>", action: function(){ $("#loadPresetPopup").popup('close'); return false; }, icon: "cancel"}
				)
			);*/
		}
		$("#loadPresetPopup").popup();
	}

	function savePresetPopup(){
		if($("#savePresetPopup").length == 0){
			buildDialog("savePresetPopup", null, null, null);
			$("#savePresetPopup").find("div").first().html("<div class='loading'>--- loading ---</div>");
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
			console.log(data);
			if(data == 200){
				$("#savePresetPopup").popup('close');
				$("#savePresetPopup").remove();
				$("#loadPresetPopup").remove();
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
				console.log(data.allow[i]);
				$("#tree_root").find("select[name=data\\[" + data.allow[i] + "\\]\\[Aco\\]\\[state\\]]").val(1);
			}
			for(var i in data.deny){
				$("#tree_root").find("select[name=data\\[" + data.deny[i] + "\\]\\[Aco\\]\\[state\\]]").val(-1);
			}
		}
		$("#loadPresetPopup").popup('close');
	}
</script>