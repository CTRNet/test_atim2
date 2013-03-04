<?php 
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/Protocol/ProtocolExtends/detail/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtend.id%%/'
		),
		'bottom'=>array('add' => '/Protocol/ProtocolExtends/add/'.$atim_menu_variables['ProtocolMaster.id'])
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
