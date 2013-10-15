<?php
	
	if(!$need_to_save){
		$this->request->data['Collection']['bank_id'] = 1;
		if($collection_data && $collection_data['TreatmentMaster']['id']) {
			$this->request->data['Collection']['collection_datetime'] = $collection_data['TreatmentMaster']['start_date'];
			$this->request->data['Collection']['collection_datetime_accuracy'] = str_replace('c', 'h', $collection_data['TreatmentMaster']['start_date_accuracy']);
		}
	}

?>
