<?php 
	if($tx_control_data['TreatmentControl']['tx_method'] == 'procure medication worksheet') {
		if(empty($this->request->data['TreatmentMaster']['start_date']['year'])) {
			$this->TreatmentMaster->validationErrors['start_date'][] = 'the worksheet date has to be completed';
			$submitted_data_validates = false;
		}
	}
	
	$this->TreatmentMaster->addWritableField('procure_created_by_bank');
	if(!$tx_control_data['TreatmentControl']['use_addgrid']) {
		$this->request->data['TreatmentMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
	} else {
		foreach($this->request->data as &$data_unit){
			$data_unit['TreatmentMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
		}
	}
	