<?php
	
	if($message_type == 'all') {
	
		// Main form
	
		// --------- Summary  ----------------------------------------------------------------------------------------------
		
		$final_atim_structure = array(); 
		$final_options = array(
			'type' => 'detail', 
			'links'	=> array(),
			'settings' => array('actions'	=> false)
		);
		$this->Structures->build( $atim_structure, $final_options );	
	
		// --------- Profile & Reproductive History  ----------------------------------------------------------------------------------------------
		
		$final_atim_structure = array(); 
		$final_options = array(
			'type' => 'detail', 
			'links'	=> array(),
			'settings' => array(
				'header' => __('main messages', null),
				'actions'	=> false), 
			'extras' => $this->Structures->ajaxIndex('Administrate/SardoMigrations/listAll/main')
		);
		$this->Structures->build( $final_atim_structure, $final_options );	
		
		// --------- Empty lists ----------------------------------------------------------------------------------------------
		
		$final_atim_structure = array(); 
		$final_options = array(
			'type' => 'detail', 
			'links'	=> array(),
			'settings' => array(
				'header' => __('profile and reproductive history update', null),
				'actions'	=> true), 
			'extras' => $this->Structures->ajaxIndex('Administrate/SardoMigrations/listAll/profile_reproductive')
		);
		$this->Structures->build( $final_atim_structure, $final_options );	
	
	} else {
	
		//Messages Display (sub-form)
		
		$final_options = array(
			'type' => 'index',
			'settings'	=> array('pagination' => true, 'actions' => false),
			'override'=> array()
		);
		$this->Structures->build($atim_structure_messages, $final_options);
	}