<?php

class ConsentMasterCustom extends ConsentMaster {
	var $useTable = 'consent_masters';
	var $name = 'ConsentMaster';
	
	function beforeValidate($options) {
		$result = parent::beforeValidate($options);	
		
		if(!preg_match("/^(PS[0-9]P0[0-9]+ V[0-9]+ -CSF[0-9]+)$/", $this->data['ConsentMaster']['procure_form_identification'], $matches)) {
			$result = false;
			$this->validationErrors['procure_form_identification'][] = "the identification format is wrong";
		}
		return $result;
	}
}

?>