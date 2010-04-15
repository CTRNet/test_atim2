<?php
	$filter_links = array( 'no filter'=>'/clinicalannotation/event_masters/listall/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'] );
	foreach ( $event_controls as $event_control ) {
		$filter_links[ __($event_control['EventControl']['disease_site'],true).' - '.__($event_control['EventControl']['event_type'],true) ] = '/clinicalannotation/event_masters/listall/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$event_control['EventControl']['id'];
	}
	
	$add_links = array();
	foreach ( $event_controls as $event_control ) {
		$add_links[ __($event_control['EventControl']['disease_site'],true).' - '.__($event_control['EventControl']['event_type'],true) ] = '/clinicalannotation/event_masters/add/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$event_control['EventControl']['id'];
	}
	
	$structure_links = array(
		'index' => array( 
			'detail' => '/clinicalannotation/event_masters/detail/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/%%EventMaster.id%%'
		),
		'bottom' => array(
			'filter' => $filter_links,
			'add' => $add_links
		)
	); 
			
	$structure_override = array();
	$structure_override['EventMaster.disease_site'] = $disease_site_list;
	$structure_override['EventMaster.event_type'] = $event_type;

	$final_atim_structure = $atim_structure;
	$final_options = array('links'=>$structure_links, 'override' => $structure_override);
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	$structures->build( $atim_structure, $final_options);
	
?>	
