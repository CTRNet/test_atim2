<?php

class ConsentsController extends ClinicalannotationAppController {

	var $uses = array('Consent','Participant');
	var $paginate = array('Consent'=>array('limit'=>10,'order'=>'Consent.date ASC')); 

	function listall( $participant_id=null ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		$this->data = $this->paginate($this->Consent, array('Consent.participant_id'=>$participant_id));
	}	

	function detail( $participant_id=null, $consent_id=null ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'Consent.id'=>$consent_id) );
		$this->data = $this->Consent->find('first',array('conditions'=>array('Consent.id'=>$consent_id)));
	}
	
	function add( $participant_id=null ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		
		if ( !empty($this->data) ) {
		//	$this->Consent->participant_id = $participant_id;
			if ( $this->Consent->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/consents/detail/'.$participant_id.'/'.$this->Consent->id );
			}
		}
	}

	function edit( $participant_id=null, $consent_id=null ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'Consent.id'=>$consent_id) );
		
		if ( !empty($this->data) ) {
			$this->Consent->id = $consent_id;
			if ( $this->Consent->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/consents/detail/'.$participant_id.'/'.$consent_id );
			}
		} else {
			$this->data = $this->Consent->find('first',array('conditions'=>array('Consent.id'=>$consent_id)));
		}
	}

	function delete( $participant_id=null, $consent_id=null ) {
		// TODO
	}
}

?>