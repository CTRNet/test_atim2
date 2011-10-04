<?php 
	$first = true;
	$options = array(
			"links"		=> array(
				"top" => "/inventorymanagement/aliquot_masters/realiquot/".$aliquot_id,
				'bottom' => array('cancel' => $url_to_cancel))
	);
	
	$options_parent = array_merge($options, array(
		"type" => "edit",
		"settings" 	=> array("actions" => false, "form_top" => false, "form_bottom" => false, "stretch" => false)
	));
	$options_children = array_merge($options, array(
		"type" => "addgrid",
		"settings" 	=> array("add_fields" => true, "del_fields" => true, "actions" => false, "form_top" => false, "form_bottom" => false, "language_heading" => __('created children aliquot(s)', true))
	));
	
	foreach($in_stock_detail['Sfs'] as &$sfs){
		if($sfs['flag_edit'] && $sfs['type'] != 'hidden'){
			$sfs['language_heading'] = 'parent aliquot (for update)';
			break;
		}
	}
	foreach($in_stock_detail_volume['Sfs'] as &$sfs){
		if($sfs['flag_edit'] && $sfs['type'] != 'hidden'){
			$sfs['language_heading'] = 'parent aliquot (for update)';
			break;
		}
	}
		
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if($hook_link){
		require($hook_link); 
	}
	
	$hook_link = $structures->hook('loop');

	$counter = 0;
	$final_parent_structure = null;
	$final_children_structure = null;
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
				'<input type="hidden" name="data[ids]" value="'.$parent_aliquots_ids.'"/>
				<input type="hidden" name="data[sample_ctrl_id]" value="'.$sample_ctrl_id.'"/>
				<input type="hidden" name="data[realiquot_from]" value="'.$realiquot_from.'"/>
				<input type="hidden" name="data[realiquot_into]" value="'.$realiquot_into.'"/>
				<input type="hidden" name="data[Realiquoting][lab_book_master_code]" value="'.$lab_book_code.'"/>
				<input type="hidden" name="data[Realiquoting][sync_with_lab_book]" value="'.$sync_with_lab_book.'"/>
				<input type="hidden" name="data[url_to_cancel]" value="'.$url_to_cancel.'"/>';
		}
		$final_options_parent['settings']['header'] = __('realiquoting process', true) . ' - ' . __('creation', true) . (empty($aliquot_id)? " #".$counter : '');
		$final_options_parent['settings']['name_prefix'] = $parent['AliquotMaster']['id'];
		$final_options_parent['data'] = $parent;
		
		$final_options_children['settings']['name_prefix'] = $parent['AliquotMaster']['id'];
		$final_options_children['override']= $created_aliquot_override_data;
		$final_options_children['data'] = $data['children'];
		
		if(empty($parent['AliquotControl']['volume_unit'])){
			$final_parent_structure = $in_stock_detail;
		}else{
			$final_parent_structure = $in_stock_detail_volume;
		}
				
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		$structures->build($final_parent_structure, $final_options_parent);
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
