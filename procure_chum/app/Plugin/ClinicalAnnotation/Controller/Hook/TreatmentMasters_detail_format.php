<?php 
	
	if($treatment_master_data['TreatmentControl']['treatment_extend_control_id']) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	
	$this->set('add_link_for_procure_forms',$this->Participant->buildAddProcureFormsButton($participant_id));
	
	if($treatment_master_data['TreatmentControl']['tx_method'] == 'procure medication worksheet') {
		//Set Drug Control Id for drugs list
		$drug_tx_control_data = $this->TreatmentControl->find('first', array('conditions'=>array('TreatmentControl.tx_method' => 'procure medication worksheet - drug')));
		$this->set('drug_tx_control_id', $drug_tx_control_data['TreatmentControl']['id']);
		//Set Inteval Dates (previous Medication Worksheet date to studied Medication Worksheet date)
		$interval_start_date = '-1';
		$interval_start_date_accuracy = 'c';
		if($treatment_master_data['TreatmentMaster']['start_date']) {
			$previous_medication_woksheet_conditions = array(
				'TreatmentMaster.treatment_control_id'=>$treatment_master_data['TreatmentControl']['id'],
				'TreatmentMaster.participant_id' => $participant_id,
				"TreatmentMaster.start_date IS NOT NULL",
				"TreatmentMaster.start_date < '".$treatment_master_data['TreatmentMaster']['start_date']."'",
			);
			$previous_medication_woksheet_data = $this->TreatmentMaster->find('first',array('conditions'=>$previous_medication_woksheet_conditions, 'order' => array('TreatmentMaster.start_date DESC')));
			if($previous_medication_woksheet_data) {
				$interval_start_date = $previous_medication_woksheet_data['TreatmentMaster']['start_date'];
				$interval_start_date_accuracy = $previous_medication_woksheet_data['TreatmentMaster']['start_date_accuracy'];
			}
		}
		$this->set('interval_start_date', $interval_start_date);
		$this->set('interval_start_date_accuracy', $interval_start_date_accuracy);
		$this->set('interval_finish_date', (empty($treatment_master_data['TreatmentMaster']['start_date'])? '-1': $treatment_master_data['TreatmentMaster']['start_date']));
		$this->set('interval_finish_date_accuracy', (empty($treatment_master_data['TreatmentMaster']['start_date'])? 'c': $treatment_master_data['TreatmentMaster']['start_date_accuracy']));
	}
	