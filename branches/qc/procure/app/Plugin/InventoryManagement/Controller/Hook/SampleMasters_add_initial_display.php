<?php 

	if(isset(AppController::getInstance()->passedArgs['templateInitId'])) {
		
		//--------------------------------------------------------------------------------
		//  BLOOD
		//--------------------------------------------------------------------------------
		
		if($sample_control_data['SampleControl']['sample_type'] == 'blood') {
			$collection_blood_samples = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_control_id' => $sample_control_data['SampleControl']['id']), 'order' => array('SpecimenDetail.reception_datetime DESC'), 'recursive' => '0'));
			if(!empty($collection_blood_samples)) {				
				// Collection blood sample already created
				$already_created = array();			
				foreach($collection_blood_samples as $new_blood) {
					$already_created[$new_blood['SampleDetail']['blood_type']] = $new_blood['SampleDetail']['blood_type'];
				}
				if(!in_array('serum', $already_created)) {
					$this->request->data['SampleDetail']['blood_type'] = 'serum';
				} else if(!in_array('paxgene', $already_created)) {
					$this->request->data['SampleDetail']['blood_type'] = 'paxgene';
				} else  if(!in_array('k2-EDTA', $already_created)) {
					$this->request->data['SampleDetail']['blood_type'] = 'k2-EDTA';
				}
				
				$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_blood_samples[0]['SpecimenDetail']['reception_datetime'];
				$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $collection_blood_samples[0]['SpecimenDetail']['reception_datetime_accuracy'];
				
				$this->request->data['SampleDetail']['procure_collection_site'] = $collection_blood_samples[0]['SampleDetail']['procure_collection_site'];
				$this->request->data['SampleDetail']['procure_collection_without_incident'] = $collection_blood_samples[0]['SampleDetail']['procure_collection_without_incident'];
				$this->request->data['SampleDetail']['procure_tubes_inverted_8_10_times'] = $collection_blood_samples[0]['SampleDetail']['procure_tubes_inverted_8_10_times'];
				$this->request->data['SampleDetail']['procure_tubes_correclty_stored'] = $collection_blood_samples[0]['SampleDetail']['procure_tubes_correclty_stored'];
				
			} else {
				// No collection blood sample already created
				$collection = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id)));
				$this->request->data['SpecimenDetail']['reception_datetime'] = $collection['Collection']['collection_datetime'];
				$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $collection['Collection']['collection_datetime_accuracy'];
				
				$this->request->data['SampleDetail']['blood_type'] = 'serum';
			}
			
		} else if(in_array($sample_control_data['SampleControl']['sample_type'], array('plasma','serum','pbmc'))) {
			
		//--------------------------------------------------------------------------------
		//  SERUM, PLASMA, PBMC
		//--------------------------------------------------------------------------------
			$this->request->data['DerivativeDetail']['creation_datetime'] = $parent_sample_data['SpecimenDetail']['reception_datetime'];
			$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'];
		}
	}

?>