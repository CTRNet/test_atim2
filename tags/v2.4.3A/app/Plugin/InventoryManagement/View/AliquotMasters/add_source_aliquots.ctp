<?php 

	$structure_links = array(
		'top'=>'/InventoryManagement/AliquotMasters/addSourceAliquots/'
			.$atim_menu_variables['Collection.id'].'/'
			.$atim_menu_variables['SampleMaster.id'].'/',
		'bottom'=>array(
			'cancel'=>'/InventoryManagement/AliquotMasters/listAllSourceAliquots/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
		)
	);
	
	$structure_override = array();
	
	//no volume
	$final_atim_structure = $sourcealiquots; 
	$final_options = array(
		'data' 		=> isset($this->request->data['no_vol'])? $this->request->data['no_vol'] : array(),
		'links' 	=> $structure_links, 
		'override' 	=> $structure_override, 
		'type' 		=> 'editgrid', 
		'settings'	=> array(
			'pagination' 	=> false,
			'form_bottom'	=> false,
			'actions'		=> false,
			'language_heading'		=> __('aliquots without volume'),
			'name_prefix'	=> 'no_vol'
		)
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('no_vol');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	//----------------

	//volume
	$final_atim_structure = $sourcealiquots_volume; 
	$final_options = array(
		'data' 		=> isset($this->request->data['vol'])? $this->request->data['vol'] : array(),
		'links' 	=> $structure_links, 
		'override' 	=> $structure_override, 
		'type' 		=> 'editgrid', 
		'settings'	=> array(
			'pagination' 	=> false,
			'form_top'		=> false,
			'language_heading'		=> __('aliquots with volume'),
			'name_prefix'	=> 'vol'
		)
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('vol');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	//----------------

?>