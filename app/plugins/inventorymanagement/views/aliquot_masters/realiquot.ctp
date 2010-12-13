<?php 
	$first = true;
	$final_options = array(
			"type" 		=> "addgrid", 
			"data" 		=> array(),
			"links"		=> array("top" => "/inventorymanagement/aliquot_masters/realiquot/"),
			"settings" 	=> array("add_fields" => true, "del_fields" => true, "actions" => false, "form_top" => false, "form_bottom" => false),
			"override"	=> array("AliquotMaster.aliquot_type" => $aliquot_type));
	while($data = array_shift($this->data)){
		$parent = $data['parent'];
		$options = $final_options;
		if($first){
			$options['settings']['form_top'] = true;
			$first = false;
		}
		if(count($this->data) == 0){
			$options['settings']['form_bottom'] = true;
			$options['settings']['actions'] = true;
			$options['extras'] = '<input type="hidden" name="data[realiquot_into]" value="'.$realiquot_into.'"/>';
		}
		$options['settings']['header'] = sprintf(__('realiquoting %s', true), $parent['AliquotMaster']['barcode']);
		$options['settings']['name_prefix'] = $parent['AliquotMaster']['id'];
		$options['override']['AliquotMaster.aliquot_volume_unit'] = $parent['AliquotMaster']["aliquot_volume_unit"];
		$options['data'] = $data['children'];
		if(strlen($parent['AliquotMaster']["aliquot_volume_unit"])){ 
			$structures->build($struct_vol, $options);
		}else{
			$structures->build($struct_no_vol, $options);
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
