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
		if(array_key_exists('treatment_type', $this->data['TreatmentDetail'])) {
			$treatment_type = strtolower($this->data['TreatmentDetail']['treatment_type']);
			//Check drug can be associated to treatment
			if( array_key_exists('drug_id', $this->data['TreatmentDetail']) && $this->data['TreatmentDetail']['drug_id']) {
				$Drug = AppModel::getInstance("Drug", "Drug", true);
				$drug_data = $Drug->getOrRedirect($this->data['TreatmentDetail']['drug_id']);
				$drug_type = strtolower($drug_data['Drug']['type']);
				if($drug_type != $treatment_type){
					$result = false;
					$this->validationErrors['drug_id'][] = __('the type of the selected drug does not match the selected treatment type');
				}					
			}
			//Check site can be associated to treatment
			if(array_key_exists('treatment_site', $this->data['TreatmentDetail']) && $this->data['TreatmentDetail']['treatment_site']) {
				if(!in_array($treatment_type, array("radiotherapy",'antalgic radiotherapy','brachytherapy'))){
					$result = false;
					$this->validationErrors['treatment_site'][] = __('no site has to be associated to the selected treatment type');
				}					
			}
			//Check precision can be associated to treatment
			if(array_key_exists('treatment_precision', $this->data['TreatmentDetail']) && $this->data['TreatmentDetail']['treatment_precision']) {
				if(preg_match("/prostatectomy/", $treatment_type)){
					$result = false;
					$this->validationErrors['treatment_precision'][] = __('no precision has to be associated to the selected treatment type');
				}					
			}
			//Check line can be associated to treatment
			if(array_key_exists('treatment_line', $this->data['TreatmentDetail']) && $this->data['TreatmentDetail']['treatment_line']) {
				if(!preg_match("/chemotherapy/", $treatment_type) && !preg_match("/hormonotherapy/", $treatment_type)){
					$result = false;
					$this->validationErrors['treatment_line'][] = __('no line has to be associated to the selected treatment type');
				}
			}
//PROCURE CHUQ custom code
			//Check surgery data complete for prostatectomy
			if(array_key_exists('procure_chuq_surgeon', $this->data['TreatmentDetail'])) {
				if(strlen($this->data['TreatmentDetail']['treatment_precision'].$this->data['TreatmentDetail']['procure_chuq_laparotomy'].$this->data['TreatmentDetail']['procure_chuq_laparoscopy']) && !in_array($treatment_type, array('aborted prostatectomy', 'prostatectomy'))) {
					$result = false;
					$this->validationErrors['procure_chuq_surgeon'][] = __('no surgery data has to be associated to the selected treatment type');
				}				
			}
//END PROCURE CHUQ custom code			
		}
		return $result;
	}
	
	function beforeSave($options = array()){
		if(Configure::read('procure_atim_version') != 'BANK') AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		return parent::beforeSave($options);
	}
}

?>