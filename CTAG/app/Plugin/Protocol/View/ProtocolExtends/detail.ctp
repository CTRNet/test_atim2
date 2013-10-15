<?php 

	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Protocol/ProtocolExtends/edit/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtend.id%%/',
			'delete'=>'/Protocol/ProtocolExtends/delete/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtend.id%%/'
		)
	);
	
	$structure_settings = array('header' => __('precision'));

	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'settings' => $structure_settings);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>