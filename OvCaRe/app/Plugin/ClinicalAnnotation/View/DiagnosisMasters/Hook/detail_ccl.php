<?php
	
if(isset($report_event_type)) {
	//Added path report list
	$path_report_atim_structure = array();
	$path_report_final_options = $final_options;
	$path_report_final_options['type'] = 'detail';
	$path_report_final_options['settings']['header'] = __('report');
	$path_report_final_options['settings']['actions'] = false;
	$path_report_final_options['extras'] = $this->Structures->ajaxIndex('ClinicalAnnotation/EventMasters/listall/'.$report_event_type['EventControl']['event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$report_event_type['EventControl']['id']);
	$this->Structures->build( $path_report_atim_structure, $path_report_final_options);	
}




