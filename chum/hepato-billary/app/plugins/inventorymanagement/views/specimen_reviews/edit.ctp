<?php 

	$structure_links = array(
		'top'=>'/inventorymanagement/specimen_reviews/edit/'
			.$atim_menu_variables['Collection.id'].'/'
			.$atim_menu_variables['SampleMaster.id'].'/'
			.$atim_menu_variables['SpecimenReviewMaster.id'].'/',
		'bottom'=>array(
			'undo' =>'/inventorymanagement/specimen_reviews/edit/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['SpecimenReviewMaster.id'].'/'.
			true, 
			'cancel'=>'/inventorymanagement/specimen_reviews/detail/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['SpecimenReviewMaster.id'].'/',
		)
	);
	
	// 1- SPECIMEN REVIEW
	
	$structure_settings = array(
		'actions'=> ($is_aliquot_review_defined? false : true), 
		
		'header' => __($review_control_data['SpecimenReviewControl']['specimen_sample_type'], null) . ' - ' . __($review_control_data['SpecimenReviewControl']['review_type'], null),
		'form_bottom'=> ($is_aliquot_review_defined? false : true));
	
	$final_atim_structure = $specimen_review_structure;
	if(!$is_aliquot_review_defined) { unset($structure_links['bottom']['undo']); }
	$final_options = array( 'settings'=>$structure_settings, 'links'=>$structure_links, 'data' => $specimen_review_data);
	
	$hook_link = $structures->hook('specimen_review');
	if( $hook_link ) { require($hook_link); }
	
	$structures->build( $final_atim_structure,  $final_options);

	if($is_aliquot_review_defined) {
		// 2- SEPARATOR & HEADER
		
		$structure_settings = array(
			'actions'=>false, 
	
			'header' => __('aliquot review', null),
			'separator' => true, 
			'form_top' => false,
			'form_bottom'=>false
		);	
	
		$structures->build($empty_structure, array('settings'=>$structure_settings));
	
		// 3- ALIQUOT REVIEW
				
		$structure_settings = array(
			'pagination' => false, 
			'add_fields' => true, 
			'del_fields' => true,
			'form_top' => false
		);
		
		$structure_override = array();
		$structure_override['AliquotReviewMaster.aliquot_masters_id'] = $aliquot_list;	
		
		$final_atim_structure = $aliquot_review_structure;
		$final_options = array('links' => $structure_links, 'data' => $aliquot_review_data, 'type' => 'datagrid', 'settings'=> $structure_settings, 'override' => $structure_override);
		
		$hook_link = $structures->hook('aliquot_review');
		if( $hook_link ) { require($hook_link); } 
		
		$structures->build( $final_atim_structure,  $final_options);	
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
