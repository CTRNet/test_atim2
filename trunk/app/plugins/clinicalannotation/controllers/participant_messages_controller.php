<?php

class ParticipantMessagesController extends ClinicalAnnotationAppController {
	
	var $uses = array(
		'Clinicalannotation.ParticipantMessage',
		'Clinicalannotation.Participant');
	var $paginate = array('ParticipantMessage'=>array('limit' => pagination_amount,'order'=>'ParticipantMessage.date_requested'));

	function listall( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( 'err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }		
			
		$this->data = $this->paginate($this->ParticipantMessage, array('ParticipantMessage.participant_id'=>$participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail( $participant_id, $participant_message_id ) {
		if ( !$participant_id && !$participant_message_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		// MANAGE DATA
		$participant_messsage_data = $this->ParticipantMessage->find('first', array('conditions'=>array('ParticipantMessage.id'=>$participant_message_id, 'ParticipantMessage.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_messsage_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
		$this->data = $participant_messsage_data;
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ParticipantMessage.id'=>$participant_message_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function add( $participant_id=null ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
	
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$this->data['ParticipantMessage']['participant_id'] = $participant_id;
			
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }	
			
			if($submitted_data_validates) {
				if ( $this->ParticipantMessage->save($this->data) ) {
					$this->atimFlash( 'your data has been updated','/clinicalannotation/participant_messages/detail/'.$participant_id.'/'.$this->ParticipantMessage->id );
				}			
			}
		}
	}
	
	function edit( $participant_id, $participant_message_id ) {
		if ( !$participant_id && !$participant_message_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		// MANAGE DATA
		$participant_message_data = $this->ParticipantMessage->find('first', array('conditions'=>array('ParticipantMessage.id'=>$participant_message_id, 'ParticipantMessage.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_message_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ParticipantMessage.id'=>$participant_message_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if(empty($this->data)) {
			$this->data = $participant_message_data;	
		} else {
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }	
			
			if($submitted_data_validates) {
				$this->ParticipantMessage->id = $participant_message_id;
				if ( $this->ParticipantMessage->save($this->data) ) {
					$this->atimFlash( 'your data has been updated','/clinicalannotation/participant_messages/detail/'.$participant_id.'/'.$participant_message_id );
				}			
			}
		}
	}

	function delete( $participant_id, $participant_message_id ) {
		if ( !$participant_id && !$participant_message_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// MANAGE DATA
		$participant_message_data = $this->ParticipantMessage->find('first', array('conditions'=>array('ParticipantMessage.id'=>$participant_message_id, 'ParticipantMessage.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_message_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }

		$arr_allow_deletion = $this->ParticipantMessage->allowDeletion($participant_message_id);
		
		if($arr_allow_deletion['allow_deletion']) {
		
			if( $this->ParticipantMessage->atim_delete( $participant_message_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/clinicalannotation/participant_messages/listall/'.$participant_id );
			} else {
				$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/participant_messages/listall/'.$participant_id );
			}		
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/participant_messages/detail/'.$participant_id.'/'.$participant_message_id);
		}
	}
}
?>