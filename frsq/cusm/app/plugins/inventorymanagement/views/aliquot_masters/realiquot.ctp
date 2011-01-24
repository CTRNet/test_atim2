<?php 
	$first = true;
	$options = array(
			"links"		=> array("top" => "/inventorymanagement/aliquot_masters/realiquot/")
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

	while($data = array_shift($this->data)){
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
				'<input type="hidden" name="data[realiquot_into]" value="'.$realiquot_into.'"/>';
		}
		$final_options_parent['settings']['header'] = sprintf(__('realiquoting %s', true), $parent['AliquotMaster']['barcode']);
		$final_options_parent['settings']['name_prefix'] = $parent['AliquotMaster']['id'];
		$final_options_parent['data'] = $parent;
		
		$final_options_children['settings']['name_prefix'] = $parent['AliquotMaster']['id'];
		$final_options_children['override']['AliquotMaster.aliquot_volume_unit'] = $parent['AliquotMaster']["aliquot_volume_unit"];
		$final_options_children['data'] = $data['children'];
		
		$structures->build($in_stock_detail, $final_options_parent);
		if(strlen($parent['AliquotMaster']["aliquot_volume_unit"])){ 
			$structures->build($struct_vol, $final_options_children);
		}else{
			$structures->build($struct_no_vol, $final_options_children);
		}
	}
?>

<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>
