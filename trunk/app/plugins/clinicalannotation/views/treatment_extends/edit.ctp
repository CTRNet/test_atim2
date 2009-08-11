<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/treatment_extends/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/'.$atim_menu_variables['TreatmentExtend.id'],
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/treatment_extends/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/'.$atim_menu_variables['TreatmentExtend.id']
		)
	);
	
	switch($tx_group){
		case "chemotherapy":
			$structure_override = array('TreatmentExtend.drug_id'=>$drug_list);
			break;
		default:
			$structure_override = NULL;
			break;
	}
	$structures->build( $atim_structure, array('links'=>$structure_links, 'override'=>$structure_override) );

?>