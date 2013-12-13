<?php
	
	if(!$need_to_save){
		if($collection_data && $collection_data['TreatmentMaster']['id']) {		
			$this->request->data['Collection']['collection_datetime'] = $collection_data['TreatmentMaster']['start_date'];
			$this->request->data['Collection']['collection_datetime_accuracy'] = str_replace('c', 'h', $collection_data['TreatmentMaster']['start_date_accuracy']);
			$this->request->data['Collection']['collection_site'] = $collection_data['TreatmentMaster']['uhn_institution'];
		}
	}

?>
