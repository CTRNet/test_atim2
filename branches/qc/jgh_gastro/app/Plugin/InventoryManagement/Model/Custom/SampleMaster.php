<?php

class SampleMasterCustom extends SampleMaster {	
	var $name = "SampleMaster";
	var $useTable = "sample_masters";

	function validates($options = array()){
		$errors = parent::validates($options);
		if(array_key_exists('qc_gastro_specimen_code', $this->data['SpecimenDetail'])) {
			$validated_code = true;
			switch($this->data['SampleControl']['sample_type']) {
				case 'tissue':
					if(!in_array($this->data['SpecimenDetail']['qc_gastro_specimen_code'], array('T','N'))) $validated_code = false;
					break;
				case 'blood':
					if(!in_array($this->data['SpecimenDetail']['qc_gastro_specimen_code'], array('B'))) $validated_code = false;
					break;
				default:
					AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			if(!$validated_code) {
				$submitted_data_validates = false;
				$this->validationErrors['qc_gastro_specimen_code'] = __('wrong qc gastro specimen code', true);
				return false;	
			}
		}
	
		return $errors;
	}
	
	function specimenSummary($variables=array()) {
		$return = false;
	
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id'])) {
			// Get specimen data
			$criteria = array(
					'SampleMaster.collection_id' => $variables['Collection.id'],
					'SampleMaster.id' => $variables['SampleMaster.initial_specimen_sample_id']);
			$specimen_data = $this->find('first', array('conditions' => $criteria));
				
			// Set summary
			$return = array(
					'menu'				=> array(null, __($specimen_data['SampleControl']['sample_type']) . ' ' . $specimen_data['SpecimenDetail']['qc_gastro_specimen_code'] . ' [' . $specimen_data['SampleMaster']['sample_code'].']'),
					'title' 			=> array(null, __($specimen_data['SampleControl']['sample_type'])),
					'data' 				=> $specimen_data,
					'structure alias' 	=> 'sample_masters,specimens'
			);
		}
	
		return $return;
	}
	
	function derivativeSummary($variables=array()) {
		$return = false;
	
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id']) && isset($variables['SampleMaster.id'])) {
			// Get derivative data
			$criteria = array(
					'SampleMaster.collection_id' => $variables['Collection.id'],
					'SampleMaster.id' => $variables['SampleMaster.id']);
			$derivative_data = $this->find('first', array('conditions' => $criteria));
	
			// Set summary
			$return = array(
					'menu' 				=> array(null, __($derivative_data['SampleControl']['sample_type']) . ' [' . $derivative_data['SampleMaster']['sample_code'].']'),
					'title' 			=> array(null, __($derivative_data['SampleControl']['sample_type'])),
					'data' 				=> $derivative_data,
					'structure alias' 	=> 'sample_masters'
			);
		}
	
		return $return;
	}
	
}

?>
