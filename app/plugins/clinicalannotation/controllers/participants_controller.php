<?php

class ParticipantsController extends ClinicalannotationAppController {

	var $uses = array('Participant');
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
	
	function add() {
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/participants/index') );
		
		if ( !empty($this->data) ) {
			if ( $this->Participant->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/participants/profile/'.$this->Participant->id );
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
		
		if( $this->Participant->del( $participant_id ) ) {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/participants/index/');
		} else {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/participants/index/');
		}
	}

}

?>