<?php 

	$structure_links = array(
		'bottom'=>array(
			'list'=>'/InventoryManagement/SpecimenReviews/listAll/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/',
			'edit'=>'/InventoryManagement/SpecimenReviews/edit/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['SpecimenReviewMaster.id'].'/',
			'delete'=>'/InventoryManagement/SpecimenReviews/delete/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['SpecimenReviewMaster.id'].'/',
		)
	);
	
	// 1- SPECIMEN REVIEW
	
	$structure_settings = array(
		'actions'=> ($is_aliquot_review_defined? false : true), 
		'form_bottom'=> ($is_aliquot_review_defined? false : true));
	
	$final_atim_structure = $specimen_review_structure;
	$final_options = array( 'settings'=>$structure_settings, 'links'=>$structure_links, 'data' => $specimen_review_data);
	
	if($aliquot_master_id_from_tree_view) {
		$final_options['settings']['header'] =  __('specimen review');
		unset($final_options['links']['bottom']['list']);
		unset($structure_links['bottom']['list']);
	}
	
	$hook_link = $this->Structures->hook('specimen_review');
	if( $hook_link ) { require($hook_link); }
	
	$this->Structures->build( $final_atim_structure,  $final_options);

	if($is_aliquot_review_defined) {
		// 2- SEPARATOR & HEADER
		
		$structure_settings = array(
			'actions'=>false, 
	
			'header' => __('aliquot review', null),
			'form_top' => false,
			'form_bottom'=>false
		);	
	
		$this->Structures->build($empty_structure, array('settings'=>$structure_settings));
	
		// 3- ALIQUOT REVIEW
				
		$structure_settings = array(
			'pagination' => false, 
			'add_fields' => true, 
			'del_fields' => true,
			'form_top' => false
		);
		
		$dropdown_options = array();
		$dropdown_options['AliquotReviewMaster.aliquot_master_id'] = $aliquot_list;	
		
		$final_atim_structure = $aliquot_review_structure;
		$final_options = array('links' => $structure_links, 'data' => $aliquot_review_data, 'type' => 'index', 'settings'=> $structure_settings, 'dropdown_options' => $dropdown_options);
		
		$hook_link = $this->Structures->hook('aliquot_review');
		if( $hook_link ) { require($hook_link); } 
		
		$this->Structures->build( $final_atim_structure,  $final_options);	
	}
		
?>