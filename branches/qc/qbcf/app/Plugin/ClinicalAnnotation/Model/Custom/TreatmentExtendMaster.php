<?php

class TreatmentExtendMasterCustom extends TreatmentExtendMaster {
	var $useTable = 'treatment_extend_masters';
	var $name = 'TreatmentExtendMaster';
	
	public function validates($options = array()){
		$res = parent::validates($options);
		
		if(array_key_exists('drug_id', $this->data['TreatmentExtendMaster']) && $this->data['TreatmentExtendMaster']['drug_id']) {
			$treatmentExtendControlType = '';
			if(array_key_exists('TreatmentExtendControl', $this->data) && array_key_exists('type', $this->data['TreatmentExtendControl'])) {
				$treatmentExtendControlType = $this->data['TreatmentExtendControl']['type'];
			} elseif(isset($this->data['TreatmentExtendMaster']['treatment_extend_control_id'])) {
				$TreatmentExtendControl = AppModel::getInstance("ClinicalAnnotation", "TreatmentExtendControl", true);
				$treatmentExtendControlData = $TreatmentExtendControl->getOrRedirect($this->data['TreatmentExtendMaster']['treatment_extend_control_id']);
				$treatmentExtendControlType = $treatmentExtendControlData['TreatmentExtendControl']['type'];
			}
			$drugType = '';
			$Drug = AppModel::getInstance("Drug", "Drug", true);
			$drugData = $Drug->getOrRedirect($this->data['TreatmentExtendMaster']['drug_id']);
			$drugType = $drugData['Drug']['type'];
			if(!$drugType || !$treatmentExtendControlType) AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
			$valTypes = true;
			
			switch($drugType) {
				case 'chemotherapy':
				case 'immunotherapy':
					if(strcmp("$drugType drug", $treatmentExtendControlType) !== 0) $valTypes = false;
					break;
				case 'bone specific':
					if(strcmp("bone specific therapy drug", $treatmentExtendControlType) !== 0) $valTypes = false;
					break;
				case 'hormonal':
					if(strcmp("hormonotherapy drug", $treatmentExtendControlType) !== 0) $valTypes = false;
					break;
				case 'other':
					if(strcmp("other (breast cancer systemic treatment) drug", $treatmentExtendControlType) !== 0) $valTypes = false;
					break;
			}
			if(!$valTypes) {
				$this->validationErrors['autocomplete_treatment_drug_id'][] = __('the type of the treatment does not match the type of the selected drug');
				$res = false;
			}
		}
		
		return $res;
	}
}