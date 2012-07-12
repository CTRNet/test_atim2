<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';
	
	function beforeValidate($options) {
		$result = parent::beforeValidate($options);	
		
		if(!preg_match("/^(PS[0-9]P0[0-9]+ V[0-9]+ -)(MED)([0-9]+)$/", $this->data['TreatmentMaster']['procure_form_identification'], $matches)) {
			$result = false;
			$this->validationErrors['procure_form_identification'][] = "the identification format is wrong";
		}
		return $result;
	}
}

?>