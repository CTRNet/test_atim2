<?php
class TreatmentMastersControllerCustom extends TreatmentMastersController {
	
	function preOperativeDetail($participant_id, $tx_master_id){
		if (( !$participant_id ) && ( !$tx_master_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// LOAD SURGERY DATA / FORM (including cirrhosis data)
		
		$surgey_data = $this->TreatmentMaster->find('first', array('conditions' => array('TreatmentMaster.id' => $tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($surgey_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	
		
		switch($surgey_data['TreatmentControl']['detail_tablename']) {
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
		$this->data = $surgey_data;
		
		// LOAD EVENT DATA LINKED TO SURGERY
		
		// Load EventMaster
		if(!App::import('Model', 'clinicalannotation.EventMaster')) {
			$this->redirect( '/pages/err_clin_system_error', null, true );
		}		
		$this->EventMaster = new EventMaster();	
				
		// Load lab reports list, imagings and structure
		$this->set('imagings_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgey_data['TreatmentDetail']['imagery_id']))));
		$this->set('lab_reports_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgey_data['TreatmentDetail']['lab_report_id']))));
		$this->Structures->set('eventmasters', 'eventmasters_structure');

		// Load scores list and structures
		$this->set('score_fong_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgey_data['TreatmentDetail']['fong_score_id']))));
		$this->Structures->set('ed_score_fong', 'score_fong_structure');
		$this->set('score_meld_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgey_data['TreatmentDetail']['meld_score_id']))));
		$this->Structures->set('ed_score_meld', 'score_meld_structure');
		$this->set('score_gretch_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgey_data['TreatmentDetail']['gretch_score_id']))));
		$this->Structures->set('ed_score_gretch', 'score_gretch_structure');
		$this->set('score_clip_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgey_data['TreatmentDetail']['clip_score_id']))));
		$this->Structures->set('ed_score_clip', 'score_clip_structure');
		$this->set('score_barcelona_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgey_data['TreatmentDetail']['barcelona_score_id']))));
		$this->Structures->set('ed_score_barcelona', 'score_barcelona_structure');
		$this->set('score_okuda_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgey_data['TreatmentDetail']['okuda_score_id']))));
		$this->Structures->set('ed_score_okuda', 'score_okuda_structure');
	}
	
	function preOperativeEdit($participant_id, $tx_master_id){
		if (( !$participant_id ) && ( !$tx_master_id )) { $this->redirect( '/pages/err_clin_funct_param_missing', NULL, TRUE ); }
		
		// LOAD SURGERY DATA / FORM (including cirrhosis data)
		
		$surgey_data = $this->TreatmentMaster->find('first', array('conditions' => array('TreatmentMaster.id' => $tx_master_id, 'TreatmentMaster.participant_id'=>$participant_id)));
		if(empty($surgey_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }	
		
		switch($surgey_data['TreatmentControl']['detail_tablename']) {
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
		$this->Structures->set('empty', 'empty_structure');
		$this->set('atim_menu', $this->Menus->get('/clinicalannotation/treatment_masters/preOperativeDetail/'));
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, 'TreatmentMaster.id' => $tx_master_id));
		
		if(empty($this->data)) {
			$this->data = $surgey_data;
			
		} else { 
			// Launch save process
			$this->TreatmentMaster->id = $tx_master_id;
			$this->data['TreatmentMaster']['id'] = $tx_master_id;
			if($this->TreatmentMaster->save($this->data)) {
				$this->flash("your data has been saved", '/clinicalannotation/treatment_masters/preOperativeDetail/'.$participant_id.'/'.$tx_master_id.'/');
				return;
			}
		}
		
		// Load EventMaster
		if(!App::import('Model', 'clinicalannotation.EventMaster')) {
			$this->redirect( '/pages/err_clin_system_error', null, true );
		}		
		$this->EventMaster = new EventMaster();	
				
		// Manage cirrhosis data import
		
		if($this->data['TreatmentDetail']['type_of_cirrhosis'] == ""
		&& $this->data['TreatmentDetail']['esophageal_varices'] == ""
		&& $this->data['TreatmentDetail']['gastric_varices'] == ""
		&& $this->data['TreatmentDetail']['tips'] == ""
		&& $this->data['TreatmentDetail']['portacaval_gradient'] == ""
		&& $this->data['TreatmentDetail']['splenomegaly'] == ""
		&& $this->data['TreatmentDetail']['splen_size'] == ""){
			$cirrhosis = $this->EventMaster->find('first', array('conditions' => array('EventMaster.event_group' => 'clinical', 'EventMaster.event_type' => 'cirrhosis medical past history'), 'order' => 'EventMaster.event_date DESC'));
			
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
		
		// LOAD EVENT DATA THAT COULD BE LINKED TO SURGERY			
		
		// Load lab reports list, imagings and structure
		$this->set('lab_reports_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'lab'))));
		$this->set('imagings_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'clinical', 'EventMaster.event_type LIKE "medical imaging%"'))));
		$this->Structures->set('eventmasters', 'eventmasters_structure');
		
		// Load scores list and structures
		$this->set('score_fong_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'fong score'))));
		$this->Structures->set('ed_score_fong', 'score_fong_structure');
		$this->set('score_meld_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'meld score'))));
		$this->Structures->set('ed_score_meld', 'score_meld_structure');
		$this->set('score_gretch_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'gretch score'))));
		$this->Structures->set('ed_score_gretch', 'score_gretch_structure');
		$this->set('score_clip_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'clip score'))));
		$this->Structures->set('ed_score_clip', 'score_clip_structure');
		$this->set('score_barcelona_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'barcelona score'))));
		$this->Structures->set('ed_score_barcelona', 'score_barcelona_structure');
		$this->set('score_okuda_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'okuda score'))));
		$this->Structures->set('ed_score_okuda', 'score_okuda_structure');	
	}
}

