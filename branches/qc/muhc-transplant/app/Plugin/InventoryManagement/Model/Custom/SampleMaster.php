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
	 			'structure alias' 	=> 'sample_masters_for_search_result'.(($specimen_data['SampleControl']['sample_type'] == 'tissue')? ',muhc_tissue_summary': '')
			);
		}	
		
		return $return;
	}
	
	function validatePaxgeneTubesFields($sample_control_data, $sample_data){
		$process_validates= true; 
		if($sample_control_data['SampleControl']['sample_type'] == 'blood') {
			if(($sample_data['SampleDetail']['blood_type'] != 'paxgene') && strlen($sample_data['SampleDetail']['muhc_paxgene_person_processing'].$sample_data['SampleDetail']['muhc_paxgen_storage_at_minus_20'].$sample_data['SampleDetail']['muhc_paxgen_storage_at_minus_80'])) {
				$process_validates= false;
				$this->validationErrors['blood_type'][] = 'paxgene tube fields should only be completed when type selected is equal to paxgene';
			}
		}
		return $process_validates;
	}
	
	function addMuhcPrecisionForTreeView(&$samples_list) {
		$StructurePermissibleValuesCustom_model = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
		$conditions = array('StructurePermissibleValuesCustomControl.name' => array('tissue source', 'tissue type'));
		$tmp_res = $StructurePermissibleValuesCustom_model->find('all', array('conditions' => $conditions));
		$str_permis_values_custom = array();
		foreach($tmp_res as $new_res) {
			$str_permis_values_custom[$new_res['StructurePermissibleValuesCustomControl']['name']][$new_res['StructurePermissibleValuesCustom']['value']] = (strlen($new_res['StructurePermissibleValuesCustom'][$lang])? $new_res['StructurePermissibleValuesCustom'][$lang] : $new_res['StructurePermissibleValuesCustom']['value']);
		}
		
		foreach($samples_list as &$new_sample) {
			$muhc_precisions = array();
			if(isset($new_sample['SampleDetail'])) {
				if(isset($new_sample['SampleDetail']['tissue_source']) && $new_sample['SampleDetail']['tissue_source'] && isset($str_permis_values_custom['tissue source'][$new_sample['SampleDetail']['tissue_source']])) {
					$muhc_precisions[] = $str_permis_values_custom['tissue source'][$new_sample['SampleDetail']['tissue_source']];
				}
				if(isset($new_sample['SampleDetail']['muhc_tissue_type']) && $new_sample['SampleDetail']['muhc_tissue_type'] && isset($str_permis_values_custom['tissue type'][$new_sample['SampleDetail']['muhc_tissue_type']])) {
					$muhc_precisions[] = $str_permis_values_custom['tissue type'][$new_sample['SampleDetail']['muhc_tissue_type']];
				}
				if(isset($new_sample['SampleDetail']['muhc_perfused']) && $new_sample['SampleDetail']['muhc_perfused'] == 'y') $muhc_precisions[] = __('perfused');
				if(isset($new_sample['SampleDetail']['muhc_intra_operative_biopsy']) && $new_sample['SampleDetail']['muhc_intra_operative_biopsy'] == 'y') $muhc_precisions[] = __('intra operative biopsy');
				
				if(isset($new_sample['SampleDetail']['muhc_from_tissue_xenograft']) && $new_sample['SampleDetail']['muhc_from_tissue_xenograft'] == 'y') $muhc_precisions[] = __('tissue xenograft cells');
				if(isset($new_sample['SampleDetail']['muhc_cell_line']) && $new_sample['SampleDetail']['muhc_cell_line'] == 'y') $muhc_precisions[] = __('cell line');
			}
			
			$new_sample['Generated']['muhc_precision'] = implode(' | ', $muhc_precisions);
		}
	}

}

?>