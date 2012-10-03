<?php

class EventMastersControllerCustom extends EventMastersController {

	function addInBatch( $participant_id, $event_control_id, $already_displayed = false) {
	
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/listall/')){
			$this->flash(__('you need privileges on the following modules to manage participant inventory: %s', implode(', ', $error)), 'javascript:history.back()');
		}
		
		// MANAGE DATA
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		$event_control_data = $this->EventControl->getOrRedirect($event_control_id);
		$event_group = $event_control_data['EventControl']['event_group'];
			
		if(!in_array($event_control_data['EventControl']['event_type'], array('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event'))) {
			$this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		}
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/'.$this->params['plugin'].'/'.$this->params['controller'].'/listall/'.$event_group) );
		$this->set( 'atim_menu_variables', array('EventControl.event_group'=>$event_group,'Participant.id'=>$participant_id,'EventControl.id'=>$event_control_id) );
		$this->set('ev_header', __($event_control_data['EventControl']['event_type']));
		
		// set FORM ALIAS based off VALUE from CONTROL table
		$this->Structures->set($event_control_data['EventControl']['form_alias']);	
		
		$followup_identification_list = $this->EventMaster->getFollowupIdentificationFromId($participant_id);
		$this->set('followup_identification_list', $followup_identification_list);
		
		if(empty($this->request->data)){
			if(!$already_displayed) {
				$default_data = array();
				if(sizeof($followup_identification_list) > 1) {
					$keys = array_keys($followup_identification_list);
					$default_data['EventDetail']['followup_event_master_id'] = $keys[1];
				}
				$this->request->data = array($default_data, $default_data, $default_data, $default_data, $default_data);	
			} else {
				if($already_displayed) $this->EventMaster->validationErrors[''] = 'at least one record has to be created';
				$this->request->data = array(array());
			}
		}else{
			$errors_tracking = array();
				
			// Launch Structure Fields Validation
			
			$row_counter = 0;
			foreach($this->request->data as &$data_unit){
				$row_counter++;
				
				$data_unit['EventMaster']['event_control_id'] = $event_control_id;
				$data_unit['EventMaster']['participant_id'] = $participant_id;			
				
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
			if(empty($errors_tracking)){
				//save all
				$this->EventMaster->addWritableField(array('event_control_id','participant_id'));
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
	
	
	function listall( $event_group, $participant_id, $event_control_id=null ){
		// MANAGE DATA
		$participant_data = $this->Participant->getOrRedirect($participant_id);
		
		$event_ctrls = $this->EventControl->find('all', array('conditions' => array('EventControl.flag_active' => '1')));
		$tmp_event_list = $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id), 'order' => array('EventMaster.event_date DESC')));
		
		$this->request->data = null;
		$event_lists = array();
		$atim_structures = array('default' => $this->Structures->get('form', 'eventmasters'));
		foreach($event_ctrls as $new_ctrls) {
			$event_lists[__($new_ctrls['EventControl']['event_type'])] = array(
				'detail_form_alias' =>  $new_ctrls['EventControl']['detail_form_alias'],
				'form_name' => __($new_ctrls['EventControl']['event_type']), 
				'data' => array());
			if(preg_match('/^procure_ed_followup_worksheet_.+$/', $new_ctrls['EventControl']['detail_form_alias'], $matches)) $atim_structures[$new_ctrls['EventControl']['detail_form_alias']] = $this->Structures->get('form', 'eventmasters,'.$new_ctrls['EventControl']['detail_form_alias']);
		}
		ksort($event_lists);
		foreach($tmp_event_list as $new_evts) $event_lists[__($new_evts['EventControl']['event_type'])]['data'][] = $new_evts;
		$this->set('event_lists', $event_lists);
		$this->set('atim_structures', $atim_structures);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id, 'EventControl.id'=>$event_control_id) );
		
		$this->set('add_link_for_procure_forms',$this->Participant->buildAddProcureFormsButton($participant_id));
	}
}

?>