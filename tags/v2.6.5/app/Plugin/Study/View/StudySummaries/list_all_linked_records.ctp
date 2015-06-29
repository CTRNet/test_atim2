<?php

	if(isset($linked_records_headers)) {
		
		// Manage all lists display
			
		if($linked_records_headers) {
			$counter = 0;
			foreach($linked_records_headers as $new_list_header) {
				$counter++;
				$final_options = array(
					'type' => 'detail',
					'links'	=> array(),
					'settings' => array(
						'header' => __($new_list_header, null),
						'actions'	=> ($counter == sizeof($linked_records_headers))? true : false), 
					'extras' => array('end' => $this->Structures->ajaxIndex('Study/StudySummaries/listAllLinkedRecords/'.$atim_menu_variables['StudySummary.id']."/$new_list_header"))
				);
				$final_atim_structure = array(); 
				
				$hook_link = $this->Structures->hook();
				if($hook_link){
					require($hook_link);
				}
				
				$this->Structures->build( $final_atim_structure, $final_options );	
			}
		} else {
			$final_options = array('type' => 'detail', 'extras' => '<div>'.__('core_no_data_available').'</div>');
			$final_atim_structure = array();
			
			$this->Structures->build( $final_atim_structure, $final_options );
		}
		
	} else {
		
		// Specific list display
		
		if(!AppController::checkLinkPermission($permission_link)){
			$final_options = array(
				'type' => 'detail',
				'extras' => '<div>'.__('You are not authorized to access that location.').'</div>');
			$final_atim_structure = array();
			$this->Structures->build($final_atim_structure, $final_options);
		} else {
			$final_atim_structure = $atim_structure;
			$final_options = array(
				'type' => 'index',
				'links' => array(
					'index' => array(
						'detail' => $details_url)),
				'settings'	=> array('pagination' => true, 'actions' => false),
				'override'=> array()
			);
			$final_atim_structure = $atim_structure; 
		
			$hook_link = $this->Structures->hook('specific_list');
			if($hook_link){
				require($hook_link);
			}

			$this->Structures->build($final_atim_structure, $final_options);
		}
		
	}

?>








