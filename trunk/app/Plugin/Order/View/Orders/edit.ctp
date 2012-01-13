<?php 
	$structure_links = array(
		'top'=>'/Order/orders/edit/' . $atim_menu_variables['Order.id'],
		'bottom'=>array('cancel'=>'/Order/orders/detail/' . $atim_menu_variables['Order.id'])
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
?>