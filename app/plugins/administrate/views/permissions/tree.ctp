<?php
	// ATiM tree
	
	
	$structure_links = array(
		'top'	=> '/administrate/permissions/tree/'.join('/',array_filter($atim_menu_variables)),
	);
	$description = __("you can find help about permissions %s", true);
	$description = sprintf($description, $help_url);
	
	$structure_extras = array();
	$structure_extras[10] = '<div id="frame"></div>';
	
	$structures->build($permissions2, array("type" => "edit", "data" => $group_data, 'links' => $structure_links, "settings" => array("form_bottom" => false, 'actions' => false, 'header' => array ('title' => __('permissions control panel', true), 'description' => $description))));
	
	$structures->build( 
		array("Aco" => $atim_structure),
		array(
			'data'		=> $this->data,
			'type'		=> 'tree', 
			'links'		=> $structure_links, 
			'extras' => $structure_extras,
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
	var permissionPreset = <?php echo AppController::checkLinkPermission('/administrate/permissions/loadPreset/') ? "true" : "false" ?>;

	function loadPresetFrame(){
		$("#frame").html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
		$.get(root_url + "administrate/permissions/loadPreset/", null, function(data){
			$("#frame").html(data);
		});
	}
	/*function loadPreset(){
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
		}
		$("#loadPresetPopup").popup();
	}
*/
	

	
</script>