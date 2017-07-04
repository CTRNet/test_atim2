<?php
class ReportsControllerCustom extends ReportsController {
	
	function participantIdentifiersSummary($parameters) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/MiscIdentifiers/listall')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		$header = null;
		$conditions = array();
	
		if(isset($parameters['SelectedItemsForCsv']['Participant']['id'])) $parameters['Participant']['id'] = $parameters['SelectedItemsForCsv']['Participant']['id'];
		if(isset($parameters['Participant']['id'])) {
			//From databrowser
			$participant_ids  = array_filter($parameters['Participant']['id']);
			if($participant_ids) $conditions['Participant.id'] = $participant_ids;
		} else if(isset($parameters['Participant']['participant_identifier_start'])) {
			$participant_identifier_start = (!empty($parameters['Participant']['participant_identifier_start']))? $parameters['Participant']['participant_identifier_start']: null;
			$participant_identifier_end = (!empty($parameters['Participant']['participant_identifier_end']))? $parameters['Participant']['participant_identifier_end']: null;
			if($participant_identifier_start) $conditions[] = "Participant.participant_identifier >= '$participant_identifier_start'";
			if($participant_identifier_end) $conditions[] = "Participant.participant_identifier <= '$participant_identifier_end'";
		} else if(isset($parameters['Participant']['participant_identifier'])) {
			$participant_identifiers  = array_filter($parameters['Participant']['participant_identifier']);
			if($participant_identifiers) $conditions['Participant.participant_identifier'] = $participant_identifiers;
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		$misc_identifier_model = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
		$tmp_res_count = $misc_identifier_model->find('count', array('conditions' => $conditions, 'order' => array('MiscIdentifier.participant_id ASC')));
		if($tmp_res_count > Configure::read('databrowser_and_report_results_display_limit')) {
			return array(
				'header' => null,
				'data' => null,
				'columns_names' => null,
				'error_msg' => 'the report contains too many results - please redefine search criteria');
		}
		$misc_identifiers = $misc_identifier_model->find('all', array('conditions' => $conditions, 'order' => array('MiscIdentifier.participant_id ASC')));
		$data = array();
		foreach($misc_identifiers as $new_ident){	
			$participant_id = $new_ident['Participant']['id'];
			if(!isset($data[$participant_id])) {
				$data[$participant_id] = array(
						'Participant' => array(
								'id' => $new_ident['Participant']['id'],
								'participant_identifier' => $new_ident['Participant']['participant_identifier'],
								'first_name' => $new_ident['Participant']['first_name'],
								'last_name' => $new_ident['Participant']['last_name']),
						'0' => array(
								'RAMQ' => null,
								'hospital_number' => null)
				);
			}
			$data[$participant_id]['0'][str_replace(array(' ', '-'), array('_','_'), $new_ident['MiscIdentifierControl']['misc_identifier_name'])] = $new_ident['MiscIdentifier']['identifier_value'];
		}
		
		return array(
				'header' => $header,
				'data' => $data,
				'columns_names' => null,
				'error_msg' => null);
	}
	
