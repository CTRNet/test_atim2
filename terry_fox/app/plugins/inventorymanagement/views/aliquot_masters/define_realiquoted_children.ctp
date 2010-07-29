<?php
	
	$structure_links = array(
		'top'=> '/inventorymanagement/aliquot_masters/defineRealiquotedChildren/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['AliquotMaster.id'].'/',
		'bottom'=>array('cancel' => '/inventorymanagement/aliquot_masters/detail/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.initial_specimen_sample_id'].'/'.$atim_menu_variables['AliquotMaster.id'].'/')
	);
	
	$structure_settings = array('pagination'=>false, 'header' => __('realiquoted children selection', null));

	$structure_override = array();
	
	$final_atim_structure = $atim_structure_for_children_aliquots_selection; 
	$final_options =  array('type'=>'datagrid', 'links' => $structure_links, 'settings' => $structure_settings, 'override' => $structure_override);
	
	// CUSTOM CODE
	
	$hook_link = $structures->hook('children_selection');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>

<div id="debug"></div>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
</script>

<?php 
	echo $javascript->link('copyControl')."\n";
?>
