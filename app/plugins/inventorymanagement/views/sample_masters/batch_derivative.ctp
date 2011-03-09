<?php
	
	$options = array(
			"links"		=> array(
				"top" => '/inventorymanagement/sample_masters/batchDerivative/',
//				'bottom' => array('cancel' => $url_to_cancel)
			));

	$options_parent = array_merge($options, array(
		"type" => "edit",
		"settings" 	=> array("actions" => false, "form_top" => false, "form_bottom" => false, "stretch" => false)));
	
	$options_children = array_merge($options, array(
		"type" => "addgrid",
		"settings" 	=> array("add_fields" => true, "del_fields" => true, "actions" => false, "form_top" => false, "form_bottom" => false),
		"override"	=> $created_sample_override_data,
		"dropdown_options" => array('DerivativeDetail.lab_book_master_id' => (isset($lab_books_list) && (!empty($lab_books_list)))? $lab_books_list: array('' => ''))));
	
	$dropdown_options = array(
		'SampleMaster.parent_id' => (isset($parent_sample_data_for_display) && (!empty($parent_sample_data_for_display)))? $parent_sample_data_for_display: array('' => ''),
		'DerivativeDetail.lab_book_master_id' => (isset($lab_books_list) && (!empty($lab_books_list)))? $lab_books_list: array('' => ''));
	
		
	$first = true;
	$counter = 0;
	while($data = array_shift($this->data)){
		$counter++;
		$parent = $data['parent'];
		$final_options_parent = $options_parent;
		$final_options_children = $options_children;
		if($first){
			$final_options_parent['settings']['form_top'] = true;
			$first = false;
		}
		if(count($this->data) == 0){
			$final_options_children['settings']['form_bottom'] = true;
			$final_options_children['settings']['actions'] = true;
			$final_options_children['extras'] = 
				'<input type="hidden" name="data[SampleMaster][sample_control_id]" value="'.$children_sample_control_id.'"/>
				<input type="hidden" name="data[DerivativeDetail][lab_book_master_code]" value="'.$lab_book_master_code.'"/>
				<input type="hidden" name="data[DerivativeDetail][sync_with_lab_book]" value="'.$sync_with_lab_book.'"/>
				<input type="hidden" name="data[ParentToDerivativeSampleControl][parent_sample_control_id]" value="'.$parent_sample_control_id.'"/>';
				
		}
		$final_options_parent['settings']['header'] = __('derivative creation process', true) . ' - ' . __('creation', true) ." #".$counter;
		$final_options_parent['settings']['name_prefix'] = $parent['ViewSample']['sample_master_id'];
		$final_options_parent['data'] = $parent;
		
		$final_options_children['settings']['name_prefix'] = $parent['ViewSample']['sample_master_id'];
		$final_options_children['data'] = $data['children'];
		$final_options_children['dropdown_options']['SampleMaster.parent_id'] = array($parent['ViewSample']['sample_master_id'] => $parent['ViewSample']['sample_code']);
				
		$structures->build($sample_info, $final_options_parent);
		$structures->build($atim_structure, $final_options_children);
	}
?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
var labBookFields = new Array("<?php echo implode('", "', $lab_book_fields); ?>");
var labBookHideOnLoad = true;
</script>
