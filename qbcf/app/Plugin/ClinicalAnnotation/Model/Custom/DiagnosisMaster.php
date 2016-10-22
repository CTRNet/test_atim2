<?php

class DiagnosisMasterCustom extends DiagnosisMaster {
	var $useTable = 'diagnosis_masters';
	var $name = 'DiagnosisMaster';
	
	function summary( $diagnosis_master_id = null ) {
		$return = false;
		if ( !is_null($diagnosis_master_id) ) {
			$result = $this->find('first', array('conditions'=>array('DiagnosisMaster.id'=>$diagnosis_master_id), 'recursive' => 0));
				
			$structure_alias = 'diagnosismasters';
			switch($result['DiagnosisControl']['category']) {
				case 'primary':
					if($result['DiagnosisControl']['controls_type'] != 'primary diagnosis unknown') $structure_alias .= ',dx_primary';
					break;
				case 'secondary - distant':
					$structure_alias = ',dx_secondary';
					break;
			}
			$result['Generated']['qbcf_dx_detail_for_tree_view'] = '';
			$return = array(
					'menu' 				=> array(NULL, __($result['DiagnosisControl']['category'], TRUE) . ' - '. __($result['DiagnosisControl']['controls_type'], TRUE)),
					'title' 			=> array(NULL,  __($result['DiagnosisControl']['category'], TRUE)),
					'data'				=> $result,
					'structure alias'	=> $structure_alias
			);
		}
		return $return;
	}
	
	function setBreastDxLaterality($participant_id) {
		$TreatmentModel = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
		$participant_breast_dx = $this->find('all', array('conditions' => array(
			'DiagnosisControl.controls_type' => 'breast', 
			'DiagnosisMaster.participant_id' => $participant_id)));
		foreach($participant_breast_dx as $new_brest_dx) {
			$tx_joins = array(
				'table' => 'qbcf_tx_breast_diagnostic_events', 
				'alias' => 'TreatmentDetail', 
				'type' => 'INNER', 
				'conditions' => array('Treatmentmaster.id = TreatmentDetail.treatment_master_id'));
			$breast_dx_event_laterality = $TreatmentModel->find('all', array(
				'conditions' => array('TreatmentControl.tx_method' => 'breast diagnostic event', 'Treatmentmaster.diagnosis_master_id' => $new_brest_dx['DiagnosisMaster']['id']), 
				'joins' => array($tx_joins),
				'fields' => array('DISTINCT TreatmentDetail.laterality')));
			$all_dx_laterality = array('laterality_left' => 'n', 'laterality_right' => 'n', 'laterality_bilateral' => 'n');
			foreach($breast_dx_event_laterality as $new_laterality) {
				$new_laterality = $new_laterality['TreatmentDetail']['laterality'];
				if(isset($all_dx_laterality['laterality_'.$new_laterality])) $all_dx_laterality['laterality_'.$new_laterality] = 'y';
			}
			foreach($all_dx_laterality as $field => $new_value) {
				if(!array_key_exists($field, $new_brest_dx['DiagnosisDetail']) || $new_brest_dx['DiagnosisDetail'][$field] == $new_value) {
					unset($all_dx_laterality[$field]);
				}
			}
			if($all_dx_laterality) {
				$this->data = array();
				$this->id = $new_brest_dx['DiagnosisMaster']['id'];
				if(!$this->save(array('DiagnosisMaster' => array(), 'DiagnosisDetail' => $all_dx_laterality))) AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );	
			}
		}
	}
}
			
?>