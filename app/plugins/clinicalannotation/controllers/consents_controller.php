<?php

class ConsentsController extends ClinicalannotationAppController {

	var $uses = array('Consent','Participant');
	var $paginate = array('Consent'=>array('limit'=>10,'order'=>'Consent.date DSC')); 

	function listall() {
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
	}	

	function detail( $participant_id=null, $consent_id=null ) {
		$this->set( 'atim_menu_variables', array('Consent.id'=>$consent_id) );
		$this->data = $this->Consent->find('first',array('conditions'=>array('Consent.id'=>$consent_id)));
	}
	
	function add() {
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/consents/index') );
		
		if ( !empty($this->data) ) {
			if ( $this->Consent->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/consents/detail/'.$this->Consent->id );
		}
	}

	function edit( $participant_id=null, $consent_id=null ) {
		$this->set( 'atim_menu_variables', array('Consent.id'=>$consent_id) );
		
		if ( !empty($this->data) ) {
			$this->Consent->id = $consent_id;
			if ( $this->Consent->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/consents/detail/'.$consent_id );
		} else {
			$this->data = $this->Consent->find('first',array('conditions'=>array('Participant.id'=>$consent_id)));
		}
	}	

	function delete( $participant_id=null, $consent_id=null ) {
/*
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$consent_id ) { $this->redirect( '/pages/err_clin-ann_no_consent_id' ); exit; }

		// Verify consent exists
		$this->Consent->id = $consent_id;
		$consent_data = $this->Consent->read();
		if ( empty( $consent_data ) ) { $this->redirect( '/pages/err_clin-ann_no_consent_data' ); exit; }				
		
		if(!$this->allowConsentDeletion($consent_id)) {
			$this->flash( 'Your are not allowed to delete this data.','/consents/detail/'.$participant_id.'/'.$consent_id );
			exit;
		}
		
		// look for CUSTOM HOOKS, "validation"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		if( $this->Consent->del( $consent_id ) ) {
			$this->flash( 'Your data has been deleted.', '/consents/listall/'.$participant_id );
		} else {
			$this->redirect( '/pages/err_clin-ann_consent_deletion' ); 
			exit;
		}  */
	}	
	/*
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
		
		// set MENU variable for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_9', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('consents') );

		// set SUMMARY variable from plugin's COMPONENTS
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
		$consent_data = $this->Consent->findAll( $criteria, NULL, $order, $limit, $page );
		
		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		$this->set( 'consents',  $consent_data);
	}

	function detail( $participant_id=null, $consent_id=null ) {
		
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$consent_id ) { $this->redirect( '/pages/err_clin-ann_no_consent_id' ); exit; }
		
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_9', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('consents') );

		// set SUMMARY variable from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );
		$this->set( 'consent_id', $consent_id );

		$this->Consent->id = $consent_id;
		$consent_data = $this->Consent->read();
		
		if ( empty( $consent_data ) ) { $this->redirect( '/pages/err_clin-ann_no_consent_data' ); exit; }		

		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		$this->set( 'data',  $consent_data);
	}

	function add( $participant_id=null ) {
		
		// missing VARS, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_9', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('consents') );

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
			foreach ( $this->Forms->getValidateArray('consents') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
							
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if ( !$this->Consent->validates( $this->data ) ) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
			if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
			
			// if data VALIDATE, then save data
			if ( $submitted_data_validates ) {
				
				if ( $this->Consent->save( $this->data ) ) {
					$this->flash( 'Your data has been saved.', '/consents/listall/'.$participant_id );
				} else {
					$this->redirect( '/pages/err_clin-ann_consent_record' ); 
					exit; 
				}
			}
		}
	}

	function edit( $participant_id=null, $consent_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$consent_id ) { $this->redirect( '/pages/err_clin-ann_no_consent_id' ); exit; }
		
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_9', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('consents') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );
		$this->set( 'consent_id', $consent_id );

		$this->Consent->id = $consent_id;
		$consent_data = $this->Consent->read();
		
		if ( empty( $consent_data ) ) { $this->redirect( '/pages/err_clin-ann_no_consent_data' ); exit; }				

		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
	
		if ( empty($this->data) ) {

			$this->data = $consent_data;
			$this->set( 'data', $this->data );

		} else {
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray('consents') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
						
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if ( !$this->Consent->validates( $this->data ) ) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
			if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
			
			// if data VALIDATE, then save data
			if ( $submitted_data_validates ) {
				
				if ( $this->Consent->save( $this->data['Consent'] ) ) {
					$this->flash( 'Your data has been updated.','/consents/detail/'.$participant_id.'/'.$consent_id );
				} else {
					$this->redirect( '/pages/err_clin-ann_consent_record' ); 
					exit; 
				}
				
			}			
		}
	}

	function delete( $participant_id=null, $consent_id=null ) {

		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$consent_id ) { $this->redirect( '/pages/err_clin-ann_no_consent_id' ); exit; }

		// Verify consent exists
		$this->Consent->id = $consent_id;
		$consent_data = $this->Consent->read();
		
		if ( empty( $consent_data ) ) { $this->redirect( '/pages/err_clin-ann_no_consent_data' ); exit; }				
		
		if(!$this->allowConsentDeletion($consent_id)) {
			$this->flash( 'Your are not allowed to delete this data.','/consents/detail/'.$participant_id.'/'.$consent_id );
			exit;
		}
		
		// look for CUSTOM HOOKS, "validation"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		if( $this->Consent->del( $consent_id ) ) {
			$this->flash( 'Your data has been deleted.', '/consents/listall/'.$participant_id );
		} else {
			$this->redirect( '/pages/err_clin-ann_consent_deletion' ); 
			exit;
		}
	}
	
	function allowConsentDeletion($consent_id){
		
		// Verify consent is not attached to a clinical collection link	
		$criteria = 'ClinicalCollectionLink.consent_id ="' .$consent_id.'"';			 
		$record_nbr = $this->ClinicalCollectionLink->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}
				
		// Etc...
		
		return TRUE;
	}
	
}
 */
?>
