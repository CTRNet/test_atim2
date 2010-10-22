<?php

	if($display_search_form) {
		
		// ------------------------------------------
		// DISPLAY SEARCH FORM
		// ------------------------------------------
		
		$structure_links = array(
			'top'=>array(
				'search'=>'/datamart/reports/manageReport/' . $atim_menu_variables['Report.id']),
			'bottom'=>array(
				'reload form' => '/datamart/reports/manageReport/' . $atim_menu_variables['Report.id'],
				'cancel'=>'/datamart/reports/index/')
		);
		
		$structure_override = array();	
		
		$final_atim_structure = $search_form_structure; 
		$final_options = array('type'=>'search', 'links'=>$structure_links, 'override'=>$structure_override);
		
		// CUSTOM CODE
		$hook_link = $structures->hook();
		if( $hook_link ) { require($hook_link); }
			
		// BUILD FORM
		$structures->build( $final_atim_structure, $final_options );
			
	} else {

		if($csv_creation){
			$k1 = array_keys($this->data);
			$k2 = array_keys($this->data[$k1[0]]);
			if(!is_array($this->data[$k1[0]][$k2[0]]) || !empty($result_columns_names)){
				//cast find first data into find all
				$this->data[0] = $this->data;
			}
			if (!empty($result_columns_names)){
				$settings['columns_names'] = $result_columns_names;
			}
			$settings['all_fields'] = true;
			$structures->build($result_form_structure, array('type' => 'csv', 'data' => $this->data, 'settings' => $settings));
		}else{
			
			// ------------------------------------------
			// DISPLAY RESULT FORM
			// ------------------------------------------
		
			$structure_links = array(
				'bottom'=>array(
					'export as CSV file (comma-separated values)'=>'/datamart/reports/manageReport/' . $atim_menu_variables['Report.id'].'/'.true,
					'list'=>'/datamart/reports/index/')
			);
			if($display_new_search){
				$structure_links['bottom']['new search'] = '/datamart/reports/manageReport/' . $atim_menu_variables['Report.id'];
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
			$hook_link = $structures->hook();
			if($hook_link){
				require($hook_link);
			}
				
			// BUILD FORM
			$structures->build( $final_atim_structure, $final_options );
		}
	}

	
	
?>