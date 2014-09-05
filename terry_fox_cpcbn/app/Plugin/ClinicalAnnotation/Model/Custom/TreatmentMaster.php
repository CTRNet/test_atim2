<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';
	
	function validates($options = array()){
		$result = parent::validates($options);
		
		if(array_key_exists('qc_tf_disease_free_survival_start_events', $this->data['TreatmentMaster']) && $this->data['TreatmentMaster']['qc_tf_disease_free_survival_start_events']) {

			//check qc_tf_disease_free_survival_start_events can be set to 1
			$treatment_control_id  = null;
			if(isset($this->data['TreatmentMaster']['treatment_control_id'])) {
				$treatment_control_id  = $this->data['TreatmentMaster']['treatment_control_id'];
			} else {			
				$tx = $this->find('first', array('conditions' => array('TreatmentMaster.id' => $this->id), 'recursive' => '-1'));			
				$treatment_control_id = $tx['TreatmentMaster']['treatment_control_id'];
			}
			$treatment_control_model = AppModel::getInstance('ClinicalAnnotation', 'TreatmentControl', true);
			$treatment_control = $treatment_control_model->find('first', array('conditions' => array('TreatmentControl.id' => $treatment_control_id)));		
			if(!in_array($treatment_control['TreatmentControl']['tx_method'], array('hormonotherapy', 'surgery', 'radiation', 'chemotherapy'))) {
				$this->validationErrors['qc_tf_disease_free_survival_start_events'][] = "this treatment can not be defined as the 'disease free survival start event'";
				$result = false;
			} else if($this->data['TreatmentMaster']['diagnosis_master_id']) {
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
		}
		
		return $result;
	}
	
	function atimDelete( $tx_master_id ) {
		$deleted_tx_data = $this->find('first',array('conditions'=>array('TreatmentMaster.id'=>$tx_master_id)));
		$result = parent::atimDelete($tx_master_id);
		if($result && array_key_exists('qc_tf_disease_free_survival_start_events', $deleted_tx_data['TreatmentMaster']) && $deleted_tx_data['TreatmentMaster']['qc_tf_disease_free_survival_start_events'] && $deleted_tx_data['TreatmentMaster']['diagnosis_master_id']) {
			$diagnosis_model = AppModel::getInstance('ClinicalAnnotation', 'DiagnosisMaster', true);
			$diagnosis_model->calculateSurvivalAndBcr($deleted_tx_data['TreatmentMaster']['diagnosis_master_id']);
		}
		return $result;
	}
}

?>