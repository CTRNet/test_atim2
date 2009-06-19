<?php
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/clinicalannotation/treatment_extends/listall/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'],
			'edit'=>'/clinicalannotation/treatment_extends/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/'.$atim_menu_variables['TreatmentExtend.id'].'/',
			'delete'=>'/clinicalannotation/treatment_extends/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/'.$atim_menu_variables['TreatmentExtend.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
/*
		$form_type = 'detail';
		$form_model = isset( $this->params['data'] ) ? array( $this->params['data'] ) : array( $data );
		$form_field = $ctrapp_form;
		$form_link = array( 'edit'=>'/clinicalannotation/treatment_extends/edit/'.$participant_id.'/'.$tx_master_id.'/', 'delete'=>'/clinicalannotation/treatment_extends/delete/'.$participant_id.'/'.$tx_master_id.'/', 'list'=>'/clinicalannotation/treatment_extends/listall/'.$participant_id.'/'.$tx_master_id.'/' );
		$form_lang = $lang;
		$form_pagination = NULL; 
		$form_extras = NULL;		
		$form_override = array('TreatmentExtend/drug_id'=>$drug_id_findall);
		
		// ************ START CUSTOM CODE CHECK **************
		if (file_exists($custom_ctrapp_view_hook)) { 
			require($custom_ctrapp_view_hook);
		}
		// ************* END CUSTOM CODE CHECK ***************
		
		$forms->build( 
			$form_type, 
			$form_model, 
			$form_field, 
			$form_link, 
			$form_lang, 
			$form_pagination, 
			$form_override, 
			$form_extras ); */
?>