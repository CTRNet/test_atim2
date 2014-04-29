<?php 
 	$structure_links = array(
		'top' => '/ClinicalAnnotation/TreatmentMasters/addInBatch/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentControl.id'].'/1',
		'bottom' => array('cancel'=>'/ClinicalAnnotation/TreatmentMasters/listall/'.$atim_menu_variables['Participant.id']));
			
 	$dropdown_options = array('TreatmentDetail.followup_event_master_id' => $followup_identification_list);
	$structure_override = array();
	$structure_settings = array('pagination' => false, 'add_fields' => true, 'del_fields' => true, 'header' => $tx_header);
	$final_options = array('links' => $structure_links, 'type' => 'addgrid', 'settings'=> $structure_settings, 'dropdown_options' => $dropdown_options);
	
	$this->Structures->build($atim_structure, $final_options);

