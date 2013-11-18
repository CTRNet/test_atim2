<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $name 		= "TreatmentMaster";
	var $tableName	= "treatment_masters";
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['TreatmentMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('TreatmentMaster.id'=>$variables['TreatmentMaster.id'])));
			
			$return = array(
				'menu'    			=> array( NULL, __($result['TreatmentControl']['tx_method'], TRUE)),
				'title'	 			=> array( NULL, __($result['TreatmentControl']['tx_method'], TRUE)),
				'data'				=> $result,
				'structure alias'	=> 'treatmentmasters'
			);
		}
		
		return $return;
	}

	function afterSave($created){
		$DiagnosisMaster = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
		if(isset($this->data['TreatmentMaster']['diagnosis_master_id']) && $this->data['TreatmentMaster']['diagnosis_master_id']) $DiagnosisMaster->validateLaterality($this->data['TreatmentMaster']['diagnosis_master_id']);
		parent::afterSave($created);
	}
}

?>