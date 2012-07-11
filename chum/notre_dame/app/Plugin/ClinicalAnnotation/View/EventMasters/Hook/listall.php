<?php
$unsorted_filter = array();
foreach($event_controls as $event_control){
	$label = __($event_control['EventControl']['event_type']).' - '.__($event_control['EventControl']['disease_site']);
	$unsorted_filter[$label] = '/ClinicalAnnotation/EventMasters/listall/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$event_control['EventControl']['id'];
}
$filter = array();

foreach($add_links as $key => $foo){
	$filter[$key] = $unsorted_filter[$key];
}
$filter[__('no filter', true)] = '/ClinicAlannotation/EventMasters/listall/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/';
$final_options['links']['bottom']['filter'] = $filter;