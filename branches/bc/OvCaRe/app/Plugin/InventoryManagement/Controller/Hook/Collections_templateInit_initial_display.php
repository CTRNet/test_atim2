<?php

// Set Default Values
if($template) {
	$collection_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id), 'recursive' => '-1'));
	switch($template['Template']['name']) {
		case 'Blood collection':
			$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_data? $collection_data['Collection']['collection_datetime'] : '';
			$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $collection_data? $collection_data['Collection']['collection_datetime_accuracy'] : '';
			$this->request->data['0']['ovcare_creation_datetime_buffy_coat'] = $collection_data? $collection_data['Collection']['collection_datetime'] : '';
			$this->request->data['0']['ovcare_creation_datetime_buffy_coat_accuracy'] = $collection_data? $collection_data['Collection']['collection_datetime_accuracy'] : '';
			$this->request->data['0']['ovcare_collected_tube_nbr_blood_edta'] = '2';
			$this->request->data['0']['ovcare_collected_volume_blood_edta'] = '12.0';
			$this->request->data['0']['ovcare_collected_volume_unit_blood_edta'] = 'ml';
			$this->request->data['0']['ovcare_collected_tube_nbr_blood_serum'] = '1';
			$this->request->data['0']['ovcare_collected_volume_blood_serum'] = '6.0';
			$this->request->data['0']['ovcare_collected_volume_unit_blood_serum'] = 'ml';
			break;
		case 'Tissue collection':
			$this->request->data['SpecimenDetail']['reception_by'] = 'Margaret Luk';
			$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_data? $collection_data['Collection']['collection_datetime'] : '';
			$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $collection_data? $collection_data['Collection']['collection_datetime_accuracy'] : '';
			$this->request->data['AliquotDetail']['block_type'] = "paraffin";
			break;
		case 'Endometriosis Study':
			$this->request->data['SpecimenDetail']['reception_by'] = 'Margaret Luk';
			$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_data? $collection_data['Collection']['collection_datetime'] : '';
			$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $collection_data? $collection_data['Collection']['collection_datetime_accuracy'] : '';
			$this->request->data['AliquotDetail']['block_type'] = "MFPE";
			$study_model = AppModel::getInstance('Study', 'StudySummary');
			$endometriosis_study = $study_model->find('first', array('conditions' => array("StudySummary.title LIKE 'endometriosis'")));
			if($endometriosis_study) $this->request->data['FunctionManagement']['autocomplete_aliquot_master_study_summary_id'] = $study_model->getStudyDataAndCodeForDisplay(array('StudySummary' => array('id' => $endometriosis_study['StudySummary']['id'])));
			break;
	}
}

?>
