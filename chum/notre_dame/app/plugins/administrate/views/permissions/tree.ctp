<?php
	// ATiM tree
	
	
	$structure_links = array(
		'top'	=> '/administrate/permissions/tree/'.join('/',array_filter($atim_menu_variables))
	);
	$description = __("you can find help about permissions %s", true);
	$description = sprintf($description, $help_url);
	$structures->build( 
		array(
			'Aco'=>$atim_structure
		),
		
		array(
			'type'		=> 'tree', 
			'links'		=> $structure_links, 
			
			'settings'	=> array (
				'tree'	=> array(
					'Aco'	=> 'Aco'
				),
				'header' => array ('title' => __('permissions control panel', true), 'description' => $description)
			)
		) 
	);
	
?>