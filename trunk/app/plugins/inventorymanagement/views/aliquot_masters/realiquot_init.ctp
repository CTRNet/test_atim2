<?php
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'add', 
		'settings' => array('header' => __('realiquoting process', true) . ' - ' . __('aliquot type selection', true)),
		'links' => array(
			'top' => '/inventorymanagement/aliquot_masters/realiquotInit2/'.$process_type.'/'.$aliquot_id,
			'bottom' => array('cancel' => $url_to_cancel)),
		'extras' => '<input type="hidden" name="data[sample_ctrl_id]" value="'.$sample_ctrl_id.'"/>
			<input type="hidden" name="data[realiquot_from]" value="'.$realiquot_from.'"/>
			<input type="hidden" name="data[url_to_cancel]" value="'.$url_to_cancel.'"/>'
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if($hook_link){
		require($hook_link); 
	}

	// BUILD FORM
	$structures->build($final_atim_structure, $final_options);			
		
?>