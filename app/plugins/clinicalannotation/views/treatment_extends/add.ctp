<?php
	$structure_links = array(
		'top'=>'/clinicalannotation/treatment_extends/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'],
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/treatment_extends/listall/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
		)
	);
	
	$structure_override = array('TreatmentExtend.drug_id'=>$drug_id_findall);
	$structures->build($atim_structure, array('links'=>$structure_links, 'override'=>$structure_override));
?>