<?php
class TreatmentMastersControllerCustom extends TreatmentMastersController {
	function postOperativeDetail($participant_id, $tx_master_id){
		App::import('Model', 'clinicalannotation.EventMaster') or die("imp failed");		
		$this->EventMaster = new EventMaster();	
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, "TreatmentMaster.id" => $tx_master_id));
		
		$this->data = $this->TreatmentMaster->find('first', array('conditions' => array('TreatmentMaster.id' => $tx_master_id)));
		
		$this->data = $this->TreatmentMaster->find('first', array('conditions' => array('TreatmentMaster.id' => $tx_master_id)));
		
		$this->set('lab_reports_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $this->data['TreatmentDetail']['lab_report_id']))));
		$this->Structures->set('qc_hb_dateNSummary', 'date_and_summary');
		$this->set('imagings_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $this->data['TreatmentDetail']['imagery_id']))));
		$this->set('score_fong_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $this->data['TreatmentDetail']['fong_score_id']))));
		$this->Structures->set('ed_score_fong', 'score_fong_structure');
		$this->set('score_meld_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $this->data['TreatmentDetail']['meld_score_id']))));
		$this->Structures->set('ed_score_meld', 'score_meld_structure');
		$this->set('score_gretch_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $this->data['TreatmentDetail']['gretch_score_id']))));
		$this->Structures->set('ed_score_gretch', 'score_gretch_structure');
		$this->set('score_clip_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $this->data['TreatmentDetail']['clip_score_id']))));
		$this->Structures->set('ed_score_clip', 'score_clip_structure');
		$this->set('score_barcelona_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $this->data['TreatmentDetail']['barcelona_score_id']))));
		$this->Structures->set('ed_score_barcelona', 'score_barcelona_structure');
		$this->set('score_okuda_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $this->data['TreatmentDetail']['okuda_score_id']))));
		$this->Structures->set('ed_score_okuda', 'score_okuda_structure');
		
		if($this->data['TreatmentControl']['detail_tablename'] == "qc_hb_txd_operation_livers"){
			$structure_name = "qc_hb_post_operation_livers";
		}else if($this->data['TreatmentControl']['detail_tablename'] == "qc_hb_txd_operation_pancreas"){
			$structure_name = "qc_hb_post_operation_pancreas";
		}else{
			$structure_name = "empty_structure";
		}
		$this->Structures->set($structure_name);
	}
	
	function postOperativeEdit($participant_id, $tx_master_id){
		$this->set('atim_menu_variables', array('Participant.id'=>$participant_id, "TreatmentMaster.id" => $tx_master_id));
		if(!empty($this->data)){
			$this->TreatmentMaster->id = $tx_master_id;
			$this->data['TreatmentMaster']['id'] = $tx_master_id;
			$this->TreatmentMaster->save($this->data);
			$this->flash("your data has been saved", '/clinicalannotation/treatment_masters/postOperativeDetail/'.$participant_id.'/'.$tx_master_id.'/');
		}else{
			App::import('Model', 'clinicalannotation.EventMaster') or die("imp failed");		
			$this->EventMaster = new EventMaster();	
			
			$this->Structures->set('empty', 'empty_structure');
			$this->data = $this->TreatmentMaster->find('first', array('conditions' => array('TreatmentMaster.id' => $tx_master_id)));
			$this->set('lab_reports_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'lab'))));
			$this->Structures->set('qc_hb_dateNSummary', 'date_and_summary');
			$this->set('imagings_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'clinical', 'EventMaster.event_type LIKE "medical imaging%"'))));
			$this->set('score_fong_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'score de fong'))));
			$this->Structures->set('ed_score_fong', 'score_fong_structure');
			$this->set('score_meld_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'meld score'))));
			$this->Structures->set('ed_score_meld', 'score_meld_structure');
			$this->set('score_gretch_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'gretch'))));
			$this->Structures->set('ed_score_gretch', 'score_gretch_structure');
			$this->set('score_clip_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'clip'))));
			$this->Structures->set('ed_score_clip', 'score_clip_structure');
			$this->set('score_barcelona_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'barcelona score'))));
			$this->Structures->set('ed_score_barcelona', 'score_barcelona_structure');
			$this->set('score_okuda_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'okuda score'))));
			$this->Structures->set('ed_score_okuda', 'score_okuda_structure');
						
			//cirrhosis
			if($this->data['TreatmentControl']['detail_tablename'] == "qc_hb_txd_operation_livers"){
				$structure_name = "qc_hb_post_operation_livers";
			}else if($this->data['TreatmentControl']['detail_tablename'] == "qc_hb_txd_operation_pancreas"){
				$structure_name = "qc_hb_post_operation_pancreas";
			}else{
				$structure_name = "empty_structure";
			}
			$this->Structures->set($structure_name);
			
			//load previous cirrhosis if needed
			if($this->data['TreatmentDetail']['type_of_cirrhosis'] == ""
			&& $this->data['TreatmentDetail']['esophageal_varices'] == ""
			&& $this->data['TreatmentDetail']['gastric_varices'] == ""
			&& $this->data['TreatmentDetail']['tips'] == ""
			&& $this->data['TreatmentDetail']['portacaval_gradient'] == ""
			&& $this->data['TreatmentDetail']['splenomegaly'] == ""
			&& $this->data['TreatmentDetail']['splen_size'] == ""){
				$cirrhosis = $this->EventMaster->find('first', array('conditions' => array('EventMaster.event_group' => 'clinical', 'EventMaster.event_type' => 'cirrhosis medical past history'), 'order' => 'EventMaster.event_date DESC'));
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
		$this->set('atim_menu', $this->Menus->get('/clinicalannotation/treatment_masters/postOperativeDetail/'));
	}
}

