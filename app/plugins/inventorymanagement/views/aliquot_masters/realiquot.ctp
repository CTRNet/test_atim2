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
		"settings" 	=> array("add_fields" => true, "del_fields" => true, "actions" => false, "form_top" => false, "form_bottom" => false),
		"override"	=> array("AliquotMaster.aliquot_type" => $aliquot_type)
	));

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
				'<input type="hidden" name="data[realiquot_into]" value="'.$realiquot_into.'"/>
				<input type="hidden" name="data[realiquot_from]" value="'.$realiquot_from.'"/>';
		}
		$final_options_parent['settings']['header'] = __('realiquoting process', true) . ' - ' . __('creation', true) ." #".$counter;
		$final_options_parent['settings']['name_prefix'] = $parent['AliquotMaster']['id'];
		$final_options_parent['data'] = $parent;
		
		$final_options_children['settings']['name_prefix'] = $parent['AliquotMaster']['id'];
		$final_options_children['override']= $created_aliquot_override_data;
		$final_options_children['data'] = $data['children'];
		
		$structures->build($in_stock_detail, $final_options_parent);
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
