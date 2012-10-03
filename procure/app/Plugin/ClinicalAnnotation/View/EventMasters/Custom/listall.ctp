<?php
	
	$structure_links = array(
		'index' => array( 
			'detail' => array(
				'link' => '/ClinicalAnnotation/EventMasters/detail/'.$atim_menu_variables['Participant.id'].'/%%EventMaster.id%%',
				'icon' => 'detail')
		),
		'bottom' => array(
			'add form' => $add_link_for_procure_forms
		)
	);
			
	$structure_override = array();
	
	$count = 0;
	foreach($event_lists as $new_events_set) {
		$count++;
		$settings = array(
			'form_bottom' => ($count == sizeof($event_lists))? true : false,
			'actions' => ($count == sizeof($event_lists))? true : false,
			'language_heading' => $new_events_set['form_name'],
			'pagination' => false);
		$atim_structure = isset($atim_structures[$new_events_set['detail_form_alias']])? $atim_structures[$new_events_set['detail_form_alias']] : $atim_structures['default'];
		$final_options = array('data' => $new_events_set['data'], 'settings' => $settings, 'links'=>$structure_links, 'type' => 'index');
		$this->Structures->build( $atim_structure, $final_options);
	}
	
?>	
