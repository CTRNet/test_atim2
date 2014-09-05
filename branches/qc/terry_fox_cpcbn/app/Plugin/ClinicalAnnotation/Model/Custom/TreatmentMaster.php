<?php

class TreatmentMasterCustom extends TreatmentMaster {
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';
	
	function validates($options = array()){
		$result = parent::validates($options);
		$treatment_control = null;
		$all_linked_diagmosises_ids = null;
		
		//check qc_tf_disease_free_survival_start_events can be set to 1
		if(array_key_exists('qc_tf_disease_free_survival_start_events', $this->data['TreatmentMaster']) && $this->data['TreatmentMaster']['qc_tf_disease_free_survival_start_events']) {
			$treatment_control = $this->getTreatmentControlData();
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
		
		//check Dx Bx can only be created once per dx
		if(isset($this->data['TreatmentDetail']) && array_key_exists('type', $this->data['TreatmentDetail']) && $this->data['TreatmentDetail']['type'] == 'Dx Bx' && $this->data['TreatmentMaster']['diagnosis_master_id']) {
			if(!$treatment_control) $treatment_control = $this->getTreatmentControlData();
			if($treatment_control['TreatmentControl']['tx_method'] == 'biopsy') {
				// Get all diagnoses linked to the same primary
				$diagnosis_model = AppModel::getInstance('ClinicalAnnotation', 'DiagnosisMaster', true);
				if(!$all_linked_diagmosises_ids) $all_linked_diagmosises_ids = $diagnosis_model->getAllTumorDiagnosesIds($this->data['TreatmentMaster']['diagnosis_master_id']);
				// Search existing 	biopsies linked to this cancer and already flagged as Dx Bx				
				$conditions = array(
					'TreatmentMaster.diagnosis_master_id'=> $all_linked_diagmosises_ids,
					'TreatmentDetail.type' => 'Dx Bx'
				);
				if($this->id) $conditions[] = 'TreatmentMaster.id != '.$this->id;
				$joins = array(array(
					'table' => 'qc_tf_txd_biopsies',
					'alias'	=> 'TreatmentDetail',
					'type'	=> 'INNER',
					'conditions' => array('TreatmentMaster.id = TreatmentDetail.treatment_master_id')));
				$count = $this->find('count', array('conditions'=>$conditions, 'joins' => $joins));
				if($count) {
					$this->validationErrors['type'][] = "a biopsy has already been defined as the 'Dx Bx' for this cancer";
					$result = false;
				}
			}
		}
		
		return $result;
	}
	
	private function getTreatmentControlData() {
		$treatment_control_id  = null;
		if(isset($this->data['TreatmentMaster']['treatment_control_id'])) {
			$treatment_control_id  = $this->data['TreatmentMaster']['treatment_control_id'];
		} else {
			$tx = $this->find('first', array('conditions' => array('TreatmentMaster.id' => $this->id), 'recursive' => '-1'));
			$treatment_control_id = $tx['TreatmentMaster']['treatment_control_id'];
		}
		$treatment_control_model = AppModel::getInstance('ClinicalAnnotation', 'TreatmentControl', true);
		$treatment_control = $treatment_control_model->find('first', array('conditions' => array('TreatmentControl.id' => $treatment_control_id)));
		return $treatment_control;
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