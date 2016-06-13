<?php 
	
	$structure_links = array(
		'top' => '/InventoryManagement/SampleMasters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'],
		'bottom'=>array(
			'cancel' => '/InventoryManagement/SampleMasters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id']
		)
	);
	
	$structure_override = array();
	$dropdown_options = array(
		'SampleMaster.parent_id' => (isset($parent_sample_data_for_display) && (!empty($parent_sample_data_for_display)))? $parent_sample_data_for_display: array('' => ''),
		'DerivativeDetail.lab_book_master_id' => (isset($lab_books_list) && (!empty($lab_books_list)))? $lab_books_list: array('' => ''));
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'override' => $structure_override, 'dropdown_options' => $dropdown_options);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
	
?>
<script>
var labBookFields = new Array("<?php echo implode('", "', $lab_book_fields); ?>");
</script>