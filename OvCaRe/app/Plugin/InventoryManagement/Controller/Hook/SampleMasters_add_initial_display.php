<?php
	
	if($is_specimen) {
		if(!isset(AppController::getInstance()->passedArgs['templateInitId'])){
			if(isset($sample) && $sample) {
				$this->request->data['SpecimenDetail']['reception_by'] = $sample['SpecimenDetail']['reception_by'];
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
