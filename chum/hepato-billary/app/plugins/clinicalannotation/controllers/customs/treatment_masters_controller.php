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
		$this->Structures->set('qc_hb_ed_score_fong', 'score_fong_structure');
		$this->set('score_meld_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgey_data['TreatmentDetail']['meld_score_id']))));
		$this->Structures->set('qc_hb_ed_score_meld', 'score_meld_structure');
		$this->set('score_gretch_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgey_data['TreatmentDetail']['gretch_score_id']))));
		$this->Structures->set('qc_hb_ed_score_gretch', 'score_gretch_structure');
		$this->set('score_clip_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgey_data['TreatmentDetail']['clip_score_id']))));
		$this->Structures->set('qc_hb_ed_score_clip', 'score_clip_structure');
		$this->set('score_barcelona_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgey_data['TreatmentDetail']['barcelona_score_id']))));
		$this->Structures->set('qc_hb_ed_score_barcelona', 'score_barcelona_structure');
		$this->set('score_okuda_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.id' => $surgey_data['TreatmentDetail']['okuda_score_id']))));
		$this->Structures->set('qc_hb_ed_score_okuda', 'score_okuda_structure');
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
		$this->Structures->set('qc_hb_ed_score_fong', 'score_fong_structure');
		$this->set('score_meld_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'meld score'))));
		$this->Structures->set('qc_hb_ed_score_meld', 'score_meld_structure');
		$this->set('score_gretch_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'gretch score'))));
		$this->Structures->set('qc_hb_ed_score_gretch', 'score_gretch_structure');
		$this->set('score_clip_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'clip score'))));
		$this->Structures->set('qc_hb_ed_score_clip', 'score_clip_structure');
		$this->set('score_barcelona_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'barcelona score'))));
		$this->Structures->set('qc_hb_ed_score_barcelona', 'score_barcelona_structure');
		$this->set('score_okuda_data', $this->EventMaster->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_id, 'EventMaster.event_group' => 'scores', 'EventMaster.event_type' => 'okuda score'))));
		$this->Structures->set('qc_hb_ed_score_okuda', 'score_okuda_structure');	
	}
	
	// --------------------------------------------------------------------------------
	// *.surgery : Add Durations (Intensive care, hospitatlisation, etc)
	// --------------------------------------------------------------------------------
	
	/** 
 	 * Set medical past history precisions list for clinical.hepatobiliary.***medical_past_history.
 	 * 
 	 * @param $tx_data Data of the created/studied trt.
 	 * @param $tx_control Tx control of the created/studied trt.
 	 * 
 	 * @return Update trt data
 	 **/
 	 
	function addSurgeryDurations( $tx_data, $tx_control ) { 
		$tx_type_title = 
			$tx_control['TreatmentControl']['disease_site'].'-'.
			$tx_control['TreatmentControl']['tx_method'];
			
		$pattern = '/^(.*)-surgery?/';
		if(preg_match($pattern, $tx_type_title)) { 
			//hospitalization duration
			$tx_data['TreatmentDetail']['hospitalization_duration_in_days'] = $this->getSpentTime($tx_data['TreatmentDetail']['hospitalization_start_date'], $tx_data['TreatmentDetail']['hospitalization_end_date']);
			
			//ic_1_duration_in_days duration
			$tx_data['TreatmentDetail']['ic_1_duration_in_days'] = $this->getSpentTime($tx_data['TreatmentDetail']['ic_1_start_date'], $tx_data['TreatmentDetail']['ic_1_end_date']);
			
			//ic_22_duration_in_days duration
			$tx_data['TreatmentDetail']['ic_2_duration_in_days'] = $this->getSpentTime($tx_data['TreatmentDetail']['ic_2_start_date'], $tx_data['TreatmentDetail']['ic_2_end_date']);
			
			//ic_1_duration_in_days duration
			$tx_data['TreatmentDetail']['ic_3_duration_in_days'] = $this->getSpentTime($tx_data['TreatmentDetail']['ic_3_start_date'], $tx_data['TreatmentDetail']['ic_3_end_date']);
			
			$tx_data['TreatmentDetail']['total_ic_duration_in_days'] =
				(empty($tx_data['TreatmentDetail']['ic_1_duration_in_days'])? 0: $tx_data['TreatmentDetail']['ic_1_duration_in_days']) +
				(empty($tx_data['TreatmentDetail']['ic_2_duration_in_days'])? 0: $tx_data['TreatmentDetail']['ic_2_duration_in_days']) +
				(empty($tx_data['TreatmentDetail']['ic_3_duration_in_days'])? 0: $tx_data['TreatmentDetail']['ic_3_duration_in_days']);
		}
		
		return $tx_data;
		
	}
	
	// --------------------------------------------------------------------------------
	// *.surgery : Add survival time
	// --------------------------------------------------------------------------------
	
	/** 
 	 * Set medical past history precisions list for clinical.hepatobiliary.***medical_past_history.
 	 * 
 	 * @param $tx_data Data of the created/studied trt.
 	 * @param $tx_control Tx control of the created/studied trt.
 	 * 
 	 * @return Update trt data
 	 **/
 	 
	function addSurvivalTime($participant_data, $tx_data, $tx_control ) { 
		$tx_type_title = 
			$tx_control['TreatmentControl']['disease_site'].'-'.
			$tx_control['TreatmentControl']['tx_method'];
					
		$pattern = '/^(.*)-surgery?/';
		if(preg_match($pattern, $tx_type_title)) { 
			//hospitalization duration
			$last_news_date = array();
			if(!empty($participant_data['Participant']['last_news_date'])) {
				list($last_news_date['year'], $last_news_date['month'], $last_news_date['day']) = explode('-', $participant_data['Participant']['last_news_date']);
			}
			$tx_data['TreatmentDetail']['survival_time_in_months'] = $this->getSpentTime($tx_data['TreatmentMaster']['start_date'], $last_news_date, 'months');			
		}
		
		return $tx_data;
	}
	
	function updateParticipantSurvivalTime($participant_id, $new_last_news_date ) { 
		if(!isset($this->TreatmentMaster)) {
			App::import('Model', "Clinicalannotation.TreatmentMaster");
			$this->TreatmentMaster = new TreatmentMaster();	
		}
			
		$surgeries = $this->TreatmentMaster->find('all', array('conditions' => array('TreatmentMaster.participant_id' => $participant_id, 'TreatmentMaster.tx_method' => 'surgery')));

		foreach($surgeries as $new_participant_surgery) {
			$surgery_date = array();
			if(!empty($new_participant_surgery['TreatmentMaster']['start_date'])) {
				list($surgery_date['year'], $surgery_date['month'], $surgery_date['day']) = explode('-', $new_participant_surgery['TreatmentMaster']['start_date']);
			}
			$survival_time_in_months = $this->getSpentTime($surgery_date, $new_last_news_date, 'months');
			
			$tx_data = array();
			$tx_data['TreatmentMaster']['id'] = $new_participant_surgery['TreatmentMaster']['id'];
			$tx_data['TreatmentDetail']['survival_time_in_months'] = $survival_time_in_months;			
			$this->TreatmentMaster->id = $new_participant_surgery['TreatmentMaster']['id'];pr($new_participant_surgery['TreatmentMaster']['id']);
			if(!$this->TreatmentMaster->save($tx_data)) { $this->redirect( '/pages/err_clin_system_error', null, true ); }
		}
	}
	
	// --------------------------------------------------------------------------------
	// Functions...
	// --------------------------------------------------------------------------------
	
	/**
	 * Return the spent time between 2 dates in days nbr. 
	 * Notes: The supported date format is YYYY-MM-DD
	 * 
	 * @param $start_date Start date
	 * @param $end_date End date
	 * 
	 * @return Spent time
	 * 
	 * @author N. Luc
	 * @since 2007-06-20
	 */
	 
	function getSpentTime($start_date, $end_date, $format = 'days'){
		$result = '';
		// Verfiy date is not empty
		if(empty($start_date['month']) || empty($start_date['day']) || empty($start_date['year']) 
		|| empty($end_date['month']) || empty($end_date['day']) || empty($end_date['year'])){
			// At least one date is missing to continue
			$result = '';	
		} else {
			switch($format) {
				case 'days':
					// ** GET TIME IN DAYS **
					$start = mktime(0, 0, 0, $start_date['month'], $start_date['day'], $start_date['year']);
					$end = mktime(0, 0, 0, $end_date['month'], $end_date['day'], $end_date['year']);
					$spent_time = $end - $start;
					
					if(($start === false)||($end === false)){
						// Error in the date
						$result = '';	
					} else if($spent_time < 0){
						// Error in the date
						$result = '';
					} else if($spent_time == 0){
						// Nothing to change to $arr_spent_time
						$result = '0';
					} else {
						// Return spend time in days
						$result = floor($spent_time / 86400);
					}
					break;
				
				case 'months':
					// ** GET TIME IN MONTHS **
					$pattern = '/^[0-9]+$/';
					if(preg_match($pattern, $start_date['month']) && preg_match($pattern, $start_date['day']) && preg_match($pattern, $start_date['year']) 
					&& preg_match($pattern, $end_date['month']) && preg_match($pattern, $end_date['day']) && preg_match($pattern, $end_date['year'])) {
						$diff_months = ($end_date['year'] - $start_date['year']) * 12;
						if($diff_months < 0) {
							$result = '';	
						} else {
							$diff_months = $diff_months + ($end_date['month'] - $start_date['month']);
							if($diff_months < 0) {
								$result = '';	
							} else {	
								if($start_date['day'] > $end_date['day']) { $diff_months = $diff_months - 1; }
								($diff_months < 0)? $result = '' : $result = $diff_months;
							}						
						}
					} else {					
						$result = '';
					}
					break;
					
				default:
					$this->redirect( '/pages/err_clin_system_error', null, true );
			}
		}
		return $result;
	}
}

