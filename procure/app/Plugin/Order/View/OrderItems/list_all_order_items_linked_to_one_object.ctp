<?php 

	$structure_links = array();
	
	$structure_links['index'] = array(
		'details' => array('link' => '/Order/Orders/detail/%%OrderItem.order_id%%/', 'icon' => 'detail')
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type'=>'index',
		'links'=>$structure_links,
		'override'=>$structure_override
	);
	 
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>
