<?php
	
	if($is_specimen) {
		if(!isset(AppController::getInstance()->passedArgs['templateInitId'])){
			if(isset($sample) && $sample) {
				//A specimen has already be created
				$this->request->data['SpecimenDetail']['reception_by'] = $sample['SpecimenDetail']['reception_by'];
			} else {
				//First Specimen
				if($sample_control_data['SampleControl']['sample_type'] == 'tissue') $this->request->data['SpecimenDetail']['reception_by'] = 'margaret luk';
			}
		}
		if($sample_control_data['SampleControl']['sample_type'] == 'blood') {
			$this->request->data['SampleDetail']['collected_volume'] = '6.0';
			$this->request->data['SampleDetail']['collected_volume_unit'] = 'ml';
			$tmp_existing_bloods = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleControl.sample_type' => 'blood'), 'recursive' => '0'));
			$existing_bloods = array();
			foreach($tmp_existing_bloods as $tmp_sample) {
					if(in_array($tmp_sample['SampleDetail']['blood_type'], array('EDTA', 'serum'))) $existing_bloods[] = $tmp_sample;
			}
			if(empty($existing_bloods)) {
				//First Blood we expect should be EDTA
				$this->request->data['SampleDetail']['blood_type'] = 'EDTA';
				$this->request->data['SampleDetail']['collected_tube_nbr'] = '2';
			} else if(sizeof($existing_bloods) == 1) {
				if($existing_bloods[0]['SampleDetail']['blood_type'] == 'EDTA') {
					$this->request->data['SampleDetail']['blood_type'] = 'serum';
					$this->request->data['SampleDetail']['collected_tube_nbr'] = '1';
				} else {
					//If no EDTA or SERUM, First Blood we expect should be EDTA
					$this->request->data['SampleDetail']['blood_type'] = 'EDTA';
					$this->request->data['SampleDetail']['collected_tube_nbr'] = '2';
				}			
			}
		}			
	} else if(in_array($sample_control_data['SampleControl']['sample_type'], array('plasma','blood cell','serum'))) {
		$last_derivative_crated = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleControl.sample_type' => array('plasma','blood cell','serum')), 'order' => array('SampleMaster.id DESC')));
		if($last_derivative_crated) {
			$this->request->data['DerivativeDetail']['creation_datetime'] = $last_derivative_crated['DerivativeDetail']['creation_datetime'];
			$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $last_derivative_crated['DerivativeDetail']['creation_datetime_accuracy'];
			$this->request->data['DerivativeDetail']['creation_by'] = $last_derivative_crated['DerivativeDetail']['creation_by'];
		} else if($parent_sample_data) {
			$this->request->data['DerivativeDetail']['creation_datetime'] = $parent_sample_data['SpecimenDetail']['reception_datetime'];
			$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'];
			$this->request->data['DerivativeDetail']['creation_by'] = $parent_sample_data['SpecimenDetail']['reception_by'];
		}
	}	
	
?>
