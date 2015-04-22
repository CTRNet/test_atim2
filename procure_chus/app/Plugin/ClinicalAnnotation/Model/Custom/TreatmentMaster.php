<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';
	
	function beforeValidate($options = Array()) {
		$result = parent::beforeValidate($options);
			
		if(array_key_exists('procure_form_identification', $this->data['TreatmentMaster'])) {
			//Form identification validation
			$Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
			$error = $Participant->validateFormIdentification($this->data['TreatmentMaster']['procure_form_identification'], 'TreatmentMaster', $this->id, (isset($this->data['TreatmentMaster']['treatment_control_id'])? $this->data['TreatmentMaster']['treatment_control_id']: null));
			if($error) {
				$result = false;
				$this->validationErrors['procure_form_identification'][] = $error;
			}
		} else {
			AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
		}
		if(array_key_exists('treatment_type', $this->data['TreatmentDetail']) || array_key_exists('drug_id', $this->data['TreatmentDetail'])) {
			if(array_key_exists('treatment_type', $this->data['TreatmentDetail']) && array_key_exists('drug_id', $this->data['TreatmentDetail'])) {
				if($this->data['TreatmentDetail']['drug_id']) {
					$treatment_type = strtolower($this->data['TreatmentDetail']['treatment_type']);
					$Drug = AppModel::getInstance("Drug", "Drug", true);
					$drug_data = $Drug->getOrRedirect($this->data['TreatmentDetail']['drug_id']);
					$drug_type = strtolower($drug_data['Drug']['type']);
					if(!preg_match("/$drug_type/", $treatment_type) ){
						$result = false;
						$this->validationErrors['drug_id'][] = __('the type of the selected drug does not match the selected treatment type');
					}					
				}
			} else {
				AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
			}
		}
		if(array_key_exists('treatment_type', $this->data['TreatmentDetail']) || array_key_exists('treatment_site', $this->data['TreatmentDetail'])) {
			if(array_key_exists('treatment_type', $this->data['TreatmentDetail']) && array_key_exists('treatment_site', $this->data['TreatmentDetail'])) {
				if($this->data['TreatmentDetail']['treatment_site']) {
					$treatment_type = strtolower($this->data['TreatmentDetail']['treatment_type']);
					pr($treatment_type);
					if(!preg_match("/((radiotherapy)|(curietherapy))/", $treatment_type) ){
						$result = false;
						$this->validationErrors['treatment_site'][] = __('no site has to be associated to the selected treatment type');
					}					
				}
			} else {
				AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
			}
		}
		return $result;
	}
}

?>