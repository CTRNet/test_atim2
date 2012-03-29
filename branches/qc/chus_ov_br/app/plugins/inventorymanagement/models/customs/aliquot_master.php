<?php

class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';
	
	function generateDefaultAliquotLabel($view_sample, $aliquot_control_data) {
		// Parameters check: Verify parameters have been set
		if(empty($view_sample) || empty($aliquot_control_data)) AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);

		$default_sample_label = '';
		
		preg_match('/^(OV|BR)([0-9]+)$/',  $view_sample['ViewSample']['frsq_number'], $matches);
		$bank_initials = isset($matches[1])? $matches[1] : '?';
		$bank_number = isset($matches[2])? $matches[2] : '?';
		
		switch($view_sample['ViewSample']['sample_type']) {
			case 'tissue':
				$SampleMasterModel = AppModel::getInstance("Clinicalannotation", "SampleMaster", true);
				$tmp_sample_data = $SampleMasterModel->find('first',array('conditions' => array('SampleMaster.id' => $view_sample['ViewSample']['sample_master_id']), 'recursive' => '0'));
				$type_char = '';
				$suffix = '';
				if($tmp_sample_data['SampleDetail']['tissue_source'] == 'breast') {
					if(in_array($tmp_sample_data['SampleDetail']['tissue_nature'], array('borderline','tumoral','metastatic'))) {
						$type_char = 'C';
					} else if($tmp_sample_data['SampleDetail']['tissue_nature'] == 'benign') {
						$type_char = 'B';
					} else if($tmp_sample_data['SampleDetail']['tissue_nature'] == 'normal') {
						$type_char = 'N';
					}
				} else if($tmp_sample_data['SampleDetail']['tissue_source'] == 'ovary') {
					$suffix = 'O';
					switch($tmp_sample_data['SampleDetail']['tissue_laterality']) {
						case 'right':
							$suffix .= 'D';
							break;
						case 'left':
							$suffix .= 'G';
							break;
						default:	
					}
				}
				$default_sample_label = $bank_initials.$type_char.$bank_number.' FT'.$suffix;
				break;
	              
			case 'ascite supernatant':
				$default_sample_label = $bank_initials.$bank_number.' FA';
				break;

			case 'plasma':
				$default_sample_label = $bank_initials.$bank_number.' S';
				break;

			case 'dna':
				$default_sample_label = $bank_initials.$bank_number.' D';
				break;
								
			default:
				$default_sample_label = $bank_initials.$bank_number;
		}

		return $default_sample_label;
	}
	
	function regenerateAliquotBarcode() {
		$query_to_update = "UPDATE aliquot_masters SET aliquot_masters.barcode = aliquot_masters.id WHERE aliquot_masters.barcode = '';";
		if(!$this->query($query_to_update) 
		|| !$this->query(str_replace("aliquot_masters", "aliquot_masters_revs", $query_to_update))) {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}		
	}
}

?>
