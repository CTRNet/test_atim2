<?php
	$add_links = array();
	foreach ($consent_controls_list as $consent_control) {
		$add_links[$consent_control['ConsentControl']['controls_type']] = '/clinicalannotation/consent_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$consent_control['ConsentControl']['id'].'/';
	}

	$structure_links = array(
		'top'=>NULL,
		'index'=>'/clinicalannotation/consent_masters/detail/'.$atim_menu_variables['Participant.id'].'/%%ConsentMaster.id%%',
		'bottom'=>array(
			'add'=> $add_links
		)
	);
	
	$structure_override = array('Consent.facility'=>$facility_id_findall);
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links,'override'=>$structure_override) );
?>