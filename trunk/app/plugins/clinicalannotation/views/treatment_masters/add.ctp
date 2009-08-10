<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/treatment_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentControl.id'],
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/treatment_masters/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structure_override = array('TreatmentMaster.protocol_id'=>$protocol_list);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>