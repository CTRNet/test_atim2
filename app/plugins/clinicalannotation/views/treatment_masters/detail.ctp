<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/clinicalannotation/treatment_masters/listall/'.$atim_menu_variables['Participant.id'].'/',
			'edit'=>'/clinicalannotation/treatment_masters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'],
			'delete'=>'/clinicalannotation/treatment_masters/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
		)
	);
	
	$structure_override = array('TreatmentMaster.protocol_id'=>$protocol_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>