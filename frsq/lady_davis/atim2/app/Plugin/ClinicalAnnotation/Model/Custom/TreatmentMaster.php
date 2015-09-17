<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $name 		= "TreatmentMaster";
	var $tableName	= "treatment_masters";
	
	function afterSave($created, $options = Array()){
		$DiagnosisMaster = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
		if(isset($this->data['TreatmentMaster']['diagnosis_master_id']) && $this->data['TreatmentMaster']['diagnosis_master_id']) $DiagnosisMaster->validateLaterality($this->data['TreatmentMaster']['diagnosis_master_id']);
		parent::afterSave($created);
	}
}

?>