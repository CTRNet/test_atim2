<?php

	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'add', 
		'settings' => array('header' => __('aliquot creation batch process') . ' - ' . __('aliquot type selection'), 'stretch' => false),
		'links' => array(
			'top' => '/InventoryManagement/AliquotMasters/add/',
			'bottom' => array('cancel' => $url_to_cancel)),
		'extras' => '
			<input type="hidden" name="data[0][ids]" value="'.$ids.'"/>
			<input type="hidden" name="data[url_to_cancel]" value="'.$url_to_cancel.'"/>'
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if($hook_link){
		require($hook_link); 
	}

	// BUILD FORM
	$this->Structures->build($final_atim_structure, $final_options);			

?>