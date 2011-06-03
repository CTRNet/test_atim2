<?php 
	$structure_links = array(
		'top'=>'/inventorymanagement/quality_ctrls/addTestedAliquots/'
			.$atim_menu_variables['Collection.id'].'/'
			.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['QualityCtrl.id'].'/',
		'bottom'=>array(
			'cancel' => '/inventorymanagement/quality_ctrls/detail/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['QualityCtrl.id'].'/'
		)
	);
	
	
	//no volume
	$final_atim_structure = $qctestedaliquots; 
	$final_options = array(
		'data' 		=> $this->data['no_vol'],
		'links' 	=> $structure_links, 
		'type' 		=> 'editgrid', 
		'settings'	=> array(
			'pagination'	=> false, 
			'header' 		=> __('aliquots without volume', true),
			'actions' 		=> false,
			'form_bottom' 	=> false,
			'name_prefix'	=> 'no_vol'
		)
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook('no_vol');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	//-----------
	
	
	
	//with volume--------
	$final_atim_structure = $qctestedaliquots_volume; 
	$final_options = array(
		'data' 		=> $this->data['vol'],
		'links' 	=> $structure_links, 
		'type' 		=> 'editgrid', 
		'settings'	=> array(
			'pagination'	=> false, 
			'header' 		=> __('aliquots with volume', true),
			'form_top'		=> false,
			'name_prefix'	=> 'vol'
		)
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook('vol');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );

?>