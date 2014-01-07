<?php 
	$structure_links = array(
		'top'=>'/Sop/SopMasters/add/'.$atim_menu_variables['SopControl.id'].'/',
		'bottom'=>array(
			'cancel'=>'/Sop/SopMasters/listall/'
		)
	);
	
	$final_atim_structure = $atim_structure;
	$final_options = array('links'=>$structure_links, 'settings' => array('header' => $sop_control_data['sop_group'].' - '.$sop_control_data['type']));
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	$this->Structures->build( $final_atim_structure,  $final_options);
	
?>