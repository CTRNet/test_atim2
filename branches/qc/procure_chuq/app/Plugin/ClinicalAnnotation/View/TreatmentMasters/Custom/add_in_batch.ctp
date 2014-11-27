<?php 
 	$structure_links = array(
		'top' => '/ClinicalAnnotation/TreatmentMasters/addInBatch/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentControl.id'].'/1',
		'bottom' => array('cancel'=>'/ClinicalAnnotation/TreatmentMasters/listall/'.$atim_menu_variables['Participant.id']));
			
 	$structure_override = array();
	$structure_settings = array('pagination' => false, 'add_fields' => true, 'del_fields' => true, 'header' => $tx_header);
	$final_options = array('links' => $structure_links, 'type' => 'addgrid', 'settings'=> $structure_settings);
	if(isset($default_procure_form_identification)) $final_options['override']['TreatmentMaster.procure_form_identification'] = $default_procure_form_identification;
	
	$this->Structures->build($atim_structure, $final_options);

