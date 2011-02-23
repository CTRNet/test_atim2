<?php
	// ATiM tree
	
	
	$structure_links = array(
		'top'	=> '/administrate/permissions/tree/'.join('/',array_filter($atim_menu_variables))
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