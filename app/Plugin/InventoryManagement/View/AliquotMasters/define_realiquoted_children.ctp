<?php
	$structure_links = array(
		'top'=> '/InventoryManagement/AliquotMasters/defineRealiquotedChildren/'.$aliquot_id,
		'bottom' => array('cancel' => $url_to_cancel)
	);
	
	$structure_settings = array('pagination'=>false, 'form_top' => false, 'form_bottom' => false, 'actions' => false);

	$final_atim_structure = $atim_structure_for_children_aliquots_selection; 
	$options =  array('type'=>'editgrid', 'links' => $structure_links, 'settings' => $structure_settings);
	$parent_options = array_merge($options, array(
		"type" 		=> "edit",
		"settings"	=> array_merge($structure_settings, array("stretch" => false)))
	);
	$parent_options['settings']["language_heading"] = __('parent aliquot (for update)');
	
	$children_options = array_merge($options, array(
		'type'		=> 'addgrid', 
		'links' 	=> $structure_links, 
		'settings' 	=> $structure_settings
	));
	$children_options['settings']["language_heading"] = __('selected children aliquot(s)');
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if($hook_link){
		require($hook_link); 
	}
	
	//BUILD FORM
	$first = true;
	$counter = 0;
	$element_nbr = sizeof($this->request->data);
	foreach($this->request->data as $aliquot) {
		$counter++;
		
		$final_parent_options = $parent_options;
		$final_children_options = $children_options;
		if($first){
			$final_parent_options['settings']['form_top'] = true;
			$first = false;
		}
		if($element_nbr == $counter){
			$final_children_options['settings']['form_bottom'] = true;
			$final_children_options['settings']['actions'] = true;
			$final_children_options['extras'] = 
				'<input type="hidden" name="data[ids]" value="'.$parent_aliquots_ids.'"/>
				<input type="hidden" name="data[sample_ctrl_id]" value="'.$sample_ctrl_id.'"/>
				<input type="hidden" name="data[realiquot_from]" value="'.$realiquot_from.'"/>
				<input type="hidden" name="data[realiquot_into]" value="'.$realiquot_into.'"/>
				<input type="hidden" name="data[Realiquoting][lab_book_master_code]" value="'.$lab_book_code.'"/>
				<input type="hidden" name="data[Realiquoting][sync_with_lab_book]" value="'.$sync_with_lab_book.'"/>
				<input type="hidden" name="data[url_to_cancel]" value="'.$url_to_cancel.'"/>';
		}
		$final_parent_options['settings']['header'] = __('realiquoting process') . ' - ' . __('children selection') . (empty($aliquot_id)? " #".$counter : '');
		$final_parent_options['settings']['name_prefix'] = $aliquot['parent']['AliquotMaster']['id'];
		$final_parent_options['data'] = $aliquot['parent'];
		$final_children_options['settings']['name_prefix'] = $aliquot['parent']['AliquotMaster']['id'];
		$final_children_options['data'] = $aliquot['children'];
		$this->Structures->build( $in_stock_detail, $final_parent_options );
		$this->Structures->build( $final_atim_structure, $final_children_options );
	}	
	
?>

<div id="debug"></div>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
var labBookFields = new Array("<?php echo implode('", "', $lab_book_fields); ?>");
var labBookHideOnLoad = true;
</script>
