<?php

class ParticipantContactsController extends ClinicalannotationAppController {
	
	var $uses = array('Clinicalannotation.ParticipantContact');
	var $paginate = array('ParticipantContact'=>array('limit'=>10,'order'=>'ParticipantContact.contact_type ASC'));	
	
	function listall( $participant_id ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		
		$this->hook();
		
		$this->data = $this->paginate($this->ParticipantContact, array('ParticipantContact.participant_id'=>$participant_id));
	}
	
	function detail( $participant_id, $participant_contact_id ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$participant_contact_id ) { $this->redirect( '/pages/err_clin-ann_no_contact_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ParticipantContact.id'=>$participant_contact_id) );
		
		$this->hook();
		
		$this->data = $this->ParticipantContact->find('first',array('conditions'=>array('ParticipantContact.id'=>$participant_contact_id)));
	}
	
	function add( $participant_id ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );	
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->data['ParticipantContact']['participant_id'] = $participant_id;
			if ( $this->ParticipantContact->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/participant_contacts/detail/'.$participant_id.'/'.$this->ParticipantContact->id );
			}
		}
	}
	
	function edit( $participant_id, $participant_contact_id) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$participant_contact_id ) { $this->redirect( '/pages/err_clin-ann_no_contact_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ParticipantContact.id'=>$participant_contact_id) );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->ParticipantContact->id = $participant_contact_id;
			if ( $this->ParticipantContact->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/participant_contacts/detail/'.$participant_id.'/'.$participant_contact_id );
			}
		} else {
			$this->data = $this->ParticipantContact->find('first',array('conditions'=>array('ParticipantContact.id'=>$participant_contact_id)));
		}
	}
	
	function delete( $participant_id=null, $participant_contact_id=null ) {
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$participant_contact_id ) { $this->redirect( '/pages/err_clin-ann_no_contact_id', NULL, TRUE ); }
		
		$this->hook();
		
		if( $this->ParticipantContact->atim_delete( $participant_contact_id ) ) {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/participant_contacts/listall/'.$participant_id );
		}
		else {
			$this->flash( 'Error deleting data - Contact administrator.', '/clinicalannotation/participant_contacts/listall/'.$participant_id );
		}
	}	
}

?>