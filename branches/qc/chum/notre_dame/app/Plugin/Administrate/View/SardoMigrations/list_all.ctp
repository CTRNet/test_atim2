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
		
		$structure_links = array(
			'bottom'=>array(
				'export as CSV file (comma-separated values)'=>sprintf("javascript:setCsvPopup('Administrate/SardoMigrations/listAll/csv/');", 0)
			)
		);
		
		$final_atim_structure = array(); 
		$final_options = array(
			'type' => 'detail', 
			'links'	=> $structure_links,
			'settings' => array(
				'header' => __('profile and reproductive history update', null),
				'actions'	=> true), 
			'extras' => $this->Structures->ajaxIndex('Administrate/SardoMigrations/listAll/profile_reproductive')
		);
		$this->Structures->build( $final_atim_structure, $final_options );	
	
	} else if ($message_type == 'csv') {
		
		$this->Structures->build($atim_structure_messages, array('type' => 'csv', 'data' => $this->request->data, 'settings' => array('all_fields' => true)));
		exit;
	
	} else {
	
		//Messages Display (sub-form)
		
		$final_options = array(
			'type' => 'index',
			'settings'	=> array('pagination' => true, 'actions' => false),
			'override'=> array()
		);
		$this->Structures->build($atim_structure_messages, $final_options);
	}