	function procureDiagnosisAndTreatmentReports($parameters) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/TreatmentMasters/listall')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/EventMasters/listall')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		$display_exact_search_warning = false;
		$header = null;
		$conditions = array('TRUE');
		if(isset($parameters['Participant']['id']) && !empty($parameters['Participant']['id'])) {
			//From databrowser
			$participant_ids  = array_filter($parameters['Participant']['id']);
			if($participant_ids) $conditions[] = "Participant.id IN ('".implode("','",$participant_ids)."')";
		} else if(isset($parameters['Participant']['participant_identifier_start'])) {
			$participant_identifier_start = (!empty($parameters['Participant']['participant_identifier_start']))? $parameters['Participant']['participant_identifier_start']: null;
			$participant_identifier_end = (!empty($parameters['Participant']['participant_identifier_end']))? $parameters['Participant']['participant_identifier_end']: null;
			if($participant_identifier_start) $conditions[] = "Participant.participant_identifier >= '$participant_identifier_start'";
			if($participant_identifier_end) $conditions[] = "Participant.participant_identifier <= '$participant_identifier_end'";
		} else if(isset($parameters['Participant']['participant_identifier'])) {
			$display_exact_search_warning = true;
			$participant_identifiers  = array_filter($parameters['Participant']['participant_identifier']);
			if($participant_identifiers) $conditions[] = "Participant.participant_identifier IN ('".implode("','",$participant_identifiers)."')";
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		if(isset($parameters['0']['procure_participant_identifier_prefix'])) {
			$procure_participant_identifier_prefix  = array_filter($parameters['0']['procure_participant_identifier_prefix']);
			if($procure_participant_identifier_prefix) {
				$prefix_conditions = array();
				foreach($procure_participant_identifier_prefix as $prefix) {
					if(!in_array($prefix, array('p','s'))) {
						$prefix_conditions[] = "Participant.participant_identifier LIKE 'PS$prefix%'";
					}
				}
				if($prefix_conditions) {
					$conditions[] = '('.implode(' OR ', $prefix_conditions).')';
				} else {
					$conditions[] =  "Participant.participant_identifier LIKE '-1'";
				}
			}
		}
			
		//Get Controls Data
		$participant_model = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$query = "SELECT id,event_type, detail_tablename FROM event_controls WHERE flag_active = 1;";
		$event_controls = array();
		foreach($participant_model->query($query) as $res) $event_controls[$res['event_controls']['event_type']] = array('id' => $res['event_controls']['id'], 'detail_tablename' => $res['event_controls']['detail_tablename']);
		$query = "SELECT id,tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1;";
		$tx_controls = array();
		foreach($participant_model->query($query) as $res) {
			$tx_controls[$res['treatment_controls']['tx_method']] = array('id' => $res['treatment_controls']['id'], 'detail_tablename' => $res['treatment_controls']['detail_tablename']);
		}
		$diagnosis_event_control_id = $event_controls['prostate cancer - diagnosis']['id'];
		$diagnosis_event_detail_tablename = $event_controls['prostate cancer - diagnosis']['detail_tablename'];
		$pathology_event_control_id = $event_controls['procure pathology report']['id'];
		$pathology_event_detail_tablename = $event_controls['procure pathology report']['detail_tablename'];
		$followup_treatment_control_id = $tx_controls['treatment']['id'];
		$followup_treatment_detail_tablename = $tx_controls['treatment']['detail_tablename'];
		
		if(!$diagnosis_event_control_id || !$pathology_event_control_id) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		//Get participants data
		$query = "SELECT 
			Participant.id,
			Participant.participant_identifier, 
			Participant.vital_status,
			Participant.date_of_death,
			Participant.date_of_death_accuracy,
			Participant.procure_cause_of_death,
			PathologyEventMaster.event_date, 
			PathologyEventMaster.event_date_accuracy, 
			PathologyEventDetail.path_number, 
			EventDetail.biopsy_pre_surgery_date, 
			EventDetail.biopsy_pre_surgery_date_accuracy
			FROM participants Participant
			LEFT JOIN event_masters EventMaster ON EventMaster.participant_id = Participant.id AND EventMaster.event_control_id = $diagnosis_event_control_id AND EventMaster.deleted <> 1
			LEFT JOIN $diagnosis_event_detail_tablename EventDetail ON EventDetail.event_master_id = EventMaster.id
			LEFT JOIN event_masters PathologyEventMaster ON PathologyEventMaster.participant_id = Participant.id AND PathologyEventMaster.event_control_id = $pathology_event_control_id AND PathologyEventMaster.deleted <> 1
			LEFT JOIN $pathology_event_detail_tablename PathologyEventDetail ON PathologyEventDetail.event_master_id = PathologyEventMaster.id
			WHERE Participant.deleted <> 1 AND ". implode(' AND ', $conditions);
		$data = array();
		$display_warning = false;
		foreach($participant_model->query($query) as $res) {
			$participant_id = $res['Participant']['id'];
			if(isset($data[$participant_id])) $display_warning = true;
			$data[$participant_id]['Participant'] = $res['Participant'];
			$data[$participant_id]['TreatmentMaster']['start_date'] = null;
			$data[$participant_id]['TreatmentMaster']['start_date_accuracy'] = null;
			$data[$participant_id]['EventMaster'] = $res['PathologyEventMaster'];
			$data[$participant_id]['EventDetail'] = array_merge($res['PathologyEventDetail'], $res['EventDetail']);	
			$data[$participant_id]['0'] = array(
				'procure_post_op_hormono' => '',
				'procure_post_op_chemo' => '',
				'procure_post_op_radio' => '',
				'procure_post_op_brachy' => '',
				'procure_pre_op_hormono' => '',
				'procure_pre_op_chemo' => '',
				'procure_pre_op_radio' => '',
				'procure_pre_op_brachy' => '',
			    'procure_CRPC' => '',
				'procure_inaccurate_date_use' => '',
				'procure_pre_op_psa_date' => '',
				'procure_pre_op_psa_date_accuracy' => '',
				'procure_first_bcr_date' => '',
				'procure_first_bcr_date_accuracy' => '',
				'procure_first_clinical_recurrence_date' => '',
				'procure_first_clinical_recurrence_date_accuracy' => '',
				'procure_first_clinical_recurrence_test' => '',
			    'procure_first_clinical_recurrence_site' => '',
				'procure_first_positive_exam_date' => '',
				'procure_first_positive_exam_date_accuracy' => '',
				'procure_first_positive_exam_test' => '',
			    'procure_first_positive_exam_site' => ''
			);
			$data[$participant_id]['EventDetail']['psa_total_ngml'] = '';
		}
		if(sizeof($data) > Configure::read('databrowser_and_report_results_display_limit')) {
			return array(
					'header' => null,
					'data' => null,
					'columns_names' => null,
					'error_msg' => 'the report contains too many results - please redefine search criteria');
		}
		if($display_warning) AppController::addWarningMsg('at least one participant is linked to more than one diagnosis or pathology worksheet'); 
		
		$participant_ids = array_keys($data);
		$inaccurate_date = false;
		
		//Analyze participants treatments
		$treatment_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
		$tx_join = array(
				'table' => $followup_treatment_detail_tablename,
				'alias' => 'TreatmentDetail',
				'type' => 'INNER',
				'conditions' => array('TreatmentDetail.treatment_master_id = TreatmentMaster.id'));
		//Get prostatectomy date
		$conditions = array(
				'TreatmentMaster.participant_id' => $participant_ids,
				'TreatmentMaster.treatment_control_id' => $followup_treatment_control_id,
				'TreatmentMaster.start_date IS NOT NULL',
				"TreatmentDetail.treatment_type" => 'surgery',
				"TreatmentDetail.surgery_type LIKE 'prostatectomy%'"
		); 
		$all_participants_prostatectomy = $treatment_model->find('all', array('conditions' => $conditions, 'joins' => array($tx_join), 'order' => array('TreatmentMaster.start_date ASC')));
		foreach($all_participants_prostatectomy as $new_prostatectomy) {
			$participant_id = $new_prostatectomy['TreatmentMaster']['participant_id'];
			if(!$data[$participant_id]['TreatmentMaster']['start_date']) {
				$data[$participant_id]['TreatmentMaster']['start_date'] = $new_prostatectomy['TreatmentMaster']['start_date'];
				$data[$participant_id]['TreatmentMaster']['start_date_accuracy'] = $new_prostatectomy['TreatmentMaster']['start_date_accuracy'];
			}
		}
		//Search Pre and Post Operative Treatments
		$conditions = array(
				'TreatmentMaster.participant_id' => $participant_ids,
				'TreatmentMaster.treatment_control_id' => $followup_treatment_control_id,
				'TreatmentMaster.start_date IS NOT NULL',
				'OR' => array("TreatmentDetail.treatment_type LIKE '%radiotherapy%'", "TreatmentDetail.treatment_type LIKE '%hormonotherapy%'", "TreatmentDetail.treatment_type LIKE '%chemotherapy%'", "TreatmentDetail.treatment_type LIKE '%brachytherapy%'"));
		$all_participants_treatment = $treatment_model->find('all', array('conditions' => $conditions, 'joins' => array($tx_join)));
		foreach($all_participants_treatment as $new_treatment) {
			$participant_id = $new_treatment['TreatmentMaster']['participant_id'];
			$prostatectomy_date = $data[$participant_id]['TreatmentMaster']['start_date'];
			$prostatectomy_date_accuracy = $data[$participant_id]['TreatmentMaster']['start_date_accuracy'];
			if($prostatectomy_date) {
				$administrated_treatment_types = array();
				if(preg_match('/chemotherapy/', $new_treatment['TreatmentDetail']['treatment_type'])) $administrated_treatment_types[] = 'chemo';
				if(preg_match('/hormonotherapy/', $new_treatment['TreatmentDetail']['treatment_type'])) $administrated_treatment_types[] = 'hormono';
				if(preg_match('/radiotherapy/', $new_treatment['TreatmentDetail']['treatment_type'])) $administrated_treatment_types[] = 'radio';
				if(preg_match('/brachytherapy/', $new_treatment['TreatmentDetail']['treatment_type'])) $administrated_treatment_types[] = 'brachy';
				if($administrated_treatment_types) {
					if($prostatectomy_date_accuracy != 'c' || $new_treatment['TreatmentMaster']['start_date_accuracy'] != 'c') {
						$inaccurate_date = true;
						$data[$participant_id][0]['procure_inaccurate_date_use'] = 'y';
					}
					if($new_treatment['TreatmentMaster']['start_date'] < $prostatectomy_date) {
						foreach($administrated_treatment_types as $tx_type) $data[$participant_id][0]['procure_pre_op_'.$tx_type] = 'y';
					} else if($new_treatment['TreatmentMaster']['start_date'] > $prostatectomy_date) {
						foreach($administrated_treatment_types as $tx_type) $data[$participant_id][0]['procure_post_op_'.$tx_type] = 'y';
					}
				}
			}
		}
		//Get CRPC
		$event_model = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
		$conditions = array(
            'EventMaster.participant_id' => $participant_ids, 
            'EventMaster.event_control_id' => $event_controls['clinical note']['id'], 
            'EventDetail.type' => 'CRPC');
		$ex_join = array(
		    'table' => $event_controls['clinical note']['detail_tablename'],
		    'alias' => 'EventDetail',
		    'type' => 'INNER',
		    'conditions' => array('EventDetail.event_master_id = EventMaster.id'));
		$all_participants_CRPC = $event_model->find('all', array('conditions' => $conditions, 'joins' => array($ex_join)));
		foreach($all_participants_CRPC as $new_CRPC) {
			$participant_id = $new_CRPC['EventMaster']['participant_id'];
			$data[$participant_id]['0']['procure_CRPC'] = 'y';
		}
		//Analyze participants psa
		$event_model = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
		$event_control_id = $event_controls['laboratory']['id'];
		$all_participants_psa = $event_model->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_ids, 'EventMaster.event_control_id' => $event_control_id, 'EventMaster.event_date IS NOT NULL'), 'order' => array('EventMaster.event_date ASC')));
		foreach($all_participants_psa as $new_psa) {
			$participant_id = $new_psa['EventMaster']['participant_id'];
			$prostatectomy_date = $data[$participant_id]['TreatmentMaster']['start_date'];
			$prostatectomy_date_accuracy = $data[$participant_id]['TreatmentMaster']['start_date_accuracy'];
			if($prostatectomy_date) {
				if($prostatectomy_date_accuracy != 'c' || $new_psa['EventMaster']['event_date_accuracy'] != 'c') {
					$inaccurate_date = true;
					$data[$participant_id][0]['procure_inaccurate_date_use'] = 'y';
				}
				if($new_psa['EventMaster']['event_date'] <= $prostatectomy_date) {
					//PSA pre-surgery
					$data[$participant_id]['0']['procure_pre_op_psa_date'] = $this->procureFormatDate($new_psa['EventMaster']['event_date'], $new_psa['EventMaster']['event_date_accuracy']);
					$data[$participant_id]['0']['procure_pre_op_psa_date_accuracy'] = $new_psa['EventMaster']['event_date_accuracy'];
					$data[$participant_id]['EventDetail']['psa_total_ngml'] = $new_psa['EventDetail']['psa_total_ngml'];
				}
				if($new_psa['EventDetail']['biochemical_relapse'] == 'y' && empty($data[$participant_id]['0']['procure_first_bcr_date'])) {
					//1st BCR
					$data[$participant_id]['0']['procure_first_bcr_date'] =  $this->procureFormatDate($new_psa['EventMaster']['event_date'], $new_psa['EventMaster']['event_date_accuracy']);
					$data[$participant_id]['0']['procure_first_bcr_date_accuracy'] =  $new_psa['EventMaster']['event_date_accuracy'];
				}
			}
		}
		
		//Analyze participants 1st clinical recurrence
		$event_control_id = $event_controls['clinical exam']['id'];
		$all_participants_test = $event_model->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_ids, 'EventMaster.event_control_id' => $event_control_id, 'EventMaster.event_date IS NOT NULL', 'OR' => array('EventDetail.clinical_relapse' => 'y', 'EventDetail.results' => 'positive')), 'order' => array('EventMaster.event_date ASC')));	
		foreach($all_participants_test as $new_test) {
			$participant_id = $new_test['EventMaster']['participant_id'];
			$prostatectomy_date = $data[$participant_id]['TreatmentMaster']['start_date'];
			$prostatectomy_date_accuracy = $data[$participant_id]['TreatmentMaster']['start_date_accuracy'];
			if($prostatectomy_date) {
				if($prostatectomy_date_accuracy != 'c' || $new_test['EventMaster']['event_date_accuracy'] != 'c') {
					$inaccurate_date = true;
					$data[$participant_id][0]['procure_inaccurate_date_use'] = 'y';
				}
				if($new_test['EventMaster']['event_date'] > $prostatectomy_date) {
				    if(empty($data[$participant_id]['0']['procure_first_clinical_recurrence_test']) && $new_test['EventDetail']['clinical_relapse'] == 'y') {
				        $data[$participant_id]['0']['procure_first_clinical_recurrence_date'] = $this->procureFormatDate($new_test['EventMaster']['event_date'], $new_test['EventMaster']['event_date_accuracy']);
    					$data[$participant_id]['0']['procure_first_clinical_recurrence_date_accuracy'] = $new_test['EventMaster']['event_date_accuracy'];
    					$data[$participant_id]['0']['procure_first_clinical_recurrence_test'] = $new_test['EventDetail']['type'];
    					$data[$participant_id]['0']['procure_first_clinical_recurrence_site'] = $new_test['EventDetail']['site_precision'];
				    }
				    if(empty($data[$participant_id]['0']['procure_first_positive_exam_test']) && $new_test['EventDetail']['results'] == 'positive') {
				        $data[$participant_id]['0']['procure_first_positive_exam_date'] = $this->procureFormatDate($new_test['EventMaster']['event_date'], $new_test['EventMaster']['event_date_accuracy']);
				        $data[$participant_id]['0']['procure_first_positive_exam_date_accuracy'] = $new_test['EventMaster']['event_date_accuracy'];
				        $data[$participant_id]['0']['procure_first_positive_exam_test'] = $new_test['EventDetail']['type'];
				        $data[$participant_id]['0']['procure_first_positive_exam_site'] = $new_test['EventDetail']['site_precision'];
				    }
				}
			}
		}
		
		if($inaccurate_date) AppController::addWarningMsg(__('at least one participant summary is based on inaccurate date'));
		
		if($display_exact_search_warning) AppController::addWarningMsg(__('all searches are considered as exact searches'));
		
		return array(
				'header' => $header,
				'data' => $data,
				'columns_names' => null,
				'error_msg' => null);
	}
	
	function procureFollowUpReports($parameters) {
		$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/TreatmentMasters/listall')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/EventMasters/listall')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/InventoryManagement/Collections/detail')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		$display_exact_search_warning = false;
		$header = null;
		$conditions = array('TRUE');
		if(isset($parameters['Participant']['id']) && !empty($parameters['Participant']['id'])) {
			//From databrowser
			$participant_ids  = array_filter($parameters['Participant']['id']);
			if($participant_ids) $conditions[] = "Participant.id IN ('".implode("','",$participant_ids)."')";
		} else if(isset($parameters['Participant']['participant_identifier_start'])) {
			$participant_identifier_start = (!empty($parameters['Participant']['participant_identifier_start']))? $parameters['Participant']['participant_identifier_start']: null;
			$participant_identifier_end = (!empty($parameters['Participant']['participant_identifier_end']))? $parameters['Participant']['participant_identifier_end']: null;
			if($participant_identifier_start) $conditions[] = "Participant.participant_identifier >= '$participant_identifier_start'";
			if($participant_identifier_end) $conditions[] = "Participant.participant_identifier <= '$participant_identifier_end'";
		} else if(isset($parameters['Participant']['participant_identifier'])) {
			$display_exact_search_warning = true;
			$participant_identifiers  = array_filter($parameters['Participant']['participant_identifier']);
			if($participant_identifiers) $conditions[] = "Participant.participant_identifier IN ('".implode("','",$participant_identifiers)."')";
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		if(isset($parameters['0']['procure_participant_identifier_prefix'])) {
			$procure_participant_identifier_prefix  = array_filter($parameters['0']['procure_participant_identifier_prefix']);
			if($procure_participant_identifier_prefix) {
				$prefix_conditions = array();
				foreach($procure_participant_identifier_prefix as $prefix) {
					if(!in_array($prefix, array('p','s'))) {
						$prefix_conditions[] = "Participant.participant_identifier LIKE 'PS$prefix%'";
					}
				}
				if($prefix_conditions) {
					$conditions[] = '('.implode(' OR ', $prefix_conditions).')';
				} else {
					$conditions[] =  "Participant.participant_identifier LIKE '-1'";
				}
			}
		}
		
		//Get Controls Data
		$participant_model = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$query = "SELECT id,event_type, detail_tablename FROM event_controls WHERE flag_active = 1;";
		$event_controls = array();
		foreach($participant_model->query($query) as $res) $event_controls[$res['event_controls']['event_type']] = array('id' => $res['event_controls']['id'], 'detail_tablename' => $res['event_controls']['detail_tablename']);
		$followup_event_control_id = $event_controls['visit - contact']['id'];
		$followup_event_detail_tablename = $event_controls['visit - contact']['detail_tablename'];
		if(!$followup_event_control_id) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);		
		$query = "SELECT id,tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1;";
		$tx_controls = array();
		foreach($participant_model->query($query) as $res) $tx_controls[$res['treatment_controls']['tx_method']] = array('id' => $res['treatment_controls']['id'], 'detail_tablename' => $res['treatment_controls']['detail_tablename']);
		$treatment_control_id = $tx_controls['treatment']['id'];
		$treatment_control_detail_tablename = $tx_controls['treatment']['detail_tablename'];
		$medication_treatment_control_id = $tx_controls['procure medication worksheet']['id'];
		$medication_treatment_control_detail_tablename = $tx_controls['procure medication worksheet']['detail_tablename'];
		$query = "SELECT id, detail_tablename, sample_type FROM sample_controls WHERE sample_type IN ('blood','urine', 'tissue');";
		$sample_controls = array();
		$blood_detail_tablename = '';
		foreach($participant_model->query($query) as $res) {
			$sample_controls[$res['sample_controls']['id']] = $res['sample_controls']['sample_type'];
			if($res['sample_controls']['sample_type'] == 'blood') $blood_detail_tablename = $res['sample_controls']['detail_tablename'];
		}
		
		$max_visit = 20;
		$empty_form_array = array(
			'procure_prostatectomy_date' => '',
			'procure_prostatectomy_date_accuracy' => '',
			'procure_last_collection_date' => '',
			'procure_last_collection_date_accuracy' => '',
			'procure_time_from_last_collection_months' => '',
			'procure_followup_worksheets_nbr' => array(),
			'procure_medication_worksheets_nbr' => array(),
			'procure_number_of_visit_with_collection' => array());
		for($tmp_visit_id = 1; $tmp_visit_id < $max_visit; $tmp_visit_id++) {
			$visit_id = (strlen($tmp_visit_id) == 1)? '0'.$tmp_visit_id : $tmp_visit_id;
			$empty_form_array["procure_".$visit_id."_followup_worksheet_date"]= null;
			$empty_form_array["procure_".$visit_id."_followup_worksheet_date_accuracy"]= null;
			$empty_form_array["procure_".$visit_id."_followup_worksheet_month"]= null;
			$empty_form_array["procure_".$visit_id."_medication_worksheet_date"]= null;
			$empty_form_array["procure_".$visit_id."_medication_worksheet_date_accuracy"]= null;
			$empty_form_array["procure_".$visit_id."_medication_worksheet_month"]= null;
			$empty_form_array["procure_".$visit_id."_first_collection_date"]= null;
			$empty_form_array["procure_".$visit_id."_first_collection_date_accuracy"]= null;
			$empty_form_array["procure_".$visit_id."_first_collection_month"]= null;
			$empty_form_array["procure_".$visit_id."_paxgene_collected"]= '';
			$empty_form_array["procure_".$visit_id."_serum_collected"]= '';
			$empty_form_array["procure_".$visit_id."_urine_collected"]= '';
			$empty_form_array["procure_".$visit_id."_k2_EDTA_collected"]= '';
			$empty_form_array["procure_".$visit_id."_tissue_collected"]= '';
		}
		
		//Get participants data + followup
		$query = "SELECT
			Participant.id,
			Participant.participant_identifier,
			EventMaster.procure_form_identification,
			EventMaster.event_date,
			EventMaster.event_date_accuracy
			FROM participants Participant
			LEFT JOIN event_masters EventMaster ON EventMaster.participant_id = Participant.id AND EventMaster.event_control_id = $followup_event_control_id AND EventMaster.deleted <> 1
			LEFT JOIN $followup_event_detail_tablename EventDetail ON EventDetail.event_master_id = EventMaster.id
			WHERE Participant.deleted <> 1 AND ". implode(' AND ', $conditions);
		$data = array();
		$display_warning_1 = false;
		$display_warning_2 = false;
		foreach($participant_model->query($query) as $res) {
			$participant_id = $res['Participant']['id'];
			if(!isset($data[$participant_id])) $data[$participant_id] = array(
				'Participant' => $res['Participant'], 
				'0' => $empty_form_array);
			$procure_form_identification = $res['EventMaster']['procure_form_identification'];
			if($procure_form_identification) {
				if(preg_match("/^PS[0-9]P0[0-9]+ V(([0])|(0[1-9])|(1[0-9])) -(FSP)[0-9]+$/", $procure_form_identification, $matches)) {
					$visit_id = $matches[1];
					if($visit_id != '0') {
						if(empty($data[$participant_id][0]["procure_".$visit_id."_followup_worksheet_date"])) {
							$data[$participant_id][0]["procure_".$visit_id."_followup_worksheet_date"] = $this->procureFormatDate($res['EventMaster']['event_date'], $res['EventMaster']['event_date_accuracy']);
							$data[$participant_id][0]["procure_".$visit_id."_followup_worksheet_date_accuracy"]= $res['EventMaster']['event_date_accuracy'];
							$data[$participant_id][0]['procure_followup_worksheets_nbr'][$visit_id] = '-';
						} else {
							$display_warning_1 = true;
						}
					}
				} else {
					$display_warning_2 = true;
				}
			}
		}
		if(sizeof($data) > Configure::read('databrowser_and_report_results_display_limit')) {
			return array(
					'header' => null,
					'data' => null,
					'columns_names' => null,
					'error_msg' => 'the report contains too many results - please redefine search criteria');
		}
		if($display_warning_1) AppController::addWarningMsg(__('at least one patient is linked to more than one followup worksheet for the same visit'));
		if($display_warning_2) AppController::addWarningMsg(__('at least one procure form identification format is not supported'));
		
		//Get medication
		$query = "SELECT
			TreatmentMaster.participant_id,
			TreatmentMaster.procure_form_identification,
			TreatmentMaster.start_date,
			TreatmentMaster.start_date_accuracy
			FROM treatment_masters TreatmentMaster 
			WHERE TreatmentMaster.deleted <> 1 AND TreatmentMaster.treatment_control_id = $medication_treatment_control_id AND TreatmentMaster.participant_id IN (".implode(',',array_keys($data)).")
			AND TreatmentMaster.start_date IS NOT NULL AND TreatmentMaster.start_date NOT LIKE ''
			ORDER BY TreatmentMaster.start_date ASC;";
		foreach($participant_model->query($query) as $res) {
			$participant_id = $res['TreatmentMaster']['participant_id'];
			$procure_form_identification = $res['TreatmentMaster']['procure_form_identification'];
			if($procure_form_identification) {
				if(preg_match("/^PS[0-9]P0[0-9]+ V(([0])|(0[1-9])|(1[0-9])) -(MED)[0-9]+$/", $procure_form_identification, $matches)) {
					$visit_id = $matches[1];
					if($visit_id != '0') {
						if(empty($data[$participant_id][0]["procure_".$visit_id."_medication_worksheet_date"])) {
								$data[$participant_id][0]["procure_".$visit_id."_medication_worksheet_date"] = $this->procureFormatDate($res['TreatmentMaster']['start_date'], $res['TreatmentMaster']['start_date_accuracy']);
								$data[$participant_id][0]["procure_".$visit_id."_medication_worksheet_date_accuracy"]= $res['TreatmentMaster']['start_date_accuracy'];
								$data[$participant_id][0]['procure_medication_worksheets_nbr'][$visit_id] = '-';
						}
					}
				}
			}
		}
		
		//Get prostatectomy
		if($data) {
			$query = "SELECT
				TreatmentMaster.participant_id,
				TreatmentMaster.start_date,
				TreatmentMaster.start_date_accuracy
				FROM treatment_masters TreatmentMaster 
				INNER JOIN $treatment_control_detail_tablename TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
				WHERE TreatmentMaster.deleted <> 1 AND TreatmentMaster.treatment_control_id = $treatment_control_id AND TreatmentMaster.participant_id IN (".implode(',',array_keys($data)).")
				AND TreatmentDetail.treatment_type = 'prostatectomy'
				AND TreatmentMaster.start_date IS NOT NULL AND TreatmentMaster.start_date NOT LIKE ''
				ORDER BY TreatmentMaster.start_date ASC;";
			foreach($participant_model->query($query) as $res) {
				$participant_id = $res['TreatmentMaster']['participant_id'];
				if(!strlen($data[$participant_id][0]["procure_prostatectomy_date"])) {
					$data[$participant_id][0]["procure_prostatectomy_date"] = $this->procureFormatDate($res['TreatmentMaster']['start_date'], $res['TreatmentMaster']['start_date_accuracy']);
					$data[$participant_id][0]["procure_prostatectomy_date_accuracy"] = $res['TreatmentMaster']['start_date_accuracy'];
				}
			}
		}
		
		//Get blood, urine and tissue
		if($data) {
			$query = "SELECT 
				Collection.participant_id,
				Collection.procure_visit,
				Collection.collection_datetime,
				Collection.collection_datetime_accuracy,
				SampleMaster.sample_control_id,
				SampleDetail.blood_type
				FROM collections Collection 
				INNER JOIN sample_masters AS SampleMaster ON SampleMaster.collection_id = Collection.id AND SampleMaster.deleted <> 1
				LEFT JOIN $blood_detail_tablename AS SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
				WHERE sample_control_id IN (".implode(',',array_keys($sample_controls)).")
				AND Collection.participant_id IN (".implode(',',array_keys($data)).");";
			foreach($participant_model->query($query) as $res) {
				$participant_id = $res['Collection']['participant_id'];
				$visit_id = str_replace('V','',$res['Collection']['procure_visit']);
				if(strlen($res['Collection']['collection_datetime'])) {
					$record_collection_date = false;
					if(!strlen($data[$participant_id][0]["procure_".$visit_id."_first_collection_date"])) {
						$record_collection_date = true;
					} else if($res['Collection']['collection_datetime'] < $data[$participant_id][0]["procure_".$visit_id."_first_collection_date"]) {
						$record_collection_date = true;
					}
					if($record_collection_date) {
						$first_collection_date_accuracy = $res['Collection']['collection_datetime_accuracy'];
						if(!in_array($first_collection_date_accuracy, array('y', 'm', 'd'))) $first_collection_date_accuracy = 'c';
						$res['Collection']['collection_datetime_accuracy'] = str_replace(array('h', 'i'), array('c','c'), $res['Collection']['collection_datetime_accuracy']);
						$data[$participant_id][0]["procure_".$visit_id."_first_collection_date"] = $this->procureFormatDate(substr($res['Collection']['collection_datetime'], 0, 10), $res['Collection']['collection_datetime_accuracy']);
						$data[$participant_id][0]["procure_".$visit_id."_first_collection_date_accuracy"] = $res['Collection']['collection_datetime_accuracy'];
						$data[$participant_id][0]['procure_number_of_visit_with_collection'][$visit_id] = '-';
					}
					if(empty($data[$participant_id][0]["procure_last_collection_date"]) || $data[$participant_id][0]["procure_last_collection_date"] < $res['Collection']['collection_datetime']) {
						$res['Collection']['collection_datetime_accuracy'] = str_replace(array('h', 'i'), array('c','c'), $res['Collection']['collection_datetime_accuracy']);
						$data[$participant_id][0]["procure_last_collection_date"] = $this->procureFormatDate(substr($res['Collection']['collection_datetime'], 0, 10), $res['Collection']['collection_datetime_accuracy']);
						$data[$participant_id][0]["procure_last_collection_date_accuracy"] = $res['Collection']['collection_datetime_accuracy'];
					}
				}				
				if($sample_controls[$res['SampleMaster']['sample_control_id']] == 'blood') {
					$sample_type = str_replace('k2-EDTA','k2_EDTA',$res['SampleDetail']['blood_type']);
				} else if($sample_controls[$res['SampleMaster']['sample_control_id']] == 'urine') {
					$sample_type = 'urine';
					} else if($sample_controls[$res['SampleMaster']['sample_control_id']] == 'tissue') {
					$sample_type = 'tissue';
				} else {
					$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				$data[$participant_id][0]["procure_".$visit_id."_".$sample_type."_collected"] = 'y';
			}
		}
		
		//Calculate last fields
		
		$months_strg = __('months');
		$query = "SELECT NOW() FROM users LIMIT 0,1;";
		$res = $participant_model->query($query);
		$current_date = $res[0][0]['NOW()'];
		foreach($data as $participant_id => &$participant_data){						
			if(!empty($participant_data[0]["procure_last_collection_date"])) {
				$current_date = substr($current_date, 0, 10);
				$procure_last_collection_date = substr($participant_data[0]["procure_last_collection_date"], 0, 10);
				$datetime1 = new DateTime($procure_last_collection_date);
				$datetime2 = new DateTime($current_date);
				$interval = $datetime1->diff($datetime2);
				$progression_time_in_months = (($interval->format('%y')*12) + $interval->format('%m'));
				if(!$interval->invert) $participant_data[0]["procure_time_from_last_collection_months"] = $progression_time_in_months;
			}
			$participant_data[0]['procure_followup_worksheets_nbr'] = sizeof($participant_data[0]['procure_followup_worksheets_nbr']);
			$participant_data[0]['procure_medication_worksheets_nbr'] = sizeof($participant_data[0]['procure_medication_worksheets_nbr']);
			$participant_data[0]['procure_number_of_visit_with_collection'] = sizeof($participant_data[0]['procure_number_of_visit_with_collection']);
			//Calculate spend time in month between visit and prostatectomy
			if($participant_data[0]['procure_prostatectomy_date']) {
				$strat_date = $participant_data[0]['procure_prostatectomy_date'];
				if(strlen($strat_date) == 4) {
					$strat_date .= '-06-01';
				} else if(strlen($strat_date) == 7) { 
					$strat_date .= '-01';
				}
				$prostatectomy_datetime = new DateTime($strat_date);
				for($tmp_visit_id = 1; $tmp_visit_id < $max_visit; $tmp_visit_id++) {
					$visit_id = (strlen($tmp_visit_id) == 1)? '0'.$tmp_visit_id : $tmp_visit_id;
					foreach(array('followup_worksheet', 'medication_worksheet', 'first_collection') as $sub_strg_field)
					if($participant_data[0]["procure_".$visit_id."_".$sub_strg_field."_date"]) {
						$accuracy = ($participant_data[0]['procure_prostatectomy_date_accuracy'].$participant_data[0]["procure_".$visit_id."_".$sub_strg_field."_date_accuracy"]!= 'cc')? '±' : '';
					$finish_date = $participant_data[0]["procure_".$visit_id."_".$sub_strg_field."_date"];
					if(strlen($finish_date) == 4) {
						$finish_date .= '-06-01';
					} else if(strlen($finish_date) == 7) {
						$finish_date .= '-01';
					}
					$visit_datetime = new DateTime($finish_date);
						$interval = $prostatectomy_datetime->diff($visit_datetime);
						$time_in_months = (($interval->format('%y')*12) + $interval->format('%m'));
						if(!$interval->invert) {
							$participant_data[0]["procure_".$visit_id."_".$sub_strg_field."_month"] = '('.$accuracy.$time_in_months.' '.$months_strg.')';
						} else {
							$participant_data[0]["procure_".$visit_id."_".$sub_strg_field."_month"] = '(-'.$time_in_months.' '.$months_strg.')';
						}
					}
				}
			}
		}
		
		if($display_exact_search_warning) AppController::addWarningMsg(__('all searches are considered as exact searches'));
		
		return array(
			'header' => $header,
			'data' => $data,
			'columns_names' => null,
			'error_msg' => null);
	}
	
	function procureAliquotsReports($parameters) {
		$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/InventoryManagement/Collections/detail')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		$display_exact_search_warning = false;
		$header = null;
		$conditions = array('TRUE');
		if(isset($parameters['Participant']['id']) && !empty($parameters['Participant']['id'])) {
			//From databrowser
			$participant_ids  = array_filter($parameters['Participant']['id']);
			if($participant_ids) $conditions[] = "Participant.id IN ('".implode("','",$participant_ids)."')";
		} else if(isset($parameters['Participant']['participant_identifier_start'])) {
			$participant_identifier_start = (!empty($parameters['Participant']['participant_identifier_start']))? $parameters['Participant']['participant_identifier_start']: null;
			$participant_identifier_end = (!empty($parameters['Participant']['participant_identifier_end']))? $parameters['Participant']['participant_identifier_end']: null;
			if($participant_identifier_start) $conditions[] = "Participant.participant_identifier >= '$participant_identifier_start'";
			if($participant_identifier_end) $conditions[] = "Participant.participant_identifier <= '$participant_identifier_end'";
		} else if(isset($parameters['Participant']['participant_identifier'])) {
			$display_exact_search_warning = true;
			$participant_identifiers  = array_filter($parameters['Participant']['participant_identifier']);
			if($participant_identifiers) $conditions[] = "Participant.participant_identifier IN ('".implode("','",$participant_identifiers)."')";
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		if(isset($parameters['0']['procure_participant_identifier_prefix'])) {
			$procure_participant_identifier_prefix  = array_filter($parameters['0']['procure_participant_identifier_prefix']);
			if($procure_participant_identifier_prefix) {
				$prefix_conditions = array();
				foreach($procure_participant_identifier_prefix as $prefix) {
					if(!in_array($prefix, array('p','s'))) {
						$prefix_conditions[] = "Participant.participant_identifier LIKE 'PS$prefix%'";
					}
				}
				if($prefix_conditions) {
					$conditions[] = '('.implode(' OR ', $prefix_conditions).')';
				} else {
					$conditions[] =  "Participant.participant_identifier LIKE '-1'";
				}
			}
		}
		
		//Get Controls Data
		$participant_model = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$query = "SELECT id, sample_type FROM sample_controls WHERE sample_type IN ('blood', 'serum', 'plasma', 'pbmc', 'buffy coat', 'centrifuged urine', 'tissue', 'rna', 'dna');";
		$sample_controls = array();
		foreach($participant_model->query($query) as $res) {
			$sample_controls[$res['sample_controls']['id']] = $res['sample_controls']['sample_type'];
		}
		$query = "SELECT id, sample_control_id, aliquot_type FROM aliquot_controls WHERE sample_control_id IN (".implode(',',array_keys($sample_controls)).") AND flag_active = 1;";
		$aliquotcontrols = array();
		foreach($participant_model->query($query) as $res) {
			$aliquotcontrols[$res['aliquot_controls']['id']] = $sample_controls[$res['aliquot_controls']['sample_control_id']].' '.$res['aliquot_controls']['aliquot_type'];
		}
		
		//Get participants data + aliquots count
		$query = "SELECT
			count(*) AS nbr_of_aliquots,
			Participant.id,
			Participant.participant_identifier,
			Collection.procure_visit,
			AliquotMaster.aliquot_control_id,
			AliquotMaster.in_stock,
			AliquotDetail.block_type,
			BloodDetail.blood_type
			FROM participants Participant
			INNER JOIN collections Collection ON Collection.participant_id = Participant.id
			INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id
			LEFT JOIN ad_blocks AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id
			LEFT JOIN sd_spe_bloods BloodDetail ON BloodDetail.sample_master_id = AliquotMaster.sample_master_id
			WHERE Participant.deleted <> 1 AND ". implode(' AND ', $conditions) ." 
			AND AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id IN (".implode(',',array_keys($aliquotcontrols)).")
			GROUP BY 
			Participant.id,
			Participant.participant_identifier,
			Collection.procure_visit,
			AliquotMaster.aliquot_control_id,
			AliquotDetail.block_type,
			BloodDetail.blood_type,
			AliquotMaster.in_stock";
		$empty_form_array = array();
		for($tmp_visit_id = 1; $tmp_visit_id < 20; $tmp_visit_id++) {
			$visit_id = (strlen($tmp_visit_id) == 1)? '0'.$tmp_visit_id : $tmp_visit_id;
			if($tmp_visit_id == 1) $empty_form_array["procure_".$visit_id."_FRZ"]= '';
			if($tmp_visit_id == 1) $empty_form_array["procure_".$visit_id."_Paraffin"]= '';
			$empty_form_array["procure_".$visit_id."_SER"]= '';
			$empty_form_array["procure_".$visit_id."_RNB"]= '';
			$empty_form_array["procure_".$visit_id."_PLA"]= '';
			$empty_form_array["procure_".$visit_id."_BFC"]= '';
			$empty_form_array["procure_".$visit_id."_WHT"]= '';
			$empty_form_array["procure_".$visit_id."_URN"]= '';
			$empty_form_array["procure_".$visit_id."_RNA"]= '';
			$empty_form_array["procure_".$visit_id."_DNA"]= '';
		}
		$data = array();
		foreach($participant_model->query($query) as $res) {
			$participant_id = $res['Participant']['id'];
			if(!isset($data[$participant_id])) $data[$participant_id] = array('Participant' => $res['Participant'], '0' => $empty_form_array);
			$report_aliquot_key = '';
			if(isset($aliquotcontrols[$res['AliquotMaster']['aliquot_control_id']])) {
				switch($aliquotcontrols[$res['AliquotMaster']['aliquot_control_id']]) {
					case 'tissue block':
						if($res['AliquotDetail']['block_type'] == 'frozen') {
							$report_aliquot_key = 'FRZ';
						} else if($res['AliquotDetail']['block_type'] == 'paraffin') {
							$report_aliquot_key = 'Paraffin';
						} 
						break;
					case 'blood tube':
						if($res['BloodDetail']['blood_type'] == 'paxgene') {
							$report_aliquot_key = 'RNB';
						}
						break;
					case 'serum tube':
						$report_aliquot_key = 'SER';
						break;
					case 'plasma tube':
						$report_aliquot_key = 'PLA';
						break;
					case 'pbmc':
						$report_aliquot_key = 'PBMC';
						break;
					case 'buffy coat tube':
						$report_aliquot_key = 'BFC';
						break;
					case 'blood whatman paper':
						$report_aliquot_key = 'WHT';
						break;
					case 'centrifuged urine tube':
						$report_aliquot_key = 'URN';
						break;
					case 'rna tube':
						$report_aliquot_key = 'RNA';
						break;
					case 'dna tube':
						$report_aliquot_key = 'DNA';
						break;
				}
			}
			if($report_aliquot_key) {
				$report_aliquot_key = "procure_".str_replace('V','',$res['Collection']['procure_visit'])."_$report_aliquot_key";
				$nbr_aliquot = ($res['AliquotMaster']['in_stock'] == 'no')? '0' : $res['0']['nbr_of_aliquots'];
				if(!strlen($data[$participant_id][0][$report_aliquot_key])) {
					$data[$participant_id][0][$report_aliquot_key] = $nbr_aliquot;
				} else {
					$data[$participant_id][0][$report_aliquot_key] += $nbr_aliquot;
				}				
			}
		}
		if(sizeof($data) > Configure::read('databrowser_and_report_results_display_limit')) {
			return array(
				'header' => null,
				'data' => null,
				'columns_names' => null,
				'error_msg' => 'the report contains too many results - please redefine search criteria');
		}
		
		if($display_exact_search_warning) AppController::addWarningMsg(__('all searches are considered as exact searches'));
		
		return array(
			'header' => $header,
			'data' => $data,
			'columns_names' => null,
			'error_msg' => null);
	}
	
	function procureBcrDetection($parameters) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/TreatmentMasters/listall')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/EventMasters/listall')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		$display_exact_search_warning = false;
		$header = null;
		$conditions = array('TRUE');
		if(isset($parameters['Participant']['id']) && !empty($parameters['Participant']['id'])) {
			//From databrowser
			$participant_ids  = array_filter($parameters['Participant']['id']);
			if($participant_ids) $conditions[] = "Participant.id IN ('".implode("','",$participant_ids)."')";
		} else if(isset($parameters['Participant']['participant_identifier_start'])) {
			$participant_identifier_start = (!empty($parameters['Participant']['participant_identifier_start']))? $parameters['Participant']['participant_identifier_start']: null;
			$participant_identifier_end = (!empty($parameters['Participant']['participant_identifier_end']))? $parameters['Participant']['participant_identifier_end']: null;
			if($participant_identifier_start) $conditions[] = "Participant.participant_identifier >= '$participant_identifier_start'";
			if($participant_identifier_end) $conditions[] = "Participant.participant_identifier <= '$participant_identifier_end'";
		} else if(isset($parameters['Participant']['participant_identifier'])) {
			$display_exact_search_warning = true;
			$participant_identifiers  = array_filter($parameters['Participant']['participant_identifier']);
			if($participant_identifiers) $conditions[] = "Participant.participant_identifier IN ('".implode("','",$participant_identifiers)."')";
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		if(isset($parameters['0']['procure_participant_identifier_prefix'])) {
			$procure_participant_identifier_prefix  = array_filter($parameters['0']['procure_participant_identifier_prefix']);
			if($procure_participant_identifier_prefix) {
				$prefix_conditions = array();
				foreach($procure_participant_identifier_prefix as $prefix) {
					if(!in_array($prefix, array('p','s'))) {
						$prefix_conditions[] = "Participant.participant_identifier LIKE 'PS$prefix%'";
					}
				}
				if($prefix_conditions) {
					$conditions[] = '('.implode(' OR ', $prefix_conditions).')';
				} else {
					$conditions[] =  "Participant.participant_identifier LIKE '-1'";
				}
			}
		}
		
		$procure_psa_level = 0.2;
		if(isset($parameters['0']['procure_psa_level']['0']) && $parameters['0']['procure_psa_level']['0']) {
			$parameters['0']['procure_psa_level']['0'] = str_replace(',','.', $parameters['0']['procure_psa_level']['0']);
			if(!preg_match('/^([0-9]+(\.[0-9]*){0,1}){0,1}$/', $parameters['0']['procure_psa_level']['0'])) {
				return array(
					'header' => null,
					'data' => null,
					'columns_names' => null,
					'error_msg' => 'wrong procure_psa_level value');
			}
			$procure_psa_level = $parameters['0']['procure_psa_level']['0'];
		}
		$procure_nbr_of_succesive_psa = 2;
		if(isset($parameters['0']['procure_nbr_of_succesive_psa']['0']) && $parameters['0']['procure_nbr_of_succesive_psa']['0']) {
			$procure_nbr_of_succesive_psa = $parameters['0']['procure_nbr_of_succesive_psa']['0'];
		}
		
		$header = array('title' => __('report parameters'),
			'description' => __('psa level').' : '.$procure_psa_level.' ng/ml & '.__('number of successive PSA').' : '.$procure_nbr_of_succesive_psa);
		
		//Get Controls Data
		$participant_model = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$query = "SELECT id,event_type, detail_tablename FROM event_controls WHERE flag_active = 1;";
		$event_controls = array();
		foreach($participant_model->query($query) as $res) $event_controls[$res['event_controls']['event_type']] = array('id' => $res['event_controls']['id'], 'detail_tablename' => $res['event_controls']['detail_tablename']);
		$query = "SELECT id,tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1;";
		$tx_controls = array();
		foreach($participant_model->query($query) as $res) {
			$tx_controls[$res['treatment_controls']['tx_method']] = array('id' => $res['treatment_controls']['id'], 'detail_tablename' => $res['treatment_controls']['detail_tablename']);
		}
		
		$followup_treatment_control_id = $tx_controls['treatment']['id'];
		$followup_treatment_detail_tablename = $tx_controls['treatment']['detail_tablename'];
		
		//Get participants data
		$query = "SELECT
			Participant.id,
			Participant.participant_identifier
			FROM participants Participant
			WHERE Participant.deleted <> 1 AND ". implode(' AND ', $conditions);
		$data = array();
		foreach($participant_model->query($query) as $res) {
			$participant_id = $res['Participant']['id'];
			$data[$participant_id]['Participant'] = $res['Participant'];
			$data[$participant_id]['TreatmentMaster']['start_date'] = null;
			$data[$participant_id]['TreatmentMaster']['start_date_accuracy'] = null;
			$data[$participant_id]['0'] = array(
				'procure_inaccurate_date_use' => '',
				'procure_detected_pre_bcr_psa' => '',
				'procure_detected_pre_bcr_psa_date' => '',
				'procure_detected_pre_bcr_psa_date_accuracy' => '',
				'procure_detected_bcr_psa' => '',
				'procure_detected_bcr_psa_date' => '',
				'procure_detected_bcr_psa_date_accuracy' => '',
				'procure_detected_post_bcr_psa' => '',
				'procure_detected_post_bcr_psa_date' => '',
				'procure_detected_post_bcr_psa_date_accuracy' => '',
				'procure_atim_bcr_psa' => '',
				'procure_atim_bcr_psa_date' => '',
				'procure_atim_bcr_psa_date_accuracy' => '',
				'procure_detected_bcr_conclusion' => 'n/a'
			);
			$data[$participant_id]['tmp_all_psa'] = array();
		}
		if(sizeof($data) > Configure::read('databrowser_and_report_results_display_limit')) {
		return array(
			'header' => null,
			'data' => null,
				'columns_names' => null,
				'error_msg' => 'the report contains too many results - please redefine search criteria');
		}
		
		$participant_ids = array_keys($data);
		$inaccurate_date = false;
		
		//Analyze participants treatments
		$treatment_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
		$tx_join = array(
			'table' => $followup_treatment_detail_tablename,
			'alias' => 'TreatmentDetail',
			'type' => 'INNER',
			'conditions' => array('TreatmentDetail.treatment_master_id = TreatmentMaster.id'));
		//Get prostatectomy date
		$conditions = array(
			'TreatmentMaster.participant_id' => $participant_ids,
			'TreatmentMaster.treatment_control_id' => $followup_treatment_control_id,
			'TreatmentMaster.start_date IS NOT NULL',
			"TreatmentDetail.treatment_type" => 'surgery',
			"TreatmentDetail.surgery_type LIKE 'prostatectomy%'"
		);
		$all_participants_prostatectomy = $treatment_model->find('all', array('conditions' => $conditions, 'joins' => array($tx_join), 'order' => array('TreatmentMaster.start_date ASC')));		
		foreach($all_participants_prostatectomy as $new_prostatectomy) {
			$participant_id = $new_prostatectomy['TreatmentMaster']['participant_id'];
			if(!$data[$participant_id]['TreatmentMaster']['start_date']) {
				$data[$participant_id]['TreatmentMaster']['start_date'] = $new_prostatectomy['TreatmentMaster']['start_date'];
				$data[$participant_id]['TreatmentMaster']['start_date_accuracy'] = $new_prostatectomy['TreatmentMaster']['start_date_accuracy'];
			}
		}
		
		//Analyze participants psa
		$event_model = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
		$event_control_id = $event_controls['laboratory']['id'];
		$all_participants_psa = $event_model->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_ids, 'EventMaster.event_control_id' => $event_control_id, 'EventMaster.event_date IS NOT NULL'), 'order' => array('EventMaster.event_date ASC')));
		foreach($all_participants_psa as $new_psa) {
			$participant_id = $new_psa['EventMaster']['participant_id'];
			$prostatectomy_date = $data[$participant_id]['TreatmentMaster']['start_date'];
			$prostatectomy_date_accuracy = $data[$participant_id]['TreatmentMaster']['start_date_accuracy'];
			if($prostatectomy_date && $new_psa['EventMaster']['event_date'] > $prostatectomy_date) {
				//Check ATiM BCR
				if($new_psa['EventDetail']['biochemical_relapse'] == 'y' && !strlen($data[$participant_id]['0']['procure_atim_bcr_psa'])) {
					$data[$participant_id]['0']['procure_atim_bcr_psa'] = $new_psa['EventDetail']['psa_total_ngml'];
					$data[$participant_id]['0']['procure_atim_bcr_psa_date'] = $this->procureFormatDate($new_psa['EventMaster']['event_date'], $new_psa['EventMaster']['event_date_accuracy']);
					$data[$participant_id]['0']['procure_atim_bcr_psa_date_accuracy'] = $new_psa['EventMaster']['event_date_accuracy'];
					$this->procureSetBcrDetectionCcl($data[$participant_id]['0']);
				}
				//Work on BCR detection
				if($prostatectomy_date_accuracy != 'c' || $new_psa['EventMaster']['event_date_accuracy'] != 'c') {
					$inaccurate_date = true;
					$data[$participant_id][0]['procure_inaccurate_date_use'] = 'y';
				}
				array_unshift($data[$participant_id]['tmp_all_psa'], array($new_psa['EventDetail']['psa_total_ngml'], $this->procureFormatDate($new_psa['EventMaster']['event_date'], $new_psa['EventMaster']['event_date_accuracy']), $new_psa['EventMaster']['event_date_accuracy']));
				switch($procure_nbr_of_succesive_psa) {
					case '1':
						if(!strlen($data[$participant_id]['0']['procure_detected_bcr_psa'])) {
							if($data[$participant_id]['tmp_all_psa']['0']['0'] >= $procure_psa_level) {
								//BCR
								list($data[$participant_id]['0']['procure_detected_bcr_psa'], $data[$participant_id]['0']['procure_detected_bcr_psa_date'], $data[$participant_id]['0']['procure_detected_bcr_psa_date_accuracy']) = $data[$participant_id]['tmp_all_psa']['0'];
								$this->procureSetBcrDetectionCcl($data[$participant_id]['0']);
								//Pre BCR
								if(isset($data[$participant_id]['tmp_all_psa']['1'])) list($data[$participant_id]['0']['procure_detected_pre_bcr_psa'], $data[$participant_id]['0']['procure_detected_pre_bcr_psa_date'], $data[$participant_id]['0']['procure_detected_pre_bcr_psa_date_accuracy']) = $data[$participant_id]['tmp_all_psa']['1'];
							}
						} else {
							if(!strlen($data[$participant_id]['0']['procure_detected_post_bcr_psa'])) {
								//Post BCR
								list($data[$participant_id]['0']['procure_detected_post_bcr_psa'], $data[$participant_id]['0']['procure_detected_post_bcr_psa_date'], $data[$participant_id]['0']['procure_detected_post_bcr_psa_date_accuracy']) = $data[$participant_id]['tmp_all_psa']['0'];
							}
						}
						break;
					case '2':
						if(sizeof($data[$participant_id]['tmp_all_psa']) > 1) {
							if(!strlen($data[$participant_id]['0']['procure_detected_bcr_psa'])) {
								if($data[$participant_id]['tmp_all_psa']['0']['0'] >= $procure_psa_level && $data[$participant_id]['tmp_all_psa']['1']['0'] >= $procure_psa_level) {
									//Pre BCR
									if(sizeof($data[$participant_id]['tmp_all_psa']) > 2) list($data[$participant_id]['0']['procure_detected_pre_bcr_psa'], $data[$participant_id]['0']['procure_detected_pre_bcr_psa_date'], $data[$participant_id]['0']['procure_detected_pre_bcr_psa_date_accuracy']) = $data[$participant_id]['tmp_all_psa']['2'];
									//BCR
									list($data[$participant_id]['0']['procure_detected_bcr_psa'], $data[$participant_id]['0']['procure_detected_bcr_psa_date'], $data[$participant_id]['0']['procure_detected_bcr_psa_date_accuracy']) = $data[$participant_id]['tmp_all_psa']['1'];
									$this->procureSetBcrDetectionCcl($data[$participant_id]['0']);
									//Post BCR
									list($data[$participant_id]['0']['procure_detected_post_bcr_psa'], $data[$participant_id]['0']['procure_detected_post_bcr_psa_date'], $data[$participant_id]['0']['procure_detected_post_bcr_psa_date_accuracy']) = $data[$participant_id]['tmp_all_psa']['0'];
								}
							}								
						}
						break;
					default:
						$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
			} else if($new_psa['EventDetail']['biochemical_relapse'] == 'y' && !strlen($data[$participant_id]['0']['procure_atim_bcr_psa'])) {
				//No prostatectomy or BCR flagged before prostatectomy date
				$data[$participant_id]['0']['procure_atim_bcr_psa'] = $new_psa['EventDetail']['psa_total_ngml'];
				$data[$participant_id]['0']['procure_atim_bcr_psa_date'] = $this->procureFormatDate($new_psa['EventMaster']['event_date'], $new_psa['EventMaster']['event_date_accuracy']);
				$data[$participant_id]['0']['procure_atim_bcr_psa_date_accuracy'] = $new_psa['EventMaster']['event_date_accuracy'];
				$this->procureSetBcrDetectionCcl($data[$participant_id]['0']);
			}
		}
	
		if($inaccurate_date) AppController::addWarningMsg(__('at least one participant summary is based on inaccurate date'));
		
		if($display_exact_search_warning) AppController::addWarningMsg(__('all searches are considered as exact searches'));
		
		return array(
			'header' => $header,
			'data' => $data,
			'columns_names' => null,
			'error_msg' => null);
	}
	
	function procureSetBcrDetectionCcl(&$bcr_participant_data) {
		if(!strlen($bcr_participant_data['procure_detected_bcr_psa'].$bcr_participant_data['procure_atim_bcr_psa'])) {
			$bcr_participant_data['procure_detected_bcr_conclusion'] = 'n/a';
		} else if($bcr_participant_data['procure_detected_bcr_psa'] == $bcr_participant_data['procure_atim_bcr_psa'] 
		&& $bcr_participant_data['procure_detected_bcr_psa_date'] == $bcr_participant_data['procure_atim_bcr_psa_date']
		&& $bcr_participant_data['procure_detected_bcr_psa_date_accuracy'] == $bcr_participant_data['procure_atim_bcr_psa_date_accuracy']) {
			$bcr_participant_data['procure_detected_bcr_conclusion'] = 'identical';
		} else {
			$bcr_participant_data['procure_detected_bcr_conclusion'] = 'different';
		}
	}
	
	function procureNextFollowupReport($parameters) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/TreatmentMasters/listall')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/EventMasters/listall')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
	
		$display_exact_search_warning = false;
		$header = null;
		$conditions = array('TRUE');
		if(isset($parameters['Participant']['id']) && !empty($parameters['Participant']['id'])) {
			//From databrowser
			$participant_ids  = array_filter($parameters['Participant']['id']);
			if($participant_ids) $conditions[] = "Participant.id IN ('".implode("','",$participant_ids)."')";
		} else if(isset($parameters['Participant']['participant_identifier_start'])) {
			$participant_identifier_start = (!empty($parameters['Participant']['participant_identifier_start']))? $parameters['Participant']['participant_identifier_start']: null;
			$participant_identifier_end = (!empty($parameters['Participant']['participant_identifier_end']))? $parameters['Participant']['participant_identifier_end']: null;
			if($participant_identifier_start) $conditions[] = "Participant.participant_identifier >= '$participant_identifier_start'";
			if($participant_identifier_end) $conditions[] = "Participant.participant_identifier <= '$participant_identifier_end'";
		} else if(isset($parameters['Participant']['participant_identifier'])) {
			$display_exact_search_warning = true;
			$participant_identifiers  = array_filter($parameters['Participant']['participant_identifier']);
			if($participant_identifiers) $conditions[] = "Participant.participant_identifier IN ('".implode("','",$participant_identifiers)."')";
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$last_record_nbr = 3;
		
		$participant_model = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$misc_identifier_model = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
		$treatment_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
		$event_model = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
		$drug_model = AppModel::getInstance("Drug", "Drug", true);
		$flag_show_confidential = $this->Session->read('flag_show_confidential');
		$StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
		
		App::uses('StructureValueDomain', 'Model');
		$this->StructureValueDomain = new StructureValueDomain();
		$procure_other_tumor_sites = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'procure_other_tumor_sites'), 'recursive' => 2));
		$procure_other_tumor_sites_values = array();
		if($procure_other_tumor_sites) {
		    foreach($procure_other_tumor_sites['StructurePermissibleValue'] as $new_value) {
		        $procure_other_tumor_sites_values[$new_value['value']] = __($new_value['language_alias']);
		    }
		}
		$procure_other_tumor_sites_values[''] = '';
		
		$procure_followup_clinical_methods = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'procure_followup_clinical_methods'), 'recursive' => 2));
		$procure_followup_clinical_methods_values = array();
		if($procure_followup_clinical_methods) {
		    foreach($procure_followup_clinical_methods['StructurePermissibleValue'] as $new_value) {
		        $procure_followup_clinical_methods_values[$new_value['value']] = __($new_value['language_alias']);
		    }
		}
		$procure_followup_clinical_methods_values[''] = '';
		
		$query = "SELECT id,event_type, detail_tablename FROM event_controls WHERE flag_active = 1;";
		$event_controls = array();
		foreach($participant_model->query($query) as $res) $event_controls[$res['event_controls']['event_type']] = array('id' => $res['event_controls']['id'], 'detail_tablename' => $res['event_controls']['detail_tablename']);
		$query = "SELECT id,tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1;";
		$tx_controls = array();
		foreach($participant_model->query($query) as $res) {
			$tx_controls[$res['treatment_controls']['tx_method']] = array('id' => $res['treatment_controls']['id'], 'detail_tablename' => $res['treatment_controls']['detail_tablename']);
		}
		
		//Get participants data
		$query = "SELECT
			Participant.id,
			Participant.participant_identifier,
			Participant.first_name,
			Participant.last_name,
			Participant.date_of_birth,
			Participant.date_of_birth_accuracy
			FROM participants Participant
			WHERE Participant.deleted <> 1 AND ". implode(' AND ', $conditions);
		$participant_data = $participant_model->query($query);
		if(sizeof($participant_data) > 10) {
			return array(
					'header' => null,
					'data' => null,
					'columns_names' => null,
					'error_msg' => 'the report contains too many results - please redefine search criteria');
		}
		
		$data = array();
		$is_first_participant = true;
		foreach($participant_data as $new_participant) {
		    if(!$is_first_participant) {
		        //*** Separate participants ***
                for($tmp=1;$tmp<4;$tmp++) {
                    $data[] = $record_template;
                }
		    }
		    $is_first_participant = false;
		    
		    $new_participant_id = $new_participant['Participant']['id'];
			$record_template = array(
				'0' => array(
					'procure_next_followup_data' => '', 
					'procure_next_followup_value' => '', 
					'procure_next_followup_date' => '', 
					'procure_next_followup_finish_date' => ''));
			
			//*** Patient Profile ***
			
			$new_data = $record_template;
			$new_data['0']['procure_next_followup_data'] = '# PROCURE';
			$new_data['0']['procure_next_followup_value'] = $new_participant['Participant']['participant_identifier'];
			$new_data['0']['procure_next_followup_date'] = '';
			$new_data['0']['procure_next_followup_finish_date'] = '';
			$data[] = $new_data;
			
			if($flag_show_confidential) {
			    $new_data = $record_template;
			    $new_data['0']['procure_next_followup_data'] = __('name');
                $new_data['0']['procure_next_followup_value'] = $new_participant['Participant']['first_name'].' '.$new_participant['Participant']['last_name'];
                $data[] = $new_data;
                $new_data = $record_template;
			    $new_data['0']['procure_next_followup_data'] = __('date of birth');
			    $new_data['0']['procure_next_followup_value'] = $this->procureFormatDate($new_participant['Participant']['date_of_birth'], $new_participant['Participant']['date_of_birth_accuracy']);
				$data[] = $new_data;
			}
			
			
			//*** Patient Identifiers ***
			
			foreach($misc_identifier_model->find('all', array('conditions' => array('MiscIdentifier.participant_id' => $new_participant_id, 'MiscIdentifierControl.misc_identifier_name' => array('hospital number', 'ramq')))) as $new_identifier) {
				$new_data = $record_template;
				$new_data['0']['procure_next_followup_data'] = __($new_identifier['MiscIdentifierControl']['misc_identifier_name']);
				$new_data['0']['procure_next_followup_value'] = (!$flag_show_confidential && $new_identifier['MiscIdentifierControl']['flag_confidential'])? CONFIDENTIAL_MARKER  : $new_identifier['MiscIdentifier']['identifier_value'];
				$data[] = $new_data;
			}
			
			//*** Last visit ***
			
			$new_data = $record_template;
			$new_data['0']['procure_next_followup_data'] = __('last visit');
			$last_data = $event_model->find('first', array('conditions' => array('EventMaster.participant_id' => $new_participant_id, 'EventControl.event_type' => 'visit/contact'), 'order' => 'EventMaster.event_date DESC'));	
			if(!$last_data) {
				$new_data['0']['procure_next_followup_value'] = __('none');
			} else {
			    $last_visit_date = $this->procureFormatDate($last_data['EventMaster']['event_date'], $last_data['EventMaster']['event_date_accuracy']);
			    $last_visit_date = $last_visit_date? $last_visit_date : __('unknown');
			    $last_visit_method = $last_data['EventDetail']['method']? ' ('.$procure_followup_clinical_methods_values[$last_data['EventDetail']['method']].')' : '';
				$new_data['0']['procure_next_followup_value'] = $last_visit_date.$last_visit_method;
			}
			$data[] = $new_data;
			
			//*** Collection data for new visit ***
			
			$data_for_new_visit = array(
			     array(
			        'procure_next_followup_data' => __('visit date'),
			        'procure_next_followup_value' => ' ______ / ___ / ___'),
			     array(
			        'procure_next_followup_data' => __('blood collection'),
			        'procure_next_followup_value' => __('time').' ___ : ___'),
			      array(
			        'procure_next_followup_data' => '',
			        'procure_next_followup_value' => __('collected by').' _____________________'),
			     array(
			        'procure_next_followup_value' => __('serum').' ('.__('yellow').') ___ --- '.__('EDTA').' ('.__('purple').') ___  --- '.__('paxgene').' ('.__('brown').') ___'),
			     array(
			        'procure_next_followup_data' => __('urine collection'),
			        'procure_next_followup_value' => __('time').' ___ : ___'),
			      array(
			        'procure_next_followup_data' => '',
			        'procure_next_followup_value' => __('collected volume').' (ml) ___'),
			     array(
			        'procure_next_followup_value' => __('aspect at reception').' : '.__('clear').' [ _ ] --- '.__('turbidity').' [ _ ] --- '.__('other').' [ _ ] '.__('precision').' _____________________'),
			     array(
			        'procure_next_followup_value' => __('hematuria').' : '.__('yes').' [ _ ] / '.__('no').' [ _ ]'),
			     array(
			        'procure_next_followup_value' => __('urine was collected via a urinary catheter').' : '.__('yes').' [ _ ] / '.__('no').' [ _ ]')
			);
			foreach($data_for_new_visit as $tmp_new_line_data) {
			    $data[]['0'] = array_merge($record_template['0'], $tmp_new_line_data);
			}
			
			//*** Line Separator ***
			
			//*** Prostatectomy ***
				
			$tx_join = array(
			    'table' => $tx_controls['treatment']['detail_tablename'],
			    'alias' => 'TreatmentDetail',
			    'type' => 'INNER',
			    'conditions' => array('TreatmentDetail.treatment_master_id = TreatmentMaster.id'));
			$prostatectomy_data = $treatment_model->find('first', array(
			    'conditions' => array(
                    'TreatmentMaster.participant_id' => $new_participant_id, 
			        'TreatmentControl.tx_method' => 'treatment', 
                    'TreatmentDetail.surgery_type' => 'prostatectomy'), 
			    'order' => 'TreatmentMaster.start_date ASC',
			    'joins' => array($tx_join)));
			$new_data = $record_template;
			$new_data['0']['procure_next_followup_data'] = __('prostatectomy');
			if($prostatectomy_data) {
			    if(empty($prostatectomy_data['TreatmentMaster']['start_date'])) {
			        $new_data['0']['procure_next_followup_value'] = __('date').' : '.__('unknown');
			    } else {
			        $new_data['0']['procure_next_followup_date'] = $this->procureFormatDate($prostatectomy_data['TreatmentMaster']['start_date'], $prostatectomy_data['TreatmentMaster']['start_date_accuracy']);
			        $datetime1 = new DateTime($prostatectomy_data['TreatmentMaster']['start_date']);
			        $datetime2 = new DateTime(date("Y-m-d"));
			        $interval = $datetime1->diff($datetime2);
			        if(!$interval->invert) {
			            $new_data['0']['procure_next_followup_value'] = __('time past (months)').' : '.(($interval->format('%y')*12) + $interval->format('%m'));
			            if($prostatectomy_data['TreatmentMaster']['start_date_accuracy'] != 'c') $new_data['0']['procure_next_followup_value'] .= ' ('.__('inaccurate date use').')';
			        }
			    }
			} else {
			    $new_data['0']['procure_next_followup_value'] = __('none');
			}
			$data[] = $new_data;
			
			//*** CRPC***
			
			$new_data = $record_template;
			$new_data['0']['procure_next_followup_data'] = __('CRPC');
			$ev_join = array(
			    'table' => $event_controls['clinical note']['detail_tablename'],
			    'alias' => 'EventDetail',
			    'type' => 'INNER',
			    'conditions' => array('EventDetail.event_master_id = EventMaster.id'));
			$last_data = $event_model->find('first', array(
			    'conditions' => array('EventMaster.participant_id' => $new_participant_id, 'EventControl.event_type' => 'clinical note', 'EventDetail.type' => 'CRPC'),
			    'joins' => array($ev_join)));
			$new_data['0']['procure_next_followup_value'] = (!$last_data)? __('no') : __('yes');
			$data[] = $new_data;
				
			//*** Clinical Relapse ***
			
			$ev_join = array(
			    'table' => $event_controls['clinical exam']['detail_tablename'],
			    'alias' => 'EventDetail',
			    'type' => 'INNER',
			    'conditions' => array('EventDetail.event_master_id = EventMaster.id'));
			$all_atim_data = $event_model->find('all', array(
			    'conditions' => array(
			        'EventMaster.participant_id' => $new_participant_id,
			        'EventControl.event_type' => 'clinical exam',
                    "EventDetail.clinical_relapse = 'y'"),
			    'joins' => array($ev_join)));
			$new_data = $record_template;
			$new_data['0']['procure_next_followup_data'] = __('clinical relapse');
			if(!$all_atim_data) {
			    $new_data['0']['procure_next_followup_value'] = __('none');
                $data[] = $new_data;
			} else {
			    $all_clinical_relapses = array();
			    foreach($all_atim_data as $atim_data) {
			        $progression_comorbidity = $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Progressions & Comorbidities (PROCURE values only)', $atim_data['EventDetail']['progression_comorbidity']);
			        $event_date = $this->procureFormatDate($atim_data['EventMaster']['event_date'], $atim_data['EventMaster']['event_date_accuracy']);
			        if($progression_comorbidity || $event_date) {
			            $all_clinical_relapses[$event_date.'-'.$progression_comorbidity] = array(($progression_comorbidity? $progression_comorbidity : __('undefined')), $event_date);
			        }
			    }
			    if(empty($all_clinical_relapses)) {
			        $new_data['0']['procure_next_followup_value'] = __('yes').' - '.__('undefined');
			        $data[] = $new_data;
			    } else {
			        krsort($all_clinical_relapses);
			        foreach($all_clinical_relapses as $clinical_relapse) {
			            list($new_data['0']['procure_next_followup_value'], $new_data['0']['procure_next_followup_date']) = $clinical_relapse;
			            $data[] = $new_data;
			            $new_data['0']['procure_next_followup_data'] = '';
			        }
			    }
			}
			
			//*** Biochemical Relapse ***
				
			$ev_join = array(
			    'table' => $event_controls['laboratory']['detail_tablename'],
			    'alias' => 'EventDetail',
			    'type' => 'INNER',
			    'conditions' => array('EventDetail.event_master_id = EventMaster.id'));
			$all_atim_data = $event_model->find('all', array(
			    'conditions' => array(
			        'EventMaster.participant_id' => $new_participant_id,
			        'EventControl.event_type' => 'laboratory',
                    "EventDetail.biochemical_relapse = 'y'"),
			    'joins' => array($ev_join)));
			$new_data = $record_template;
			$new_data['0']['procure_next_followup_data'] = __('biochemical relapse');
			if(!$all_atim_data) {
			    $new_data['0']['procure_next_followup_value'] = __('none');
			    $data[] = $new_data;
			} else {
			    $all_biochemical_relapses = array();
			    foreach($all_atim_data as $atim_data) {
                    $psa = strlen($atim_data['EventDetail']['psa_total_ngml'])? $atim_data['EventDetail']['psa_total_ngml'].' (ng/ml)' : ''; 
                    $event_date = $this->procureFormatDate($atim_data['EventMaster']['event_date'], $atim_data['EventMaster']['event_date_accuracy']);
			        if($event_date || strlen($psa)) {
			            $all_biochemical_relapses[$event_date.'-'.$psa] = array((strlen($psa)? $psa : __('undefined')), $event_date);
			        }
			    }
			    if(empty($all_biochemical_relapses)) {
			        $new_data['0']['procure_next_followup_value'] = __('yes').' - '.__('undefined');
			        $data[] = $new_data;
			    } else {
			        ksort($all_biochemical_relapses);
			        foreach($all_biochemical_relapses as $biochemical_relapse) {
			            list($new_data['0']['procure_next_followup_value'], $new_data['0']['procure_next_followup_date']) = $biochemical_relapse;
			            $data[] = $new_data;
			            $new_data['0']['procure_next_followup_data'] = '';
			        }
			    }
			}
			 
			//*** Other Tumors ***
			
			$all_atim_data = $event_model->find('all', array(
			    'conditions' => array(
			        'EventMaster.participant_id' => $new_participant_id,
			        'EventControl.event_type' => 'other tumor diagnosis')));
			$new_data = $record_template;
			$new_data['0']['procure_next_followup_data'] = __('other tumor diagnosis');
			if(!$all_atim_data) {
			    $new_data['0']['procure_next_followup_value'] = __('none');
                $data[] = $new_data;
			} else {
			    $all_tumor_sites = array();
			    foreach($all_atim_data as $atim_data) {
			        $tumor_site = $procure_other_tumor_sites_values[$atim_data['EventDetail']['tumor_site']];
			        $event_date = $this->procureFormatDate($atim_data['EventMaster']['event_date'], $atim_data['EventMaster']['event_date_accuracy']);
                    if($tumor_site || $event_date) {
			           $all_tumor_sites[$event_date.'-'.$tumor_site] = array(($tumor_site? $tumor_site : __('undefined')), $event_date);
			        }
			    }
			    if(empty($all_tumor_sites)) {
			        $new_data['0']['procure_next_followup_value'] = __('yes').' - '.__('undefined');
                    $data[] = $new_data;
			    } else {
                    krsort($all_tumor_sites);
			        foreach($all_tumor_sites as $tumor_site) {
			            list($new_data['0']['procure_next_followup_value'], $new_data['0']['procure_next_followup_date']) = $tumor_site;
			            $data[] = $new_data;
			            $new_data['0']['procure_next_followup_data'] = '';
			        }
			    }
			}
			
			//*** Last PSA ***
			
			$ev_join = array(
				'table' => $event_controls['laboratory']['detail_tablename'],
				'alias' => 'EventDetail',
				'type' => 'INNER',
				'conditions' => array('EventDetail.event_master_id = EventMaster.id'));
			$all_atim_data = $event_model->find('all', array(
			    'conditions' => array(
                    'EventMaster.participant_id' => $new_participant_id, 
			        'EventControl.event_type' => 'laboratory', 
			        'OR' => array(
			            array('EventDetail.psa_total_ngml IS NOT NULL', "EventDetail.psa_total_ngml NOT LIKE ''"),
			            'EventDetail.biochemical_relapse' => 'y')), 
			    'joins' => array($ev_join), 
			    'order' => 'EventMaster.event_date DESC', 
			    'limit' => $last_record_nbr));
			if(!$all_atim_data) {
				$new_data = $record_template;
				$new_data['0']['procure_next_followup_data'] = __('last psa').' - '.__('total ng/ml');
				$new_data['0']['procure_next_followup_value'] = __('none');
				$data[] = $new_data;
			} else {
			    $is_first_record = true;
				foreach($all_atim_data as $atim_data) {
					$new_data = $record_template;
					$new_data['0']['procure_next_followup_data'] = $is_first_record? __('last psa').' - '.__('total ng/ml') : '';
					$new_data['0']['procure_next_followup_value'] = (strlen($atim_data['EventDetail']['psa_total_ngml'])? $atim_data['EventDetail']['psa_total_ngml']: '?').(($atim_data['EventDetail']['biochemical_relapse'] == 'y')? ' (BCR)': '');
					$new_data['0']['procure_next_followup_date'] = $this->procureFormatDate($atim_data['EventMaster']['event_date'], $atim_data['EventMaster']['event_date_accuracy']);
					$data[] = $new_data;
					$is_first_record = false;
				}
			}
			
			//*** Last Testosterone ***
				
			$ev_join = array(
				'table' => $event_controls['laboratory']['detail_tablename'],
				'alias' => 'EventDetail',
				'type' => 'INNER',
				'conditions' => array('EventDetail.event_master_id = EventMaster.id'));
			$all_atim_data = $event_model->find('all', array(
			    'conditions' => array(
			        'EventMaster.participant_id' => $new_participant_id, 
			        'EventControl.event_type' => 'laboratory', 
			        'EventDetail.testosterone_nmoll IS NOT NULL', 
                    "EventDetail.testosterone_nmoll NOT LIKE ''"), 
			    'joins' => array($ev_join), 
			    'order' => 'EventMaster.event_date DESC', 
			    'limit' => $last_record_nbr));
			if(!$all_atim_data) {
				$new_data = $record_template;
				$new_data['0']['procure_next_followup_data'] = __('last testosterone - nmol/l');
				$new_data['0']['procure_next_followup_value'] = __('none');
				$data[] = $new_data;
			} else {
				$is_first_record = true;
				foreach($all_atim_data as $atim_data) {
					$new_data = $record_template;
					$new_data['0']['procure_next_followup_data'] = $is_first_record? __('last testosterone - nmol/l') : '';
					$new_data['0']['procure_next_followup_value'] = (strlen($atim_data['EventDetail']['testosterone_nmoll'])? $atim_data['EventDetail']['testosterone_nmoll']: '?').(($atim_data['EventDetail']['biochemical_relapse'] == 'y')? ' (BCR)': '');
					$new_data['0']['procure_next_followup_date'] = $this->procureFormatDate($atim_data['EventMaster']['event_date'], $atim_data['EventMaster']['event_date_accuracy']);
					$data[] = $new_data;
					$is_first_record = false;
				}
			}
			
			//*** Last clinical event ***
				
			$all_atim_data = $event_model->find('all', array(
			    'conditions' => array(
			        'EventMaster.participant_id' => $new_participant_id, 
			        'EventControl.event_type' => 'clinical exam'), 
			    'order' => 'EventMaster.event_date DESC', 
			    'limit' => $last_record_nbr));
			if(!$all_atim_data) {
				$new_data = $record_template;
				$new_data['0']['procure_next_followup_data'] = __('last clinical event');
				$new_data['0']['procure_next_followup_value'] = __('none');
				$data[] = $new_data;
			} else {
				$is_first_record = true;
				foreach($all_atim_data as $atim_data) {
					$new_data = $record_template;
					$new_data['0']['procure_next_followup_data'] = $is_first_record? __('last clinical event') : '';
					$new_data['0']['procure_next_followup_value'] = implode(' - ', array_filter(array(
						$StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Clinical Exam - Types (PROCURE values only)', $atim_data['EventDetail']['type']),
						$StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Clinical Exam - Sites (PROCURE values only)', $atim_data['EventDetail']['site_precision']),
						$StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Clinical Exam - Results (PROCURE values only)', $atim_data['EventDetail']['results']),
						$StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Progressions & Comorbidities (PROCURE values only)', $atim_data['EventDetail']['progression_comorbidity']),
						(($atim_data['EventDetail']['clinical_relapse'] == 'y')? __('clinical relapse'): '')
					)));
					$new_data['0']['procure_next_followup_date'] = $this->procureFormatDate($atim_data['EventMaster']['event_date'], $atim_data['EventMaster']['event_date_accuracy']);
					$data[] = $new_data;
					$is_first_record = false;
				}
			}
			
			//*** Last completed treatment ***
			
			$all_atim_data = $treatment_model->find('all', array(
			    'conditions' => array(
			        'TreatmentMaster.participant_id' => $new_participant_id, 
			        'TreatmentControl.tx_method' => 'treatment', 
                    'TreatmentMaster.finish_date IS NOT NULL'), 
			    'order' => 'TreatmentMaster.finish_date DESC', 
			    'limit' => $last_record_nbr));
			if(!$all_atim_data) {
				$new_data = $record_template;
				$new_data['0']['procure_next_followup_data'] = __('last completed treatment');
				$new_data['0']['procure_next_followup_value'] = __('none');
				$data[] = $new_data;
			} else {
				$is_first_record = true;
				foreach($all_atim_data as $atim_data) {
					$new_data = $record_template;
					$new_data['0']['procure_next_followup_data'] = $is_first_record? __('last completed treatment') : '';
					$new_data['0']['procure_next_followup_value'] =  implode(' - ', array_filter(array(
						$StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Treatment Types (PROCURE values only)', $atim_data['TreatmentDetail']['treatment_type']),
						$atim_data['Drug']['generic_name'],
						$StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Treatment Sites (PROCURE values only)', $atim_data['TreatmentDetail']['treatment_site']),
						$StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Treatment Precisions (PROCURE values only)', $atim_data['TreatmentDetail']['treatment_precision']),
						$StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Surgery Types (PROCURE values only)', $atim_data['TreatmentDetail']['surgery_type'])
					)));
					$new_data['0']['procure_next_followup_date'] = $this->procureFormatDate($atim_data['TreatmentMaster']['start_date'], $atim_data['TreatmentMaster']['start_date_accuracy']);
					$new_data['0']['procure_next_followup_finish_date'] = $this->procureFormatDate($atim_data['TreatmentMaster']['finish_date'], $atim_data['TreatmentMaster']['finish_date_accuracy']);
					$data[] = $new_data;
					$is_first_record = false;
				}
			}
			
			//*** Ongoing treatment : tx ***
			
			$all_atim_data = $treatment_model->find('all', array(
			    'conditions' => array(
			        'TreatmentMaster.participant_id' => $new_participant_id, 
			        'TreatmentControl.tx_method' => 'treatment', 
                    'TreatmentMaster.finish_date IS NULL'), 
			    'order' => 'TreatmentMaster.start_date DESC'));
			if($all_atim_data) {
			    $is_first_record = true;
				foreach($all_atim_data as $atim_data) {
					$new_data = $record_template;
					$new_data['0']['procure_next_followup_data'] = $is_first_record? __('ongoing treatment') : '';
					$new_data['0']['procure_next_followup_value'] =  implode(' - ', array_filter(array(
						$StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Treatment Types (PROCURE values only)', $atim_data['TreatmentDetail']['treatment_type']),
						$atim_data['Drug']['generic_name'],
						$StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Treatment Sites (PROCURE values only)', $atim_data['TreatmentDetail']['treatment_site']),
						$StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Treatment Precisions (PROCURE values only)', $atim_data['TreatmentDetail']['treatment_precision']),
						$StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Surgery Types (PROCURE values only)', $atim_data['TreatmentDetail']['surgery_type'])
					)));
					$procure_next_followup_date = $this->procureFormatDate($atim_data['TreatmentMaster']['start_date'], $atim_data['TreatmentMaster']['start_date_accuracy']);
					$new_data['0']['procure_next_followup_date'] = strlen($procure_next_followup_date)? $procure_next_followup_date : '______ / ___ / ___';
					$new_data['0']['procure_next_followup_finish_date'] = '______ / ___ / ___';
					$data[] = $new_data;
					$is_first_record = false;
				}
			} else {
				$new_data = $record_template;
				$new_data['0']['procure_next_followup_data'] = __('ongoing treatment');
				$new_data['0']['procure_next_followup_value'] = __('none');
				$data[] = $new_data;
			}
		}
        
		if($display_exact_search_warning) AppController::addWarningMsg(__('all searches are considered as exact searches'));
		
		return array(
			'header' => $header,
			'data' => $data,
			'columns_names' => null,
			'error_msg' => null);
	}
	
	function procureFormatDate($date, $accuracy) {
		$lengh = strlen($date);
		switch($accuracy) {
			case 'd':
				$lengh = strrpos($date, '-');
				break;
			case 'm':
			case 'y':
				$lengh = strpos($date, '-');
				break;
		}
		return substr($date, 0, $lengh);
	}
	
	function procureGetListOfBarcodeErrors($parameters) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/InventoryManagement/Collections/detail')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}

		AppController::addWarningMsg(__('search is only done on banks aliquots'));
		
		$display_exact_search_warning = false;
		$header = null;
		$conditions = array('TRUE');
		if(isset($parameters['ViewAliquot']['participant_identifier_start'])) {
			$participant_identifier_start = (!empty($parameters['ViewAliquot']['participant_identifier_start']))? $parameters['ViewAliquot']['participant_identifier_start']: null;
			$participant_identifier_end = (!empty($parameters['ViewAliquot']['participant_identifier_end']))? $parameters['ViewAliquot']['participant_identifier_end']: null;
			if($participant_identifier_start) $conditions[] = "ViewAliquot.participant_identifier >= '$participant_identifier_start'";
			if($participant_identifier_end) $conditions[] = "ViewAliquot.participant_identifier <= '$participant_identifier_end'";
		} else if(isset($parameters['ViewAliquot']['participant_identifier'])) {
			$display_exact_search_warning = true;
			$participant_identifiers  = array_filter($parameters['ViewAliquot']['participant_identifier']);
			if($participant_identifiers) $conditions[] = "ViewAliquot.participant_identifier IN ('".implode("','",$participant_identifiers)."')";
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		if(isset($parameters['ViewAliquot']['procure_created_by_bank'])) {
			$procure_created_by_bank  = array_filter($parameters['ViewAliquot']['procure_created_by_bank']);
			$conditions[] = "ViewAliquot.procure_created_by_bank IN ('".implode("','",$procure_created_by_bank)."')";
			if(in_array('p', $procure_created_by_bank) || in_array('s', $procure_created_by_bank)) {
				$check_procure_created_by_bank = implode('',$procure_created_by_bank);
				if(in_array($check_procure_created_by_bank, array('p','s','ps','sp'))) $conditions = array("ViewAliquot.procure_created_by_bank = '-1'");
			}
		}
		
		$data = array();
		
		//Get Controls Data
		$ViewAliquot_model = AppModel::getInstance("ClinicalAnnotation", "ViewAliquot", true);
		
		//Look for duplicated barcodes
		
		$query = "SELECT ViewAliquot.*
			FROM (
				SELECT barcode, count(*) as nbr_of_aliquots
				FROM view_aliquots AS ViewAliquot
				WHERE ". implode(' AND ', $conditions) ." AND ViewAliquot.procure_created_by_bank NOT IN ('p','s') GROUP BY barcode
			) TmpRes, view_aliquots AS ViewAliquot
			WHERE TmpRes.nbr_of_aliquots > 1 
			AND TmpRes.barcode = ViewAliquot.barcode
			ORDER BY ViewAliquot.barcode;";
		foreach($ViewAliquot_model->query($query) as $res) {
			$data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']] = array_merge(array('0'=> array(__('duplicated'))), $res);
		}
		
		//Look for barcodes that don't match format (limited to bank aliquots)
		
		$wrong_format_aliquot_master_ids = array('-1');
		$query = "SELECT ViewAliquot.*
			FROM view_aliquots AS ViewAliquot
			WHERE ". implode(' AND ', $conditions) ."
			AND ViewAliquot.barcode NOT REGEXP '^PS[0-9]P[0-9]{4}\ V[0-9]{2}(\.[0-9]+){0,1}\ \-[A-Z]{3}'
			AND ViewAliquot.procure_created_by_bank != 'p';";
		foreach($ViewAliquot_model->query($query) as $res) {
			$error = __('wrong format');
			if(!isset($data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']])) {
				$data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']] = array_merge(array('0'=> array($error)), $res);
			} else {
				$data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']]['0'][] = $error;
			}
			$wrong_format_aliquot_master_ids[] = $res['ViewAliquot']['aliquot_master_id'];
		}
		
		//Look for barcodes that don't match the participant identifier of the collection participant (limited to bank aliquots)
		
		$query = "SELECT ViewAliquot.*
			FROM view_aliquots AS ViewAliquot
			WHERE ". implode(' AND ', $conditions) ."
			AND ViewAliquot.barcode NOT REGEXP CONCAT('^',ViewAliquot.participant_identifier,'\ V[0-9]{2}(\.[0-9]+){0,1}\ \-[A-Z]{3}')
			AND ViewAliquot.procure_created_by_bank != 'p'
			AND ViewAliquot.aliquot_master_id NOT IN (".implode(',',$wrong_format_aliquot_master_ids).");";
		foreach($ViewAliquot_model->query($query) as $res) {
			$error = __('wrong participant identifier');
			if(!isset($data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']])) {
				$data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']] = array_merge(array('0'=> array($error)), $res);
			} else {
				$data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']]['0'][] = $error;
			}
		}
		
		//Look for barcodes that don't match the visit of the collection (limited to bank aliquots)
		
		$query = "SELECT ViewAliquot.*
			FROM view_aliquots AS ViewAliquot
			WHERE ". implode(' AND ', $conditions) ."
			AND ViewAliquot.barcode NOT REGEXP CONCAT('^PS[0-9]P[0-9]{4}\ ',ViewAliquot.procure_visit,'\ \-[A-Z]{3}')
			AND ViewAliquot.procure_created_by_bank != 'p'
			AND ViewAliquot.aliquot_master_id NOT IN (".implode(',',$wrong_format_aliquot_master_ids).");";
		foreach($ViewAliquot_model->query($query) as $res) {
			$error = __('wrong visit');
			if(!isset($data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']])) {
				$data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']] = array_merge(array('0'=> array($error)), $res);
			} else {
				$data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']]['0'][] = $error;
			}
		}
		
		$final_data = array();
		foreach($data as $new_aliquots) {
			foreach($new_aliquots as $new_aliquot) {
				$new_aliquot['0']['procure_barcode_error'] = implode(' & ', $new_aliquot['0']);
				$final_data[] = $new_aliquot;
			}
		}
		
		if(sizeof($final_data) > Configure::read('databrowser_and_report_results_display_limit')) {
			return array(
				'header' => null,
				'data' => null,
				'columns_names' => null,
				'error_msg' => 'the report contains too many results - please redefine search criteria');
		}
		
		if($display_exact_search_warning) AppController::addWarningMsg(__('all searches are considered as exact searches'));
		
		return array(
			'header' => $header,
			'data' => $final_data,
			'columns_names' => null,
			'error_msg' => null);
	}
	
	function procureBankActivityReport($parameters) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/InventoryManagement/Collections/detail')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
		$display_exact_search_warning = false;
		$inaccurate_date = false;
		
		//Get Criteria
		
		$header = array();
		$conditions = array('TRUE');
		
		if(isset($parameters['Participant']['participant_identifier_start'])) {
			$participant_identifier_start = (!empty($parameters['Participant']['participant_identifier_start']))? $parameters['Participant']['participant_identifier_start']: null;
			$participant_identifier_end = (!empty($parameters['Participant']['participant_identifier_end']))? $parameters['Participant']['participant_identifier_end']: null;
			if($participant_identifier_start) $conditions[] = "Participant.participant_identifier >= '$participant_identifier_start'";
			if($participant_identifier_end) $conditions[] = "Participant.participant_identifier <= '$participant_identifier_end'";
		} else if(isset($parameters['Participant']['participant_identifier'])) {
			$display_exact_search_warning = true;
			$participant_identifiers  = array_filter($parameters['Participant']['participant_identifier']);
			if($participant_identifiers) $conditions[] = "Participant.participant_identifier IN ('".implode("','",$participant_identifiers)."')";
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		if(isset($parameters['0']['procure_participant_identifier_prefix'])) {
		    $tmp_conditions = array();
		    $procure_ps_nbrs = array();
		    foreach($parameters['0']['procure_participant_identifier_prefix'] as $tmp_new_prefix) {
		        if(in_array($tmp_new_prefix, array('1', '2', '3', '4'))) {
		          $tmp_conditions[] = "Participant.participant_identifier LIKE 'PS$tmp_new_prefix%'";
		          $procure_ps_nbrs[] = "PS$tmp_new_prefix";
		        } else if(strlen($tmp_new_prefix)) {
		          $tmp_conditions[] = "Participant.participant_identifier LIKE '-1'";
		        }
		    }
		    if($tmp_conditions) {
		        $conditions[] = "(".implode(' OR ', $tmp_conditions).")";
		    }
		    if($procure_ps_nbrs) {
    		    $header = array(
                    'title' => __('report limited to').' : ' .implode(", ",$procure_ps_nbrs).'.',
                    'description' => '');
		    }
		}
		
		//Get Data
		
        $data = array(
		    'procure_nbr_of_participants_with_collection_and_visit' => array(),
		    'procure_nbr_of_participants_with_collection' => array(),
		    'procure_nbr_of_participants_with_visit_only' => array(),
		    'procure_nbr_of_participants_with_collection_post_bcr' => array(),
		    'procure_nbr_of_participants_with_collection_pre_bcr' => array(),
		    'procure_nbr_of_participants_with_pbmc_extraction' => array(),
		    'procure_nbr_of_participants_with_rna_extraction' => array(),
		    'procure_nbr_of_participants_with_clinical_data_update' => array());
        $date_key_list = array();
        
		$participant_model = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		
		$query = "SELECT id,event_type, detail_tablename FROM event_controls WHERE flag_active = 1;";
		$event_controls = array();
		foreach($participant_model->query($query) as $res) $event_controls[$res['event_controls']['event_type']] = array('id' => $res['event_controls']['id'], 'detail_tablename' => $res['event_controls']['detail_tablename']);
		$query = "SELECT id,tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1;";
		$tx_controls = array();
		foreach($participant_model->query($query) as $res) {
		    $tx_controls[$res['treatment_controls']['tx_method']] = array('id' => $res['treatment_controls']['id'], 'detail_tablename' => $res['treatment_controls']['detail_tablename']);
		}
		$query = "SELECT id,sample_type, detail_tablename FROM sample_controls;";
		$sample_controls = array();
		foreach($participant_model->query($query) as $res) $sample_controls[$res['sample_controls']['sample_type']] = array('id' => $res['sample_controls']['id'], 'detail_tablename' => $res['sample_controls']['detail_tablename']);
		
		$end_date_year = date("Y");
		$end_date = date("Y-m-d");
		$start_date= str_replace($end_date_year, ($end_date_year -1), $end_date);

		//Get participants ids
		$query = "SELECT DISTINCT
			Participant.id
			FROM participants Participant
			WHERE Participant.deleted <> 1 AND ". implode(' AND ', $conditions);
		$participant_ids = array();
		foreach($participant_model->query($query) as $new_participant_id) {
		    $participant_ids[] = $new_participant_id['Participant']['id'];
		}
		$participant_ids_strg = empty($participant_ids)? '-1': implode(',',$participant_ids);
		
        // Get number of participants with visit and/or collection
		
		$query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
                SELECT DISTINCT res1.participant_id, res1.record_year, res1.record_month FROM (
                    SELECT DISTINCT Collection.participant_id, 
                    YEAR(Collection.collection_datetime) AS record_year, 
                    IF(Collection.collection_datetime_accuracy <> 'm', LPAD(MONTH(Collection.collection_datetime), 2, '0'), '?') AS record_month
                    FROM aliquot_masters AS AliquotMaster
                    INNER JOIN collections AS Collection ON Collection.id = AliquotMaster.collection_id
                    WHERE Collection.participant_id IN ($participant_ids_strg)
                    AND Collection.deleted <> 1
                    AND AliquotMaster.deleted <> 1
                    AND Collection.collection_datetime > '$start_date 23:59:59' 
                    AND Collection.collection_datetime <= '$end_date 23:59:59'
                    AND Collection.collection_datetime_accuracy <> 'y'
                    UNION ALL
                    SELECT DISTINCT EventMaster.participant_id, 
                    YEAR(EventMaster.event_date) AS event_year, 
                    IF(EventMaster.event_date_accuracy <> 'm', LPAD(MONTH(EventMaster.event_date), 2, '0'), '?') AS event_month
                    FROM event_masters AS EventMaster
                    WHERE EventMaster.participant_id IN ($participant_ids_strg)
                    AND EventMaster.deleted <> 1
                    AND EventMaster.event_control_id = ".$event_controls['visit/contact']['id']."
                    AND EventMaster.event_date > '$start_date' 
                    AND EventMaster.event_date <= '$end_date'
                    AND EventMaster.event_date_accuracy <> 'y'
                ) AS res1
    		) AS res
    		 GROUP BY res.record_year, res.record_month;";
		foreach($participant_model->query($query) as $new_participants_count) {
		    $data['procure_nbr_of_participants_with_collection_and_visit'][$new_participants_count[0]['y_m']] =  $new_participants_count[0]['nbr_of_records'];
		    $date_key_list[$new_participants_count[0]['y_m']] = $new_participants_count[0]['y_m'];
		}
		
		// Get number of participants with collection
		
		$query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
        		SELECT DISTINCT Collection.participant_id,
        		YEAR(Collection.collection_datetime) AS record_year,
        		IF(Collection.collection_datetime_accuracy <> 'm', LPAD(MONTH(Collection.collection_datetime), 2, '0'), '?') AS record_month
        		FROM aliquot_masters AS AliquotMaster
        		INNER JOIN collections AS Collection ON Collection.id = AliquotMaster.collection_id
        		WHERE Collection.participant_id IN ($participant_ids_strg)
        		AND Collection.deleted <> 1
        		AND AliquotMaster.deleted <> 1
        		AND Collection.collection_datetime > '$start_date 23:59:59'
        		AND Collection.collection_datetime <= '$end_date 23:59:59'
        		AND Collection.collection_datetime_accuracy <> 'y'
    		) AS res
    		GROUP BY res.record_year, res.record_month;";	
		foreach($participant_model->query($query) as $new_participants_count) {
		    $data['procure_nbr_of_participants_with_collection'][$new_participants_count[0]['y_m']] =  $new_participants_count[0]['nbr_of_records'];
		    $date_key_list[$new_participants_count[0]['y_m']] = $new_participants_count[0]['y_m'];
		}
		
		// Get number of participants with visit only
		
		foreach($data['procure_nbr_of_participants_with_collection_and_visit'] as $key_year_month => $record_nbrs) {
		    if(!array_key_exists($key_year_month, $data['procure_nbr_of_participants_with_collection'])) {
		        $data['procure_nbr_of_participants_with_visit_only'][$key_year_month] = $record_nbrs;
		    } else {
		        $data['procure_nbr_of_participants_with_visit_only'][$key_year_month] = $record_nbrs - $data['procure_nbr_of_participants_with_collection'][$key_year_month];
		    }
		}
		
		// Get number of participants with collections after BCR
		
		$query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
        		SELECT DISTINCT Collection.participant_id,
        		YEAR(Collection.collection_datetime) AS record_year,
        		IF(Collection.collection_datetime_accuracy <> 'm', LPAD(MONTH(Collection.collection_datetime), 2, '0'), '?') AS record_month
        		FROM aliquot_masters AS AliquotMaster
        		INNER JOIN collections AS Collection ON Collection.id = AliquotMaster.collection_id
        		INNER JOIN event_masters AS EventMaster ON EventMaster.participant_id = Collection.participant_id
        		INNER JOIN ".$event_controls['laboratory']['detail_tablename']." AS EventDetail ON EventDetail.event_master_id = EventMaster.id
        		WHERE Collection.participant_id IN ($participant_ids_strg)
        		AND Collection.deleted <> 1
        		AND AliquotMaster.deleted <> 1
        		AND EventMaster.deleted <> 1
        		AND EventMaster.event_control_id = ".$event_controls['laboratory']['id']."
    		    AND EventMaster.event_date <= Collection.collection_datetime
    		    AND EventDetail.biochemical_relapse = 'y'
        		AND Collection.collection_datetime > '$start_date 23:59:59'
        		AND Collection.collection_datetime <= '$end_date 23:59:59'
        		AND Collection.collection_datetime_accuracy <> 'y'
    		) AS res
    		GROUP BY res.record_year, res.record_month;";
		foreach($participant_model->query($query) as $new_participants_count) {
		    $data['procure_nbr_of_participants_with_collection_post_bcr'][$new_participants_count[0]['y_m']] =  $new_participants_count[0]['nbr_of_records'];
		    $date_key_list[$new_participants_count[0]['y_m']] = $new_participants_count[0]['y_m'];
		}
		
		// Get number of participants with visit collection pre bcr
		
		foreach($data['procure_nbr_of_participants_with_collection_and_visit'] as $key_year_month => $record_nbrs) {
		    if(!array_key_exists($key_year_month, $data['procure_nbr_of_participants_with_collection_post_bcr'])) {
		        $data['procure_nbr_of_participants_with_collection_pre_bcr'][$key_year_month] = $record_nbrs;
		    } else {
		        $data['procure_nbr_of_participants_with_collection_pre_bcr'][$key_year_month] = $record_nbrs - $data['procure_nbr_of_participants_with_collection_post_bcr'][$key_year_month];
		    }
		}
		    
		// Get number of participants with pbmc extraction
		
		$query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
        		SELECT DISTINCT Collection.participant_id,
        		YEAR(DerivativeDetail.creation_datetime) AS record_year,
        		IF(DerivativeDetail.creation_datetime_accuracy <> 'm', LPAD(MONTH(DerivativeDetail.creation_datetime), 2, '0'), '?') AS record_month
        		FROM sample_masters AS SampleMaster
        		INNER JOIN derivative_details DerivativeDetail ON DerivativeDetail.sample_master_id = SampleMaster.id
        		INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id
        		WHERE Collection.participant_id IN ($participant_ids_strg)
        		AND Collection.deleted <> 1
        		AND SampleMaster.deleted <> 1
        		AND DerivativeDetail.creation_datetime > '$start_date 23:59:59'
        		AND DerivativeDetail.creation_datetime <= '$end_date 23:59:59'
        		AND DerivativeDetail.creation_datetime_accuracy <> 'y'
        		AND SampleMaster.sample_control_id = ".$sample_controls['pbmc']['id']."
    		) AS res
    		GROUP BY res.record_year, res.record_month;";
		foreach($participant_model->query($query) as $new_participants_count) {
		    $data['procure_nbr_of_participants_with_pbmc_extraction'][$new_participants_count[0]['y_m']] =  $new_participants_count[0]['nbr_of_records'];
		    $date_key_list[$new_participants_count[0]['y_m']] = $new_participants_count[0]['y_m'];
		}
		
		// Get number of participants with rna extraction
		
		$query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
        		SELECT DISTINCT Collection.participant_id,
        		YEAR(DerivativeDetail.creation_datetime) AS record_year,
        		IF(DerivativeDetail.creation_datetime_accuracy <> 'm', LPAD(MONTH(DerivativeDetail.creation_datetime), 2, '0'), '?') AS record_month
        		FROM sample_masters AS SampleMaster
        		INNER JOIN derivative_details DerivativeDetail ON DerivativeDetail.sample_master_id = SampleMaster.id
        		INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id
        		WHERE Collection.participant_id IN ($participant_ids_strg)
        		AND Collection.deleted <> 1
        		AND SampleMaster.deleted <> 1
        		AND DerivativeDetail.creation_datetime > '$start_date 23:59:59'
        		AND DerivativeDetail.creation_datetime <= '$end_date 23:59:59'
        		AND DerivativeDetail.creation_datetime_accuracy <> 'y'
        		AND SampleMaster.sample_control_id = ".$sample_controls['rna']['id']."
    		) AS res
    		GROUP BY res.record_year, res.record_month;";
		foreach($participant_model->query($query) as $new_participants_count) {
		    $data['procure_nbr_of_participants_with_rna_extraction'][$new_participants_count[0]['y_m']] =  $new_participants_count[0]['nbr_of_records'];
		    $date_key_list[$new_participants_count[0]['y_m']] = $new_participants_count[0]['y_m'];
		}
		
		// Get number of participants with clinical data updated
		
		$query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
                SELECT DISTINCT res1.participant_id, res1.record_year, res1.record_month FROM (
                    SELECT DISTINCT id as participant_id, 
            		YEAR(date_of_death) AS record_year,
                    LPAD(MONTH(date_of_death), 2, '0') AS record_month
            		FROM participants
            		WHERE date_of_death > '$start_date' 
                    AND date_of_death <= '$end_date'
                    AND id IN ($participant_ids_strg)
            		UNION All
            		SELECT DISTINCT participant_id, 
            		YEAR(event_date) AS event_year,
                    LPAD(MONTH(event_date), 2, '0') AS event_month
            		FROM event_masters
            		WHERE event_date > '$start_date'
                    AND event_date <= '$end_date'   
                    AND participant_id IN ($participant_ids_strg)
            		UNION All
            		SELECT DISTINCT participant_id, 
            		YEAR(start_date) AS event_year,
                    LPAD(MONTH(start_date), 2, '0') AS event_month
            		FROM treatment_masters
            		WHERE start_date > '$start_date'
                    AND start_date <= '$end_date'
                    AND participant_id IN ($participant_ids_strg)
            		UNION All
            		SELECT DISTINCT participant_id, 
            		YEAR(finish_date) AS event_year,
                    LPAD(MONTH(finish_date), 2, '0') AS event_month
            		FROM treatment_masters
            		WHERE finish_date > '$start_date'
                    AND finish_date <= '$end_date'
                    AND participant_id IN ($participant_ids_strg)
                ) AS res1
    		) AS res
    		 GROUP BY res.record_year, res.record_month;";
		foreach($participant_model->query($query) as $new_participants_count) {
		    $data['procure_nbr_of_participants_with_clinical_data_update'][$new_participants_count[0]['y_m']] =  $new_participants_count[0]['nbr_of_records'];
		    $date_key_list[$new_participants_count[0]['y_m']] = $new_participants_count[0]['y_m'];
		}
		
		// Set empty value
		if($inaccurate_date) AppController::addWarningMsg(__('at least one participant summary is based on inaccurate date'));
		
		if($display_exact_search_warning) AppController::addWarningMsg(__('all searches are considered as exact searches'));
		
		foreach($data as $field_key => $field_vals) {
		    foreach($date_key_list as $expected_field_key) {
		        if(!array_key_exists($expected_field_key, $field_vals)) {
		            $data[$field_key][$expected_field_key] = '0';
		        }
		    }
		}
		
		if(empty($date_key_list)) {
		    $date_key_list = array(__('no data'));
    		foreach($data as $key => $val_arr)
    		$data[$key] = array('no data' => __('n/a'));
		}
		
        sort($date_key_list);
		$array_to_return = array(
			'header' => $header, 
			'data' => array($data), 
			'columns_names' => $date_key_list,
			'error_msg' => null);
		
		return $array_to_return;
	}
	
}