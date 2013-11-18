<?php

class DiagnosisMasterCustom extends DiagnosisMaster {
	var $useTable = 'diagnosis_masters';
	var $name = 'DiagnosisMaster';
	
	function updateAgeAtDx($model, $primary_key_id) {	
		$criteria = array(
			'DiagnosisControl.category' => 'primary', 
			'DiagnosisControl.controls_type' => array('breast'),
			'DiagnosisMaster.deleted <> 1',
			$model.'.id' => $primary_key_id);
		$joins = array(array(
				'table' => 'participants',
				'alias' => 'Participant',
				'type' => 'INNER',
				'conditions'=> array('Participant.id = DiagnosisMaster.participant_id')));
		$dx_to_check = $this->find('all', array('conditions' => $criteria, 'joins' => $joins, 'recursive' => '0', 'fields' => array('Participant.*, DiagnosisMaster.*')));

		$dx_to_update = array();
		$warnings = array();
		foreach($dx_to_check as $new_dx) {
			$dx_id = $new_dx['DiagnosisMaster']['id'];
			$previous_age_at_dx = $new_dx['DiagnosisMaster']['age_at_dx'];
			if($new_dx['DiagnosisMaster']['dx_date'] && $new_dx['Participant']['date_of_birth']) {
				if(($new_dx['DiagnosisMaster']['dx_date_accuracy'] != 'c') || ($new_dx['Participant']['date_of_birth_accuracy'] != 'c')) $warnings[-1] = __('age at diagnosis has been calculated with at least one unaccuracy date');
				$arr_spent_time = $this->getSpentTime($new_dx['Participant']['date_of_birth'].' 00:00:00', $new_dx['DiagnosisMaster']['dx_date'].' 00:00:00');
				if($arr_spent_time['message']) {
					$warnings[$arr_spent_time['message']] = __('unable to calculate age at diagnosis').': '.__($arr_spent_time['message']);
					$dx_to_update[] = array('DiagnosisMaster' => array('id' => $dx_id, 'age_at_dx' => ''));
				} else if($arr_spent_time['years'] != $previous_age_at_dx) {
					$dx_to_update[] = array('DiagnosisMaster' => array('id' => $dx_id, 'age_at_dx' => $arr_spent_time['years']));
				}
			} else {
				$warnings['missing date'] = __('unable to calculate age at diagnosis').': '.__('missing date');
				$dx_to_update[] = array('DiagnosisMaster' => array('id' => $dx_id, 'age_at_dx' => ''));
			}	
		}
		foreach($warnings as $new_warning) AppController::getInstance()->addWarningMsg($new_warning);
		
		$this->addWritableField(array('age_at_dx'));
		foreach($dx_to_update as $dx_data) {
			$thid->data = array();
			$this->id = $dx_data['DiagnosisMaster']['id'];
			if(!$this->save($dx_data, false)) AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
		}
	}
	
	function afterSave($created){
		if(isset($this->data['DiagnosisDetail']['laterality'])) {
			$this->validateLaterality($this->id);
		}
		parent::afterSave($created);
	}
	
	function validateLaterality($diagnosis_master_id) {
		$this->unbindModel(array('hasMany' => array('Collection')));
		$this->bindModel(
			array('hasMany' => array(
				'TreatmentMaster'	=> array(
					'className'  	=> 'ClinicalAnnotation.TreatmentMaster',
					'foreignKey'	=> 'diagnosis_master_id'),
				'EventMaster'	=> array(
					'className'  	=> 'ClinicalAnnotation.EventMaster',
					'foreignKey'	=> 'diagnosis_master_id'))));
		$res = $this->find('first', array('conditions' => array('DiagnosisMaster.id' => $diagnosis_master_id, 'DiagnosisControl.category' => 'primary', 'DiagnosisControl.controls_type' => 'breast')));
		if($res && in_array($res['DiagnosisDetail']['laterality'], array('left', 'right'))) {
			$wrong_laterality = $res['DiagnosisDetail']['laterality'] == 'left'? 'right' : 'left';
			$warning = false;
			foreach($res['EventMaster'] as $new_event) if($new_event['qc_lady_clinic_imaging_laterality'] == $wrong_laterality) $warning = true;
			foreach($res['TreatmentMaster'] as $new_trt) if($new_trt['qc_lady_laterality'] == $wrong_laterality) $warning = true;
			if($warning) AppController::addWarningMsg(__('diagnosis, treatments and/or events lateralities mismatch'));
		}
	}
}

?>