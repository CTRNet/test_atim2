<?php

class ConsentMasterCustom extends ConsentMaster {
	var $useTable = 'consent_masters';
	var $name = 'ConsentMaster';
	
	function beforeValidate($options = Array()) {
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
	
	function beforeSave($options = array()){
		if(Configure::read('procure_atim_version') != 'BANK') $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		return parent::beforeSave($options);
	}
}

?>