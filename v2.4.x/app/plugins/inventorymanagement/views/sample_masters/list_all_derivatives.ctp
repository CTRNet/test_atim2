<?php 

	if(isset($derivatives_data)) {
		$structure_links = array();
		$structure_links['index']['detail'] = '/inventorymanagement/sample_masters/detail/%%Collection.id%%/%%SampleMaster.id%%';
	
		$hook_link = $structures->hook();
		if($hook_link){
			require($hook_link); 
		}
	
		$i = 0;
		$arr_size = count($derivatives_data);
		$hook_link = $structures->hook('unit');
		foreach($derivatives_data as $sample_control_id => $derivatives){
			$final_atim_structure = $derivatives_structures[$sample_control_id];
			$final_options = array(
				'type'				=> 'index', 
				'links'				=> $structure_links, 
				'dropdown_options'	=> array(), 
				'data' 				=> $derivatives, 
				'settings' 			=> array(
					'language_heading'	=> __($derivatives[0]['SampleControl']['sample_type'], true),
					'header'			=> array(),
					'actions'			=> ++ $i == $arr_size,
					'pagination'		=> false
				)
			);
			
			// CUSTOM CODE
			if($hook_link){ 
				require($hook_link); 
			}
				
			// BUILD FORM
			$structures->build( $final_atim_structure, $final_options );
		}
		
	} else {
		
		//Display empty form
		
		$final_atim_structure = $no_data_structure; 
		$final_options = array('type' => 'index', 'data' => array(), 'settings' => array('pagination' => false));
		
		// CUSTOM CODE
		$hook_link = $structures->hook('empty');
		if( $hook_link ) { require($hook_link); }
			
		// BUILD FORM
		$structures->build( $final_atim_structure, $final_options );
	}

?>