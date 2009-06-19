<?php
	$structure_links = array(
		'top'=>'/clinicalannotation/treatment_extends/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'],
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/treatment_extends/listall/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
/*
		$form_link = array( 'add'=>'/clinicalannotation/treatment_extends/add/'.$participant_id.'/'.$tx_master_id.'/', 'cancel'=>'/clinicalannotation/treatment_extends/listall/'.$participant_id.'/'.$tx_master_id.'/' );
		$form_lang = $lang;
		$form_pagination = NULL;
		$form_override = array('TreatmentExtend/drug_id'=>$drug_id_findall);
		$form_extras = $html->hiddenTag( 'TreatmentExtend/tx_master_id', $tx_master_id ); */
?>