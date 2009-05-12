<?php

class ParticipantMessagesController extends ClinicalAnnotationAppController {
	var $uses = array('ParticipantMessage');
	var $paginate = array('ParticipantMessages'=>array('limit'=>10,'order'=>'ParticipantMessages.name ASC');

	function listall( $participant_id ) {
		$this->data = $this->paginate($this->ParticipantMessage);
	}
	
	function detail( $participant_id, $participant_message_id ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ParticipantMessage.id'=>$participant_message_id) );
		$this->data = $this->ParticipantMessage->find('first',array('conditions'=>array('ParticipantMessage.id'=>$participant_message_id)));
	}
	
	function add( $participant_id ) {
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/participant_messages/listall/'.$particiant_id) );
		
		if ( !empty($this->data) ) {
			if ( $this->ParticipantMessage->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/participant_messages/detail/'.$participant_id.$this->ParticipantMessage->id );
		}
	}
	
	function edit( $participant_id, $participant_message_id) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ParticipantMessage.id'=>$participant_message_id) );
		
		if ( !empty($this->data) ) {
			$this->ParticipantMessage->id = $participant_message_id;
			if ( $this->ParticipantMessage->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/participant_messages/detail/'.$participant_id.$participant_message_id );
		} else {
			$this->data = $this->ParticipantMessage->find('first',array('conditions'=>array('ParticipantMessage.id'=>$participant_message_id)));
		}
	}
/*
	var $name = 'ParticipantMessages';
	var $uses = array('ParticipantMessage');

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
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_25', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('participant_messages') );

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
		$message_data = $this->ParticipantMessage->findAll( $criteria, NULL, $order, $limit, $page );
		
		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		$this->set( 'participant_messages',  $message_data);
	}

	function detail( $participant_id=null, $participant_message_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$participant_message_id ) { $this->redirect( '/pages/err_clin-ann_no_message_id' ); exit; }
		
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_25', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('participant_messages') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );
		$this->set( 'participant_message_id', $participant_message_id );

		$this->ParticipantMessage->id = $participant_message_id;
		$message_data = $this->ParticipantMessage->read();
		
		if ( empty( $message_data ) ) { $this->redirect( '/pages/err_clin-ann_no_message_data' ); exit; }		

		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		$this->set( 'data',  $message_data);
	}

	function add( $participant_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_25', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('participant_messages') );

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
			foreach ( $this->Forms->getValidateArray('participant_messages') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
							
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if ( !$this->ParticipantMessage->validates( $this->data ) ) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
			if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
			
			// if data VALIDATE, then save data
			if ( $submitted_data_validates ) {
				
				if ( $this->ParticipantMessage->save( $this->data ) ) {
					$this->flash( 'Your data has been saved.', '/participant_messages/listall/'.$participant_id );
				} else {
					$this->redirect( '/pages/err_clin-ann_message_record' ); 
					exit; 
				}
			}
		}
	}

	function edit( $participant_id=null, $participant_message_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$participant_message_id ) { $this->redirect( '/pages/err_clin-ann_no_message_id' ); exit; }
		
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_25', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('participant_messages') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );
		$this->set( 'participant_message_id', $participant_message_id );

		$this->ParticipantMessage->id = $participant_message_id;
		$message_data = $this->ParticipantMessage->read();
		
		if ( empty( $message_data ) ) { $this->redirect( '/pages/err_clin-ann_no_message_data' ); exit; }				

		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
	
		if ( empty($this->data) ) {
			$this->data = $message_data;
			$this->set( 'data', $this->data );

		} else {
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray('participant_messages') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
						
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if ( !$this->ParticipantMessage->validates( $this->data ) ) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
			if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
			
			// if data VALIDATE, then save data
			if ( $submitted_data_validates ) {
				
				if ( $this->ParticipantMessage->save( $this->data['ParticipantMessage'] ) ) {
					$this->flash( 'Your data has been updated.','/participant_messages/detail/'.$participant_id.'/'.$participant_message_id );
				} else {
					$this->redirect( '/pages/err_clin-ann_message_record' ); 
					exit; 
				}
			}			
		}
	}
*/
	function delete( $participant_id=null, $participant_message_id=null ) {}
	/*
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$participant_message_id ) { $this->redirect( '/pages/err_clin-ann_no_message_id' ); exit; }

		// Verify consent exists
		$this->ParticipantMessage->id = $participant_message_id;
		$message_data = $this->ParticipantMessage->read();
		
		if ( empty( $message_data ) ) { $this->redirect( '/pages/err_clin-ann_no_message_data' ); exit; }				
		
		// look for CUSTOM HOOKS, "validation"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		if( $this->ParticipantMessage->del( $participant_message_id ) ) {
			$this->flash( 'Your data has been deleted.', '/participant_messages/listall/'.$participant_id );
		} else {
			$this->redirect( '/pages/err_clin-ann_message_deletion' ); 
			exit;
		}
	}

}
*/
}
?>