<?php

class Participant extends ClinicalAnnotationAppModel {
	
	function summary($variables=array()){
		$return = false;
		
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			
			$return = array(
					'menu'				=>	array( NULL, ($result['Participant']['participant_identifier']) ),
					'title'				=>	array( NULL, ($result['Participant']['participant_identifier']) ),
					'structure alias' 	=> 'participants',
					'data'				=> $result
			);
		}
		
		return $return;
	}
	
	/**
	 * Replaces icd10 empty string to null values to respect foreign keys constraints
	 * @param array $participantArray
	 */
	function patchIcd10NullValues(array &$participant){
		if(isset($participant['Participant']['cod_icd10_code']) && strlen(trim($participant['Participant']['cod_icd10_code'])) == 0){
			$participant['Participant']['cod_icd10_code'] = null;
		}
		if(isset($participant['Participant']['secondary_cod_icd10_code']) && strlen(trim($participant['Participant']['secondary_cod_icd10_code'])) == 0){
			$participant['Participant']['secondary_cod_icd10_code'] = null;
		}
	}
	
/**
	 * Check if a record can be deleted.
	 * 
	 * @param $participant_id ID of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	function allowDeletion( $participant_id ) {
		$arr_allow_deletion = array('allow_deletion' => true, 'msg' => '');
		
		// Check for existing records linked to the participant. If found, set error message and deny delete
		$collection_model = AppModel::getInstance("InventoryManagement", "Collection", true);
		$nbr_linked_collection = $collection_model->find('count', array('conditions' => array('Collection.participant_id' => $participant_id)));
		if ($nbr_linked_collection > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_collection';
		}
		
		$consent_master_model = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true); 
		$nbr_consents = $consent_master_model->find('count', array('conditions'=>array('ConsentMaster.participant_id'=>$participant_id)));
		if ($nbr_consents > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_consent';
		}
		
		$diagnosis_master_model = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
		$nbr_diagnosis = $diagnosis_master_model->find('count', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id)));
		if ($nbr_diagnosis > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_diagnosis';
		}

		$treatment_master_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
		$nbr_treatment = $treatment_master_model->find('count', array('conditions'=>array('TreatmentMaster.participant_id'=>$participant_id)));
		if ($nbr_treatment > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_treatment';
		}	
		
		$family_history_model = AppModel::getInstance("ClinicalAnnotation", "FamilyHistory", true);
		$nbr_familyhistory = $family_history_model->find('count', array('conditions'=>array('FamilyHistory.participant_id'=>$participant_id)));
		if ($nbr_familyhistory > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_familyhistory';
		}			

		$reproductive_history_model = AppModel::getInstance("ClinicalAnnotation", "ReproductiveHistory", true);
		$nbr_reproductive = $reproductive_history_model->find('count', array('conditions'=>array('ReproductiveHistory.participant_id'=>$participant_id)));
		if ($nbr_reproductive > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_reproductive';
		}			

		$participant_contact_model = AppModel::getInstance("ClinicalAnnotation", "ParticipantContact", true);
		$nbr_contacts = $participant_contact_model->find('count', array('conditions'=>array('ParticipantContact.participant_id'=>$participant_id)));
		if ($nbr_contacts > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_contacts';
		}

		$misc_identifier_model = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
		$nbr_identifiers = $misc_identifier_model->find('count', array('conditions'=>array('MiscIdentifier.participant_id'=>$participant_id)));
		if ($nbr_identifiers > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_identifiers';
		}

		$participant_message_model = AppModel::getInstance("ClinicalAnnotation", "ParticipantMessage", true);
		$nbr_messages = $participant_message_model->find('count', array('conditions'=>array('ParticipantMessage.participant_id'=>$participant_id)));
		if ($nbr_messages > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_messages';
		}			

		$event_master_model = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
		$nbr_events = $event_master_model->find('count', array('conditions'=>array('EventMaster.participant_id'=>$participant_id)));
		if ($nbr_events > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_events';
		}
		
		return $arr_allow_deletion;
	}
	
	function beforeSave(){
		$ret_val = parent::beforeSave();
		$this->data['Participant']['last_modification'] = $this->data['Participant']['modified']; 
		$this->data['Participant']['last_modification_ds_id'] = 4;//participant
		return $ret_val; 
	}
}

?>