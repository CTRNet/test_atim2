<?php

class ParticipantsController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.Participant',
		'Clinicalannotation.ConsentMaster',
		'Clinicalannotation.ParticipantContact',
		'Clinicalannotation.ParticipantMessage',
		'Clinicalannotation.EventMaster',
		'Clinicalannotation.DiagnosisMaster',
		'Clinicalannotation.FamilyHistory',
		'Clinicalannotation.MiscIdentifier',
		'Clinicalannotation.ClinicalCollectionLink',
		'Clinicalannotation.ReproductiveHistory',
		'Clinicalannotation.TreatmentMaster'
	);
	var $paginate = array('Participant'=>array('limit'=>10,'order'=>'Participant.last_name ASC, Participant.first_name ASC')); 
	
	function index() {
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
	}
	
	function search() {
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/participants/index') );
		
		// if SEARCH form data, parse and create conditions
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->data = $this->paginate($this->Participant, $_SESSION['ctrapp_core']['search']['criteria']);
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Participant']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/clinicalannotation/participants/search';
	}

	function profile( $participant_id ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		$this->data = $this->Participant->find('first',array('conditions'=>array('Participant.id'=>$participant_id)));
	}
	
	function listall( ){
		$this->data = $this->paginate($this->Participant, array());
	}
	
	function add() {
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/participants/index') );
		
		if ( !empty($this->data) ) {
			if ( $this->Participant->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/participants/profile/'.$this->Participant->getLastInsertID());
		}
	}
	
	function edit( $participant_id ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		
		if ( !empty($this->data) ) {
			$this->Participant->id = $participant_id;
			if ( $this->Participant->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/participants/profile/'.$participant_id );
		} else {
			$this->data = $this->Participant->find('first',array('conditions'=>array('Participant.id'=>$participant_id)));
		}
	}

	function delete( $participant_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$consent_master_id = $this->ConsentMaster->find('first', array('conditions'=>array('ConsentMaster.participant_id'=>$participant_id, 'ConsentMaster.deleted'=>0),'fields'=>array('ConsentMaster.id')));
		$event_id = $this->EventMaster->find('first', array('conditions'=>array('EventMaster.participant_id'=>$participant_id, 'EventMaster.deleted'=>0),'fields'=>array('EventMaster.id')));
		$contact_id = $this->ParticipantContact->find('first', array('conditions'=>array('ParticipantContact.participant_id'=>$participant_id, 'ParticipantContact.deleted'=>0),'fields'=>array('ParticipantContact.id')));

		$diagnosis_master_id = $this->DiagnosisMaster->find('first', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id, 'DiagnosisMaster.deleted'=>0),'fields'=>array('DiagnosisMaster.id')));
		$family_id = $this->FamilyHistory->find('first', array('conditions'=>array('FamilyHistory.participant_id'=>$participant_id, 'FamilyHistory.deleted'=>0), 'fields'=>array('FamilyHistory.id')));
		$identifier_id = $this->MiscIdentifier->find('first', array('conditions'=>array('MiscIdentifier.participant_id'=>$participant_id, 'MiscIdentifier.deleted'=>0), 'fields'=>array('MiscIdentifier.id')));
		//$link_id = $this->ClinicalCollectionLink->find('first', array('conditions'=>array('ClinicalCollectionLink.participant_id'=>$participant_id, 'ClinicalCollectionLink.deleted'=>0), 'fields'=>array('ClinicalCollectionLink.id')));
		$link_id = NULL;
		$message_id = $this->ParticipantMessage->find('first', array('conditions'=>array('ParticipantMessage.participant_id'=>$participant_id, 'ParticipantMessage.deleted'=>0), 'fields'=>array('ParticipantMessage.id')));
		$reproductive_id = $this->ReproductiveHistory->find('first', array('conditions'=>array('ReproductiveHistory.participant_id'=>$participant_id, 'ReproductiveHistory.deleted'=>0), 'fields'=>array('ReproductiveHistory.id')));
		$treatment_id = $this->TreatmentMaster->find('first', array('conditions'=>array('TreatmentMaster.participant_id'=>$participant_id, 'TreatmentMaster.deleted'=>0),'fields'=>array('TreatmentMaster.id')));
		
		if ( $consent_master_id == NULL && $event_id == NULL && $contact_id == NULL && $diagnosis_master_id == NULL && $family_id == NULL && $identifier_id == NULL && $link_id == NULL &&
			$message_id == NULL && $reproductive_id == NULL && $treatment_id == NULL){
			if( $this->Participant->atim_delete( $participant_id ) ) {
				$this->flash( 'Your data has been deleted.', '/clinicalannotation/participants/index/');
			} else {
				$this->flash( 'Error deleting data - Contact administrator.', '/clinicalannotation/participants/index/');
			}
		}else{
			$message = "Your data cannot be deleted because the following records exist: ";
			if( $consent_master_id != NULL ){
				$message = $message."A consent record exists, ";
			}
			if( $event_id != NULL ){
				$message = $message."A annotation record exists, ";
			}
			if( $contact_id != NULL ){
				$message = $message."A contact record exists, ";
			}
			if( $diagnosis_master_id != NULL ){
				$message = $message."A diagnosis record exists, ";
			}
			if( $family_id != NULL ){
				$message = $message."A family history record exists, ";
			}
			if( $identifier_id != NULL ){
				$message = $message."A identifier record exists, ";
			}
			//if( $link_id != NULL ){
				//$message = $message."A link to collections exists, ";
			//}
			if( $message_id != NULL ){
				$message = $message."A message record exists, ";
			}
			if( $reproductive_id != NULL ){
				$message = $message."A reproductive history exists, ";
			}
			if( $treatment_id != NULL ){
				$message = $message."A treatment record exists, ";
			}
			
			$message = substr($message, 0, -2);
			
			$this->flash( $message, '/clinicalannotation/participants/profile/'.$participant_id.'/');
		}
	}

}

?>