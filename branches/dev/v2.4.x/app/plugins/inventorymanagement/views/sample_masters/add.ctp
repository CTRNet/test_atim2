<?php
	if($is_ajax){
		ob_start();
	}

	$structure_links = array(
		'top' => '/inventorymanagement/sample_masters/add/'. $atim_menu_variables['Collection.id'] . '/' . $sample_control_data['SampleControl']['id'] . '/' . $parent_sample_master_id
	);
	
	if($is_ajax){
		$structure_links['top'] .= '/1';
	}else{
		$structure_links['bottom'] = array('cancel' => '/inventorymanagement/sample_masters/contentTreeView/'.$atim_menu_variables['Collection.id']); 
	}
	
	$sample_parent_id = (isset($parent_sample_data_for_display) && (!empty($parent_sample_data_for_display)))? $parent_sample_data_for_display: array('' => '');
	$structure_override = $is_specimen ? array() : array('SampleMaster.parent_id' => key($sample_parent_id));
	$dropdown_options = array(
		'SampleMaster.parent_id' => $sample_parent_id,
		'DerivativeDetail.lab_book_master_id' => (isset($lab_books_list) && (!empty($lab_books_list)))? $lab_books_list: array('' => ''));
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'override' => $structure_override, 'dropdown_options' => $dropdown_options);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if($hook_link){
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build($final_atim_structure, $final_options);		
?>
<script>
var labBookFields = new Array("<?php echo implode('", "', $lab_book_fields); ?>");
</script>

<?php 
if($is_ajax){
	$display = $shell->validationErrors().ob_get_contents();
	ob_end_clean();
	$shell->validationErrors = null;
	echo json_encode(array('goToNext' => false, 'display' => $display, 'id' => null));
}