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
	$final_options =  array('type'=>'editgrid', 'links' => $structure_links, 'settings' => $structure_settings, 'form_top' => false);
	
	// CUSTOM CODE
	$hook_link = $structures->hook('children_selection');
	if($hook_link){
		require($hook_link); 
	}
		
	//BUILD FORM
	$first = true;
	while($aliquot = array_pop($this->data)){
		$options = $final_options;
		if($first){
			$options['settings']['form_top'] = true;
			$first = false;
		}
		if(count($this->data) == 0){
			$options['settings']['form_bottom'] = true;
			$options['settings']['actions'] = true;
			$options['extras']['end'] = __("remove empty aliquots from stocks", true).$this->Form->input("remove_when_empty", array('type' => 'checkbox', 'value' => 1, 'checked' => isset($remove_when_empty) && $remove_when_empty, "id" => false, "div" => false, "label" => false));
		}
		$options['settings']['header'] = __('realiquoted children selection', true)." [".$aliquot['parent']['AliquotMaster']['barcode']."]";
		$options['settings']['name_prefix'] = $aliquot['parent']['AliquotMaster']['id'];
		$options['data'] = $aliquot['children'];
		$structures->build( $final_atim_structure, $options );
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
