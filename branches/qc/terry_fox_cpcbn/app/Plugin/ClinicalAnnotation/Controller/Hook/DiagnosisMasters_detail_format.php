<?php 
	
	if($dx_master_data['DiagnosisControl']['controls_type'] == 'prostate' && $dx_master_data['DiagnosisControl']['category'] == 'primary') {		
		$disease_free_start_trt = $this->TreatmentMaster->find('first', array('conditions' => array('TreatmentMaster.participant_id' => $participant_id, 'TreatmentMaster.diagnosis_master_id' => $diagnosis_master_id, 'TreatmentMaster.qc_tf_disease_free_survival_start_events' => '1'), 'recursive' => '-1'));	
		$this->set('disease_free_start_trt_id', empty($disease_free_start_trt)? '-1' : $disease_free_start_trt['TreatmentMaster']['id']);

		$conditions = array(
				'DiagnosisMaster.primary_id '=> $diagnosis_master_id,
				'DiagnosisDetail.first_biochemical_recurrence'=> '1');
		$joins = array(array(
				'table' => 'qc_tf_dxd_recurrence_bio',
				'alias' => 'DiagnosisDetail',
				'type' => 'INNER',
				'conditions'=> array('DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id')));
		$disease_free_end_bcr = $this->DiagnosisMaster->find('first', array('conditions' => $conditions, 'joins' => $joins));
		$this->set('disease_free_end_bcr_id', empty($disease_free_end_bcr)? '-1' : $disease_free_end_bcr['DiagnosisMaster']['id']);
	}
	
