<?php 
	$structure_links = array(
		'top'=>'/inventorymanagement/quality_ctrls/edit/'
			.$atim_menu_variables['Collection.id'].'/'
			.$atim_menu_variables['SampleMaster.id'].'/'
			.$atim_menu_variables['QualityCtrl.id'].'/',
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/quality_ctrls/detail/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['QualityCtrl.id'].'/',
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'links' => $structure_links,
		'type'	=> 'edit',
		'settings' => array(
			'form_bottom'	=> false,
			'actions'		=> false
		)
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );

	
	
	
	//aliquot part
	$aliquot_master_id = $this->data['QualityCtrl']['aliquot_master_id'];
	foreach($aliquot_data as &$aliquot_data_unit){
		if($aliquot_data_unit['AliquotMaster']['id'] == $aliquot_master_id){
			$aliquot_data_unit['QualityCtrl']['aliquot_master_id'] = $aliquot_master_id;
			break;
		}
	}
	
	$structure_links['radiolist'] = array('QualityCtrl.aliquot_master_id' => '%%AliquotMaster.id%%');
	$final_atim_structure = $aliquot_structure;
	$final_options = array(
		'links'	=> $structure_links,
		'type'	=> 'index',
		'data'	=> $aliquot_data,
		'settings'	=> array(
			'form_top'		=> false,
			'pagination'	=> false,
			'header'		=> __('used aliquot', true),
			'form_inputs'	=> false
		)
	);
	
	$hook_link = $structures->hook('aliquot');
	if( $hook_link ) { 
		require($hook_link); 
	}
	$structures->build( $final_atim_structure, $final_options );
?>