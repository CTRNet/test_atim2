<?php

class ParticipantContact extends ClinicalannotationAppModel {

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
		$ccl_model = AppModel::atimNew("Clinicalannotation", "ClinicalCollectionLink", true);
		$nbr_linked_collection = $ccl_model->find('count', array('conditions' => array('ClinicalCollectionLink.participant_id' => $participant_id, 'ClinicalCollectionLink.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_linked_collection > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_collection';
		}
		
		$_model = AppModel::atimNew("Clinicalannotation", "ConsentMaster", true); 
		$nbr_consents = $this->ConsentMaster->find('count', array('conditions'=>array('ConsentMaster.participant_id'=>$participant_id, 'ConsentMaster.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_consents > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_consent';
		}
		
		$diagnosis_master_model = AppModel::atimNew("Clinicalannotation", "DiagnosisMaster", true);
		$nbr_diagnosis = $diagnosis_master_model->find('count', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id, 'DiagnosisMaster.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_diagnosis > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_diagnosis';
		}

		$treatment_master_model = AppModel::atimNew("Clinicalannotation", "TreatmentMaster", true);
		$nbr_treatment = $treatment_master_model->find('count', array('conditions'=>array('TreatmentMaster.participant_id'=>$participant_id, 'TreatmentMaster.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_treatment > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_treatment';
		}	
		
		$family_history_model = AppModel::atimNew("Clinicalannotation", "FamilyHistory", true);
		$nbr_familyhistory = $family_history_model->find('count', array('conditions'=>array('FamilyHistory.participant_id'=>$participant_id, 'FamilyHistory.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_familyhistory > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_familyhistory';
		}			

		$reproductive_history_model = AppModel::atimNew("Clinicalannotation", "ReproductiveHistory", true);
		$nbr_reproductive = $reproductive_history_model->find('count', array('conditions'=>array('ReproductiveHistory.participant_id'=>$participant_id, 'ReproductiveHistory.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_reproductive > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_reproductive';
		}			

		$participant_contact_model = AppModel::atimNew("Clinicalannotation", "ParticipantContact", true);
		$nbr_contacts = $participant_contact_model->find('count', array('conditions'=>array('ParticipantContact.participant_id'=>$participant_id, 'ParticipantContact.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_contacts > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_contacts';
		}

		$misc_identifier_model = AppModel::atimNew("Clinicalannotation", "MiscIdentifier", true);
		$nbr_identifiers = $misc_identifier_model->find('count', array('conditions'=>array('MiscIdentifier.participant_id'=>$participant_id, 'MiscIdentifier.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_identifiers > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_identifiers';
		}

		$participant_message_model = AppModel::atimNew("Clinicalannotation", "ParticipantMessage", true);
		$nbr_messages = $participant_message_model->find('count', array('conditions'=>array('ParticipantMessage.participant_id'=>$participant_id, 'ParticipantMessage.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_messages > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_messages';
		}			

		$event_master_model = AppModel::atimNew("Clinicalannotation", "EventMaster", true);
		$nbr_events = $event_master_model->find('count', array('conditions'=>array('EventMaster.participant_id'=>$participant_id, 'EventMaster.deleted'=>0), 'recursive' => '-1'));
		if ($nbr_events > 0) {
			$arr_allow_deletion['allow_deletion'] = false;
			$arr_allow_deletion['msg'] = 'error_fk_participant_linked_events';
		}
		
		return $arr_allow_deletion;
	}
}

?>