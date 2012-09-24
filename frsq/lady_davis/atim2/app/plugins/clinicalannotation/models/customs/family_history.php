<?php

class FamilyHistoryCustom extends FamilyHistory{
	var $name 		= "FamilyHistory";
	var $tableName	= "family_histories";
	
	function afterSave($created) {
		parent::afterSave($created);
		
		$participant_id = null;
		if($created){
			$participant_id = $this->data['FamilyHistory']['participant_id'];
			$participant_model = AppModel::getInstance('Clinicalannotation', 'Participant', true);
			$participant_model->id = $participant_id;
			$participant_model->save(array('Participant' => array('qc_lady_has_family_history' => 'y')));
		}else if(isset($this->data['FamilyHistory']['deleted']) && $this->data['FamilyHistory']['deleted']){
			//it's a delete
			$data = $this->find('first', array('conditions' => array('FamilyHistory.id' => $this->id, 'FamilyHistory.deleted' => 1)));
			$participant_id = $data['FamilyHistory']['participant_id'];

			$data = $this->find('first', array('conditions' => array('FamilyHistory.participant_id' => $participant_id)));
			if(empty($data)){
				AppController::addWarningMsg('No more family histories exist for this participant in the system. You may update the participant "has family history" field at your convenience.');
			}
		}
	}
}

/*

 * add
 *  [FamilyHistory] => Array
        (
            [family_domain] => 
            [relation] => 
            [previous_primary_code] => 
            [primary_icd10_code] => 
            [previous_primary_code_system] => 
            [age_at_dx] => 
            [age_at_dx_precision] => 
            [participant_id] => 402
            [modified] => 2012-06-20 09:31:29
            [created] => 2012-06-20 09:31:29
            [created_by] => 1
            [modified_by] => 1
        )
        
        
       edit
       
       [FamilyHistory] => Array
        (
            [family_domain] => 
            [relation] => 
            [previous_primary_code] => 
            [primary_icd10_code] => 
            [previous_primary_code_system] => 
            [age_at_dx] => 
            [age_at_dx_precision] => 
            [modified] => 2012-06-20 09:31:47
            [modified_by] => 1
        )
        
        delete
        FamilyHistory] => Array
        (
            [deleted] => 1
            [modified] => 2012-06-20 09:32:05
            [modified_by] => 1
        )
 */