<?php 

	$structure_links = array(
		'top'=>'/inventorymanagement/aliquot_masters/addSourceAliquots/'
			.$atim_menu_variables['Collection.id'].'/'
			.$atim_menu_variables['SampleMaster.id'].'/',
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/aliquot_masters/listAllSourceAliquots/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
		)
	);
	
	$structure_override = array();
	
	//no volume
	$final_atim_structure = $sourcealiquots; 
	$final_options = array(
		'data' 		=> isset($this->data['no_vol'])? $this->data['no_vol'] : array(),
		'links' 	=> $structure_links, 
		'override' 	=> $structure_override, 
		'type' 		=> 'editgrid', 
		'settings'	=> array(
			'pagination' 	=> false,
			'form_bottom'	=> false,
			'actions'		=> false,
			'header'		=> __('aliquots without volume', true),
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
	//----------------

	//volume
	$final_atim_structure = $sourcealiquots_volume; 
	$final_options = array(
		'data' 		=> isset($this->data['vol'])? $this->data['vol'] : array(),
		'links' 	=> $structure_links, 
		'override' 	=> $structure_override, 
		'type' 		=> 'editgrid', 
		'settings'	=> array(
			'pagination' 	=> false,
			'form_top'		=> false,
			'header'		=> __('aliquots with volume', true),
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
	//----------------

?>