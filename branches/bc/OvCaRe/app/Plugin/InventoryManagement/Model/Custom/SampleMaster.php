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
			
			$additional_info = '';
			switch($specimen_data['SampleControl']['sample_type']) {
				case 'tissue':
					$tissue_source = $specimen_data['SampleDetail']['tissue_source'];
					
					if($tissue_source) {
						$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
						$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
						$validated_tissue_source = $StructurePermissibleValuesCustom->find('first', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => 'tissue sources', 'StructurePermissibleValuesCustom.value' => $tissue_source)));
						if($validated_tissue_source) $tissue_source = strlen($validated_tissue_source['StructurePermissibleValuesCustom'][$lang])? $validated_tissue_source['StructurePermissibleValuesCustom'][$lang] : $validated_tissue_source['StructurePermissibleValuesCustom']['value'];
					}
					$additional_info = ' '.$tissue_source;
					break;
				case 'blood':
					$additional_info = ' '.__($specimen_data['SampleDetail']['blood_type']);
					break;
			}			
			
			// Set summary	
			$title = __($specimen_data['SampleControl']['sample_type']) . $additional_info . ' [' . $specimen_data['SampleMaster']['sample_code'].']'; 	
	 		$return = array(
				'menu'				=> array(null, $title),
				'title' 			=> array(null, $title),
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
