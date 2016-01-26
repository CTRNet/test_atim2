<?php
	
	if(isset($message_nbrs)) {
	
		// Main form
	
		// --------- Summary  ----------------------------------------------------------------------------------------------
		
		$final_atim_structure = array(); 
		$final_options = array(
			'type' => 'detail', 
			'links'	=> array(),
			'settings' => array('actions'	=> empty($message_nbrs)? true : false)
		);
		$this->Structures->build( $atim_structure, $final_options );
		
		// --------- Launch Messages Display Per Title ----------------------------------------------------------------------------------------------
		
		while($new_messages = array_shift($message_nbrs)) {
			list($message_nbr, $title, $description) = $new_messages;
			$final_atim_structure = array();
			$final_options = array(
				'type' => 'detail',
				'links'	=> array(),
				'settings' => array(
					'header' => array('title' => $title, 'description' => $description),
					'actions'	=> empty($message_nbrs)? true : false),
				'extras' => $this->Structures->ajaxIndex('Administrate/ProcureBanksDataMergeSummary/listAll/'.$message_nbr)
			);
			$this->Structures->build( $final_atim_structure, $final_options );
		}

	} else {
	
		//Messages Display (sub-form)
		
		$final_options = array(
			'type' => 'index',
			'settings'	=> array('pagination' => true, 'actions' => false),
			'override'=> array()
		);
		$this->Structures->build($procure_banks_data_merge_messages, $final_options);
	}