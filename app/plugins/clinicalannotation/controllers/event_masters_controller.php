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
		if ( (!$participant_id) && (!$event_group)) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
			
		// set FILTER, used as this->data CONDITIONS
		if ( !isset($_SESSION['MasterDetail_filter']) || !$event_control_id ) {
			$_SESSION['MasterDetail_filter'] = array();
			
			$_SESSION['MasterDetail_filter']['EventMaster.participant_id'] = $participant_id;
			$_SESSION['MasterDetail_filter']['EventControl.event_group'] = $event_group;
			
			$this->Structures->set('eventmasters');
		} else {
			$_SESSION['MasterDetail_filter']['EventMaster.event_control_id'] = $event_control_id;
			
			$filter_data = $this->EventControl->find('first',array('conditions'=>array('EventControl.id'=>$event_control_id)));
			if(empty($filter_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
			$this->Structures->set($filter_data['EventControl']['form_alias']);
		}
			
		// MANAGE DATA
		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}

		$this->data = $this->paginate($this->EventMaster, $_SESSION['MasterDetail_filter']);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id, 'EventControl.id'=>$event_control_id) );
		
		// find all EVENTCONTROLS, for ADD form
		$event_controls = $this->EventControl->find('all', array('conditions'=>array('EventControl.event_group'=>$event_group, 'EventControl.flag_active' => '1' )));
		$this->set( 'event_controls', $event_controls );
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
	}
	
	function detail( $event_group, $participant_id, $event_master_id, $is_ajax = 0 ) {
		// MANAGE DATA
		$this->data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id, 'EventMaster.participant_id'=>$participant_id)));
		if(empty($this->data)) { 
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}	

		$diagnosis_data = array('event' => array(), 'history' => array());
		if(!empty($this->data['EventMaster']['diagnosis_master_id'])) {
			$tmp_diagnosis_data = $this->DiagnosisMaster->find('first', array('conditions'=>array('DiagnosisMaster.id' => $this->data['EventMaster']['diagnosis_master_id'])));
			if(empty($tmp_diagnosis_data)) $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
			$diagnosis_data['event'][] = $tmp_diagnosis_data;
			
			if($tmp_diagnosis_data['DiagnosisMaster']['id'] != $tmp_diagnosis_data['DiagnosisMaster']['primary_id']) {
				$tmp_diagnosis_data = $this->DiagnosisMaster->find('all', array('conditions'=>array('DiagnosisMaster.id' => array($tmp_diagnosis_data['DiagnosisMaster']['primary_id'], $tmp_diagnosis_data['DiagnosisMaster']['parent_id'])), 'order' => 'DiagnosisMaster.id ASC'));
				if(empty($tmp_diagnosis_data)) $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
				$diagnosis_data['history'] = $tmp_diagnosis_data;
			}
		}
		$this->set('diagnosis_data', $diagnosis_data);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventMaster.id'=>$event_master_id,  'EventControl.id'=>$this->data['EventControl']['id']) );
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set($this->data['EventControl']['form_alias']);
		$this->Structures->set('diagnosismasters', 'diagnosis_structure');
		$this->set('is_ajax', $is_ajax);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}

		if(is_array($diagnosis_data['history']) && strpos($this->data['EventControl']['event_type'], 'cap report - ') !== false){
			//cap report, generate warnings if there are mismatches
			EventMaster::generateDxCompatWarnings($diagnosis_data['history'][0], $this->data);
		}
	}
	
	function add( $event_group, $participant_id, $event_control_id) {
		if ((!$participant_id) || (!$event_group) || (!$event_control_id)) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		// MANAGE DATA

		$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
		if(empty($participant_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	

		$event_control_data = $this->EventControl->find('first',array('conditions'=>array('EventControl.id'=>$event_control_id)));
		if(empty($event_control_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }	
		
		// Set diagnosis data for diagnosis selection (radio button)
		$dx_data = $this->DiagnosisMaster->find('all', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id), 'order' => array('DiagnosisMaster.dx_date ASC')));
		$sorted_dx_data = array();
		foreach($dx_data as $dx_tmp_data) {
			if(!empty($this->data)) {
				// User submitted data: take updated data in consideration in case data validation is wrong and form is redisplayed
				// Set data to display correctly selected diagnosis			
				if($dx_tmp_data['DiagnosisMaster']['id'] == $this->data['EventMaster']['diagnosis_master_id'] ){
					$dx_tmp_data['EventMaster']['diagnosis_master_id'] = $this->data['EventMaster']['diagnosis_master_id'];
				}				
			}
			
			$tmp_primary_id = $dx_tmp_data['DiagnosisMaster']['primary_id'];
			if(!array_key_exists($tmp_primary_id, $sorted_dx_data)) $sorted_dx_data[$tmp_primary_id] = array('category'=>null,'controls_type'=>null,'dx_list'=>array());
			if($tmp_primary_id == $dx_tmp_data['DiagnosisMaster']['id']) {
				$sorted_dx_data[$tmp_primary_id]['category'] = $dx_tmp_data['DiagnosisControl']['category'];
				$sorted_dx_data[$tmp_primary_id]['controls_type'] = $dx_tmp_data['DiagnosisControl']['controls_type'];
				$sorted_dx_data[$tmp_primary_id]['dx_list'] = array_merge(array($dx_tmp_data), $sorted_dx_data[$tmp_primary_id]['dx_list']);
			} else {
				$sorted_dx_data[$tmp_primary_id]['dx_list'][] = $dx_tmp_data;
			}
		}
		$this->set('data_for_checklist', $sorted_dx_data);	

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
		if( $hook_link ) { 
			require($hook_link); 
		}
		
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
			if( $hook_link ) { 
				require($hook_link); 
			}

			if ($submitted_data_validates && $this->EventMaster->save($this->data) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been updated','/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$this->EventMaster->getLastInsertId());
			}
		} 
	}
	
	function edit( $event_group, $participant_id, $event_master_id ) {
		if ((!$participant_id) || (!$event_group) || (!$event_master_id)) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }		
		
		// MANAGE DATA
		$event_master_data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id, 'EventMaster.participant_id'=>$participant_id)));
		if (empty($event_master_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
		// Set diagnosis data for diagnosis selection (radio button)
		$dx_data = $this->DiagnosisMaster->find('all', array('conditions'=>array('DiagnosisMaster.participant_id'=>$participant_id), 'order' => array('DiagnosisMaster.dx_date ASC')));
		$sorted_dx_data = array();
		foreach($dx_data as $dx_tmp_data) {
			// Define event data to take in consideration
			$event_master_data_to_use = $event_master_data['EventMaster'];
			if(!empty($this->data)) {
				// User submitted data: take updated data in consideration in case data validation is wrong and form is redisplayed
				$event_master_data_to_use = $this->data['EventMaster'];
			}
			
			// Set data to display correctly selected diagnosis			
			if($dx_tmp_data['DiagnosisMaster']['id'] == $event_master_data_to_use['diagnosis_master_id'] ){
				$dx_tmp_data['EventMaster']['diagnosis_master_id'] = $event_master_data_to_use['diagnosis_master_id'];
			}
			
			$tmp_primary_id = $dx_tmp_data['DiagnosisMaster']['primary_id'];
			if(!array_key_exists($tmp_primary_id, $sorted_dx_data)) $sorted_dx_data[$tmp_primary_id] = array('category'=>null,'controls_type'=>null,'dx_list'=>array());
			if($tmp_primary_id == $dx_tmp_data['DiagnosisMaster']['id']) {
				$sorted_dx_data[$tmp_primary_id]['category'] = $dx_tmp_data['DiagnosisControl']['category'];
				$sorted_dx_data[$tmp_primary_id]['controls_type'] = $dx_tmp_data['DiagnosisControl']['controls_type'];
				$sorted_dx_data[$tmp_primary_id]['dx_list'] = array_merge(array($dx_tmp_data), $sorted_dx_data[$tmp_primary_id]['dx_list']);
			} else {
				$sorted_dx_data[$tmp_primary_id]['dx_list'][] = $dx_tmp_data;
			}
		}
		$this->set('data_for_checklist', $sorted_dx_data);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventMaster.id'=>$event_master_id,  'EventControl.id'=>$event_master_data['EventControl']['id']) );
		
		// set FORM ALIAS based off VALUE from MASTER table
		$this->Structures->set('empty', 'empty_structure');
		$this->Structures->set($event_master_data['EventControl']['form_alias']);
		$this->Structures->set('diagnosismasters', 'diagnosis_structure');		
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { 
			require($hook_link); 
		}
		
		if ( !empty($this->data) ) {
			$this->EventMaster->id = $event_master_id;

			// LAUNCH SPECIAL VALIDATION PROCESS
			$submitted_data_validates = true;
			
			// CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}
			
			if ($submitted_data_validates && $this->EventMaster->save($this->data) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been updated','/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$event_master_id);
			}
		} else {
			$this->data = $event_master_data;
		}
	}

	function delete($event_group, $participant_id, $event_master_id) {
		if ((!$participant_id) || (!$event_master_id)) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }

		$event_master_data = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.id'=>$event_master_id, 'EventMaster.participant_id'=>$participant_id)));
		if (empty($event_master_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
		
		$arr_allow_deletion = $this->EventMaster->allowDeletion($event_master_id);
		
		// CUSTOM CODE		
		$hook_link = $this->hook('delete');
		if ($hook_link) { 
			require($hook_link); 
		}
		
		if ($arr_allow_deletion['allow_deletion']) {
			if ($this->EventMaster->atim_delete( $event_master_id )) {
				$this->atimFlash( 'your data has been deleted', '/clinicalannotation/event_masters/listall/'.$event_group.'/'.$participant_id );
			} else {
				$this->flash( 'error deleting data - contact administrator', '/clinicalannotation/event_masters/listall/'.$event_group.'/'.$participant_id );
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/clinicalannotation/event_masters/detail/'.$event_group.'/'.$participant_id.'/'.$event_master_id);
		}
	}
}

?>