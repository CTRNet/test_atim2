<?php
	$extras = '<input type="hidden" name="data[SampleMaster][ids]" value="'.$sample_master_ids.'"/>
				<input type="hidden" name="data[SampleMaster][sample_control_id]" value="'.$sample_master_control_id.'"/>
				<input type="hidden" name="data[ParentToDerivativeSampleControl][parent_sample_control_id]" value="'.$parent_sample_control_id.'"/>';
	$structures->build($atim_structure, array(
		'type' => 'add', 
		'links' => array(
			'top' => '/inventorymanagement/sample_masters/batchDerivative/',
			'bottom' => array(
				'add lab book (pop-up)' => '/labbook/lab_book_masters/add/1/1/'
				)
			), 
		'extras' => $extras));
?>

<script>
var labBookPopup = true;
</script>