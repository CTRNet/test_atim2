<?php
	$structure_links = array(
		'index'=>array(
			'detail'=>'/ClinicalAnnotation/ClinicalCollectionLinks/detail/'.$atim_menu_variables['Participant.id'].'/%%Collection.id%%/',
			'collection' => array(
				'link' => '/InventoryManagement/collections/detail/%%Collection.id%%/',
				'icon' => 'collection'
			)
		),
		'bottom'=>array(
			'add'=>'/ClinicalAnnotation/ClinicalCollectionLinks/add/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links, 'override' => $structure_override, 'settings' => array('pagination' => false));
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>