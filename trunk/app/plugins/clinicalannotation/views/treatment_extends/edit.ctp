<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/treatment_extends/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/'.$atim_menu_variables['TreatmentExtend.id'],
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/treatment_extends/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/'.$atim_menu_variables['TreatmentExtend.id']
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );

/*		$form_type = 'edit';
		$form_model = isset( $this->params['data'] ) ? array( $this->params['data'] ) : array( $data );
		$form_field = $ctrapp_form;
		$form_link = array( 'edit'=>'/clinicalannotation/treatment_extends/edit/'.$participant_id.'/'.$tx_master_id.'/', 'cancel'=>'/clinicalannotation/treatment_extends/detail/'.$participant_id.'/'.$tx_master_id.'/' );
		$form_lang = $lang;
		$form_pagination = NULL; 
		$form_extras = NULL;		
		$form_override = array('TreatmentExtend/drug_id'=>$drug_id_findall);	
	*/
?>