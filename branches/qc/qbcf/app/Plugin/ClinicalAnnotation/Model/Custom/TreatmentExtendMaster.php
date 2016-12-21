<?php

class TreatmentExtendMasterCustom extends TreatmentExtendMaster {
	var $useTable = 'treatment_extend_masters';
	var $name = 'TreatmentExtendMaster';
	
	function validates($options = array()){
		$res = parent::validates($options);
		
		if(array_key_exists('drug_id', $this->data['TreatmentExtendMaster']) && $this->data['TreatmentExtendMaster']['drug_id']) {
			$treatment_extend_control_type = '';
			if(array_key_exists('TreatmentExtendControl', $this->data) && array_key_exists('type', $this->data['TreatmentExtendControl'])) {
				$treatment_extend_control_type = $this->data['TreatmentExtendControl']['type'];
			} else if(isset($this->data['TreatmentExtendMaster']['treatment_extend_control_id'])) {
				$TreatmentExtendControl = AppModel::getInstance("ClinicalAnnotation", "TreatmentExtendControl", true);
				$treatment_extend_control_data = $TreatmentExtendControl->getOrRedirect($this->data['TreatmentExtendMaster']['treatment_extend_control_id']);
				$treatment_extend_control_type = $treatment_extend_control_data['TreatmentExtendControl']['type'];
			}
			$drug_type = '';
			$Drug = AppModel::getInstance("Drug", "Drug", true);
			$drug_data = $Drug->getOrRedirect($this->data['TreatmentExtendMaster']['drug_id']);
			$drug_type = $drug_data['Drug']['type'];
			if(!$drug_type || !$treatment_extend_control_type) AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
			$val_types = true;
			
			switch($drug_type) {
				case 'chemotherapy':
				case 'bone specific':
				case 'immunotherapy':
					if(strcmp("$drug_type drug", $treatment_extend_control_type) !== 0) $val_types = false;
					break;
				case 'hormonal':
					if(strcmp("hormonotherapy drug", $treatment_extend_control_type) !== 0) $val_types = false;
					break;
				case 'other':
					if(strcmp("other (breast cancer systemic treatment) drug", $treatment_extend_control_type) !== 0) $val_types = false;
					break;
			}
			if(!$val_types) {
				$this->validationErrors['autocomplete_treatment_drug_id'][] = __('the type of the treatment does not match the type of the selected drug');
				$res = false;
			}
		}
		
		return $res;
	}
}

?>