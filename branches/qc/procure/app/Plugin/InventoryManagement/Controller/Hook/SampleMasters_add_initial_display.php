<?php 

//	if(isset(AppController::getInstance()->passedArgs['templateInitId'])) {
		
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
				$this->ViewCollection = AppModel::getInstance("InventoryManagement", "ViewCollection", true);
				$collection = $this->ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id), 'recursive' => '-1'));
			
				$this->request->data['SpecimenDetail']['reception_datetime'] = $collection['ViewCollection']['collection_datetime'];
				$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = 'h';
				
				$this->request->data['SampleDetail']['blood_type'] = 'serum';
			}
	
		} else if(in_array($sample_control_data['SampleControl']['sample_type'], array('urine', 'tissue'))) {
			
			//--------------------------------------------------------------------------------
			//  URINE
			//--------------------------------------------------------------------------------
			
			$this->ViewCollection = AppModel::getInstance("InventoryManagement", "ViewCollection", true);
			$collection = $this->ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id), 'recursive' => '-1'));
			
			switch($sample_control_data['SampleControl']['sample_type']) {
				case 'urine':
					$this->request->data['SampleDetail']['collected_volume_unit'] = 'ml';
					break;
				case 'tissue':
					$participant_identifier = empty($collection['ViewCollection']['participant_identifier'])? '?' : $collection['ViewCollection']['participant_identifier'];
					$this->request->data['SampleDetail']['procure_tissue_identification'] = $participant_identifier. ' V01 -PST1';
					break;			
			}
			
			$this->request->data['SpecimenDetail']['reception_datetime'] = $collection['ViewCollection']['collection_datetime'];
			$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = 'h';
			
		} else if(in_array($sample_control_data['SampleControl']['sample_type'], array('plasma','serum','pbmc','centrifuged urine'))) {
			
			//--------------------------------------------------------------------------------
			//  SERUM, PLASMA, PBMC, CENT. URINE
			//--------------------------------------------------------------------------------
			
			$this->request->data['DerivativeDetail']['creation_datetime'] = $parent_sample_data['SpecimenDetail']['reception_datetime'];
			$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] =  'h';
			
		}
//	}
		
?>