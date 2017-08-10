<?php 
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/Protocol/ProtocolExtendMasters/detail/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtendMaster.id%%/',
			'edit'=>'/Protocol/ProtocolExtendMasters/edit/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtendMaster.id%%/',
			'delete'=>'/Protocol/ProtocolExtendMasters/delete/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtendMaster.id%%/'
		),
		'bottom'=>array('add' => '/Protocol/ProtocolExtendMasters/add/'.$atim_menu_variables['ProtocolMaster.id'])
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'index', 'links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>
