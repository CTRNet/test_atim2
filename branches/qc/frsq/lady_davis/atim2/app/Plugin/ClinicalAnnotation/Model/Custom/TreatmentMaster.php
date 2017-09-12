<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $name 		= "TreatmentMaster";
	var $tableName	= "treatment_masters";

	function beforeSave($options = array()){
	    if(isset($this->data['TreatmentDetail']) && array_key_exists('er_receptor_ccl', $this->data['TreatmentDetail'])) {
	        $er_receptor_ccl = $this->data['TreatmentDetail']['er_receptor_ccl'];
	        $pr_receptor_ccl = $this->data['TreatmentDetail']['pr_receptor_ccl'];
	        $her2_receptor_ccl = $this->data['TreatmentDetail']['her2_receptor_ccl'];
	        $fish_ccl = $this->data['TreatmentDetail']['fish_ccl'];
	        $triple_negative_ccl = '';
	        if($er_receptor_ccl == 'negative' && $pr_receptor_ccl == 'negative' && ($her2_receptor_ccl == 'negative' || $fish_ccl == 'negative')) {
	            $triple_negative_ccl = 'y';
	        } else if((strlen($er_receptor_ccl) && $er_receptor_ccl != 'negative') || (strlen($pr_receptor_ccl) && $pr_receptor_ccl != 'negative') || (strlen($her2_receptor_ccl.$fish_ccl) && !preg_match('/negative/', $her2_receptor_ccl.$fish_ccl))) {
	            $triple_negative_ccl = 'n';
	        }
	        $this->data['TreatmentDetail']['triple_negative_ccl'] = $triple_negative_ccl;
	        $this->addWritableField(array('triple_negative_ccl'));
	    }
	    
	    $ret_val = parent::beforeSave($options);
	    return $ret_val;
	}
	
	function afterSave($created, $options = Array()){
		$DiagnosisMaster = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
		if(isset($this->data['TreatmentMaster']['diagnosis_master_id']) && $this->data['TreatmentMaster']['diagnosis_master_id']) $DiagnosisMaster->validateLaterality($this->data['TreatmentMaster']['diagnosis_master_id']);
		parent::afterSave($created);
	}
}

?>