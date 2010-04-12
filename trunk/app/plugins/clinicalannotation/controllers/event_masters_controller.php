<?php

class EventMastersController extends ClinicalannotationAppController {

	var $uses = array(
		'Clinicalannotation.Participant',
		'Clinicalannotation.EventMaster', 
		'Clinicalannotation.EventControl', 
		'Clinicalannotation.DiagnosisMaster'
	);
	
	var $paginate = array(
		'EventMaster'=>array('limit' => pagination_amount,'order'=>'EventMaster.event_date DESC')
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
		$event_controls = $this->EventControl->find('all', array('conditions'=>array('EventControl.event_group'=>$event_group, 'EventControl.flag_active' => '1' )));
		$this->set( 'event_controls', $event_controls );
	
		$disease_site_list = array();
		$event_type = array();
		foreach($event_controls as $new_event_ctr) {
			$disease_site_list[$new_event_ctr['EventControl']['disease_site']] = __($new_event_ctr['EventControl']['disease_site'], true);
			$event_type[$new_event_ctr['EventControl']['event_type']] = __($new_event_ctr['EventControl']['event_type'], true);
		}
		$this->set('disease_site_list', $disease_site_list);
		$this->set('event_type', $event_type);
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function detail( $event_group, $participant_id, $event_master_id ) {
		if ( (!$participant_id) && (!$event_group) && (!$event_master_id)) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// MANAGE DATA
		$this->data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id, 'EventMaster.participant_id'=>$participant_id)));
		if(empty($this->data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	

		$this->set('dx_data', $this->DiagnosisMaster->find('all', array('conditions' => array('DiagnosisMaster.id' => $this->data['EventMaster']['diagnosis_master_id']))));		

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventMaster.id'=>$event_master_id,  'EventControl.id'=>$this->data['EventControl']['id']) );
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($this->data['EventControl']['form_alias']);
		$this->Structures->set('diagnosismasters', 'diagnosis_structure');
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}
	
	function add( $event_group, $participant_id, $event_control_id) {
		if ((!$participant_id) || (!$event_group) || (!$event_control_id)) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		// MANAGE DATA

		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	

		$event_control_data = $this->EventControl->find('first',array('conditions'=>array('EventControl.id'=>$event_control_id)));
		if(empty($event_control_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	
		
		// set DIAGANOSES for diagnosis selection (radio button)
		$diagnosis_data = $this->DiagnosisMaster->find('all', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id)));
		if(!empty($this->data)) {
			//User submitted data: take updated data in consideration in case data validation is wrong and form is redisplayed
			foreach ($diagnosis_data as &$dx) {
				$dx['EventMaster']['diagnosis_master_id'] = $this->data['EventMaster']['diagnosis_master_id'];
			} 			
		}
		$this->set( 'data_for_checklist',  $diagnosis_data);

		$this->set('initial_display', (empty($this->data)? true : false));
					
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		$this->set( 'atim_menu_variables', array('EventControl.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventControl.id'=>$event_control_id) );
		
		// set FORM ALIAS based off VALUE from CONTROL table
		$this->Structures->set('empty', 'empty_structure');
		$this->Structures->set($event_control_data['EventControl']['form_alias']);
		$this->Structures->set('diagnosismasters', 'diagnosis_structure');
					
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$this->data['EventMaster']['participant_id'] = $participant_id;
			$this->data['EventMaster']['event_control_id'] = $event_control_id;

			$this->data['EventMaster']['event_group'] = $event_group;
			$this->data['EventMaster']['event_type'] = $event_control_data['EventControl']['event_type'];
			$this->data['EventMaster']['disease_site'] = $event_control_data['EventControl']['disease_site'];
			
			// LAUNCH SPECIAL VALIDATION PROCESS
			$submitted_data_validates = true;
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }

			if ($submitted_data_validates && $this->EventMaster->save($this->data) ) {
				$this->flash( 'your data has been updated','/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$this->EventMaster->getLastInsertId());
			}
		} 
	}
	
	function edit( $event_group, $participant_id, $event_master_id ) {
		if ((!$participant_id) || (!$event_group) || (!$event_master_id)) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }		
		
		// MANAGE DATA
		$event_master_data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id, 'EventMaster.participant_id'=>$participant_id)));
		if (empty($event_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		// set DIAGANOSES for diagnosis selection (radio button)
		$diagnosis_data = $this->DiagnosisMaster->find('all', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id)));
		$selected_diagnosis_master_id = empty($this->data)? $event_master_data['EventMaster']['diagnosis_master_id'] : $this->data['EventMaster']['diagnosis_master_id'];
		foreach ($diagnosis_data as &$dx) {
			$dx['EventMaster']['diagnosis_master_id'] = $selected_diagnosis_master_id;
		} 
		$this->set( 'data_for_checklist', $diagnosis_data);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventMaster.id'=>$event_master_id,  'EventControl.id'=>$event_master_data['EventControl']['id']) );
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set('empty', 'empty_structure');
		$this->Structures->set($event_master_data['EventControl']['form_alias']);
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
				$this->flash( 'your data has been updated','/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$event_master_id);
			}
		} else {
			$this->data = $event_master_data;
		}
	}

	function delete($event_group, $participant_id, $event_master_id) {
		if ((!$participant_id) || (!$event_master_id)) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }

		$event_master_data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id, 'EventMaster.participant_id'=>$participant_id)));
		if (empty($event_master_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
		
		$arr_allow_deletion = $this->allowEventDeletion($event_master_id);
		
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if ($hook_link) { require($hook_link); }
		
		if ($arr_allow_deletion['allow_deletion']) {
			if ($this->EventMaster->atim_delete( $event_master_id )) {
				$this->flash( 'your data has been deleted', '/clinicalannotation/event_masters/listall/'.$event_group.'/'.$participant_id );
			} else {
				$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/event_masters/listall/'.$event_group.'/'.$participant_id );
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$event_master_id);
		}
	}

	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if a record can be deleted.
	 * 
	 * @param $consent_master_id Id of the studied record.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowEventDeletion($event_master_id){
		$arr_allow_deletion = array('allow_deletion' => true, 'msg' => '');

		return $arr_allow_deletion;
	}	
}

?>