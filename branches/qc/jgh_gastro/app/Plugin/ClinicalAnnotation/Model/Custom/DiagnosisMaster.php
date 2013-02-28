<?php

class DiagnosisMasterCustom extends DiagnosisMaster {
	var $name = "DiagnosisMaster";
	var $useTable = "diagnosis_masters";
	
	function formatIcd10ForBank(&$data_for_display) {
		if(is_array($data_for_display)) {
			$CodingIcd10Who = AppModel::getInstance("CodingIcd", "CodingIcd10Who", true);
			foreach($data_for_display AS &$new_dx) {
				if(isset($new_dx['DiagnosisMaster']['icd10_code'])) {
					if($new_dx['DiagnosisMaster']['icd10_code']) {
						$new_dx['DiagnosisMaster']['icd10_code'] .= ' | '.$CodingIcd10Who->getDescription($new_dx['DiagnosisMaster']['icd10_code']);
					}
				}
				if(isset($new_dx['children'])) $this->formatIcd10ForBank($new_dx['children']);
			}
		}
	}
	
	function find($type = 'first', $query = array()) {
		$tmp_res  = parent::find($type, $query);
		if($type == 'threaded') {
			// ADD ICD10 CODE DESCRIPTION IN TREE VIEW
			$this->formatIcd10ForBank($tmp_res);
		}
		return $tmp_res;
	}
}

?>