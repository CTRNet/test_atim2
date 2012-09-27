<?php

class FamilyHistoryCustom extends FamilyHistory{
	var $name 		= "FamilyHistory";
	var $tableName	= "family_histories";
	
	function afterSave($created) {
		parent::afterSave($created);
		
		$participant_id = null;
		if($created){
			$participant_id = $this->data['FamilyHistory']['participant_id'];
			$participant_model = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);		
			$participant_model->data = array();
			$participant_model->id = $participant_id;
			$participant_model->addWritableField(array('qc_lady_has_family_history'));
			$participant_model->save(array('Participant' => array('qc_lady_has_family_history' => 'y')), false);
			AppController::addWarningMsg('family history exists - field has family history updated');	
					
		}else if(isset($this->data['FamilyHistory']['deleted']) && $this->data['FamilyHistory']['deleted']){
			//it's a delete
			$data = $this->find('first', array('conditions' => array('FamilyHistory.id' => $this->id, 'FamilyHistory.deleted' => 1)));
			$participant_id = $data['FamilyHistory']['participant_id'];
			$data = $this->find('first', array('conditions' => array('FamilyHistory.participant_id' => $participant_id)));
			if(empty($data)){
				AppController::addWarningMsg('no more family histories exists - update the participant has family history');
			}
		}
	}
}
