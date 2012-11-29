<?php

class SampleMasterCustom extends SampleMaster {
	
	var $useTable = 'sample_masters';	
	var $name = 'SampleMaster';	
	
	function specimenSummary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id'])) {
			// Get specimen data
			$criteria = array(
				'SampleMaster.collection_id' => $variables['Collection.id'],
				'SampleMaster.id' => $variables['SampleMaster.initial_specimen_sample_id']);
			$specimen_data = $this->find('first', array('conditions' => $criteria, 'recursive' => '0'));
			
			$title_precision = '';
			if(isset($specimen_data['SampleDetail']['blood_type'])) {
				$title_precision = ' '.__($specimen_data['SampleDetail']['blood_type']);
			} else if(isset($specimen_data['SampleDetail']['tissue_source'])) {
				$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
				$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
				
				$conditions = array('StructurePermissibleValuesCustomControl.name' => 'tissue source', 'StructurePermissibleValuesCustom.value' => $specimen_data['SampleDetail']['tissue_source']);
				$tmp_res = $StructurePermissibleValuesCustom->find('first', array('conditions' => $conditions));
				$title_precision = ' '.(strlen($tmp_res['StructurePermissibleValuesCustom'][$lang])? $tmp_res['StructurePermissibleValuesCustom'][$lang] : $tmp_res['StructurePermissibleValuesCustom']['value']);
				
				if(!empty($specimen_data['SampleDetail']['muhc_liver_segment'])) {
					$conditions = array('StructurePermissibleValuesCustomControl.name' => 'liver segment', 'StructurePermissibleValuesCustom.value' => $specimen_data['SampleDetail']['muhc_liver_segment']);
					$tmp_res = $StructurePermissibleValuesCustom->find('first', array('conditions' => $conditions));				
					$title_precision .= ' '.(strlen($tmp_res['StructurePermissibleValuesCustom'][$lang])? $tmp_res['StructurePermissibleValuesCustom'][$lang] : $tmp_res['StructurePermissibleValuesCustom']['value']);
				}
			}			
			
			// Set summary	 	
	 		$return = array(
				'menu'				=> array(null, __($specimen_data['SampleControl']['sample_type'], true) . $title_precision . ' : ' . $specimen_data['SampleMaster']['sample_code']),
				'title' 			=> array(null, __($specimen_data['SampleControl']['sample_type'], true) . $title_precision . ' : ' . $specimen_data['SampleMaster']['sample_code']),
				'data' 				=> $specimen_data,
	 			'structure alias' 	=> 'sample_masters_for_search_result'
			);
		}	
		
		return $return;
	}
	
	function validatePaxgeneTubesFields($sample_control_data, $sample_data){
		$process_validates= true; 
		if($sample_control_data['SampleControl']['sample_type'] == 'blood') {
			if(($sample_data['SampleDetail']['blood_type'] != 'paxgene') && strlen($sample_data['SampleDetail']['muhc_paxgene_person_processing'].$sample_data['SampleDetail']['muhc_paxgen_storage_at_minus_20'])) {
				$process_validates= false;
				$this->validationErrors['blood_type'][] = 'paxgene tube fields should only be completed when type selected is equal to paxgene';
			}
		}
		return $process_validates;
	}
	

}

?>