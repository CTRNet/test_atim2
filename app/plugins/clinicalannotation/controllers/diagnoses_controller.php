<?php

class DiagnosesController extends ClinicalannotationAppController {

	var $uses = array('Diagnosis', 'CodingIcd10', 'ClinicalCollectionLink', 'EventMaster', 'TreatmentMaster');
	var $paginate = array('Diagnosis'=>array('limit'=>10,'order'=>'Diagnosis.case_number ASC, Diagnosis.dx_date ASC')); 
	
	function listall( $participant_id=null ) {
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
	}

	function detail( $participant_id=null, $diagnosis_id=null ) {
		$this->set( 'atim_menu_variables', array('Diagnosis.id'=>$diagnosis_id) );
		$this->data = $this->Diagnosis->find('first',array('conditions'=>array('Diagnosis.id'=>$diagnosis_id)));
	}

	function add( $participant_id=null ) {
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/diagnoses/index') );
		
		if ( !empty($this->data) ) {
			if ( $this->Diagnosis->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/diagnoses/detail/'.$this->Diagnosis->id );
		}		
	}

	function edit( $participant_id=null, $diagnosis_id=null ) {
		$this->set( 'atim_menu_variables', array('Diagnosis.id'=>$diagnosis_id) );
		
		if ( !empty($this->data) ) {
			$this->Diagnosis->id = $diagnosis_id;
			if ( $this->Diagnosis->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/diagnoses/detail/'.$diagnosis_id );
		} else {
			$this->data = $this->Diagnosis->find('first',array('conditions'=>array('Diagnosis.id'=>$diagnosis_id)));
		}
	}

	function delete( $participant_id=null, $diagnosis_id=null ) {
/*		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$diagnosis_id ) { $this->redirect( '/pages/err_clin-ann_no_dx_id' ); exit; }

		// Verify consent exists
		$this->Diagnosis->id = $diagnosis_id;
		$dx_data = $this->Diagnosis->read();
		
		if ( empty( $dx_data ) ) { $this->redirect( '/pages/err_clin-ann_no_dx_data' ); exit; }				
		
		if(!$this->allowDiagnosisDeletion($diagnosis_id)) {
			$this->flash( 'Your are not allowed to delete this data.','/diagnoses/detail/'.$participant_id.'/'.$diagnosis_id );
			exit;
		}
		
		// look for CUSTOM HOOKS, "validation"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		if( $this->Diagnosis->del( $diagnosis_id ) ) {
			$this->flash( 'Your data has been deleted.', '/diagnoses/listall/'.$participant_id );
		} else {
			$this->redirect( '/pages/err_clin-ann_dx_deletion' ); 
			exit;
		}
*/
	}
	
	function allowDiagnosisDeletion($diagnosis_id) {
/*		
		// Verify diagnosis is not attached to a clinical collection link	
		$criteria = 'ClinicalCollectionLink.diagnosis_id ="' .$diagnosis_id.'"';			 
		$record_nbr = $this->ClinicalCollectionLink->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}
		
		// Verify diagnosis is not attached to an event	
		$criteria = 'EventMaster.diagnosis_id ="' .$diagnosis_id.'"';			 
		$record_nbr = $this->EventMaster->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}
		
		// Verify diagnosis is not attached to a trt	
		$criteria = 'TreatmentMaster.diagnosis_id ="' .$diagnosis_id.'"';			 
		$record_nbr = $this->TreatmentMaster->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}			
		
		// Etc...
		
		return TRUE;
		*/
	}
}
/*
	var $name = 'Diagnoses';
	var $uses = array('Diagnosis', 'CodingIcd10', 'ClinicalCollectionLink', 'EventMaster', 'TreatmentMaster');

	var $components = array('Summaries');
	var $helpers = array('Summaries', 'MoreForm');

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
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_5', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('diagnoses') );

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
		$order = '';
		$order = 'case_number ASC, dx_date ASC';
		
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$dx_data = $this->Diagnosis->findAll( $criteria, NULL, $order, $limit, $page );
		
		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		$this->set( 'diagnoses',  $dx_data);
	}

	function detail( $participant_id=null, $diagnosis_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$diagnosis_id ) { $this->redirect( '/pages/err_clin-ann_no_dx_id' ); exit; }
		
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_5', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('diagnoses') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );
		$this->set( 'diagnosis_id', $diagnosis_id );
		
		$this->Diagnosis->id = $diagnosis_id;
		$dx_data = $this->Diagnosis->read();
		
		if ( empty( $dx_data ) ) { $this->redirect( '/pages/err_clin-ann_no_dx_data' ); exit; }		

		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		$this->set( 'data',  $dx_data);
	}

	function add( $participant_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_5', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('diagnoses') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );

		// get all DX rows for primary/case input
		$criteria = 'participant_id="'.$participant_id.'" AND case_number>=0';
		$order = 'case_number ASC, dx_date ASC';
		$this->set( 'dx_listall', $this->Diagnosis->findAll( $criteria, NULL, $order ) );

		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		if ( !empty($this->data) ) {
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray('diagnoses') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
							
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if ( !$this->Diagnosis->validates( $this->data ) ) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
			if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
			
			// if data VALIDATE, then save data
			if ( $submitted_data_validates ) {
				
				if ( $this->Diagnosis->save( $this->data ) ) {
					$this->flash( 'Your data has been saved.', '/diagnoses/listall/'.$participant_id );
				} else {
					$this->redirect( '/pages/err_clin-ann_diagnosis_record' ); 
					exit; 
				}
			}
		}
		
	}

	function edit( $participant_id=null, $diagnosis_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$diagnosis_id ) { $this->redirect( '/pages/err_clin-ann_no_dx_id' ); exit; }
		
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_5', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('diagnoses') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'participant_id', $participant_id );
		$this->set( 'diagnosis_id', $diagnosis_id );

		// get all DX rows for primary/case input
		$criteria = 'participant_id="'.$participant_id.'" AND case_number>=0';
		$order = 'case_number ASC, dx_date ASC';
		$this->set( 'dx_listall', $this->Diagnosis->findAll( $criteria, NULL, $order ) );

		$this->Diagnosis->id = $diagnosis_id;
		$dx_data = $this->Diagnosis->read();
		
		if ( empty( $dx_data ) ) { $this->redirect( '/pages/err_clin-ann_no_consent_data' ); exit; }				

		// look for CUSTOM HOOKS, "format"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
	
		if ( empty($this->data) ) {
			$this->data = $dx_data;
			$this->set( 'data', $this->data );
		} else {
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray('diagnoses') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
						
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if ( !$this->Diagnosis->validates( $this->data ) ) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
			if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
			
			// if data VALIDATE, then save data
			if ( $submitted_data_validates ) {
				if ( $this->Diagnosis->save( $this->data['Diagnosis'] ) ) {
					$this->flash( 'Your data has been updated.','/diagnoses/detail/'.$participant_id.'/'.$diagnosis_id );
				} else {
					$this->redirect( '/pages/err_clin-ann_dx_record' ); 
					exit; 
				}
			}			
		}
	}

	function delete( $participant_id=null, $diagnosis_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$diagnosis_id ) { $this->redirect( '/pages/err_clin-ann_no_dx_id' ); exit; }

		// Verify consent exists
		$this->Diagnosis->id = $diagnosis_id;
		$dx_data = $this->Diagnosis->read();
		
		if ( empty( $dx_data ) ) { $this->redirect( '/pages/err_clin-ann_no_dx_data' ); exit; }				
		
		if(!$this->allowDiagnosisDeletion($diagnosis_id)) {
			$this->flash( 'Your are not allowed to delete this data.','/diagnoses/detail/'.$participant_id.'/'.$diagnosis_id );
			exit;
		}
		
		// look for CUSTOM HOOKS, "validation"
		$custom_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
		if ( file_exists($custom_controller_hook) ) { require($custom_controller_hook); }
		
		if( $this->Diagnosis->del( $diagnosis_id ) ) {
			$this->flash( 'Your data has been deleted.', '/diagnoses/listall/'.$participant_id );
		} else {
			$this->redirect( '/pages/err_clin-ann_dx_deletion' ); 
			exit;
		}

	}
	
	function allowDiagnosisDeletion($diagnosis_id){
		
		// Verify diagnosis is not attached to a clinical collection link	
		$criteria = 'ClinicalCollectionLink.diagnosis_id ="' .$diagnosis_id.'"';			 
		$record_nbr = $this->ClinicalCollectionLink->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}
		
		// Verify diagnosis is not attached to an event	
		$criteria = 'EventMaster.diagnosis_id ="' .$diagnosis_id.'"';			 
		$record_nbr = $this->EventMaster->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}
		
		// Verify diagnosis is not attached to a trt	
		$criteria = 'TreatmentMaster.diagnosis_id ="' .$diagnosis_id.'"';			 
		$record_nbr = $this->TreatmentMaster->findCount($criteria);
		
		if($record_nbr > 0){
			return FALSE;
		}			
		
		// Etc...
		
		return TRUE;
	}

}

?>
*/
