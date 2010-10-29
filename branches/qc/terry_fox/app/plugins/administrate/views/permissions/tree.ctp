<?php
	// ATiM tree
	
	$structures_override = array(
		'Aco.state'	=>	array(
			''	=> 'Inherit',
			'1'	=> 'Allow',
			'-1'	=> 'Deny'
		)
	);
	
	$structure_links = array(
		'top'	=> '/administrate/permissions/tree/'.join('/',array_filter($atim_menu_variables))
		
		// 'index' => array(
		// 	'detail permission' => '/administrate/permissions/tree/',
		// 	'delete permission' => '/administrate/permissions/tree/'
		// )
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
			'override'	=> $structures_override,
			
			'settings'	=> array (
				'tree'	=> array(
					'Aco'	=> 'Aco'
				),
				'header' => array ('title' => __('permissions control panel', true), 'description' => $description)
			)
		) 
	);
	
?>