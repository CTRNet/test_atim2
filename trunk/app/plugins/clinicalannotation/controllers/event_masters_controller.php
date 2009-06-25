<?php

class EventMastersController extends ClinicalannotationAppController {

	var $uses = array('Clinicalannotation.EventMaster', 'Clinicalannotation.EventControl', 'Clinicalannotation.Diagnosis');
	var $paginate = array('EventMaster'=>array('limit'=>10,'order'=>'EventMaster.event_date DESC'));
	
	function listall( $event_group=NULL, $participant_id=null, $event_control_id=null ) {
		
		// set FILTER, used as this->data CONDITIONS
		
			if ( !isset($_SESSION['MasterDetail_filter']) || !$event_control_id ) {
				$_SESSION['MasterDetail_filter'] = array();
				
				$_SESSION['MasterDetail_filter']['EventMaster.participant_id'] = $participant_id;
				$_SESSION['MasterDetail_filter']['EventMaster.event_group'] = $event_group;
				
				$this->set( 'atim_structure', $this->Structures->get('form','eventmasters') );
			}
			
			else {
				$_SESSION['MasterDetail_filter']['EventMaster.event_control_id'] = $event_control_id;
				
				$filter_data = $this->EventControl->find('first',array('conditions'=>array('EventControl.id'=>$event_control_id)));
				$this->set( 'atim_structure', $this->Structures->get('form',$filter_data['EventControl']['form_alias']) );
			}
			
		
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id, 'EventControl.id'=>$event_control_id) );
		$this->data = $this->paginate($this->EventMaster, $_SESSION['MasterDetail_filter']);
		
		// find all EVENTCONTROLS, for ADD form
		$this->set( 'event_controls', $this->EventControl->find('all', array('conditions'=>array('event_group'=>$event_group))) );
				
	}
	
	function detail( $event_group=NULL, $participant_id=null, $event_master_id=null ) {
		
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventMaster.id'=>$event_master_id) );
		$this->data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->set( 'atim_structure', $this->Structures->get('form',$this->data['EventControl']['form_alias']) );
		
	}
	
	function add( $event_group=NULL, $participant_id=null, $event_control_id=null) {
		
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		
		$this->set( 'atim_menu_variables', array('EventControl.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventControl.id'=>$event_control_id) );
		$this_data = $this->EventControl->find('first',array('conditions'=>array('EventControl.id'=>$event_control_id)));
		
		// set FORM ALIAS based off VALUE from CONTROL table
		$this->set( 'atim_structure', $this->Structures->get('form',$this_data['EventControl']['form_alias']) );
		
		if ( !empty($this->data) ) {
			
			$this->data['EventMaster']['participant_id'] = $participant_id;
			$this->data['EventMaster']['event_control_id'] = $this_data['EventControl']['id'];
			$this->data['EventMaster']['event_group'] = $this_data['EventControl']['event_group'];
			$this->data['EventMaster']['event_type'] = $this_data['EventControl']['event_type'];
			$this->data['EventMaster']['disease_site'] = $this_data['EventControl']['disease_site'];
			
			if ( $this->EventMaster->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$this->EventMaster->getLastInsertId());
			} else {
				$this->data = $this_data;
			}
		} 		
	}
	
	function edit( $event_group=NULL, $participant_id=null, $event_master_id=null ) {
		
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventMaster.id'=>$event_master_id) );
		$this_data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id)));
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->set( 'atim_structure', $this->Structures->get('form',$this_data['EventControl']['form_alias']) );
		
		if ( !empty($this->data) ) {
			$this->EventMaster->id = $event_master_id;
			if ( $this->EventMaster->save($this->data) ) $this->flash( 'Your data has been updated.','/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$event_master_id);
		} else {
			$this->data = $this_data;
		}
		
	}
	
	/*
	function listall( $menu_id=NULL, $event_group=NULL, $participant_id=null ) {
		
		// Missing or empty function variable, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		/ get all DX rows, for EVENT FILTER pulldown && DX input
		$this->set('dx_listall', $this->Diagnosis->find('all',array('conditions'=>array('Diagnosis.participant_id'=>$participant_id))));
		
		// set SESSION var of EVENT PRIMARY to blank or form value
		if ( isset($this->params['form']['event_filter']) ) {
			$_SESSION['ctrapp_core']['clinical_annotation']['event_filter'] = $this->params['form']['event_filter'];
		} else if ( !isset( $_SESSION['ctrapp_core']['clinical_annotation']['event_filter'] ) ) {
			$_SESSION['ctrapp_core']['clinical_annotation']['event_filter'] = '';
		}

		// build EVENT FILTER LIST
		$event_filter_array = array();
		if ( $_SESSION['ctrapp_core']['clinical_annotation']['event_filter']!=='' ) {
			if ( substr($_SESSION['ctrapp_core']['clinical_annotation']['event_filter'],0,1)=='p' ) {
				// get ROWS of DXs with matching EVENT PRIMARY
				$case_number = substr($_SESSION['ctrapp_core']['clinical_annotation']['event_filter'],1);
				$event_filter_result = $this->Diagnosis->find('all',array('conditions'=>array('participant_id'=>$participant_id, 'case_number'=>$case_number)));
			} else {
				// get ROWS of DXs with EXACT ID
				$case_number = substr($_SESSION['ctrapp_core']['clinical_annotation']['event_filter'],1);
				$event_filter_result = $this->Diagnosis->find('all',array('conditions'=>array('participant_id'=>$participant_id, 'case_number'=>$case_number)));
			}

			// add DX ids to CRITERIA array list
			foreach( $event_filter_result as $dx ) {
				$event_filter_array[] = $dx['Diagnosis']['id'];
			}
		}

		// set MENU varible for echo on VIEW
		// $ctrapp_menu[] = $this->Menus->tabs( 
		// 	array( 
		// 		array( 'clin_CAN_1',	'clin_CAN_4',	$participant_id ), 
		// 		array( 'clin_CAN_4',	NULL,				$participant_id ) 
		// 	) 
		// );		
		
		// build criteria, append EVENT_FILTER if any...
		$criteria = 'EventMaster.participant_id="'.$participant_id.'" AND EventMaster.event_group="'.$event_group.'"';
		if ( $_SESSION['ctrapp_core']['clinical_annotation']['event_filter']!=='' ) {
			$criteria .= ' AND ( EventMaster.diagnosis_id="'.implode( '" OR EventMaster.diagnosis_id="', $event_filter_array ).'" )';
		}
		
		// Set view variables
		$this->set( 'atim_menu_variables', array('Participant.id'=>$participant_id) );
		$this->set('menu_id', $menu_id);
		$this->set('event_group', $event_group);
		
		$this->data = $this->paginate($this->EventMaster, array('EventMaster.participant_id'=>$participant_id));

		// find all EVENTCONTROLS, for ADD form
		$this->set('event_controls', $this->EventControl->find('all', array('conditions'=>array('event_group'=>$event_group))));
	
	}

	function detail( $menu_id=NULL, $event_group=NULL, $participant_id=null, $event_master_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		
		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_4', $participant_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_4', $menu_id, $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		// $this->set( 'ctrapp_form', $this->Forms->getFormArray('event_masters') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'menu_id', $menu_id );
		$this->set( 'event_group', $event_group );
		$this->set( 'participant_id', $participant_id );
		$this->set( 'event_master_id', $event_master_id );

		// EVENT MASTER info defines EVENTDETAIL info, including FORM alias

			// read EVENTMASTER info, which contains FORM alias and DETAIL tablename
			$this->EventMaster->id = $event_master_id;
			$event_master_data = $this->EventMaster->read();

				// read related DIAGNOSIS row (if any), whose ID should be same as EVENTMASTER's DIAGNOSIS_ID value
				$this->Diagnosis->id = $event_master_data['EventMaster']['diagnosis_id'];
				$this->set( 'dx_listall', $this->Diagnosis->read()  );

			// FORM alias, from EVENT MASTER field
			$this->set( 'ctrapp_form', $this->Forms->getFormArray( $event_master_data['EventMaster']['form_alias'] ) );

			// start new instance of EVENTDETAIL model, using TABLENAME from EVENT MASTER
			$this->EventDetail = new EventDetail( false, $event_master_data['EventMaster']['detail_tablename'] );
			// read related EVENTDETAIL row, whose ID should be same as EVENTMASTER ID
			$this->EventDetail->id = $event_master_id;
			$event_specific_data = $this->EventDetail->read();

			// merge both datasets into a SINGLE dataset, set for VIEW
			$this->set( 'data', array_merge( $event_master_data, $event_specific_data )  );
			
			// look for CUSTOM HOOKS, "format"
			$custom_ctrapp_controller_hook 
				= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
				'controllers' . DS . 'hooks' . DS . 
				$this->params['controller'].'_'.$this->params['action'].'_format.php';
			
			if (file_exists($custom_ctrapp_controller_hook)) {
				require($custom_ctrapp_controller_hook);
			}
					
	}

	function add( $menu_id=NULL, $event_group=NULL, $participant_id=null, $event_control_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		
		if ( $event_control_id!=null ) {

			// read EVENTCONTROL info, which contains FORM alias and DETAIL tablename
			$this->EventControl->id = $event_control_id;
			$event_control_data = $this->EventControl->read();
			$this->set( 'control_data', $event_control_data  );

			// start new instance of EVENTDETAIL model, using TABLENAME from EVENT MASTER
			$this->EventDetail = new EventDetail( false, $event_control_data['EventControl']['detail_tablename'] );

		} else if ( isset($this->params['form']['event_control_id']) ) {

			// get EVENTCONTROL ID from LISTALL add form submit
			$event_control_id = $this->params['form']['event_control_id'];

			// read EVENTCONTROL info, which contains FORM alias and DETAIL tablename
			$this->EventControl->id = $event_control_id;
			$event_control_data = $this->EventControl->read();
			$this->set( 'control_data', $event_control_data  );

			// start new instance of EVENTDETAIL model, using TABLENAME from EVENT MASTER
			$this->EventDetail = new EventDetail( false, $event_control_data['EventControl']['detail_tablename'] );

		} else {

			// error
			die('missing event control id');

		}

		// get all DX rows, for EVENT FILTER pulldown && DX input
		$criteria = 'participant_id="'.$participant_id.'"';
		$order = 'case_number ASC, dx_date ASC';
		$this->set( 'dx_listall', $this->Diagnosis->findAll( $criteria, NULL, $order ) );

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_4', $participant_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_4', $menu_id, $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_form', $this->Forms->getFormArray( $event_control_data['EventControl']['form_alias'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_dx_form', $this->Forms->getFormArray('diagnoses') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'menu_id', $menu_id );
		$this->set( 'event_group', $event_group );
		$this->set( 'participant_id', $participant_id );
		$this->set( 'event_control_id', $event_control_id );

		// setup MODEL(s) validation array(s) for displayed FORM
		foreach ( $this->Forms->getValidateArray( $event_control_data['EventControl']['form_alias'] ) as $validate_model=>$validate_rules ) {
			$this->{ $validate_model }->validate = $validate_rules;
		}

		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		if ( !empty($this->data) ) {

			// after EVENTDETAIL model is set and declared
			$this->cleanUpFields('EventDetail');

			// validate MASTER first...
			if ( $this->EventMaster->validates( $this->data['EventMaster'] ) ) {
				
				// validate DETAIL/CONTROL second...
				if ( $this->EventDetail->validates( $this->data['EventDetail'] ) ) {
					
					// save EVENTMASTER data
					$this->EventMaster->save( $this->data['EventMaster'] );
					
					// set ID fields based on EVENTMASTER
					$this->data['EventDetail']['id'] = $this->EventMaster->getLastInsertId();
					$this->data['EventDetail']['event_master_id'] = $this->EventMaster->getLastInsertId();
	
					// save EVENTDETAIL data
					$this->EventDetail->save( $this->data['EventDetail'] );
					
					$this->flash( 'Your data has been updated.','/event_masters/listall/'.$menu_id.'/'.$event_group.'/'.$participant_id );
	
				} else {
					// manually assign ERROR MESSAGES to validation variable for VIEW display
					$this->EventControl->validationErrors= array_merge( $this->EventControl->validationErrors, $this->EventDetail->invalidFields($this->data['EventDetail']) );
					$this->EventDetail->validationErrors= array_merge( $this->EventDetail->validationErrors, $this->EventDetail->invalidFields($this->data['EventDetail']) );
				}
			
			} else {
				// manually assign ERROR MESSAGES to validation variable for VIEW display
				$this->EventMaster->validationErrors= array_merge( $this->EventMaster->validationErrors, $this->EventMaster->invalidFields($this->data['EventMaster']) );
			}

		} else {
			$this->set( 'data', array() );
			$this->data = array();
		}

	}

	function edit( $menu_id=NULL, $event_group=NULL, $participant_id=null, $event_master_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		
		// get all DX rows, for EVENT FILTER pulldown && DX input
		$criteria = 'participant_id="'.$participant_id.'"';
		$order = 'case_number ASC, dx_date ASC';
		$this->set( 'dx_listall', $this->Diagnosis->findAll( $criteria, NULL, $order ) );

		// set MENU varible for echo on VIEW
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_1', 'clin_CAN_4', $participant_id );
		$ctrapp_menu[] = $this->Menus->tabs( 'clin_CAN_4', $menu_id, $participant_id );
		$this->set( 'ctrapp_menu', $ctrapp_menu );

		// set FORM variable, for HELPER call on VIEW
		// $this->set( 'ctrapp_form', $this->Forms->getFormArray('event_masters') );
				
		// set FORM variable, for HELPER call on VIEW
		$this->set( 'ctrapp_dx_form', $this->Forms->getFormArray('diagnoses') );

		// set SUMMARY varible from plugin's COMPONENTS
		$this->set( 'ctrapp_summary', $this->Summaries->build( $participant_id ) );

		// set SIDEBAR variable, for HELPER call on VIEW
		// use PLUGIN_CONTROLLER_ACTION by default, but any ALIAS string that matches in the SIDEBARS datatable will do...
		$this->set( 'ctrapp_sidebar', $this->Sidebars->getColsArray( $this->params['plugin'].'_'.$this->params['controller'].'_'.$this->params['action'] ) );

		// set FORM variable, for HELPER call on VIEW
		$this->set( 'menu_id', $menu_id );
		$this->set( 'event_group', $event_group );
		$this->set( 'participant_id', $participant_id );
		$this->set( 'event_master_id', $event_master_id );

		// EVENT MASTER info defines EVENTDETAIL info, including FORM alias

			// read EVENTMASTER info, which contains FORM alias and DETAIL tablename
			$this->EventMaster->id = $event_master_id;
			$event_master_data = $this->EventMaster->read();
			
			// FORM alias, from EVENT MASTER field
			$this->set( 'ctrapp_form', $this->Forms->getFormArray( $event_master_data['EventMaster']['form_alias'] ) );

			// start new instance of EVENTDETAIL model, using TABLENAME from EVENT MASTER
			$this->EventDetail = new EventDetail( false, $event_master_data['EventMaster']['detail_tablename'] );
			// read related EVENTDETAIL row, whose ID should be same as EVENTMASTER ID
			$this->EventDetail->id = $event_master_id;
			$event_specific_data = $this->EventDetail->read();
			
			// setup MODEL(s) validation array(s) for displayed FORM
			foreach ( $this->Forms->getValidateArray( $event_master_data['EventMaster']['form_alias'] ) as $validate_model=>$validate_rules ) {
				$this->{ $validate_model }->validate = $validate_rules;
			}

		// look for CUSTOM HOOKS, "format"
		$custom_ctrapp_controller_hook 
			= APP . 'plugins' . DS . $this->params['plugin'] . DS . 
			'controllers' . DS . 'hooks' . DS . 
			$this->params['controller'].'_'.$this->params['action'].'_format.php';
		
		if (file_exists($custom_ctrapp_controller_hook)) {
			require($custom_ctrapp_controller_hook);
		}
		
		if ( empty($this->data) ) {

			// merge both datasets into a SINGLE dataset, set for VIEW
			$this->data = array_merge( $event_master_data, $event_specific_data );
			$this->set( 'data', $this->data  );

		} else {

			// after EVENTDETAIL model is set and declared
			$this->cleanUpFields('EventDetail');
			
			// validate MASTER first...
			if ( $this->EventMaster->validates( $this->data['EventMaster'] ) ) {
				
				// validate CONTROL/DETAIL second...
				if ( $this->EventDetail->validates( $this->data['EventDetail'] ) ) {
					
					// Check to see if diagnosis_id has been set
					if ( isset($this->data['EventMaster']['diagnosis_id']) ) {
						// Check diagnosis_id is set and FALSE ('' or 0) 
						if ( !$this->data['EventMaster']['diagnosis_id'] ) {
							// Set diagnosis_id to NULL. This ensures the diagnosis_id FK
							// constraint is satisfied. 
							$this->data['EventMaster']['diagnosis_id']= NULL;
						}
					}
			
					$this->EventMaster->save( $this->data['EventMaster'] );
					$this->EventDetail->save( $this->data['EventDetail'] );
	
					$this->flash( 'Your data has been updated.','/event_masters/detail/'.$menu_id.'/'.$event_group.'/'.$participant_id.'/'.$event_master_id );
					
				} else {
					// manually assign ERROR MESSAGES to validation variable for VIE display
					$this->EventControl->validationErrors= array_merge( $this->EventControl->validationErrors, $this->EventDetail->invalidFields($this->data['EventDetail']) );
					$this->EventDetail->validationErrors= array_merge( $this->EventDetail->validationErrors, $this->EventDetail->invalidFields($this->data['EventDetail']) );
				}
			
			} else {
				// manually assign ERROR MESSAGES to validation variable for VIE display
				$this->EventMaster->validationErrors= array_merge( $this->EventMaster->validationErrors, $this->EventMaster->invalidFields($this->data['EventMaster']) );
			}

		}



	}

	function delete( $menu_id=NULL, $event_group=NULL, $participant_id=null, $event_master_id=null ) {
		// missing VARS, send to ERROR page
		if ( !$participant_id  ) { $this->redirect( '/pages/err_clin-ann_no_part_id' ); exit; }
		
		// read EVENTMASTER info, which contains FORM alias and DETAIL tablename
		$this->EventMaster->id = $event_master_id;
		$event_master_data = $this->EventMaster->read();

		// start new instance of EVENTDETAIL model, using TABLENAME from EVENT MASTER
		$this->EventDetail = new EventDetail( false, $event_master_data['EventMaster']['detail_tablename'] );

		if(!$this->allowEventDeletion($event_master_id)) {
			$this->flash( 'Your are not allowed to delete this data.', '/event_masters/detail/'.$menu_id.'/'.$event_group.'/'.$participant_id.'/'.$event_master_id );
			exit;
		}
		
		// delete MASTER/DETAIL rows
		$this->EventDetail->del( $event_master_id );
		$this->EventMaster->del( $event_master_id );

		$this->flash( 'Your data has been deleted.', '/event_masters/listall/'.$menu_id.'/'.$event_group.'/'.$participant_id );

	}
	
	function allowEventDeletion($event_master_id){		
		
		// To Define
		
		return TRUE;
	}
	*/
}

?>