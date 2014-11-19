<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';
	
	function beforeValidate($options = Array()) {
		$result = parent::beforeValidate($options);
			
		if(array_key_exists('procure_form_identification', $this->data['TreatmentMaster'])) {
			//Form identification validation
			$Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
			$error = $Participant->validateFormIdentification($this->data['TreatmentMaster']['procure_form_identification'], 'TreatmentMaster', $this->id);
			if($error) {
				$result = false;
				$this->validationErrors['procure_form_identification'][] = $error;
			}
		} else {
			AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
		}
		
		return $result;
	}
}

?>