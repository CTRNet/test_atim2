<?php

class EventMastersController extends ClinicalAnnotationAppController {

	var $uses = array(
		'ClinicalAnnotation.Participant',
		'ClinicalAnnotation.EventMaster', 
		'ClinicalAnnotation.EventControl', 
		'ClinicalAnnotation.DiagnosisMaster'
	);
	
	var $paginate = array(
		'EventMaster'=>array('limit' => pagination_amount,'order'=>'EventMaster.event_date DESC')
	);
	
	function beforeFilter( ) {
		parent::beforeFilter();
		$this->set( 'atim_menu', $this->Menus->get( '/'.$this->params['plugin'].'/'.$this->params['controller'].'/'.$this->params['action'].'/'.$this->params['pass'][0] ) );
	}
	
	function listall( $event_group, $participant_id, $event_control_id=null ){
		// set FILTER, used as this->data CONDITIONS
		if ( !isset($_SESSION['MasterDetail_filter']) || !$event_control_id ) {
			$_SESSION['MasterDetail_filter'] = array();
			
			$_SESSION['MasterDetail_filter']['EventMaster.participant_id'] = $participant_id;
			$_SESSION['MasterDetail_filter']['EventControl.event_group'] = $event_group;
			
			$this->Structures->set('eventmasters');
		} else {
			$_SESSION['MasterDetail_filter']['EventMaster.event_control_id'] = $event_control_id;
			
			$filter_data = $this->EventControl->getOrRedirect($event_control_id);
			$this->Structures->set($filter_data['EventControl']['form_alias']);
		}
			
		// MANAGE DATA
		$participant_data = $this->Participant->getOrRedirect($participant_id);

		$this->request->data = $this->paginate($this->EventMaster, $_SESSION['MasterDetail_filter']);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id, 'EventControl.id'=>$event_control_id) );
		
		// find all EVENTCONTROLS, for ADD form
		$event_controls = $this->EventControl->find('all', array('conditions'=>array('EventControl.event_group'=>$event_group, 'EventControl.flag_active' => '1' )));
		$add_links = $this->EventControl->buildAddLinks($event_controls, $participant_id, $event_group);
		$this->set('add_links', $add_links);
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function detail( $participant_id, $event_master_id, $is_ajax = 0 ) {
		// MANAGE DATA
		$this->request->data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id, 'EventMaster.participant_id'=>$participant_id)));
		if(empty($this->request->data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		$this->EventMaster->calculatedDetailfields($this->request->data);
		
		$event_group = $this->request->data['EventControl']['event_group'];
		$diagnosis_data = $this->DiagnosisMaster->getRelatedDiagnosisEvents($this->request->data['EventMaster']['diagnosis_master_id']);
		$this->set('diagnosis_data', $diagnosis_data);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventMaster.id'=>$event_master_id,  'EventControl.id'=>$this->request->data['EventControl']['id']) );
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($this->request->data['EventControl']['form_alias']);
		$this->Structures->set('view_diagnosis,diagnosis_event_relation_type', 'diagnosis_structure');
		$this->set('is_ajax', $is_ajax);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}

		if(isset($diagnosis_data[0]) && strpos($this->request->data['EventControl']['event_type'], 'cap report - ') !== false && $diagnosis_data[0]['DiagnosisControl']['flag_compare_with_cap']){
			//cap report, generate warnings if there are mismatches
			EventMaster::generateDxCompatWarnings($diagnosis_data[0], $this->request->data);
		}
	}
	
	function add( $participant_id, $event_control_id, $diagnosis_master_id = null) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/listall/')){
			$this->flash(__('you need privileges on the following modules to manage participant inventory: %s', implode(', ', $error)), 'javascript:history.back()');
		}
		
		// MANAGE DATA
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		$event_control_data = $this->EventControl->getOrRedirect($event_control_id);
		$event_group = $event_control_data['EventControl']['event_group'];
		
		// Set diagnosis data for diagnosis selection (radio button)
		$dx_data = $this->DiagnosisMaster->find('threaded', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id), 'order' => array('DiagnosisMaster.dx_date ASC')));
		if(!empty($this->request->data) && isset($this->request->data['EventMaster']['diagnosis_master_id'])){
			$this->DiagnosisMaster->arrangeThreadedDataForView($dx_data, $this->request->data['EventMaster']['diagnosis_master_id'], 'EventMaster');
		}else if($diagnosis_master_id){
			$this->DiagnosisMaster->arrangeThreadedDataForView($dx_data, $diagnosis_master_id, 'EventMaster');
		}
		$this->set('data_for_checklist', $dx_data);	

		$this->set('initial_display', (empty($this->request->data)));
					
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		$this->set( 'atim_menu_variables', array('EventControl.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventControl.id'=>$event_control_id) );
		$this->set('ev_header', __($event_control_data['EventControl']['event_type']) . ' - ' . __($event_control_data['EventControl']['disease_site']));
		
		// set FORM ALIAS based off VALUE from CONTROL table
		$this->Structures->set('empty', 'empty_structure');
		$this->Structures->set($event_control_data['EventControl']['form_alias']);
		$this->Structures->set('view_diagnosis', 'diagnosis_structure');
		$this->set('use_addgrid', $event_control_data['EventControl']['use_addgrid']);
					
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( empty($this->request->data)) {
			if($event_control_data['EventControl']['use_addgrid']) $this->request->data = array(array());
				
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
			
		} else {
			if(!$event_control_data['EventControl']['use_addgrid']) {
				
				// 1 - ** Single data save ** 
				
				$this->request->data['EventMaster']['participant_id'] = $participant_id;
				$this->request->data['EventMaster']['event_control_id'] = $event_control_id;
				
				// LAUNCH SPECIAL VALIDATION PROCESS
				$submitted_data_validates = true;
				
				// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
				$hook_link = $this->hook('presave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				
				$this->EventMaster->addWritableField(array('participant_id', 'event_control_id', 'diagnosis_master_id'));
				if ($submitted_data_validates && $this->EventMaster->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been updated','/ClinicalAnnotation/EventMasters/detail/'.$participant_id.'/'.$this->EventMaster->getLastInsertId());
				}
					
			} else {
				
				// 2 - ** Multi lines save ** 
				
				$errors_tracking = array();
				
				// Launch Structure Fields Validation
				$diagnosis_master_id = $this->request->data['EventMaster']['diagnosis_master_id'];
				unset($this->request->data['EventMaster']);
						
				$row_counter = 0;
				foreach($this->request->data as &$data_unit){
					$row_counter++;
				
					$data_unit['EventMaster']['event_control_id'] = $event_control_id;
					$data_unit['EventMaster']['participant_id'] = $participant_id;
					$data_unit['EventMaster']['diagnosis_master_id'] = $diagnosis_master_id;
					
					$this->EventMaster->id = null;
					$this->EventMaster->set($data_unit);
					if(!$this->EventMaster->validates()){
						foreach($this->EventMaster->validationErrors as $field => $msgs) {
							$msgs = is_array($msgs)? $msgs : array($msgs);
							foreach($msgs as $msg)$errors_tracking[$field][$msg][] = $row_counter;
						}
					}
					$data_unit = $this->EventMaster->data;
				}
				unset($data_unit);
				
				// Launch Save Process
				if(empty($this->request->data)) {
					$this->EventMaster->validationErrors[][] = 'at least one record has to be created';
				} else if(empty($errors_tracking)){
					//save all
					$this->EventMaster->addWritableField(array('event_control_id','participant_id','diagnosis_master_id'));
					$this->EventMaster->writable_fields_mode = 'addgrid';
					foreach($this->request->data as $new_data_to_save) {
						$this->EventMaster->id = null;
						$this->EventMaster->data = array();
						if(!$this->EventMaster->save($new_data_to_save, false)) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
					}
					$this->atimFlash('your data has been updated', '/ClinicalAnnotation/EventMasters/listall/'.$event_group.'/'.$participant_id.'/');
				} else {
					$this->EventMaster->validationErrors = array();
					foreach($errors_tracking as $field => $msg_and_lines) {
						foreach($msg_and_lines as $msg => $lines) {
							$this->EventMaster->validationErrors[$field][] = $msg . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
						}
					}
				}
				
			}
		} 
	}
	
	function edit( $participant_id, $event_master_id ) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/listall/')){
			$this->flash(__('you need privileges on the following modules to manage participant inventory: %s', implode(', ', $error)), 'javascript:history.back()');
		}
		
		// MANAGE DATA
		$event_master_data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id, 'EventMaster.participant_id'=>$participant_id)));
		if (empty($event_master_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		$event_group = $event_master_data['EventControl']['event_group'];
		
		// Set diagnosis data for diagnosis selection (radio button)
		$dx_data = $this->DiagnosisMaster->find('threaded', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id), 'order' => array('DiagnosisMaster.dx_date ASC')));
		$dx_id = isset($this->request->data['EventMaster']['diagnosis_master_id']) ? $this->request->data['EventMaster']['diagnosis_master_id'] : $event_master_data['EventMaster']['diagnosis_master_id']; 
		$this->DiagnosisMaster->arrangeThreadedDataForView($dx_data, $dx_id, 'EventMaster');
		$this->set('data_for_checklist', $dx_data);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventMaster.id'=>$event_master_id,  'EventControl.id'=>$event_master_data['EventControl']['id']) );
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set('empty', 'empty_structure');
		$this->Structures->set($event_master_data['EventControl']['form_alias']);
		$this->Structures->set('view_diagnosis', 'diagnosis_structure');		
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( !empty($this->request->data) ) {
			$this->EventMaster->id = $event_master_id;

			// LAUNCH SPECIAL VALIDATION PROCESS
			$submitted_data_validates = true;
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			$this->EventMaster->addWritableField('diagnosis_master_id');
			if ($submitted_data_validates && $this->EventMaster->save($this->request->data) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been updated','/ClinicalAnnotation/EventMasters/detail/'.$participant_id.'/'.$event_master_id);
			}
		} else {
			$this->request->data = $event_master_data;
		}
	}

	function delete($participant_id, $event_master_id) {
		$event_master_data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id, 'EventMaster.participant_id'=>$participant_id)));
		if (empty($event_master_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		$event_group = $event_master_data['EventControl']['event_group'];
		
		$arr_allow_deletion = $this->EventMaster->allowDeletion($event_master_id);
		
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if ($hook_link) { 
			require($hook_link); 
		}
		
		if ($arr_allow_deletion['allow_deletion']) {
			if ($this->EventMaster->atimDelete( $event_master_id )) {
				$this->atimFlash( 'your data has been deleted', '/ClinicalAnnotation/EventMasters/listall/'.$event_group.'/'.$participant_id );
			} else {
				$this->flash( 'error deleting data - contact administrator', '/ClinicalAnnotation/EventMasters/listall/'.$event_group.'/'.$participant_id );
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/ClinicalAnnotation/EventMasters/detail/'.$participant_id.'/'.$event_master_id);
		}
	}
}

?>