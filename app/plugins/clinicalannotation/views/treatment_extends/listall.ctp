<?php
	$structure_links = array(
		'index'=>array(
			'detail'=>'/clinicalannotation/treatment_extends/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/%%TreatmentExtend.id%%/'
		),
		'bottom'=>array(
			'add'=>'/clinicalannotation/treatment_extends/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
		)
	);
	
	$structure_override = array('TreatmentExtend.drug_id'=>$drug_id_findall);
	$structures->build($atim_structure, array('type'=>'index', 'links'=>$structure_links, 'override'=>$structure_override));
?>