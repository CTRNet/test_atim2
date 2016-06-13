<?php
	$extras = '<input type="hidden" name="data[SampleMaster][ids]" value="'.$sample_master_ids.'"/>
				<input type="hidden" name="data[AliquotMaster][ids]" value="'.(isset($aliquot_master_ids) ? $aliquot_master_ids : "").'"/>
				<input type="hidden" name="data[SampleMaster][sample_control_id]" value="'.$sample_master_control_id.'"/>
				<input type="hidden" name="data[ParentToDerivativeSampleControl][parent_sample_control_id]" value="'.$parent_sample_control_id.'"/>
				<input type="hidden" name="data[url_to_cancel]" value="'.$url_to_cancel.'"/>';
	
	$bottom = array();
	if(isset($lab_book_control_id)) $bottom['add lab book (pop-up)'] = '/labbook/LabBookMasters/add/'.$lab_book_control_id.'/1/';
	$bottom['cancel'] = $url_to_cancel;
	
	$final_atim_structure = $atim_structure;
	$final_options = array(
		'type' => 'add', 
		'settings' => array('header' => __('derivative creation process') . ' - ' . __('lab book selection')),
		'links' => array(
			'top' => '/InventoryManagement/SampleMasters/batchDerivative/'.$aliquot_master_id,
			'bottom' => $bottom
		), 
		'extras' => $extras);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if($hook_link){
		require($hook_link); 
	}

	// BUILD FORM
	$this->Structures->build($final_atim_structure, $final_options);	
?>

<script>
var labBookPopup = true;
</script>