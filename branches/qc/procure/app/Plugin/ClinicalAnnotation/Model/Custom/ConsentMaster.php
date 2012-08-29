<?php

class ConsentMasterCustom extends ConsentMaster {
	var $useTable = 'consent_masters';
	var $name = 'ConsentMaster';
	
	function beforeValidate($options) {
		$result = parent::beforeValidate($options);	
		
		//Form identification validation
		$Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$error = $Participant->validateFormIdentification($this->data['ConsentMaster']['procure_form_identification'], 'ConsentMaster', $this->id);
		if($error) {
			$result = false;
			$this->validationErrors['procure_form_identification'][] = $error;
		}
			
		return $result;
	}
}

?>