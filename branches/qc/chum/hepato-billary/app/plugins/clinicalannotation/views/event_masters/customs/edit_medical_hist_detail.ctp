<?php
pr('clean up /views/envet_masters/ folder');
	
	$structure_links = array(
		'top'=>'/clinicalannotation/event_masters/editMedicalHistDetail/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'].'/'.$atim_menu_variables['EventExtend.id'],
		'bottom'=>array('cancel'=>'/clinicalannotation/event_masters/detail/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'])
	);
	
	$structure_settings = array(
		'header' => __('medical past history details', null));
			
	$structure_override = array();
	$structure_override['EventExtend.disease_type'] = $disease_types_list;
	$structure_override['EventExtend.disease_precision'] = $disease_precisions_list;
		
	// BUILD FORM
	$structures->build( $event_extend_structure, array('links' => $structure_links, 'type' => 'edit', 'settings' => $structure_settings, 'override' => $structure_override));
	
?>
