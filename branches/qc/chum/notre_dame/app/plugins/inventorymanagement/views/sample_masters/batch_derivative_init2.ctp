<?php
	$extras = '<input type="hidden" name="data[SampleMaster][ids]" value="'.$sample_master_ids.'"/>
				<input type="hidden" name="data[SampleMaster][sample_control_id]" value="'.$sample_master_control_id.'"/>
				<input type="hidden" name="data[ParentToDerivativeSampleControl][parent_sample_control_id]" value="'.$parent_sample_control_id.'"/>
				<input type="hidden" name="data[url_to_cancel]" value="'.$url_to_cancel.'"/>';
	
	$final_atim_structure = $atim_structure;
	$final_options = array(
		'type' => 'add', 
		'settings' => array('header' => __('derivative creation process', true) . ' - ' . __('lab book selection', true)),
		'links' => array(
			'top' => '/inventorymanagement/sample_masters/batchDerivative/',
			'bottom' => array(
				'add lab book (pop-up)' => '/labbook/lab_book_masters/add/1/1/',
				'cancel' => $url_to_cancel
				)
			), 
		'extras' => $extras);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if($hook_link){
		require($hook_link); 
	}

	// BUILD FORM
	$structures->build($final_atim_structure, $final_options);	
?>

<script>
var labBookPopup = true;
</script>