<?php 
	$structure_links = array(
		'top'=>'/Sop/SopMasters/edit/'.$atim_menu_variables['SopMaster.id'].'/',
		'bottom'=>array(
			'cancel'=>'/Sop/SopMasters/detail/%%SopMaster.id%%/'
		)
	);
	
	$final_atim_structure = $atim_structure;
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	$this->Structures->build( $final_atim_structure,  $final_options);
