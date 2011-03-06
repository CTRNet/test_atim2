<?php

	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'add', 
		'settings' => array('header' => __('derivative creation process', true) . ' - ' . __('selection', true)),
		'dropdown_options' => array('SampleMaster.sample_control_id' => (isset($derivatives_dropdown) && (!empty($derivatives_dropdown)))? $derivatives_dropdown: array('' => '')),
		'links' => array(
			'top' => '/inventorymanagement/sample_masters/batchDerivativeInit',
			'bottom' => array('cancel' => $url_to_cancel)),
		'extras' => '<input type="hidden" name="data[SampleMaster][ids]" value="'.$ids.'"/>
					<input type="hidden" name="data[SampleMaster][parent_sample_control_id]" value="'.$parent_sample_control_id.'"/>'	
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if($hook_link){
		require($hook_link); 
	}

	// BUILD FORM
	$structures->build($final_atim_structure, $final_options);			

?>