<?php

class FamilyHistoriesController extends ClinicalAnnotationAppController {
	
	$uses = array('FamilyHistory');
	$paginate = array('FamilyHistory'=>array('limit'=>10,'order'=>'FamilyHistory.participant_id ASC'));
	
	function listall( $participant_id ) {
		$this->data = $this->paginate($this->FamilyHistory);
	}
	
	function detail( $participant_id, $family_history_id ) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'FamilyHistory.id'=>$family_history_id) );
		$this->data = $this->FamilyHistory->find('first',array('conditions'=>array('FamilyHistory.id'=>$family_history_id)));
	}
	
	function add( $participant_id ) {
		$this->set( 'atim_menu', $this->Menus->get('/clinicalannotation/family_histories/listall/'.$particiant_id) );
		
		if ( !empty($this->data) ) {
			if ( $this->FamilyHistory->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/family_histories/detail/'.$participant_id.$this->FamilyHistory->id );
		}
	}
	
	function edit( $participant_id, $family_history_id) {
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id, 'FamilyHistory.id'=>$family_history_id) );
		
		if ( !empty($this->data) ) {
			$this->FamilyHistory->id = $family_history_id;
			if ( $this->FamilyHistory->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/family_histories/detail/'.$participant_id.$family_history_id );
		} else {
			$this->data = $this->FamilyHistory->find('first',array('conditions'=>array('FamilyHistory.id'=>$family_history_id)));
		}
	}
	
