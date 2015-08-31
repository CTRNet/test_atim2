<?php 
	
	if($event_control_data['EventControl']['event_type'] == 'procure follow-up worksheet') {
		if(empty($this->request->data['EventMaster']['event_date']['year'])) {
			$this->EventMaster->validationErrors['event_date'][] = 'the visite date has to be completed';
			$submitted_data_validates = false;
		}
	}

	$this->EventMaster->addWritableField('procure_created_by_bank');
	if(!$event_control_data['EventControl']['use_addgrid']) {
		$this->request->data['EventMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
	} else {
		foreach($this->request->data as &$data_unit){
			$data_unit['EventMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
		}
	}
	