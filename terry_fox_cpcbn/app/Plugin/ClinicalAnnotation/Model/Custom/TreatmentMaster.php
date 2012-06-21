<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';
	
	function validates($options = array()){
		$result = parent::validates($options);
		
		if(array_key_exists('qc_tf_disease_free_survival_start_events', $this->data['TreatmentMaster']) && $this->data['TreatmentMaster']['qc_tf_disease_free_survival_start_events'] && $this->data['TreatmentMaster']['diagnosis_master_id']) {
			// Get all diagnoses linked to the same primary
			$diagnosis_model = AppModel::getInstance('ClinicalAnnotation', 'DiagnosisMaster', true);
			$all_linked_diagmosises_ids = $diagnosis_model->getAllTumorDiagnosesIds($this->data['TreatmentMaster']['diagnosis_master_id']);
			
			// Search existing 	trt linked to this cancer and already flagged as qc_tf_disease_free_survival_start_events	
			$conditions = array(
				'TreatmentMaster.diagnosis_master_id'=> $all_linked_diagmosises_ids, 
				'TreatmentMaster.qc_tf_disease_free_survival_start_events'=> '1');
			if($this->id) $conditions[] = 'TreatmentMaster.id != '.$this->id;
			
			$count = $this->find('count', array('conditions'=>$conditions));	
			if($count) {
				$this->validationErrors['qc_tf_disease_free_survival_start_events'][] = "a treatment or biopsy has already been defined as the 'disease free survival start event' for this cancer";
				$result = false;
			}
		}
		
		return $result;
	}
	
	function atimDelete( $tx_master_id ) {
		$deleted_tx_data = $this->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id)));
		$result = parent::atimDelete($tx_master_id);
		if($result && array_key_exists('qc_tf_disease_free_survival_start_events', $this->data['TreatmentMaster']) && $this->data['TreatmentMaster']['qc_tf_disease_free_survival_start_events'] && $this->data['TreatmentMaster']['diagnosis_master_id']) {
			$diagnosis_model = AppModel::getInstance('ClinicalAnnotation', 'DiagnosisMaster', true);
			$diagnosis_model->calculateSurvivalAndBcr($this->data['TreatmentMaster']['diagnosis_master_id']);
		}
		return $result;
	}
}

?>