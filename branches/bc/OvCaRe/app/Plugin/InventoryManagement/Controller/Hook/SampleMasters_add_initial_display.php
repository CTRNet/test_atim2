<?php

// Default Data
switch($sample_control_data['SampleControl']['sample_type']) {
	case 'tissue':
		$this->request->data['SampleDetail']['ovcare_tissue_type'] = 'tumour';
		break;
	case 'plasma':
	case 'serum':
	case 'buffy coat':
		$this->request->data['DerivativeDetail']['creation_datetime'] = $parent_sample_data['SpecimenDetail']['reception_datetime'];
		$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'];
		$this->request->data['DerivativeDetail']['creation_by'] = $parent_sample_data['SpecimenDetail']['reception_by'];
		break;
}

//Default Data Template Dependent
if(isset(AppController::getInstance()->passedArgs['templateInitId'])) {
	$template_init_data = AppController::getInstance()->Session->read('Template.init_data.'.AppController::getInstance()->passedArgs['templateInitId']);
	switch($sample_control_data['SampleControl']['sample_type']) {
		case 'blood':
			$nbr_of_blood_samples = $this->SampleMaster->find('count', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleControl.sample_type' => 'blood'), 'recursive' => '0'));
			if(!$nbr_of_blood_samples) {
				//First Blood we expect should be EDTA
				$this->request->data['SampleDetail']['blood_type'] = 'EDTA';
				if(array_key_exists('0', $template_init_data) && array_key_exists('ovcare_collected_tube_nbr_blood_edta', $template_init_data['0'])) {
					$this->request->data['SampleDetail']['collected_volume'] = $template_init_data['0']['ovcare_collected_volume_blood_edta'];
					$this->request->data['SampleDetail']['collected_volume_unit'] = $template_init_data['0']['ovcare_collected_volume_unit_blood_edta'];
					$this->request->data['SampleDetail']['collected_tube_nbr'] = $template_init_data['0']['ovcare_collected_tube_nbr_blood_edta'];
				}
			} else if($nbr_of_blood_samples == '1') {
				$this->request->data['SampleDetail']['blood_type'] = 'serum';
				if(array_key_exists('0', $template_init_data) && array_key_exists('ovcare_collected_tube_nbr_blood_serum', $template_init_data['0'])) {
					$this->request->data['SampleDetail']['collected_volume'] = $template_init_data['0']['ovcare_collected_volume_blood_serum'];
					$this->request->data['SampleDetail']['collected_volume_unit'] = $template_init_data['0']['ovcare_collected_volume_unit_blood_serum'];
					$this->request->data['SampleDetail']['collected_tube_nbr'] = $template_init_data['0']['ovcare_collected_tube_nbr_blood_serum'];
				}
			}
			break;
		case 'buffy coat':
			$tmp_datetime = $template_init_data['0']['ovcare_creation_datetime_buffy_coat'];
			$this->request->data['DerivativeDetail']['creation_datetime'] = $tmp_datetime['year'].'-'.$tmp_datetime['month'].'-'.$tmp_datetime['day'].' '.$tmp_datetime['hour'].':'.$tmp_datetime['min'];
		case 'plasma':
		case 'serum':
			if(array_key_exists('0', $template_init_data) && array_key_exists('ovcare_ischemia_time_mn_plasma_serum', $template_init_data['0'])) {
				if($sample_control_data['SampleControl']['sample_type'] != 'buffy coat') {
					$this->request->data['SampleDetail']['ovcare_ischemia_time_mn'] = $template_init_data['0']['ovcare_ischemia_time_mn_plasma_serum'];;
				} else {
					$this->request->data['SampleDetail']['ovcare_ischemia_time_mn'] = $template_init_data['0']['ovcare_ischemia_time_mn_buffy_coat'];;
				}
			}
			break;
	}
}


?>
