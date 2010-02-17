<?php 
	$add_links = array();
	foreach ( $treatment_controls as $treatment_control ) {
		$add_links[$treatment_control['TreatmentControl']['tx_method']] = '/clinicalannotation/treatment_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$treatment_control['TreatmentControl']['id'];
	}
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/clinicalannotation/treatment_masters/detail/'.$atim_menu_variables['Participant.id'].'/%%TreatmentMaster.id%%/'
		),
		'bottom'=>array('add' => $add_links)
	);

	$structure_override = array('TreatmentMaster.protocol_id'=>$protocol_list);
	$structures->build( $atim_structure, array('type'=>'index', 'links'=>$structure_links, 'override'=>$structure_override) );
?>