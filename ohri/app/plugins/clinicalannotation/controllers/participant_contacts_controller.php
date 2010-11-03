<?php

class ParticipantContactsController extends ClinicalannotationAppController {
	
	var $uses = array(
		'Clinicalannotation.ParticipantContact',
		'Clinicalannotation.Participant'
	);
	var $paginate = array('ParticipantContact'=>array('limit' => pagination_amount,'order'=>'ParticipantContact.contact_type ASC'));	
	
	function listall( $participant_id ) {
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	

		$this->data = $this->paginate($this->ParticipantContact, array('ParticipantContact.participant_id'=>$participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail( $participant_id, $participant_contact_id ) {
		if ( !$participant_id && !$participant_contact_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA
		$participant_contact_data = $this->ParticipantContact->find('first', array('conditions'=>array('ParticipantContact.id'=>$participant_contact_id, 'ParticipantContact.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_contact_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		$this->data = $participant_contact_data;

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ParticipantContact.id'=>$participant_contact_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function add( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
	
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$this->data['ParticipantContact']['participant_id'] = $participant_id;
			
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			if($submitted_data_validates) {
				if ( $this->ParticipantContact->save($this->data) ) {
					$this->atimFlash( 'your data has been updated','/clinicalannotation/participant_contacts/detail/'.$participant_id.'/'.$this->ParticipantContact->id );
				}
			}
		}
	}
	
	function edit( $participant_id, $participant_contact_id) {
		if ( !$participant_id && !$participant_contact_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$participant_contact_data = $this->ParticipantContact->find('first', array('conditions'=>array('ParticipantContact.id'=>$participant_contact_id, 'ParticipantContact.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_contact_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ParticipantContact.id'=>$participant_contact_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if(empty($this->data)) {
			$this->data = $participant_contact_data;	
		} else {
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }	
			
			if($submitted_data_validates) {
				$this->ParticipantContact->id = $participant_contact_id;
				if ( $this->ParticipantContact->save($this->data) ) {
					$this->atimFlash( 'your data has been updated','/clinicalannotation/participant_contacts/detail/'.$participant_id.'/'.$participant_contact_id );
				}
			}
		}
	}
	
	function delete( $participant_id, $participant_contact_id ) {
		if ( !$participant_id && !$participant_contact_id ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$participant_contact_data = $this->ParticipantContact->find('first', array('conditions'=>array('ParticipantContact.id'=>$participant_contact_id, 'ParticipantContact.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_contact_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		$arr_allow_deletion = $this->allowParticipantContactDeletion($participant_contact_id);
		
		if($arr_allow_deletion['allow_deletion']) {
			if( $this->ParticipantContact->atim_delete( $participant_contact_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/clinicalannotation/participant_contacts/listall/'.$participant_id );
			}
			else {
				$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/participant_contacts/listall/'.$participant_id );
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/participant_contacts/detail/'.$participant_id.'/'.$participant_contact_id);
		}
	}
	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $participant_contact_id Id of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */	
	 
	function allowParticipantContactDeletion( $participant_contact_id ) {
		//$returned_nbr = $this->LinkedModel->find('count', array('conditions' => array('LinkedModel.family_history_id' => $family_history_id), 'recursive' => '-1'));
		//if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'a LinkedModel exists for the deleted family history'); }
		return array('allow_deletion' => true, 'msg' => '');
	}	
}

?>