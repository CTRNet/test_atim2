<?php

class EventMasterCustom extends EventMaster {
	var $useTable = 'event_masters';
	var $name = 'EventMaster';
	
	function beforeValidate($options = Array()) {
		$result = parent::beforeValidate($options);	
			
		if(array_key_exists('procure_form_identification', $this->data['EventMaster'])) {
			//Form identification validation
			$Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);

pr('Check TODO cusm shoule be added in EventMasterCustom');			
//TODO verifeier section doit être ajouté			
//TODO DELETE THIS SECTION FOR OTHER BANK
//Custom code for cusm to track additional biopdy event
//if($Participant->bank_identification == 'PS3P0' && strtoupper($this->data['EventMaster']['procure_form_identification']) == 'N/A' && array_key_exists('biopsy_pre_surgery_date', $this->data['EventDetail'])) {
////	$this->data['EventMaster']['procure_form_identification'] = 'N/A';
//	return $result;
//}			
			
			$error = $Participant->validateFormIdentification($this->data['EventMaster']['procure_form_identification'], 'EventMaster', $this->id, (isset($this->data['EventMaster']['event_control_id'])? $this->data['EventMaster']['event_control_id']: null));
			if($error) {
				$result = false;
				$this->validationErrors['procure_form_identification'][] = $error;
			}
					
		} else {
			AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
		}
		
		return $result;
	}
	
	function beforeSave($options = array()){
		if(Configure::read('procure_atim_version') != 'BANK') AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		return parent::beforeSave($options);
	}
}

?>