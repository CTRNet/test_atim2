<?php
	$links = array(
		'top' 			=> '/inventorymanagement/quality_ctrls/add/'.$atim_menu_variables['SampleMaster.id'],
		'bottom'		=> array(
			'cancel'	=> '/inventorymanagement/quality_ctrls/listAll/'
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
			'header' => __('used aliquot', true),
			'pagination'	=> false,
			'form_inputs'	=> false,
			'actions'		=> false,
			'form_bottom'	=> false
		)
	);
	$hook_link = $structures->hook('empty');
	if( $hook_link ) { 
		require($hook_link); 
	}
	$structures->build( $final_atim_structure, $final_options );
	
	
	echo "<div style='padding: 10px;'>", 
		$this->Form->radio(
			'ViewAliquot.aliquot_master_id', 
			array('' => __('no aliquot', true)),
			array('value' => '')
	), "</div>";
	
	$final_atim_structure = $aliquot_structure;
	$final_options = array(
		'type' 	=> 'index',
		'links'	=> $links,
		'data'	=> $this->data,
		'settings' => array(
			'pagination'	=> false,
			'form_inputs'	=> false,
			'form_top'		=> false
		)
	);
	
	$hook_link = $structures->hook('aliquot');
	if( $hook_link ) { 
		require($hook_link); 
	}
	$structures->build( $final_atim_structure, $final_options );