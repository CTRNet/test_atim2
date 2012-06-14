<?php
	// ATiM tree
	
	
	$structure_links = array(
		'top'	=> '/Administrate/Permissions/tree/'.join('/',array_filter($atim_menu_variables)),
	);
	$description = __("you can find help about permissions %s");
	$description = sprintf($description, $help_url);
	
	$structure_extras = array();
	$structure_extras[10] = '<div id="frame"></div>';
	
	$this->Structures->build($permissions2, array("type" => "edit", "data" => $group_data, 'links' => $structure_links, "settings" => array("form_bottom" => false, 'actions' => false, 'header' => array ('title' => __('permissions control panel'), 'description' => $description))));
	
	$this->Structures->build( 
		array("Aco" => $atim_structure),
		array(
			'data'		=> $this->request->data,
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
	var permissionPreset = <?php echo AppController::checkLinkPermission('/Administrate/permissions/loadPreset/') ? "true" : "false" ?>;

	function loadPresetFrame(){
		$("#frame").html("<div class='loading'>--- " + STR_LOADING + " ---</div>");
		$.get(root_url + "Administrate/Permissions/loadPreset/", null, function(data){
			$("#frame").html(data);
		});
	}
</script>