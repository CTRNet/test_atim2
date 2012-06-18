<?php

	if($display_search_form) {
		
		// ------------------------------------------
		// DISPLAY SEARCH FORM
		// ------------------------------------------
		
		$structure_links = array(
			'top'=>array(
				'search'=>'/Datamart/reports/manageReport/' . $atim_menu_variables['Report.id']),
			'bottom'=>array(
				'reload form' => '/Datamart/reports/manageReport/' . $atim_menu_variables['Report.id'],
				'cancel'=>'/Datamart/reports/index/')
		);
		
		$structure_override = array();	
		
		$final_atim_structure = $search_form_structure; 
		$final_options = array('type'=>'search', 'links'=>$structure_links, 'override'=>$structure_override);
		
		// CUSTOM CODE
		$hook_link = $this->Structures->hook();
		if( $hook_link ) { require($hook_link); }
			
		// BUILD FORM
		$this->Structures->build( $final_atim_structure, $final_options );
			
	} else {

		if($csv_creation){
			$k1 = array_keys($this->request->data);
			$k2 = array_keys($this->request->data[$k1[0]]);
			if(!is_array($this->request->data[$k1[0]][$k2[0]]) || !empty($result_columns_names)){
				//cast find first data into find all
				$this->request->data[0] = $this->request->data;
			}
			if (!empty($result_columns_names)){
				$settings['columns_names'] = $result_columns_names;
			}
			$settings['all_fields'] = true;
			$this->Structures->build($result_form_structure, array('type' => 'csv', 'data' => $this->request->data, 'settings' => $settings));
		}else{
			
			// ------------------------------------------
			// DISPLAY RESULT FORM
			// ------------------------------------------
		
			$structure_links = array(
				'bottom'=>array(
					'export as CSV file (comma-separated values)'=>'/Datamart/reports/manageReport/' . $atim_menu_variables['Report.id'].'/'.true,
					'list'=>'/Datamart/reports/index/')
			);
			if($display_new_search){
				$structure_links['bottom']['new search'] = array('link' => '/Datamart/reports/manageReport/' . $atim_menu_variables['Report.id'], 'icon' => 'search');
			}
			
			$structure_override = array();	
			$settings = array('pagination' => false);
			if (!empty($result_header)){
				$settings['header'] = $result_header;
			}
			if (!empty($result_columns_names)){
				$settings['columns_names'] = $result_columns_names;
			}
			
			$final_atim_structure = $result_form_structure; 	
			$final_options = array('type'=>$result_form_type, 'links'=>$structure_links, 'override'=>$structure_override, 'settings' => $settings);
			
			// CUSTOM CODE
			$hook_link = $this->Structures->hook();
			if($hook_link){
				require($hook_link);
			}
				
			// BUILD FORM
			$this->Structures->build( $final_atim_structure, $final_options );
		}
	}

	
	
?>