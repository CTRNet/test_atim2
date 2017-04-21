<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $useTable = 'treatment_masters';
	var $name = "TreatmentMaster";
	
	private $ParticipantModel = null;
	
	private $TreatmentExtendMasterModel = null;
	
	private $sardo_treatment_data = array();
	
	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		foreach($results as &$new_treatment) {
			if(array_key_exists('TreatmentControl', $new_treatment) && array_key_exists('treatment_extend_control_id', $new_treatment['TreatmentControl'])) {
				$new_treatment['Generated']['qc_nd_sardo_tx_detail_summary'] 
					= $this->getSardoTreatmentDetailSummary((isset($new_treatment['TreatmentMaster']['id'])? $new_treatment['TreatmentMaster']['id'] : '0'), $new_treatment['TreatmentControl']['treatment_extend_control_id']);
			}
		}
		return $results;
	}
	
	function getSardoTreatmentDetailSummary($treatment_master_id, $treatment_extend_control_id = null) {
		if($treatment_master_id && $treatment_extend_control_id) {
			if(!$this->TreatmentExtendMasterModel) $this->TreatmentExtendMasterModel = AppModel::getInstance("ClinicalAnnotation", "TreatmentExtendMaster", true);
			if(!$this->ParticipantModel) $this->ParticipantModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
			
			$sardo_treatment_summary = array();
			foreach($this->TreatmentExtendMasterModel->find('all', array('conditions' => array('TreatmentExtendMaster.treatment_master_id' => $treatment_master_id))) as $new_treatment_extend_data) {
				if(preg_match('/^sardo treatment extend\ \-\ ([a-z]+)$/', $new_treatment_extend_data['TreatmentExtendControl']['type'], $matches)) {
					$sardo_treatment_type = "SARDO : ".strtoupper($matches[1])." Treatments";
					if(!isset($this->sardo_treatment_data[$sardo_treatment_type])) $this->sardo_treatment_data[$sardo_treatment_type] = $this->ParticipantModel->getSardoValues(array('0' => $sardo_treatment_type));
					if(isset($this->sardo_treatment_data[$sardo_treatment_type][$new_treatment_extend_data['TreatmentExtendDetail']['treatment']])) {
						$sardo_treatment_summary[] = $this->sardo_treatment_data[$sardo_treatment_type][$new_treatment_extend_data['TreatmentExtendDetail']['treatment']];
					}
				}
			}
			return implode (' & ', $sardo_treatment_summary);
		}
		return '';
	}
	
}

?>