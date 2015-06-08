<?php

	if ($sample_control_data['SampleControl']['sample_category'] == 'specimen' && !empty($collection_data['Collection']['collection_datetime'])) {
		$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_data['Collection']['collection_datetime'];
		$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = in_array($collection_data['Collection']['collection_datetime_accuracy'], array('i','c'))? 'h' : $collection_data['Collection']['collection_datetime_accuracy'];
	}

//TODO: To un-comment if user requests this specific change
//	$tmp_session_data = $this->passedArgs;
//	$tmp_template_session_data = isset($tmp_session_data['templateInitId'])? $this->Session->read('Template.init_data.'.$tmp_session_data['templateInitId']) : array();
// 	$qc_ladyis_blood_meta_template = (isset($tmp_template_session_data['FunctionManagement']['qc_ladyis_blood_meta_template']) && $tmp_template_session_data['FunctionManagement']['qc_ladyis_blood_meta_template'])? true : false;
	
	// *********** BLOOD ***********
	
 	if ($sample_control_data['SampleControl']['sample_type'] == 'blood') {
 		$this->request->data['SampleDetail']['collected_volume_unit'] = 'ml';
 		
 		$this->request->data['SampleMaster']['sop_master_id'] = $collection_data['Collection']['sop_master_id'];
 		$this->request->data['SampleMaster']['qc_lady_sop_followed'] = $collection_data['Collection']['qc_lady_sop_followed'];
 		$this->request->data['SampleMaster']['qc_lady_sop_deviations'] = $collection_data['Collection']['qc_lady_sop_deviations'];
 		
// 		if($qc_ladyis_blood_meta_template) {
 			$existing_collection_bloods = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleControl.sample_type' => 'blood'), 'order' => 'SampleMaster.id DESC',  'recursive' => 0));
 			switch(sizeof($existing_collection_bloods)) {
 				case '0':
 					$this->request->data['SampleDetail']['blood_type'] = 'EDTA';
 					$this->request->data['SpecimenDetail']['reception_by'] = 'Urszula Krzemien';
					$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_data['Collection']['collection_datetime'];
					$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $collection_data['Collection']['collection_datetime_accuracy'];
					$this->request->data['SampleDetail']['collected_tube_nbr'] = '3';
					break;

 				case '1':
 					$this->request->data['SampleDetail']['blood_type'] = 'CTAD';
 					$this->request->data['SpecimenDetail']['supplier_dept'] = $existing_collection_bloods[0]['SpecimenDetail']['supplier_dept'];
 					$this->request->data['SpecimenDetail']['reception_by'] = $existing_collection_bloods[0]['SpecimenDetail']['reception_by'];
 					$this->request->data['SpecimenDetail']['reception_datetime'] = $existing_collection_bloods[0]['SpecimenDetail']['reception_datetime'];
					$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $existing_collection_bloods[0]['SpecimenDetail']['reception_datetime_accuracy'];
					$this->request->data['SampleMaster']['sop_master_id'] = $existing_collection_bloods[0]['SampleMaster']['sop_master_id'];
					$this->request->data['SampleMaster']['qc_lady_sop_followed'] = $existing_collection_bloods[0]['SampleMaster']['qc_lady_sop_followed'];
					$this->request->data['SampleMaster']['qc_lady_sop_deviations'] = $existing_collection_bloods[0]['SampleMaster']['qc_lady_sop_deviations'];
					$this->request->data['SampleDetail']['collected_tube_nbr'] = '1';
					break;

 				case '2':
 					$this->request->data['SampleDetail']['blood_type'] = 'serum';
 					$this->request->data['SpecimenDetail']['supplier_dept'] = $existing_collection_bloods[0]['SpecimenDetail']['supplier_dept'];
 					$this->request->data['SpecimenDetail']['reception_by'] = $existing_collection_bloods[0]['SpecimenDetail']['reception_by'];
 					$this->request->data['SpecimenDetail']['reception_datetime'] = $existing_collection_bloods[0]['SpecimenDetail']['reception_datetime'];
					$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $existing_collection_bloods[0]['SpecimenDetail']['reception_datetime_accuracy'];
					$this->request->data['SampleMaster']['sop_master_id'] = $existing_collection_bloods[0]['SampleMaster']['sop_master_id'];
					$this->request->data['SampleMaster']['qc_lady_sop_followed'] = $existing_collection_bloods[0]['SampleMaster']['qc_lady_sop_followed'];
					$this->request->data['SampleMaster']['qc_lady_sop_deviations'] = $existing_collection_bloods[0]['SampleMaster']['qc_lady_sop_deviations'];
 					$this->request->data['SampleDetail']['collected_tube_nbr'] = '1';
					break;

 				default:
 			}
// 		}

 	// *********** PBMC, SERUM, PLASMA ***********		
 			
 	} else if(in_array($sample_control_data['SampleControl']['sample_type'], array('pbmc','serum','plasma'))) {
 		$existing_blood_derivative = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleControl.sample_type' => array('pbmc','serum','plasma')), 'order' => 'SampleMaster.id DESC',  'recursive' => 0));
 		if($existing_blood_derivative) {
 			$this->request->data['DerivativeDetail']['creation_by'] = $existing_blood_derivative['DerivativeDetail']['creation_by'];
 			$this->request->data['DerivativeDetail']['creation_datetime'] = $existing_blood_derivative['DerivativeDetail']['creation_datetime'];
 			$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $existing_blood_derivative['DerivativeDetail']['creation_datetime_accuracy'];
 		} else {
 			$this->request->data['DerivativeDetail']['creation_by'] = $parent_sample_data['SpecimenDetail']['reception_by'];
 			$this->request->data['DerivativeDetail']['creation_datetime'] = $parent_sample_data['SpecimenDetail']['reception_datetime'];
 			$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'];
 		}
	}

