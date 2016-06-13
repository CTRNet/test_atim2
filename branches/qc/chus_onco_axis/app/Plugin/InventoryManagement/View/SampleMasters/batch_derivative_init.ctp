<?php

	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'add', 
		'settings' => array('header' => __('derivative creation process') . ' - ' . __('derivative type selection'), 'stretch' => false),
		'links' => array(
			'top' => ($skip_lab_book_selection_step ? '/InventoryManagement/SampleMasters/batchDerivative/'.$aliquot_master_id : '/InventoryManagement/SampleMasters/batchDerivativeInit2/'.$aliquot_master_id),
			'bottom' => array('cancel' => $url_to_cancel)),
		'extras' => '<input type="hidden" name="data[SampleMaster][ids]" value="'.$ids.'"/>
					<input type="hidden" name="data[AliquotMaster][ids]" value="'.(isset($aliquot_ids) ? $aliquot_ids : "").'"/>
					<input type="hidden" name="data[ParentToDerivativeSampleControl][parent_sample_control_id]" value="'.$parent_sample_control_id.'"/>
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