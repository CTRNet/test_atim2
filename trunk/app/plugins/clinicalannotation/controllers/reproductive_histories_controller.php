<?php

class ReproductiveHistoriesController extends ClinicalAnnotationAppController {
	
	$uses = array('ReproductiveHistory');
	$paginate = array('ReproductiveHistory'=>array('limit'=>10,'order'=>'ReproductiveHistory.participant_id ASC'));
	
	function listall( $participant_id ) {
		$this->data = $this->paginate($this->ReproductiveHistory);
	}
	
	function detail( $participant_id, $reproductive_history_id ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ReproductiveHistory.id'=>$reproductive_history_id) );
		$this->data = $this->FamilyHistory->find('first',array('conditions'=>array('ReproductiveHistory.id'=>$reproductive_history_id)));
	}
	
	function add( $participant_id ) {
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/reproductive_histories/listall/'.$particiant_id) );
		
		if ( !empty($this->data) ) {
			if ( $this->ReproductiveHistory->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/reproductive_histories/detail/'.$participant_id.$this->ReproductiveHistory->id );
		}
	}
	
	function edit( $participant_id, $reproductive_history_id) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'ReproductiveHistory.id'=>$reproductive_history_id) );
		
		if ( !empty($this->data) ) {
			$this->ReproductiveHistory->id = $reproductive_history_id;
			if ( $this->rReproductiveHistory->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/reproductive_histories/detail/'.$participant_id.$reproductive_history_id );
		} else {
			$this->data = $this->ReproductiveHistory->find('first',array('conditions'=>array('ReproductiveHistory.id'=>$reproductive_history_id)));
		}
	}

/*
	var $name = 'ReproductiveHistories';
	var $uses = array('ReproductiveHistory');

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
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_68', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('reproductive_histories') );

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
		$reproductive_data = $this->ReproductiveHistory->findAll( $criteria, NULL, $order, $limit, $page );
		
		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		$this->set( 'reproductive_histories',  $reproductive_data);
	}

	function detail( $participant_id=null, $reproductive_history_id=null ) {

		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$reproductive_history_id ) { $this->redirect( '/pages/err_clin-ann_no_reproductive_id' ); exit; }
		
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_68', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('reproductive_histories') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );
		$this->set( 'reproductive_history_id', $reproductive_history_id );

		$this->ReproductiveHistory->id = $reproductive_history_id;
		$reproductive_data = $this->ReproductiveHistory->read();
		
		if ( empty( $reproductive_data ) ) { $this->redirect( '/pages/err_clin-ann_no_reproductive_data' ); exit; }		

		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		$this->set( 'data',  $reproductive_data);		
	}

	function add( $participant_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
				
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_68', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('reproductive_histories') );

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
			foreach ( $this->Forms->getValidateArray('reproductive_histories') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
							
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if ( !$this->ReproductiveHistory->validates( $this->data ) ) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
			if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
			
			// if data VALIDATE, then save data
			if ( $submitted_data_validates ) {
				
				if ( $this->ReproductiveHistory->save( $this->data ) ) {
					$this->flash( 'Your data has been saved.', '/reproductive_histories/listall/'.$participant_id );
				} else {
					$this->redirect( '/pages/err_clin-ann_reproductive_record' ); 
					exit; 
				}
			}
		}
	}

	function edit( $participant_id=null, $reproductive_history_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$reproductive_history_id ) { $this->redirect( '/pages/err_clin-ann_no_reproductive_id' ); exit; }
		
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_68', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('reproductive_histories') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );
		$this->set( 'reproductive_history_id', $reproductive_history_id );

		$this->ReproductiveHistory->id = $reproductive_history_id;
		$reproductive_data = $this->ReproductiveHistory->read();
		
		if ( empty( $reproductive_data ) ) { $this->redirect( '/pages/err_clin-ann_no_reproductive_data' ); exit; }				

		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
	
		if ( empty($this->data) ) {
			$this->data = $reproductive_data;
			$this->set( 'data', $this->data );
		} else {
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray('reproductive_histories') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
						
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if ( !$this->ReproductiveHistory->validates( $this->data ) ) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
			if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
			
			// if data VALIDATE, then save data
			if ( $submitted_data_validates ) {
				if ( $this->ReproductiveHistory->save( $this->data['ReproductiveHistory'] ) ) {
					$this->flash( 'Your data has been updated.','/reproductive_histories/detail/'.$participant_id.'/'.$reproductive_history_id );
				} else {
					$this->redirect( '/pages/err_clin-ann_reproductive_record' ); 
					exit; 
				}
			}			
		}
	}
*/
	function delete( $participant_id=null, $reproductive_history_id=null ) {
/*
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$reproductive_history_id ) { $this->redirect( '/pages/err_clin-ann_no_reproductive_id' ); exit; }

		// Verify consent exists
		$this->ReproductiveHistory->id = $reproductive_history_id;
		$reproductive_data = $this->ReproductiveHistory->read();
		
		if ( empty( $reproductive_data ) ) { $this->redirect( '/pages/err_clin-ann_no_reproductive_data' ); exit; }				
		
		// look for CUSTOM HOOKS, "validation"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		if( $this->ReproductiveHistory->del( $reproductive_history_id ) ) {
			$this->flash( 'Your data has been deleted.', '/reproductive_histories/listall/'.$participant_id );
		} else {
			$this->redirect( '/pages/err_clin-ann_reproductive_deletion' ); 
			exit;
		}
	}

}

?>