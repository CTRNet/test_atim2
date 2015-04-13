<?php 
	
	if(!$treatment_control_id) {
	 	if(!isset($controls_for_subform_display)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		//Re-order for display
		$tm_controls_for_subform_display = array(
			'procure follow-up worksheet - treatment' => array(),
			'procure follow-up worksheet - other tumor tx' => array(),
			'procure medication worksheet' => array(),
			'procure medication worksheet - drug' => array()
		);
		foreach($controls_for_subform_display as $new_control_for_subform_display)  $tm_controls_for_subform_display[$new_control_for_subform_display['TreatmentControl']['tx_method']] = $new_control_for_subform_display; 
		$this->set('controls_for_subform_display', $tm_controls_for_subform_display);
		//Set procure add button
		$this->set('add_link_for_procure_forms',$this->Participant->buildAddProcureFormsButton($participant_id));
	} else if($treatment_control_id!= '-1' && $control_data['TreatmentControl']['tx_method'] == 'procure medication worksheet') {
		$this->Structures->set('treatmentmasters');
	}
	