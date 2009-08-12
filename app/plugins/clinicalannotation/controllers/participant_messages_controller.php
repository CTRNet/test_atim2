<?php

class ParticipantMessagesController extends ClinicalAnnotationAppController {
	
	var $uses = array('Clinicalannotation.ParticipantMessage', 'Clinicalannotation.Participant');
	var $paginate = array('ParticipantMessage'=>array('limit'=>10,'order'=>'ParticipantMessage.date_requested'));

	function listall( $participant_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }

		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		$this->data = $this->paginate($this->ParticipantMessage, array('ParticipantMessage.participant_id'=>$participant_id));
	}
	
	function detail( $participant_id=null, $participant_message_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$participant_message_id ) { $this->redirect( '/pages/err_clin-ann_no_message_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ParticipantMessage.id'=>$participant_message_id) );
		$this->data = $this->ParticipantMessage->find('first',array('conditions'=>array('ParticipantMessage.id'=>$participant_message_id)));
	}
	
	function add( $participant_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
	
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		if ( !empty($this->data) ) {
			$this->data['ParticipantMessage']['participant_id'] = $participant_id;
			if ( $this->ParticipantMessage->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/participant_messages/detail/'.$participant_id.'/'.$this->ParticipantMessage->id );
			}
		}
	}
	
	function edit( $participant_id=null, $participant_message_id=null) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$participant_message_id ) { $this->redirect( '/pages/err_clin-ann_no_message_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ParticipantMessage.id'=>$participant_message_id) );
		
		if ( !empty($this->data) ) {
			$this->ParticipantMessage->id = $participant_message_id;
			if ( $this->ParticipantMessage->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/participant_messages/detail/'.$participant_id.'/'.$participant_message_id );
			}
		} else {
			$this->data = $this->ParticipantMessage->find('first',array('conditions'=>array('ParticipantMessage.id'=>$participant_message_id)));
		}
	}

	function delete( $participant_id=null, $participant_message_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		if ( !$participant_message_id ) { $this->redirect( '/pages/err_clin-ann_no_message_id', NULL, TRUE ); }
		
		if( $this->ParticipantMessage->atim_delete( $participant_message_id ) ) {
			$this->flash( 'Your data has been deleted.', '/clinicalannotation/participant_messages/listall/'.$participant_id );
		} else {
			$this->flash( 'Error deleting data - Contact administrator.', '/clinicalannotation/participant_messages/listall/'.$participant_id );
		}
	}
	
}
?>