<?php

class ParticipantsController extends ClinicalannotationAppController {

	var $uses = array('Participant');
	var $paginate = array('Participant'=>array('limit'=>10,'order'=>'Participant.last_name ASC, Participant.first_name ASC')); 
	
	// temp beforefilter to allow permissions, ACL tables not updated yet
	function beforeFilter() {
		parent::beforeFilter(); 
		$this->Auth->allowedActions = array('index','search');
	}
	
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
		$_SESSION['ctrapp_core']['search']['url'] = '/clinicalannotation/participants/i';
	}

	function profile( $participant_id ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		$this->data = $this->Participant->find('first',array('conditions'=>array('Participant.id'=>$participant_id)));
	}
	
	function edit( $participant_id ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		
		if ( !empty($this->data) ) {
			$this->Participant->id = $bank_id;
			if ( $this->Participant->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/participants/profile/'.$participant_id );
		} else {
			$this->data = $this->Participant->find('first',array('conditions'=>array('Participant.id'=>$participant_id)));
		}
	}
	
	/*
	var $name = 'Participants';
	var $uses = array('Participant',
		'Consent', 'Diagnosis', 'FamilyHistory', 'ReproductiveHistory', 
		'TreatmentMaster', 'EventMaster', 'ClinicalCollectionLink', 'ParticipantContact', 
		'ParticipantMessage', 'MiscIdentifier');

	function index() {

		// clear SEARCH criteria, for pagination bug
		$_SESSION['ctrapp_core']['clinical_annotation']['search_criteria'] = NULL;

		// set MENU varible for echo on VIEW
		$this->set( 'ctrapp_menu', array() );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('participants') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build() );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
	}

	function search() {

		// set MENU varible for echo on VIEW
		$this->set( 'ctrapp_menu', array() );

		// set FORM variable, for HELPER call on VIEW
		$ctrapp_form = $this->Forms->getFormArray('participants');
		$this->set( 'ctrapp_form', $ctrapp_form );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build() );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// if SEARCH form data, parsxe and create conditions
		if ( $this->data ) {
			$criteria = $this->Forms->getSearchConditions( $this->data, $ctrapp_form );
			$_SESSION['ctrapp_core']['clinical_annotation']['search_criteria'] = $criteria; // save CRITERIA to session for pagination
		} else {
			$criteria = $_SESSION['ctrapp_core']['clinical_annotation']['search_criteria']; // if no form data, use SESSION critera for PAGINATION bug
		}

		$no_pagination_order = '';
		$no_pagination_order = 'last_name ASC, first_name ASC';
		
		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$this->set( 'participants', $this->Participant->findAll( $criteria, NULL, $no_pagination_order, $limit, $page, 0, 2 ) );

	}

	function profile( $participant_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		
		// clear EVENT DX FILTER, used in EVENT MASTERS controller...
		$_SESSION['ctrapp_core']['clinical_annotation']['event_filter'] = NULL;

		// clear SEARCH criteria, for pagination bug
		$_SESSION['ctrapp_core']['clinical_annotation']['search_criteria'] = NULL;

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_6', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('participants') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		$this->Participant->id = $participant_id;
		$participant_data = $this->Participant->read();
		
		if ( empty( $participant_data ) ) { $this->redirect( '/pages/err_clin-ann_no_participant_data' ); exit; }		
		
		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		$this->set( 'data',  $participant_data);
	}

	function add() {
		// set MENU varible for echo on VIEW
		$this->set( 'ctrapp_menu', array() );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('participants') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build(  ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		if ( !empty($this->data) ) {
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray('participants') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if ( !$this->Participant->validates( $this->data ) ) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
			if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
			
			// if data VALIDATE, then save data
			if ( $submitted_data_validates ) {
				if ( $this->Participant->save( $this->data ) ) {
					$this->flash( 'Your data has been saved.', '/participants/profile/'.$this->Participant->getLastInsertId() );
				} else {
					$this->redirect( '/pages/err_clin-ann_participant_record' ); 
					exit; 
				}
			}	
		}
	}

	function edit( $participant_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_6', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('participants') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// Create participant object and load
		$this->Participant->id = $participant_id;
		$participant_data = $this->Participant->read();		
		
		if ( empty( $participant_data ) ) { $this->redirect( '/pages/err_clin-ann_no_participant_data' ); exit; }
				
		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
	
		if ( empty($this->data) ) {
			$this->data = $participant_data;
			$this->set( 'data', $this->data );
		} else {
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray('participants') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
						
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if ( !$this->Participant->validates( $this->data ) ) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
			if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
			
			// if data VALIDATE, then save data
			if ( $submitted_data_validates ) {
				
				if ( $this->Participant->save( $this->data['Participant'] ) ) {
					$this->flash( 'Your data has been updated.','/participants/profile/'.$participant_id );
				} else {
					$this->redirect( '/pages/err_clin-ann_participant_record' ); 
					exit; 
				}
			}			
		}
	}

	function delete( $participant_id=null ) {
		
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }

		// Verify consent exists
		$this->Participant->id = $participant_id;
		$participant_data = $this->Participant->read();
		
		if ( empty( $participant_data ) ) { $this->redirect( '/pages/err_clin-ann_no_participant_data' ); exit; }				
		
		if(!$this->allowParticipantDeletion($participant_id)) {
			$this->flash( 'Your are not allowed to delete this data.','/participants/profile/'.$participant_id );
			exit;
		}
		
		// look for CUSTOM HOOKS, "validation"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		if ( $this->Participant->del( $participant_id ) ) {
			$this->flash( 'Your data has been deleted.', '/participants/' );
		} else {
			$this->redirect( '/pages/err_clin-ann_participant_deletion' ); 
			exit;
		}
	}
	
	function allowParticipantDeletion($participant_id){
		
		// Verify record is not attached to a consnet	
		$criteria = 'Consent.participant_id ="' .$participant_id.'"';			 
		$record_nbr = $this->Consent->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}
		
		// Verify record is not attached to a diag	
		$criteria = 'Diagnosis.participant_id ="' .$participant_id.'"';			 
		$record_nbr = $this->Diagnosis->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}
					
		// Verify record is not attached to a FamilyHistory	
		$criteria = 'FamilyHistory.participant_id ="' .$participant_id.'"';			 
		$record_nbr = $this->FamilyHistory->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}
					
		// Verify record is not attached to a ReproductiveHistory
		$criteria = 'ReproductiveHistory.participant_id ="' .$participant_id.'"';			 
		$record_nbr = $this->ReproductiveHistory->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}
		
		// Verify record is not attached to a trt	
		$criteria = 'TreatmentMaster.participant_id ="' .$participant_id.'"';			 
		$record_nbr = $this->TreatmentMaster->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}
					
		// Verify record is not attached to an event	
		$criteria = 'EventMaster.participant_id ="' .$participant_id.'"';			 
		$record_nbr = $this->EventMaster->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}

		// Verify record is not attached to a clinical collection link	
		$criteria = 'ClinicalCollectionLink.participant_id ="' .$participant_id.'"';			 
		$record_nbr = $this->ClinicalCollectionLink->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}
		
		// Verify record is not attached to a ParticipantContact	
		$criteria = 'ParticipantContact.participant_id ="' .$participant_id.'"';			 
		$record_nbr = $this->ParticipantContact->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}
		
		// Verify record is not attached to a ParticipantMessage	
		$criteria = 'ParticipantMessage.participant_id ="' .$participant_id.'"';			 
		$record_nbr = $this->ParticipantMessage->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}
		
		// Verify record is not attached to a ParticipantMessage	
		$criteria = 'MiscIdentifier.participant_id ="' .$participant_id.'"';			 
		$record_nbr = $this->MiscIdentifier->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}
		
		// Etc...
		
		return TRUE;
	}
	*/
}

?>