<?php 
	if($tx_control_data['TreatmentControl']['tx_method'] == 'procure medication worksheet') {
		if(empty($this->request->data['TreatmentMaster']['start_date']['year'])) {
			$this->TreatmentMaster->validationErrors['start_date'][] = 'the worksheet date has to be completed';
			$submitted_data_validates = false;
		}
	}
	