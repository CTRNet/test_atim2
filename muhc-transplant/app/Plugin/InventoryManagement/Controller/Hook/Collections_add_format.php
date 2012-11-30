<?php
	
	if(!$need_to_save && $collection_id) {
		$this->request->data['Collection']['bank_id'] = $collection_data['Participant']['muhc_participant_bank_id'];
		$this->request->data['Collection']['collection_datetime'] = $collection_data['TreatmentMaster']['start_date'];
		$this->request->data['Collection']['collection_datetime_accuracy'] = $collection_data['TreatmentMaster']['start_date_accuracy'];	
	}
