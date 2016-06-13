<?php 
	$structure_links = array(
		'top'=>'/Order/OrderItems/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderItem.id'],
		'bottom'=>array('cancel'=>$url_to_cancel)
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'links'=>$structure_links,
		'override'=>$structure_override, 
		'settings'=>array('header' => __('order item')), 
		'extras' => '<input type="hidden" name="data[url_to_cancel]" value="'.$url_to_cancel.'"/>');

	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );

?>
