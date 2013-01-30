<?php
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/treatment_extends/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/%%TreatmentExtend.id%%',
			'delete'=>'/clinicalannotation/treatment_extends/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/%%TreatmentExtend.id%%',
			'list'=>'/clinicalannotation/treatment_extends/listall/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
		)
	);
	
	switch($tx_method){
		case "chemotherapy":
			$structure_override = array('TreatmentExtend.drug_id'=>$drug_list);
			break;
		default:
			$structure_override = array();
			break;
	}
	
	$structures->build( $atim_structure, array('links'=>$structure_links, 'override'=>$structure_override) );
?>