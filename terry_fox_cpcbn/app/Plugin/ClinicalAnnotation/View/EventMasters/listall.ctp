<?php
	$structure_links = array(
		'index' => array( 
			'detail' => array(
				'link' => '/ClinicalAnnotation/EventMasters/detail/'.$atim_menu_variables['Participant.id'].'/%%EventMaster.id%%',
				'icon' => 'detail')
		)
	); 
	if(isset($add_links)) $structure_links['bottom']['add'] = $add_links;
	$structure_settings = array();
	$structure_override = array();
	$final_options = array('links'=>$structure_links, 'override' => $structure_override, 'type' => 'index', 'settings' => $structure_settings);
	
	$final_atim_structure = $atim_structure;
	
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
	
	if(!isset($controls_for_subform_display)) {
		// Subform display
		$this->Structures->build( $atim_structure, $final_options);
		
	} else {
		// Main form display
		if(empty($controls_for_subform_display)) {
			// No active control for this event_group => Display empty list 
			$final_options['settings']['pagination'] = false;
			$this->Structures->build( $atim_structure, $final_options);
			
		} else {
			$counter = 0;
			foreach($controls_for_subform_display as $new_control) {	
				$counter++;	
				$final_atim_structure = array();
				$final_options['type'] = 'detail';
				$final_options['settings']['header'] = $new_control['EventControl']['ev_header'];
				$final_options['settings']['actions'] = $counter == sizeof($controls_for_subform_display);
				$final_options['extras'] = $this->Structures->ajaxIndex('ClinicalAnnotation/EventMasters/listall/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$new_control['EventControl']['id']);
		
				$hook_link = $this->Structures->hook('subform');
				if( $hook_link ) { require($hook_link); }
				
				$this->Structures->build( $final_atim_structure, $final_options);
			}
		}
	}		
	
?>	
