<?php
	$links = array(
		'top' 			=> '/InventoryManagement/QualityCtrls/add/'.$atim_menu_variables['SampleMaster.id'],
		'bottom'		=> array(
			'cancel'	=> '/InventoryManagement/QualityCtrls/listAll/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'
		),'radiolist'	=> array(
			'ViewAliquot.aliquot_master_id' => '%%AliquotMaster.id%%'
		)
	);

	$final_atim_structure = $empty_structure;
	$final_options = array(
		'type' 	=> 'detail',
		'links'	=> $links,
		'data'	=> array(),
		'settings' => array(
			'header' => __('quality control creation process') . ' - ' . __('tested aliquot selection'),
			'pagination'	=> false,
			'form_inputs'	=> false,
			'actions'		=> false,
			'form_bottom'	=> false
		)
	);
	$hook_link = $this->Structures->hook('empty');
	if( $hook_link ) { 
		require($hook_link); 
	}
	$this->Structures->build( $final_atim_structure, $final_options );
	
	
	echo "<div style='padding: 10px;'>", 
		$this->Form->radio(
			'ViewAliquot.aliquot_master_id', 
			array('' => __('unspecified')),
			array('value' => '')
	), "</div>";
	
	$final_atim_structure = $aliquot_structure_vol;
	$final_options = array(
		'type' 	=> 'index',
		'links'	=> $links,
		'data'	=> $aliquot_data_vol,
		'settings' => array(
			'pagination'	=> false,
			'form_inputs'	=> false,
			'form_top'		=> false,
			'form_bottom'	=> false,
			'actions'		=> false,
			'language_heading' => __('aliquots with volume')
		)
	);
	
	$hook_link = $this->Structures->hook('aliquot_vol');
	if( $hook_link ) { 
		require($hook_link); 
	}
	$this->Structures->build( $final_atim_structure, $final_options );
	
	
	
	
	
	
	$final_atim_structure = $aliquot_structure_no_vol;
	$final_options = array(
			'type' 	=> 'index',
			'links'	=> $links,
			'data'	=> $aliquot_data_no_vol,
			'settings' => array(
				'pagination'	=> false,
				'form_inputs'	=> false,
				'form_top'		=> false,
				'language_heading' => __('aliquots without volume')
	)
	);
	
	$hook_link = $this->Structures->hook('aliquot_no_vol');
	if( $hook_link ) {
		require($hook_link);
	}
	$this->Structures->build( $final_atim_structure, $final_options );