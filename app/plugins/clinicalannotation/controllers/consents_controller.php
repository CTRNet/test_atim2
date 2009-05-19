<?php

class ConsentsController extends ClinicalannotationAppController {

	var $uses = array('Consent','Participant');
	var $paginate = array('Consent'=>array('limit'=>10,'order'=>'Consent.date DSC')); 

	function listall( $participant_id=null ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		$this->data = $this->paginate($this->Consent);
	}	

	function detail( $participant_id=null, $consent_id=null ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'Consent.id'=>$consent_id) );
		$this->data = $this->Consent->find('first',array('conditions'=>array('Consent.id'=>$consent_id)));
	}
	
	function add() {
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/consents/index') );
		
		if ( !empty($this->data) ) {
			if ( $this->Consent->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/consents/detail/'.$this->Consent->id );
		}
	}

	function edit( $participant_id=null, $consent_id=null ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'Consent.id'=>$consent_id) );
		
		if ( !empty($this->data) ) {
			$this->Consent->id = $consent_id;
			if ( $this->Consent->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/consents/detail/'.$consent_id );
		} else {
			$this->data = $this->Consent->find('first',array('conditions'=>array('Consent.id'=>$consent_id)));
		}
	}

	function delete( $participant_id=null, $consent_id=null ) {
		// TODO
	}
}

?>