<?php 
		
	//Note there is no interest to add control for CENTRAL BANK because data will be erased
	if(Configure::read('procure_atim_version') != 'BANK') {
		if($sample_control_data['SampleControl']['sample_category'] == 'specimen') {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		} else if($parent_sample_data['SampleMaster']['procure_created_by_bank'] != 'p'){
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	}
	
	//--------------------------------------------------------------------------------
	//  BLOOD
	//--------------------------------------------------------------------------------
	
	if($sample_control_data['SampleControl']['sample_type'] == 'blood') {
		$collection_blood_types = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_control_id' => $sample_control_data['SampleControl']['id']), 'fields' => array("GROUP_CONCAT(SampleDetail.blood_type SEPARATOR ',') as blood_types"), 'recursive' => '0'));
		$last_received_blood_sample = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_control_id' => $sample_control_data['SampleControl']['id']), 'order' => array('SpecimenDetail.reception_datetime DESC'), 'recursive' => '0'));	
		if(!empty($last_received_blood_sample)) {				
			// Collection blood sample already created
			$already_created = explode(',',$collection_blood_types[0][0]['blood_types']);
			if(!in_array('serum', $already_created)) {
				$this->request->data['SampleDetail']['blood_type'] = 'serum';
			} else if(!in_array('paxgene', $already_created)) {
				$this->request->data['SampleDetail']['blood_type'] = 'paxgene';
			} else  if(!in_array('k2-EDTA', $already_created)) {
				$this->request->data['SampleDetail']['blood_type'] = 'k2-EDTA';
			}
			
			$this->request->data['SpecimenDetail']['reception_datetime'] = $last_received_blood_sample['SpecimenDetail']['reception_datetime'];
			$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $last_received_blood_sample['SpecimenDetail']['reception_datetime_accuracy'];
			
			$this->request->data['SampleDetail']['procure_collection_site'] = $last_received_blood_sample['SampleDetail']['procure_collection_site'];
			
		} else {
			// No collection blood sample already created
			$this->ViewCollection = AppModel::getInstance("InventoryManagement", "ViewCollection", true);
			$collection = $this->ViewCollection->find('first', array('conditions' => array('ViewCollection.collection_id' => $collection_id), 'recursive' => '-1'));
		
			$this->request->data['SpecimenDetail']['reception_datetime'] = $collection['ViewCollection']['collection_datetime'];
			$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = ($collection['ViewCollection']['collection_datetime_accuracy'] == 'c')? 'h' : $collection['ViewCollection']['collection_datetime_accuracy'];
			
			$this->request->data['SampleDetail']['procure_collection_site'] = 'clinic';
			
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
				$this->request->data['SampleDetail']['urine_aspect'] = 'clear';
				$this->request->data['SampleDetail']['procure_hematuria'] = 'n';
				$this->request->data['SampleDetail']['procure_collected_via_catheter'] = 'n';
				$this->request->data['SampleDetail']['collected_volume_unit'] = 'ml';
				break;
			case 'tissue':
				$participant_identifier = empty($collection['ViewCollection']['participant_identifier'])? '?' : $collection['ViewCollection']['participant_identifier'];
				$this->request->data['SampleDetail']['procure_tissue_identification'] = $participant_identifier. ' ' . $collection['ViewCollection']['procure_visit'] . ' -PST1';
				break;			
		}
		
		$this->request->data['SpecimenDetail']['reception_datetime'] = $collection['ViewCollection']['collection_datetime'];
		$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = ($collection['ViewCollection']['collection_datetime_accuracy'] == 'c')? 'h' : $collection['ViewCollection']['collection_datetime_accuracy'];
		
	} else if(in_array($sample_control_data['SampleControl']['sample_type'], array('plasma','serum','pbmc','buffy coat'))) {
		
		//--------------------------------------------------------------------------------
		//  SERUM, PLASMA, PBMC, Buffy coat
		//--------------------------------------------------------------------------------
		
		$sample_control_ids = $this->SampleControl->find('list', array('conditions' => array('sample_type' => array('serum', 'plasma', 'buffy coat', 'pbmc'))));
		$collection_blood_derivatives = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleMaster.sample_control_id' => $sample_control_ids), 'order' => array('DerivativeDetail.creation_datetime DESC'), 'recursive' => '0'));
		if($collection_blood_derivatives) {
			$this->request->data['DerivativeDetail']['creation_datetime'] = $collection_blood_derivatives['DerivativeDetail']['creation_datetime'];
			$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $collection_blood_derivatives['DerivativeDetail']['creation_datetime_accuracy'];
		} else {
			$this->request->data['DerivativeDetail']['creation_datetime'] = $parent_sample_data['SpecimenDetail']['reception_datetime'];
			$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = ($parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'] == 'c')? 'h' : $parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'];
		}
		
	} else if(in_array($sample_control_data['SampleControl']['sample_type'], array('centrifuged urine'))) {
		
		//--------------------------------------------------------------------------------
		//  CENT. URINE
		//--------------------------------------------------------------------------------
		
		$this->request->data['DerivativeDetail']['creation_datetime'] = $parent_sample_data['SpecimenDetail']['reception_datetime'];
		$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = ($parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'] == 'c')? 'h' : $parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'];
		$this->request->data['DerivativeDetail']['procure_pellet_volume_ml'] = '50';

	}
		
?>