<?php 
	
	$structure_links = array(
		'top' => '/inventorymanagement/aliquot_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $aliquot_control_data['AliquotControl']['id'],
		'bottom' => array('cancel' => '/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id']
		)
	);
	
	$structure_override = array();
	
	$structure_override['AliquotMaster.aliquot_type'] = $aliquot_control_data['AliquotControl']['aliquot_type'];	
	$structure_override['AliquotMaster.aliquot_volume_unit'] = $aliquot_control_data['AliquotControl']['volume_unit'];	
	
	$structure_override['AliquotMaster.sop_master_id'] = $arr_aliquot_sops_for_display; 	
	$structure_override['AliquotMaster.study_summary_id'] = $arr_studies_for_display;	
	$structure_override['AliquotMaster.storage_master_id'] = $arr_preselected_storages_for_display;	
	
	if(isset($default_storage_datetime)) { $structure_override['AliquotMaster.storage_datetime'] = $default_storage_datetime; }

	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'type' => 'datagrid', 'settings'=> array('pagination' => false, 'add_fields' => true, 'del_fields' => true));
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>

<div id="debug"></div>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
</script>

<?php 
	echo $javascript->link('copyControl')."\n";
?>