<?php
if(isset($this->request->data[0]['parent']['AliquotMaster'])){
	$child_structure_to_use = empty($this->request->data[0]['parent']['AliquotControl']['volume_unit']) ? $sourcealiquots : $aliquots_volume_structure;
	//hack structures to add aliquot data
	//start with parent
	foreach($sample_info['Sfs'] as &$sfs){
		$sfs['display_column'] -= 10;
	}
	
	//updating parent language headings
	foreach($sample_info['Sfs'] as &$sfs){
		if($sfs['flag_edit']){
			$sfs['language_heading'] = 'parent sample';
			break;
		}
	}
	foreach($child_structure_to_use['Sfs'] as &$sfs){
		if($sfs['flag_edit']){
			$sfs['language_heading'] = 'aliquot source (for update)';
			break;
		}
	}
	
	//merging parent structures		
	if(is_array(current($child_structure_to_use['Structure']))){
		//volume structure
		$sample_info['Structure'] = array_merge(array($sample_info['Structure']), $child_structure_to_use['Structure']);
		$derivative_structure = $derivative_volume_structure;
	}else{
		$sample_info['Structure'] = array($sample_info['Structure'], $child_structure_to_use['Structure']);
	}
	$sample_info['Sfs'] = array_merge($sample_info['Sfs'], $child_structure_to_use['Sfs']);
}

//structure options
$options = array(
		"links"		=> array(
			"top" => '/InventoryManagement/SampleMasters/batchDerivative/'.$aliquot_master_id,
			'bottom' => array('cancel' => $url_to_cancel)
		));

$options_parent = array_merge($options, array(
	"type" => "edit",
	"settings" 	=> array("actions" => false, "form_top" => false, "form_bottom" => false, "stretch" => false, 'section_start' => true)));

$options_children = array_merge($options, array(
	"type" => "addgrid",
	"settings" 	=> array("add_fields" => true, "del_fields" => true, "actions" => false, "form_top" => false, "form_bottom" => false, 'language_heading' => __('derivatives'), 'section_end' => true),
	"override"	=> $created_sample_override_data,
	"dropdown_options" => array('DerivativeDetail.lab_book_master_id' => (isset($lab_books_list) && (!empty($lab_books_list)))? $lab_books_list: array('' => ''))));

$dropdown_options = array(
	'SampleMaster.parent_id' => (isset($parent_sample_data_for_display) && (!empty($parent_sample_data_for_display)))? $parent_sample_data_for_display: array('' => ''),
	'DerivativeDetail.lab_book_master_id' => (isset($lab_books_list) && (!empty($lab_books_list)))? $lab_books_list: array('' => ''));

$hook_link = $this->Structures->hook();
if( $hook_link ) { 
	require($hook_link); 
}

$hook_link = $this->Structures->hook('loop');

$first = true;
$counter = 0;

$one_parent = (sizeof($this->request->data) == 1)? true : false;

//print the layout
while($data = array_shift($this->request->data)){
	$counter++;
	$parent = $data['parent'];
	$final_options_parent = $options_parent;
	$final_options_children = $options_children;
	if($first){
		$final_options_parent['settings']['form_top'] = true;
		$first = false;
	}
	if(count($this->request->data) == 0){
		$final_options_children['settings']['form_bottom'] = true;
		$final_options_children['settings']['actions'] = true;
		$final_options_children['settings']['confirmation_msg'] = __('multi_entry_form_confirmation_msg');
		$final_options_children['extras'] = 
			'
			<input type="hidden" name="data[SampleMaster][sample_control_id]" value="'.$children_sample_control_id.'"/>
			<input type="hidden" name="data[DerivativeDetail][lab_book_master_code]" value="'.$lab_book_master_code.'"/>
			<input type="hidden" name="data[DerivativeDetail][sync_with_lab_book]" value="'.$sync_with_lab_book.'"/>
			<input type="hidden" name="data[ParentToDerivativeSampleControl][parent_sample_control_id]" value="'.$parent_sample_control_id.'"/>
			<input type="hidden" name="data[url_to_cancel]" value="'.$url_to_cancel.'"/>
			<input type="hidden" name="data[sample_master_ids]" value="'.$sample_master_ids.'"/>';
	}
	$prefix = isset($parent['AliquotMaster']) ? $parent['AliquotMaster']['id'] : $parent['ViewSample']['sample_master_id'];
	$final_options_parent['settings']['header'] = __('derivative creation process') . ' - ' . __('creation') .($one_parent? '' : " #".$counter);
	$final_options_parent['settings']['name_prefix'] = $prefix;
	$final_options_parent['data'] = $parent;
	
	$final_options_children['settings']['name_prefix'] = $prefix;
	$final_options_children['data'] = $data['children'];
	$final_options_children['dropdown_options']['SampleMaster.parent_id'] = array($parent['ViewSample']['sample_master_id'] => $parent['ViewSample']['sample_code']);
	$final_options_children['override']['SampleMaster.parent_id'] = $parent['ViewSample']['sample_master_id'];
	if(isset($parent['AliquotMaster']) && !empty($parent['AliquotControl']['volume_unit'])){
		$final_options_children['override']['AliquotControl.volume_unit'] = $parent['AliquotControl']['volume_unit'];
	}
	
	if( $hook_link ) { 
		require($hook_link); 
	}
	
	$this->Structures->build($sample_info, $final_options_parent);
	$this->Structures->build($derivative_structure, $final_options_children);
	
}
?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
var labBookFields = new Array("<?php echo is_array($lab_book_fields) ? implode('", "', $lab_book_fields) : ""; ?>");
var labBookHideOnLoad = true;
</script>
