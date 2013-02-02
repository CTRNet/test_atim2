<?php

	if(in_array($sample_control_data['SampleControl']['sample_type'], array('pbmc','serum','plasma'))) {
		$this->request->data['DerivativeDetail']['creation_by'] = $parent_sample_data['SpecimenDetail']['reception_by'];
		$this->request->data['DerivativeDetail']['creation_datetime'] = $parent_sample_data['SpecimenDetail']['reception_datetime'];
		$this->request->data['DerivativeDetail']['creation_datetime_accuracy'] = $parent_sample_data['SpecimenDetail']['reception_datetime_accuracy'];		
	} else if($sample_control_data['SampleControl']['sample_type'] == 'blood') {
		$collection_bloods = $this->SampleMaster->find('all', array('conditions' => array('SampleMaster.collection_id' => $collection_id, 'SampleControl.sample_type' => 'blood'), 'recursive' => '0', 'order' => array('SampleMaster.created DESC')));
		if(!empty($collection_bloods)) {
			$this->request->data['SpecimenDetail']['muhc_person_collecting_specimen'] = $collection_bloods[0]['SpecimenDetail']['muhc_person_collecting_specimen'];
			$this->request->data['SpecimenDetail']['reception_by'] = $collection_bloods[0]['SpecimenDetail']['reception_by'];
			$this->request->data['SpecimenDetail']['reception_datetime'] = $collection_bloods[0]['SpecimenDetail']['reception_datetime'];
			$this->request->data['SpecimenDetail']['reception_datetime_accuracy'] = $collection_bloods[0]['SpecimenDetail']['reception_datetime_accuracy'];
				
			$this->request->data['SampleDetail']['muhc_person_drawing_blood'] = $collection_bloods[0]['SampleDetail']['muhc_person_drawing_blood'];
			$this->request->data['SampleDetail']['muhc_type_of_procedure'] = $collection_bloods[0]['SampleDetail']['muhc_type_of_procedure'];
			$this->request->data['SampleDetail']['muhc_patient_status'] = $collection_bloods[0]['SampleDetail']['muhc_patient_status'];
			$this->request->data['SampleDetail']['muhc_patient_status_precision'] = $collection_bloods[0]['SampleDetail']['muhc_patient_status_precision'];
			$this->request->data['SampleDetail']['muhc_type_of_blood_draw'] = $collection_bloods[0]['SampleDetail']['muhc_type_of_blood_draw'];
			$this->request->data['SampleDetail']['muhc_type_of_blood_draw_precision'] = $collection_bloods[0]['SampleDetail']['muhc_type_of_blood_draw_precision'];
		}
	}
	