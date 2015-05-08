<?php

if($template) {
	$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id), 'recursive' => '-1'));
	$collection_datetime = '';
	if($collection_data) {
		$collection_datetime = $collection_data['Collection']['collection_datetime'];
		switch($collection_data['Collection']['collection_datetime_accuracy']) {
			case 'y':
			case 'm':
				$collection_datetime = substr($collection_datetime, 0, 4);
				break;
			case 'd':
				$collection_datetime = substr($collection_datetime, 0, 7);
				break;
			case 'h':
				$collection_datetime = substr($collection_datetime, 0, 10);
				break;
			case 'i':
				$collection_datetime = substr($collection_datetime, 0, 13);
				break;
		}
	} 
	switch($template['Template']['name']) {
		case 'Blood collection':
			$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_datetime;
			$this->request->data['0']['ovcare_collected_tube_nbr_blood_edta'] = '2';
			$this->request->data['0']['ovcare_collected_volume_blood_edta'] = '12.0';
			$this->request->data['0']['ovcare_collected_volume_unit_blood_edta'] = 'ml';
			$this->request->data['0']['ovcare_collected_tube_nbr_blood_serum'] = '1';
			$this->request->data['0']['ovcare_collected_volume_blood_serum'] = '6.0';
			$this->request->data['0']['ovcare_collected_volume_unit_blood_serum'] = 'ml';
			break;
		case 'Tissue collection':
			$this->request->data['SpecimenDetail']['reception_by'] = 'Margaret Luk';
			$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_datetime;
			$this->request->data['AliquotDetail']['block_type'] = "paraffin";
			break;
		case 'Endometriosis Study':
			$this->request->data['SpecimenDetail']['reception_by'] = 'Margaret Luk';
			$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_datetime;
			$this->request->data['AliquotDetail']['block_type'] = "MFPE";
			break;
	}
}

?>