/*
	var $name = 'FamilyHistories';
	var $uses = array('FamilyHistory');
	
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
	
	// This method is used only as an EXAMPLE, demostrating the DATAGRID Form element
	function datagrid( $participant_id=null ) {
	
		// missing VARS, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_10', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('family_histories') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'participant_id', $participant_id );
			
		// set FAMILY HISTORY data
		$criteria = array();
		$criteria['participant_id'] = $participant_id;
		$criteria = array_filter($criteria);
		
		list( $order, $limit, $page ) = $this->Pagination->init( $criteria );
		$family_history_data = $this->FamilyHistory->findAll( $criteria, NULL, $order, $limit, $page );

		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		$this->set( 'data',  $family_history_data);
		
		// if DATA submitted...
		if ( !empty($this->data) ) {
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray('family_histories') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
			
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE each row separately, setting the FLAG to FALSE if ANY row has a problem
			foreach ( $this->data as $key=>$val ) {
				if ( !$this->FamilyHistory->validates( $val ) ) {
					$submitted_data_validates = false;
				}
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
			if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
			
			// if ALL the rows VALIDATE, then save each row separately, otherwise display errors
			if ( $submitted_data_validates ) {
				
				// save each ROW
				foreach ( $this->data as $key=>$val ) {
					if( !$this->FamilyHistory->save( $val ) ) {
						$this->redirect( '/pages/err_clin-ann_fam_hist_record' ); 
						exit;
					}
				}
				
				$this->flash( 'Your data has been saved.', '/family_histories/listall/'.$participant_id  );
			
			} else {
				
				// extra ERROR message, which FORMS HELPER will translate normally
				$this->FamilyHistory->validationErrors[] = 'Wil Needs More Coffee To Be Productive In The Morning!';
				
			}
			
		}
		
	}
	
	function listall( $participant_id=null ) {
		
		// missing VARS, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_10', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('family_histories') );
		
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
		$family_history_data = $this->FamilyHistory->findAll( $criteria, NULL, $order, $limit, $page );

		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		$this->set( 'family_histories',  $family_history_data);
		
	}
	
	function detail( $participant_id=null, $family_history_id=null ) {
		
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$family_history_id ) { $this->redirect( '/pages/err_clin-ann_no_fam_hist_id' ); exit; }
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_10', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('family_histories') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'participant_id', $participant_id );
		$this->set( 'family_history_id', $family_history_id );
			
		$this->FamilyHistory->id = $family_history_id;
		$family_history_data = $this->FamilyHistory->read();
		
		if ( empty( $family_history_data ) ) { $this->redirect( '/pages/err_clin-ann_no_fam_hist_data' ); exit; }		

		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		$this->set( 'data',  $family_history_data);

	}
	
	function add( $participant_id=null ) {
		
		// missing VARS, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_10', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('family_histories') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'participant_id', $participant_id );
		
		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		if ( !empty($this->data) ) {
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray('family_histories') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
							
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if ( !$this->FamilyHistory->validates( $this->data ) ) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
			if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
			
			// if data VALIDATE, then save data
			if ( $submitted_data_validates ) {
				
				if ( $this->FamilyHistory->save( $this->data ) ) {
					$this->flash( 'Your data has been saved.', '/family_histories/listall/'.$participant_id );
				} else {
					$this->redirect( '/pages/err_clin-ann_fam_hist_record' ); 
					exit; 
				}
				
			}
			
		}
		
	}
	
	function edit( $participant_id=null, $family_history_id=null ) {
		
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$family_history_id ) { $this->redirect( '/pages/err_clin-ann_no_fam_hist_id' ); exit; }
		
		// set MENU varible for echo on VIEW 
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_10', $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'ctrapp_form', $this->Forms->getFormArray('family_histories') );
		
		// set SUMMARY varible from plugin's COMPONENTS 
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );
		
		// set SIDEBAR variable, for HELPER call on VIEW 
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );
		
		// set FORM variable, for HELPER call on VIEW 
		$this->set( 'participant_id', $participant_id );
		$this->set( 'family_history_id', $family_history_id );
		
		$this->FamilyHistory->id = $family_history_id;
		$family_history_data = $this->FamilyHistory->read();
		
		if ( empty( $family_history_data ) ) { $this->redirect( '/pages/err_clin-ann_no_fam_hist_data' ); exit; }				

		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_format.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		if ( empty($this->data) ) {
			
			$this->data = $family_history_data;
			$this->set( 'data', $this->data );
			
		} else {
			
			// setup MODEL(s) validation array(s) for displayed FORM 
			foreach ( $this->Forms->getValidateArray('family_histories') as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}
						
			// set a FLAG
			$submitted_data_validates = true;
			
			// VALIDATE submitted data
			if ( !$this->FamilyHistory->validates( $this->data ) ) {
				$submitted_data_validates = false;
			}
			
			// look for CUSTOM HOOKS, "validation"
			$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
			if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
			
			// if data VALIDATE, then save data
			if ( $submitted_data_validates ) {
				
				if ( $this->FamilyHistory->save( $this->data['FamilyHistory'] ) ) {
					$this->flash( 'Your data has been updated.','/family_histories/detail/'.$participant_id.'/'.$family_history_id );
				} else {
					$this->redirect( '/pages/err_clin-ann_fam_hist_record' ); 
					exit; 
				}
				
			}			
			
		}
		
	}
	*/
	function delete( $participant_id=null, $family_history_id=null ) {}
	/*	
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		if ( !$family_history_id ) { $this->redirect( '/pages/err_clin-ann_no_fam_hist_id' ); exit; }

		// Verify famiy history exists
		$this->FamilyHistory->id = $family_history_id;
		$family_history_data = $this->FamilyHistory->read();
		
		if ( empty( $family_history_data ) ) { $this->redirect( '/pages/err_clin-ann_no_fam_hist_data' ); exit; }				
		
		// look for CUSTOM HOOKS, "validation"
		$custom_ctrapp_controller_hook = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'controllers' . DS . 'hooks' . DS . $this->params['controller'].'_'.$this->params['action'].'_validation.php';
		if ( file_exists($custom_ctrapp_controller_hook) ) { require($custom_ctrapp_controller_hook); }
		
		if(!$this->allowFamilyHistoryDeletion($family_history_id)) {
			$this->flash( 'Your are not allowed to delete this data.', '/family_histories/detail/'.$participant_id.'/'.$family_history_id );
			exit;
		}
		
		if( $this->FamilyHistory->del( $family_history_id ) ) {
			$this->flash( 'Your data has been deleted.', '/family_histories/listall/'.$participant_id );
		} else {
			$this->redirect( '/pages/err_clin-ann_fam_hist_deletion' ); 
			exit;
		}
		
	}
	*/
	function allowFamilyHistoryDeletion($family_history_id){}		
	/*	
		// To Define
		
		return TRUE;
	}
*/
}

?>