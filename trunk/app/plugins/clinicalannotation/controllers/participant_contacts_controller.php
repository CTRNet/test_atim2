<?php

class ParticipantContactsController extends ClinicalAnnotationAppController {
	var $uses = array('ParticipantContacts');
	var $paginate = array('ParticipantContacts'=>array('limit'=>10,'order'=>'ParticipantConacts.name ASC');	
	
	function listall( $participant_id ) {
		$this->data = $this->paginate($this->ParticipantContact);
	}
	
	function detail( $participant_id, $participant_contact_id ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ParticipantContact.id'=>$participant_contact_id) );
		$this->data = $this->ParticipantContact->find('first',array('conditions'=>array('ParticipantContact.id'=>$participant_contact_id)));
	}
	
	function add( $participant_id ) {
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/participant_contacts/listall/'.$particiant_id) );
		
		if ( !empty($this->data) ) {
			if ( $this->ParticipantContact->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/participant_contacts/detail/'.$participant_id.$this->ParticipantContact->id );
		}
	}
	
	function edit( $participant_id, $participant_contact_id) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ParticipantContact.id'=>$participant_contact_id) );
		
		if ( !empty($this->data) ) {
			$this->ParticipantContact->id = $participant_contact_id;
			if ( $this->ParticipantContact->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/participant_contacts/detail/'.$participant_id.$participant_contact_id );
		} else {
			$this->data = $this->ParticipantContact->find('first',array('conditions'=>array('ParticipantContact.id'=>$participant_contact_id)));
		}
	}
/*
	var $name = 'ParticipantContacts';
	var $uses = array('ParticipantContact');

	var $components = array('Summaries');
	var $helpers = array('Summaries');

	function beforeFilter() {
		// $auth_conf array hardcoded in oth_auth component, due to plugins compatibility
		$this->othAuth->controller = &$this;
		$this->othAuth->init();
		$this->othAuth->check();

		// CakePHP function to re-combine dat/time select fields
		$this->cleanUpFields();
	}

	function index() {
		// nothing...
	}

	function listall( $participant_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_26', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('participant_contacts') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );

		$criteria = array();
		$criteria['participant_id'] = $participant_id;
		$criteria = array_filter($criteria);

		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$contacts_data = $this->ParticipantContact->findAll( $criteria, NULL, $order, $limit, $page );
		
		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		$this->set( 'participant_contacts',  $contacts_data);
	}

	function detail( $participant_id=null, $participant_contact_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$participant_contact_id ) { $this->redirect( '/pages/err_clin-ann_no_contact_id' ); exit; }
		
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_26', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('participant_contacts') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );
		$this->set( 'participant_contact_id', $participant_contact_id );

		$this->ParticipantContact->id = $participant_contact_id;
		$contact_data = $this->ParticipantContact->read();
		
		if ( empty( $contact_data ) ) { $this->redirect( '/pages/err_clin-ann_no_contact_data' ); exit; }		

		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		$this->set( 'data',  $contact_data);
	}

	function add( $participant_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_26', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('participant_contacts') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );

		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		if ( !empty($this->data) ) {
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray('participant_contacts') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
							
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if ( !$this->ParticipantContact->validates( $this->data ) ) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
			if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
			
			// if data VALIDATE, then save data
			if ( $submitted_data_validates ) {
				
				if ( $this->ParticipantContact->save( $this->data ) ) {
					$this->flash( 'Your data has been saved.', '/participant_contacts/listall/'.$participant_id );
				} else {
					$this->redirect( '/pages/err_clin-ann_contact_record' ); 
					exit; 
				}
			}
		}
	}

	function edit( $participant_id=null, $participant_contact_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$participant_contact_id ) { $this->redirect( '/pages/err_clin-ann_no_contact_id' ); exit; }		

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_26', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('participant_contacts') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );
		$this->set( 'participant_contact_id', $participant_contact_id );

		$this->ParticipantContact->id = $participant_contact_id;
		$contact_data = $this->ParticipantContact->read();
		
		if ( empty( $contact_data ) ) { $this->redirect( '/pages/err_clin-ann_no_contact_data' ); exit; }				

		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
	
		if ( empty($this->data) ) {
			$this->data = $contact_data;
			$this->set( 'data', $this->data );

		} else {
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray('participant_contacts') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
						
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if ( !$this->ParticipantContact->validates( $this->data ) ) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
			if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
			
			// if data VALIDATE, then save data
			if ( $submitted_data_validates ) {
				
				if ( $this->ParticipantContact->save( $this->data['ParticipantContact'] ) ) {
					$this->flash( 'Your data has been updated.','/participant_contacts/detail/'.$participant_id.'/'.$participant_contact_id );
				} else {
					$this->redirect( '/pages/err_clin-ann_contact_record' ); 
					exit; 
				}
			}			
		}
	}

	function delete( $participant_id=null, $participant_contact_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$participant_contact_id ) { $this->redirect( '/pages/err_clin-ann_no_contact_id' ); exit; }

		// Verify consent exists
		$this->ParticipantContact->id = $participant_contact_id;
		$contact_data = $this->ParticipantContact->read();
		
		if ( empty( $contact_data ) ) { $this->redirect( '/pages/err_clin-ann_no_contact_data' ); exit; }				
		
		// look for CUSTOM HOOKS, "validation"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		if( $this->ParticipantContact->del( $participant_contact_id ) ) {
			$this->flash( 'Your data has been deleted.', '/participant_contacts/listall/'.$participant_id );
		} else {
			$this->redirect( '/pages/err_clin-ann_contact_deletion' ); 
			exit;
		}
	}
}
*/
?>