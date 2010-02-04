<?php

class EventMastersController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.Participant',
		'Clinicalannotation.EventMaster', 
		'Clinicalannotation.EventControl', 
		'Clinicalannotation.DiagnosisMaster'
	);
	
	var $paginate = array(
		'EventMaster'=>array('limit'=>10,'order'=>'EventMaster.event_date DESC')
	);
	
	function beforeFilter( ) {
		parent::beforeFilter();
		$this->set( 'atim_menu', $this->Menus->get( '/'.$this->params['plugin'].'/'.$this->params['controller'].'/'.$this->params['action'].'/'.$this->params['pass'][0] ) );
	}
	
	function listall( $event_group, $participant_id, $event_control_id=null ) {
		if ( (!$participant_id) && (!$event_group)) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
			
		// set FILTER, used as this->data CONDITIONS
			if ( !isset($_SESSION['MasterDetail_filter']) || !$event_control_id ) {
				$_SESSION['MasterDetail_filter'] = array();
				
				$_SESSION['MasterDetail_filter']['EventMaster.participant_id'] = $participant_id;
				$_SESSION['MasterDetail_filter']['EventMaster.event_group'] = $event_group;
				
				$this->Structures->set('eventmasters');
			} else {
				$_SESSION['MasterDetail_filter']['EventMaster.event_control_id'] = $event_control_id;
				
				$filter_data = $this->EventControl->find('first',array('conditions'=>array('EventControl.id'=>$event_control_id)));
				$this->Structures->set($filter_data['EventControl']['form_alias']);
			}
			
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }

		$this->data = $this->paginate($this->EventMaster, $_SESSION['MasterDetail_filter']);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id, 'EventControl.id'=>$event_control_id) );
		
		// find all EVENTCONTROLS, for ADD form
		$this->set( 'event_controls', $this->EventControl->find('all', array('conditions'=>array('event_group'=>$event_group))) );
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail( $event_group, $participant_id, $event_master_id ) {
		if ( (!$participant_id) && (!$event_group) && (!$event_master_id)) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$this->data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id)));
		$this->data['EventDetail']['file_path'] = $this->webroot.'/uploaded_files/'.$this->data['EventDetail']['file_path'];
		$this->set('dx_data', $this->DiagnosisMaster->find('all', array('conditions' => array('DiagnosisMaster.id' => $this->data['EventMaster']['diagnosis_master_id']))));		
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventMaster.id'=>$event_master_id) );
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($this->data['EventControl']['form_alias']);
		$this->Structures->set('diagnosismasters', 'diagnosis_structure');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function add( $event_group=NULL, $participant_id=null, $event_control_id=null) {
		if ( (!$participant_id) && (!$event_group) ) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		// MANAGE DATA
		$event_control_data = $this->EventControl->find('first',array('conditions'=>array('EventControl.id'=>$event_control_id)));
		
		// set DIAGANOSES
		$this->set( 'data_for_checklist', $this->DiagnosisMaster->find('all', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id))) );
		$this->set( 'atim_structure_for_checklist', $this->Structures->get('form','diagnosis_master') );

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		$this->set( 'atim_menu_variables', array('EventControl.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventControl.id'=>$event_control_id) );
		
		// set FORM ALIAS based off VALUE from CONTROL table
		$this->Structures->set($event_control_data['EventControl']['form_alias']);
			
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$this->data['EventMaster']['participant_id'] = $participant_id;
			$this->data['EventMaster']['event_control_id'] = $event_control_id;
			$this->data['EventMaster']['event_group'] = __($event_group, TRUE);
			$this->data['EventMaster']['event_type'] = __($event_control_data['EventControl']['event_type'], TRUE);
			$this->data['EventMaster']['disease_site'] = __($event_control_data['EventControl']['disease_site'], TRUE);
			
			// LAUNCH SPECIAL VALIDATION PROCESS
			$submitted_data_validates = true;
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			if ($submitted_data_validates && $this->EventMaster->save($this->data) ) {
				if($this->data['EventDetail']['file_name']['error'] == 0){
					$this->data['EventMaster']['id'] = $this->EventMaster->getLastInsertID();
					$this->data['EventDetail']['file_path'] = $this->data['EventMaster']['id'].'.'.end(explode(".", $this->data['EventDetail']['file_name']['name']));  
					move_uploaded_file($this->data['EventDetail']['file_name']['tmp_name'], getcwd().'/uploaded_files/'.$this->data['EventDetail']['file_path']);
					$this->EventMaster->save($this->data);
				}
				$this->flash( 'Your data has been updated.','/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$this->EventMaster->getLastInsertId());
			}
		} 
		
		$this->Structures->set('diagnosismasters', 'diagnosis_structure');
		$this->Structures->set('empty', 'empty_structure');
	}
	
	function edit( $event_group, $participant_id, $event_master_id ) {
		if ((!$participant_id) && (!$event_group) && ($event_master_id)) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }		
		
		// MANAGE DATA
		$event_master_data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id, 'EventMaster.participant_id'=>$participant_id)));
		if (empty($event_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventMaster.id'=>$event_master_id) );
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($this_data['EventControl']['form_alias']);
		
		// set DIAGANOSES
		$diagnosis_data = $this->DiagnosisMaster->find('all', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id)));
		foreach ($diagnosis_data as &$dx) {
			$dx['EventMaster']['diagnosis_master_id'] = $this->data['EventMaster']['diagnosis_master_id'];
		} 
		$this->set( 'data_for_checklist', $diagnosis_data);
		$this->Structures->set('diagnosismasters', 'diagnosis_structure');		
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$this->EventMaster->id = $event_master_id;

			// LAUNCH SPECIAL VALIDATION PROCESS
			$submitted_data_validates = true;
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
			
			if ($submitted_data_validates && $this->EventMaster->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$event_master_id);
			}
		} else {
			$this->data = $event_master_data;
		}
		$this->Structures->set('empty', 'empty_structure');
	}

	function delete($event_group, $participant_id, $event_master_id) {
		if (!$participant_id) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }

		// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
		$hook_link = $this->hook('presave_process');
		if( $hook_link ) { require($hook_link); }
	
		if( $this->EventMaster->atim_delete( $event_master_id ) ) {
			$this->flash( 'your data has been deleted', '/clinicalannotation/event_masters/listall/'.$event_group.'/'.$participant_id );
		} else {
			$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/event_masters/listall/'.$event_group.'/'.$participant_id );
		}
	}
}

?>