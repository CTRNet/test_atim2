<?php 
	
	//Validate barcode (in case one bank allow barcode modification)
	if(Configure::read('procure_atim_version') == 'PROCESSING') {
		if(!preg_match('/^[0-9]+$/', $this->request->data['AliquotMaster']['barcode'])) {
			$this->AliquotMaster->validationErrors['barcode'][] = __('aliquot barcode format errror - integer value expected');
			$submitted_data_validates = false;
		}
	} else {
		$procure_participant_identifier = $aliquot_data['ViewAliquot']['participant_identifier'];
		$procure_visit = $aliquot_data['ViewAliquot']['procure_visit'];
		if(!preg_match('/^'.$procure_participant_identifier.' '.$procure_visit.' /', $this->request->data['AliquotMaster']['barcode'])) {
			$this->AliquotMaster->validationErrors['barcode'][] = __('aliquot barcode format errror - should begin with the participant identifier and the visit PS0P0000 V00');
			$submitted_data_validates = false;
		}
	}
