<?php

//NL Revised

class TreatmentMastersControllerCustom extends TreatmentMastersController {
	
	function preOperativeDetail($participant_id, $tx_master_id){
		if (( !$participant_id ) && ( !$tx_master_id )) { $this->redirect( '/pages/err_plugin_funct_param_missing', NULL, TRUE ); }
		
		// LOAD SURGERY DATA / FORM (including cirrhosis data)
		
		$surgery_data = $this->TreatmentMaster->find('first', array('conditions' => array('TreatmentMaster.id' => $tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($surgery_data)) { $this->redirect( '/pages/err_plugin_no_data', null, true ); }	
		
		switch($surgery_data['TreatmentControl']['detail_tablename']) {
			case 'qc_hb_txd_surgery_livers':
				$structure_name = 'qc_hb_pre_surgery_livers';
				break;
			case 'qc_hb_txd_surgery_pancreas':
				$structure_name = 'qc_hb_pre_surgery_pancreas';
				break;
			default:
				$this->flash("no pre operative data has to be defined for this type of treatment", '/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$tx_master_id.'/');
				return;
		}
		
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id' => $tx_master_id));
		$this->Structures->set($structure_name);
		$this->data = $surgery_data;
		
		// LOAD EVENT DATA & STRUCTURES (that could be linked to preoperative report)

		$surgeries_events_data = array();
		
		$surgeries_events_data['lab_report_id'] = $this->getEventDataForPreOperativeForm('lab_report_id', 'lab', 'biology', $this->data, $participant_id, $this->data['TreatmentDetail']['lab_report_id']);
		$surgeries_events_data['imagery_id'] = $this->getEventDataForPreOperativeForm('imagery_id', 'clinical', 'medical imaging%', $this->data, $participant_id, $this->data['TreatmentDetail']['imagery_id']);
		$surgeries_events_data['fong_score_id'] =  $this->getEventDataForPreOperativeForm('fong_score_id', 'scores', 'fong score',  $this->data, $participant_id, $this->data['TreatmentDetail']['fong_score_id']);
		$surgeries_events_data['meld_score_id'] = $this->getEventDataForPreOperativeForm('meld_score_id', 'scores', 'meld score', $this->data, $participant_id, $this->data['TreatmentDetail']['meld_score_id']);
		$surgeries_events_data['gretch_score_id'] = $this->getEventDataForPreOperativeForm('gretch_score_id', 'scores', 'gretch score', $this->data, $participant_id, $this->data['TreatmentDetail']['gretch_score_id']);
		$surgeries_events_data['clip_score_id'] = $this->getEventDataForPreOperativeForm('clip_score_id', 'scores', 'clip score', $this->data, $participant_id, $this->data['TreatmentDetail']['clip_score_id']); 
		$surgeries_events_data['barcelona_score_id'] = $this->getEventDataForPreOperativeForm('barcelona_score_id', 'scores', 'barcelona score', $this->data, $participant_id, $this->data['TreatmentDetail']['barcelona_score_id']);
		$surgeries_events_data['okuda_score_id'] = $this->getEventDataForPreOperativeForm('okuda_score_id', 'scores', 'okuda score', $this->data, $participant_id, $this->data['TreatmentDetail']['okuda_score_id']);	
		
		$this->set('surgeries_events_data', $surgeries_events_data);	
		
		// Load EventMaster
		if(!App::import('Model', 'clinicalannotation.EventMaster')) {
			$this->redirect( '/pages/err_plugin_system_error', null, true );
		}		
		$this->EventMaster = new EventMaster();	
				
		// Load lab reports list, imagings and structure
		$this->set('imagings_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgery_data['TreatmentDetail']['imagery_id']))));
		$this->set('lab_reports_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgery_data['TreatmentDetail']['lab_report_id']))));
		$this->Structures->set('eventmasters', 'eventmasters_structure');

		// Load scores list and structures
		$this->set('score_fong_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgery_data['TreatmentDetail']['fong_score_id']))));
		$this->Structures->set('qc_hb_ed_score_fong', 'score_fong_structure');
		$this->set('score_meld_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgery_data['TreatmentDetail']['meld_score_id']))));
		$this->Structures->set('qc_hb_ed_score_meld', 'score_meld_structure');
		$this->set('score_gretch_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgery_data['TreatmentDetail']['gretch_score_id']))));
		$this->Structures->set('qc_hb_ed_score_gretch', 'score_gretch_structure');
		$this->set('score_clip_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgery_data['TreatmentDetail']['clip_score_id']))));
		$this->Structures->set('qc_hb_ed_score_clip', 'score_clip_structure');
		$this->set('score_barcelona_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgery_data['TreatmentDetail']['barcelona_score_id']))));
		$this->Structures->set('qc_hb_ed_score_barcelona', 'score_barcelona_structure');
		$this->set('score_okuda_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgery_data['TreatmentDetail']['okuda_score_id']))));
		$this->Structures->set('qc_hb_ed_score_okuda', 'score_okuda_structure');
	}
	
	function preOperativeEdit($participant_id, $tx_master_id){
		if (( !$participant_id ) && ( !$tx_master_id )) { $this->redirect( '/pages/err_plugin_funct_param_missing', NULL, TRUE ); }
		
		// SURGERY DATA & STRUCTURES
		
		$surgery_data = $this->TreatmentMaster->find('first', array('conditions' => array('TreatmentMaster.id' => $tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($surgery_data)) { $this->redirect( '/pages/err_plugin_no_data', null, true ); }	
		
		switch($surgery_data['TreatmentControl']['detail_tablename']) {
			case 'qc_hb_txd_surgery_livers':
				$structure_name = 'qc_hb_pre_surgery_livers';
				break;
			case 'qc_hb_txd_surgery_pancreas':
				$structure_name = 'qc_hb_pre_surgery_pancreas';
				break;
			default:
				$this->flash("no pre operative data has to be defined for this type of treatment", '/clinicalannotation/treatment_masters/detail/'.$participant_id.'/'.$tx_master_id.'/');
				return;
		}
		
		$this->Structures->set($structure_name);
		$this->set('atim_menu', $this->Menus->get('/clinicalannotation/treatment_masters/preOperativeDetail/'));
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id' => $tx_master_id));	
	
		if(empty($this->data)) {
			
			//INITIAL DISPLAY
			
			$this->data = $surgery_data;
			
			// Set default cirrhosis data
			if($this->data['TreatmentDetail']['type_of_cirrhosis'] == ""
			&& $this->data['TreatmentDetail']['esophageal_varices'] == ""
			&& $this->data['TreatmentDetail']['gastric_varices'] == ""
			&& $this->data['TreatmentDetail']['tips'] == ""
			&& $this->data['TreatmentDetail']['portacaval_gradient'] == ""
			&& $this->data['TreatmentDetail']['splenomegaly'] == ""
			&& $this->data['TreatmentDetail']['splen_size'] == ""){
				
				$this->EventMaster = AppModel::getInstance("Clinicalannotation", "EventMaster", true);
				$cirrhosis = $this->EventMaster->find('first', array('conditions' => array('EventControl.event_group' => 'clinical', 'EventControl.event_type' => 'cirrhosis medical past history'), 'order' => 'EventMaster.event_date DESC'));
				if(!empty($cirrhosis)) {
					//not the most efficient, but will automatically work if new fields matches in both tables
					unset($cirrhosis['EventDetail']['id']);
					unset($cirrhosis['EventDetail']['event_master_id']);
					unset($cirrhosis['EventDetail']['created']);
					unset($cirrhosis['EventDetail']['created_by']);
					unset($cirrhosis['EventDetail']['modified']);
					unset($cirrhosis['EventDetail']['modified_by']);
					unset($cirrhosis['EventDetail']['deleted']);
					unset($cirrhosis['EventDetail']['deleted_by']);
					$this->data['TreatmentDetail'] = array_merge($this->data['TreatmentDetail'], $cirrhosis['EventDetail']);				
				}
			}			

		} else { 
			
			// LAUNCH SAVE PROCESS
			
			$this->TreatmentMaster->id = $tx_master_id;
			$this->data['TreatmentMaster']['id'] = $tx_master_id;
			if($this->TreatmentMaster->save($this->data)) {
				$this->flash("your data has been saved", '/clinicalannotation/treatment_masters/preOperativeDetail/'.$participant_id.'/'.$tx_master_id.'/');
				return;
			}
		}
		
		// LOAD EVENT DATA & STRUCTURES (that could be linked to preoperative report)
		
		$surgeries_events_data = array();
		
		$surgeries_events_data['lab_report_id'] = $this->getEventDataForPreOperativeForm('lab_report_id', 'lab', 'biology', $this->data, $participant_id);
		$surgeries_events_data['imagery_id'] = $this->getEventDataForPreOperativeForm('imagery_id', 'clinical', 'medical imaging%', $this->data, $participant_id);
		$surgeries_events_data['fong_score_id'] =  $this->getEventDataForPreOperativeForm('fong_score_id', 'scores', 'fong score',  $this->data, $participant_id);
		$surgeries_events_data['meld_score_id'] = $this->getEventDataForPreOperativeForm('meld_score_id', 'scores', 'meld score', $this->data, $participant_id);
		$surgeries_events_data['gretch_score_id'] = $this->getEventDataForPreOperativeForm('gretch_score_id', 'scores', 'gretch score', $this->data, $participant_id);
		$surgeries_events_data['clip_score_id'] = $this->getEventDataForPreOperativeForm('clip_score_id', 'scores', 'clip score', $this->data, $participant_id); 
		$surgeries_events_data['barcelona_score_id'] = $this->getEventDataForPreOperativeForm('barcelona_score_id', 'scores', 'barcelona score', $this->data, $participant_id);
		$surgeries_events_data['okuda_score_id'] = $this->getEventDataForPreOperativeForm('okuda_score_id', 'scores', 'okuda score', $this->data, $participant_id);
		
		$this->set('surgeries_events_data', $surgeries_events_data);	
	}
	
	function getEventDataForPreOperativeForm($event_foreign_key, $event_group, $event_type, $pre_operative_data, $participant_id, $event_master_id = '-1') {
		$this->EventMaster = AppModel::getInstance("Clinicalannotation", "EventMaster", true);
		
		$conditions = array(
			'EventMaster.participant_id' => $participant_id,
			'EventControl.event_group' => $event_group,
			'EventControl.event_type LIKE "'.$event_type.'"'
		);
		if($event_master_id != '-1') {
			$conditions['EventMaster.id'] = $event_master_id;
		}
		$event_data = $this->EventMaster->find('all', array('conditions' => $conditions));
		
		$selected_event_found = false;
		if($event_master_id == '-1') {
			foreach($event_data as &$event){
				if($event['EventMaster']['id'] == $pre_operative_data['TreatmentDetail'][$event_foreign_key]){
					//we found the one that interests us
					$event['TreatmentMaster'] = $pre_operative_data['TreatmentMaster'];
					$event['TreatmentDetail'] = $pre_operative_data['TreatmentDetail'];
					$selected_event_found = true;
					break;
				}
				if($selected_event_found) break;
			}
		}	

		$this->EventControl = AppModel::getInstance("Clinicalannotation", "EventControl", true);
		$conditions = array(
			'EventControl.event_group' => $event_group,
			'EventControl.event_type LIKE "'.$event_type.'"'
		);
		$event_controls = $this->EventControl->find('all', array('conditions' => $conditions));		
		
		$form_aliases = array();
		foreach($event_controls as $new_control) {
			$form_aliases[$new_control['EventControl']['form_alias']] = $new_control['EventControl']['form_alias'];
		}
		$form_alias = (sizeof($form_aliases) == 1)? array_shift($form_aliases) : 'eventmasters';

		return array('event_foreign_key' => $event_foreign_key, 
			'data' => $event_data, 
			'selected_event_found' => $selected_event_found,
			'structure' => $this->Structures->get('form', $form_alias),
			'header' => str_replace('%', '', $event_type));
	}		
}
