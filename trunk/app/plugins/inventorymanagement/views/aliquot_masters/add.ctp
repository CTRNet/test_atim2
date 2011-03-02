<?php
	
	$options = array(
			"links"		=> array(
				"top" => '/inventorymanagement/aliquot_masters/add/'.$sample_master_id,
				'bottom' => array('cancel' => $url_to_cancel)));

	$options_parent = array_merge($options, array(
		"type" => "edit",
		"settings" 	=> array("actions" => false, "form_top" => false, "form_bottom" => false, "stretch" => false)));
	
	$options_children = array_merge($options, array(
		"type" => "addgrid",
		"settings" 	=> array("add_fields" => true, "del_fields" => true, "actions" => false, "form_top" => false, "form_bottom" => false),
		"override"	=> $override_data));
	
	$first = true;
	$counter = 0;
	while($data = array_shift($this->data)){
		$counter++;
		$parent = $data['parent'];
		$final_options_parent = $options_parent;
		$final_options_children = $options_children;
		if($first){
			$final_options_parent['settings']['form_top'] = true;
			if(!$is_batch_process) {
				$final_options_children['settings']['form_top'] = true;
			}
			$first = false;
		}
		if(count($this->data) == 0){
			$final_options_children['settings']['form_bottom'] = true;
			$final_options_children['settings']['actions'] = true;
			$final_options_children['extras'] = '<input type="hidden" name="data[0][realiquot_into]" value="'.$aliquot_control_id.'"/>';
		}
		if($is_batch_process) $final_options_parent['settings']['header'] = __('aliquot creation batch process', true) . ' - ' . __('creation', true) ." #".$counter;
		$final_options_parent['settings']['name_prefix'] = $parent['ViewSample']['sample_master_id'];
		$final_options_parent['data'] = $parent;
		
		$final_options_children['settings']['name_prefix'] = $parent['ViewSample']['sample_master_id'];
		$final_options_children['data'] = $data['children'];
				
		if($is_batch_process) $structures->build($sample_info, $final_options_parent);
		$structures->build($atim_structure, $final_options_children);
	}
?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>
