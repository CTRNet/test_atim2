<?php

	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'add', 
		'settings' => array('header' => __('aliquot creation batch process', true) . ' - ' . __('selection', true)),
		'links' => array(
			'top' => '/inventorymanagement/aliquot_masters/add/',
			'bottom' => array('cancel' => $url_to_cancel)),
		'extras' => '<input type="hidden" name="data[0][ids]" value="'.$ids.'"/>'
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if($hook_link){
		require($hook_link); 
	}

	// BUILD FORM
	$structures->build($final_atim_structure, $final_options);			

?>