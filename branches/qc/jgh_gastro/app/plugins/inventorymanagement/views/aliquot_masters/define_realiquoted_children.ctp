<?php
	$structure_links = array(
		'top'=> '/inventorymanagement/aliquot_masters/defineRealiquotedChildren/'
	);
	if(isset($atim_menu_variables['Collection.id'])){
		$structure_links['top'] .= $atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['AliquotMaster.id'].'/'; 
		$structure_links['bottom'] = array('cancel' => '/inventorymanagement/aliquot_masters/detail/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['AliquotMaster.id'].'/'); 
	}
	$structure_settings = array('pagination'=>false, 'form_top' => false, 'form_bottom' => false, 'actions' => false);

	$final_atim_structure = $atim_structure_for_children_aliquots_selection; 
	$options =  array('type'=>'editgrid', 'links' => $structure_links, 'settings' => $structure_settings);
	$parent_options = array_merge($options, array(
		"type" 		=> "edit",
		"settings"	=> array_merge($structure_settings, array("stretch" => false)))
	);
	$children_options = array_merge($options, array(
		'type'		=> 'addgrid', 
		'links' 	=> $structure_links, 
		'settings' 	=> $structure_settings	
	));
	// CUSTOM CODE
	$hook_link = $structures->hook('children_selection');
	if($hook_link){
		require($hook_link); 
	}
	
	//BUILD FORM
	$first = true;
	while($aliquot = array_pop($this->data)){
		$final_parent_options = $parent_options;
		$final_children_options = $children_options;
		if($first){
			$final_parent_options['settings']['form_top'] = true;
			$first = false;
		}
		if(count($this->data) == 0){
			$final_children_options['settings']['form_bottom'] = true;
			$final_children_options['settings']['actions'] = true;
		}
		$final_parent_options['settings']['header'] = __('realiquoted children selection', true)." [".$aliquot['parent']['AliquotMaster']['barcode']."]";
		$final_parent_options['settings']['name_prefix'] = $aliquot['parent']['AliquotMaster']['id'];
		$final_parent_options['data'] = $aliquot['parent'];
		$final_children_options['settings']['name_prefix'] = $aliquot['parent']['AliquotMaster']['id'];
		$final_children_options['data'] = $aliquot['children'];
		$structures->build( $in_stock_detail, $final_parent_options );
		$structures->build( $final_atim_structure, $final_children_options );
	}	
	
?>

<div id="debug"></div>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>
