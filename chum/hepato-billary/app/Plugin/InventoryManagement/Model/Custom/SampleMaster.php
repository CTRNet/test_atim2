<?php
class SampleMasterCustom extends SampleMaster{
	var $useTable = 'sample_masters';
	var $name = 'SampleMaster';
	
	function specimenSummary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id'])) {
			// Get specimen data
			$criteria = array(
				'SampleMaster.collection_id' => $variables['Collection.id'],
				'SampleMaster.id' => $variables['SampleMaster.initial_specimen_sample_id']);
			$this->unbindModel(array('hasMany' => array('AliquotMaster')));
			$specimen_data = $this->find('first', array('conditions' => $criteria, 'recursive' => '0'));
			
			$sample_precision = '';
			if(array_key_exists('blood_type', $specimen_data['SampleDetail']) && $specimen_data['SampleDetail']['blood_type']) {
				$query = array(
					'recursive' => 2, 
					'conditions' => array('StructureValueDomain.domain_name' => 'blood_type'));
				App::uses("StructureValueDomain", 'Model');
				$structure_value_domain_model = new StructureValueDomain();
				$blood_types_list = $structure_value_domain_model->find('first', $query);
				if(isset($blood_types_list['StructurePermissibleValue'])) {
					foreach($blood_types_list['StructurePermissibleValue'] as $new_type) if($new_type['value'] == $specimen_data['SampleDetail']['blood_type']) $sample_precision = ' - '.__($new_type['language_alias']);
				}
			}
			
			// Set summary	 	
	 		$return = array(
				'menu'				=> array(null, __($specimen_data['SampleControl']['sample_type']) . $sample_precision . ' [' . $specimen_data['SampleMaster']['sample_code'].']'),
				'title' 			=> array(null, __($specimen_data['SampleControl']['sample_type']) . ' [' . $specimen_data['SampleMaster']['sample_code'].']'),
				'data' 				=> $specimen_data,
	 			'structure alias' 	=> 'sample_masters'
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
			$this->unbindModel(array('hasMany' => array('AliquotMaster')));
			$derivative_data = $this->find('first', array('conditions' => $criteria, 'recursive' => '0'));
				 	
			// Set summary	 	
	 		$return = array(
					'menu' 				=> array(null, __($derivative_data['SampleControl']['sample_type']) . ' [' . $derivative_data['SampleMaster']['sample_code'].']'),
					'title' 			=> array(null, __($derivative_data['SampleControl']['sample_type']) . ' [' . $derivative_data['SampleMaster']['sample_code'].']'),
					'data' 				=> $derivative_data,
	 				'structure alias' 	=> 'sample_masters'
			);
		}	
		
		return $return;
	}
}
