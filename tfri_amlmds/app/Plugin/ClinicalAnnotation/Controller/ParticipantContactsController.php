<?php

class ParticipantContactsController extends ClinicalAnnotationAppController {
	
	var $uses = array(
		'ClinicalAnnotation.ParticipantContact',
		'ClinicalAnnotation.Participant'
	);
	var $paginate = array('ParticipantContact'=>array('limit' => pagination_amount,'order'=>'ParticipantContact.contact_type ASC'));	
	
	function listall( $participant_id ) {
		// MANAGE DATA
		$participant_data = $this->Participant->getOrRedirect($participant_id);		

		$this->request->data = $this->paginate($this->ParticipantContact, array('ParticipantContact.participant_id'=>$participant_id));
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail( $participant_id, $participant_contact_id ) {
		if ( !$participant_id && !$participant_contact_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		// MANAGE DATA
		$participant_contact_data = $this->ParticipantContact->find('first', array('conditions'=>array('ParticipantContact.id'=>$participant_contact_id, 'ParticipantContact.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_contact_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		$this->request->data = $participant_contact_data;

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ParticipantContact.id'=>$participant_contact_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function add( $participant_id ) {
		if ( !$participant_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
	
		// MANAGE DATA
		$participant_data = $this->Participant->getOrRedirect($participant_id);
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->request->data) ) {
			$this->ParticipantContact->addWritableField('participant_id');
			$this->request->data['ParticipantContact']['participant_id'] = $participant_id;
			
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			if($submitted_data_validates) {
				if ( $this->ParticipantContact->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been updated','/ClinicalAnnotation/ParticipantContacts/detail/'.$participant_id.'/'.$this->ParticipantContact->id );
				}
			}
		}
	}
	
	function edit( $participant_id, $participant_contact_id) {
		if ( !$participant_id && !$participant_contact_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// MANAGE DATA
		$participant_contact_data = $this->ParticipantContact->find('first', array('conditions'=>array('ParticipantContact.id'=>$participant_contact_id, 'ParticipantContact.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_contact_data)) { $this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ParticipantContact.id'=>$participant_contact_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if(empty($this->request->data)) {
			$this->request->data = $participant_contact_data;	
		} else {
			$submitted_data_validates = true;
			// ... special validations
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}	
			
			if($submitted_data_validates) {
				$this->ParticipantContact->id = $participant_contact_id;
				if ( $this->ParticipantContact->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been updated','/ClinicalAnnotation/ParticipantContacts/detail/'.$participant_id.'/'.$participant_contact_id );
				}
			}
		}
	}
	
	function delete( $participant_id, $participant_contact_id ) {
		if ( !$participant_id && !$participant_contact_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// MANAGE DATA
		$participant_contact_data = $this->ParticipantContact->find('first', array('conditions'=>array('ParticipantContact.id'=>$participant_contact_id, 'ParticipantContact.participant_id'=>$participant_id), 'recursive' => '-1'));		
		if(empty($participant_contact_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}

		$arr_allow_deletion = $this->ParticipantContact->allowDeletion($participant_contact_id);
		
		if($arr_allow_deletion['allow_deletion']) {
			if( $this->ParticipantContact->atimDelete( $participant_contact_id ) ) {
				$this->atimFlash( 'your data has been deleted', '/ClinicalAnnotation/ParticipantContacts/listall/'.$participant_id );
			}
			else {
				$this->flash( 'error deleting data - contact administrator', '/ClinicalAnnotation/ParticipantContacts/listall/'.$participant_id );
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/ClinicalAnnotation/ParticipantContacts/detail/'.$participant_id.'/'.$participant_contact_id);
		}
	}
}

?>