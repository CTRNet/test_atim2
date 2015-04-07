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
			$participant_identifiers  = array_filter($parameters['Participant']['participant_identifier']);
			if($participant_identifiers) $conditions[] = "Participant.participant_identifier IN ('".implode("','",$participant_identifiers)."')";
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
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
		$diagnosis_event_control_id = $event_controls['procure diagnostic information worksheet']['id'];
		$diagnosis_event_detail_tablename = $event_controls['procure diagnostic information worksheet']['detail_tablename'];
		$pathology_event_control_id = $event_controls['procure pathology report']['id'];
		$pathology_event_detail_tablename = $event_controls['procure pathology report']['detail_tablename'];
		$followup_treatment_control_id = $tx_controls['procure follow-up worksheet - treatment']['id'];
		$followup_treatment_detail_tablename = $tx_controls['procure follow-up worksheet - treatment']['detail_tablename'];
		
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
			EventDetail.biopsy_pre_surgery_date_accuracy,
			EventDetail.aps_pre_surgery_total_ng_ml,
			EventDetail.aps_pre_surgery_free_ng_ml,
			EventDetail.aps_pre_surgery_date,
			EventDetail.aps_pre_surgery_date_accuracy
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
				'procure_inaccurate_date_use' => '',
				'procure_pre_op_psa_date' => '',
				'procure_first_bcr_date' => ''
			);
			$data[$participant_id]['EventDetail']['total_ngml'] = '';
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
				"TreatmentDetail.treatment_type" => 'prostatectomy');
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
		
		//Analyze participants psa
		$event_model = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
		$event_control_id = $event_controls['procure follow-up worksheet - aps']['id'];
		$all_participants_psa = $event_model->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_ids, 'EventMaster.event_control_id' => $event_control_id, 'EventMaster.event_date IS NOT NULL'), 'order' => array('EventMaster.event_date ASC')));
		foreach($all_participants_psa as $new_psa) {
			$participant_id = $new_psa['EventMaster']['participant_id'];
			//Use pathology report date to set pre op psa list
			$prostatectomy_date = $data[$participant_id]['TreatmentMaster']['start_date'];
			$prostatectomy_date_accuracy = $data[$participant_id]['TreatmentMaster']['start_date_accuracy'];
			if($prostatectomy_date) {
				if($prostatectomy_date_accuracy != 'c' || $new_psa['EventMaster']['event_date_accuracy'] != 'c') {
					$inaccurate_date = true;
					$data[$participant_id][0]['procure_inaccurate_date_use'] = 'y';
				}
				if($new_psa['EventMaster']['event_date'] <= $prostatectomy_date) {
					//PSA pre-surgery
					$lengh = strlen($new_psa['EventMaster']['event_date']);
					switch($new_psa['EventMaster']['event_date_accuracy']) {
						case 'c':
							break;
						case 'd':
							$lengh = strrpos($new_psa['EventMaster']['event_date'], '-');
							break;
						case 'm':
						case 'y':
							$lengh = strpos($new_psa['EventMaster']['event_date'], '-');
							break;
					}
					$new_psa['EventMaster']['event_date'] = substr($new_psa['EventMaster']['event_date'], 0, $lengh);
					$data[$participant_id]['0']['procure_pre_op_psa_date'] = $new_psa['EventMaster']['event_date'];
					$data[$participant_id]['EventDetail']['total_ngml'] = $new_psa['EventDetail']['total_ngml'];
				}
				if($new_psa['EventDetail']['biochemical_relapse'] == 'y' && empty($data[$participant_id]['0']['procure_first_bcr_date'])) {
					//1st BCR
					$lengh = strlen($new_psa['EventMaster']['event_date']);
					switch($new_psa['EventMaster']['event_date_accuracy']) {
						case 'c':
							break;
						case 'd':
							$lengh = strrpos($new_psa['EventMaster']['event_date'], '-');
							break;
						case 'm':
						case 'y':
							$lengh = strpos($new_psa['EventMaster']['event_date'], '-');
							break;
					}
					$data[$participant_id]['0']['procure_first_bcr_date'] =  substr($new_psa['EventMaster']['event_date'], 0, $lengh);
				}
			}
		}
		
		if($inaccurate_date) AppController::addWarningMsg(__('at least one participant summary is based on inaccurate date'));
		
		return array(
				'header' => $header,
				'data' => $data,
				'columns_names' => null,
				'error_msg' => null);
	}
	
	function procureFollowUpReports($parameters) {
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
			$participant_identifiers  = array_filter($parameters['Participant']['participant_identifier']);
			if($participant_identifiers) $conditions[] = "Participant.participant_identifier IN ('".implode("','",$participant_identifiers)."')";
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		//Get Controls Data
		$participant_model = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$query = "SELECT id,event_type, detail_tablename FROM event_controls WHERE flag_active = 1;";
		$event_controls = array();
		foreach($participant_model->query($query) as $res) $event_controls[$res['event_controls']['event_type']] = array('id' => $res['event_controls']['id'], 'detail_tablename' => $res['event_controls']['detail_tablename']);
		$followup_event_control_id = $event_controls['procure follow-up worksheet']['id'];
		$followup_event_detail_tablename = $event_controls['procure follow-up worksheet']['detail_tablename'];
		if(!$followup_event_control_id) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);		
		$query = "SELECT id,tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1;";
		$tx_controls = array();
		foreach($participant_model->query($query) as $res) $tx_controls[$res['treatment_controls']['tx_method']] = array('id' => $res['treatment_controls']['id'], 'detail_tablename' => $res['treatment_controls']['detail_tablename']);
		$treatment_control_id = $tx_controls['procure follow-up worksheet - treatment']['id'];
		$treatment_control_detail_tablename = $tx_controls['procure follow-up worksheet - treatment']['detail_tablename'];
		$query = "SELECT id, detail_tablename, sample_type FROM sample_controls WHERE sample_type IN ('blood','urine', 'tissue');";
		$sample_controls = array();
		$blood_detail_tablename = '';
		foreach($participant_model->query($query) as $res) {
			$sample_controls[$res['sample_controls']['id']] = $res['sample_controls']['sample_type'];
			if($res['sample_controls']['sample_type'] == 'blood') $blood_detail_tablename = $res['sample_controls']['detail_tablename'];
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
		$empty_form_array = array(
			'procure_prostatectomy_date' => '',
			'procure_prostatectomy_date_accuracy' => '',
			'procure_last_collection_date' => '',
			'procure_last_collection_date_accuracy' => '',
			'procure_time_from_last_collection_months' => '',
			'procure_followup_worksheets_nbr' => array(), 
			'procure_number_of_visit_with_collection' => array());
		for($tmp_visit_id = 1; $tmp_visit_id < 20; $tmp_visit_id++) {
			$visit_id = (strlen($tmp_visit_id) == 1)? '0'.$tmp_visit_id : $tmp_visit_id;
			$empty_form_array["procure_".$visit_id."_procure_form_identification"]= '';
			$empty_form_array["procure_".$visit_id."_event_date"]= null;
			$empty_form_array["procure_".$visit_id."_event_date_accuracy"]= '';
			$empty_form_array["procure_".$visit_id."_first_collection_date"]= null;
			$empty_form_array["procure_".$visit_id."_first_collection_date_accuracy"]= '';
			$empty_form_array["procure_".$visit_id."_paxgene_collected"]= '';
			$empty_form_array["procure_".$visit_id."_serum_collected"]= '';
			$empty_form_array["procure_".$visit_id."_urine_collected"]= '';
			$empty_form_array["procure_".$visit_id."_k2_EDTA_collected"]= '';
			$empty_form_array["procure_".$visit_id."_tissue_collected"]= '';
		}
		$display_warning_1 = false;
		$display_warning_2 = false;
		foreach($participant_model->query($query) as $res) {
			$participant_id = $res['Participant']['id'];
			if(!isset($data[$participant_id])) $data[$participant_id] = array(
				'Participant' => $res['Participant'], 
				'0' => $empty_form_array);
			$procure_form_identification = $res['EventMaster']['procure_form_identification'];
			if($procure_form_identification) {
				if(preg_match("/^PS[0-9]P0[0-9]+ V(([0])|(0[1-9])|(1[0-9])) -(CSF|FBP|PST|FSP|MED|QUE)[0-9x]+$/", $procure_form_identification, $matches)) {
					$visit_id = $matches[1];
					if($visit_id != '0') {
						if(empty($data[$participant_id][0]["procure_".$visit_id."_procure_form_identification"])) {
							$data[$participant_id][0]["procure_".$visit_id."_procure_form_identification"] = $res['EventMaster']['procure_form_identification'];
							$data[$participant_id][0]["procure_".$visit_id."_event_date"]= $res['EventMaster']['event_date'];
							$data[$participant_id][0]["procure_".$visit_id."_event_date_accuracy"]= $res['EventMaster']['event_date_accuracy'];
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
					$data[$participant_id][0]["procure_prostatectomy_date"] = $res['TreatmentMaster']['start_date'];
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
						$data[$participant_id][0]["procure_".$visit_id."_first_collection_date"] = $res['Collection']['collection_datetime'];
						$data[$participant_id][0]["procure_".$visit_id."_first_collection_date_accuracy"] = $res['Collection']['collection_datetime_accuracy'];
						$data[$participant_id][0]['procure_number_of_visit_with_collection'][$visit_id] = '-';
					}
					if(empty($data[$participant_id][0]["procure_last_collection_date"]) || $data[$participant_id][0]["procure_last_collection_date"] < $res['Collection']['collection_datetime']) {
						$data[$participant_id][0]["procure_last_collection_date"] = $res['Collection']['collection_datetime'];
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
		
		$query = "SELECT NOW() FROM users LIMIT 0,1;";
		$res = $participant_model->query($query);
		$current_date = $res[0][0]['NOW()'];
		foreach($data as $participant_id => $participant_data){
			if(!empty($data[$participant_id][0]["procure_last_collection_date"])) {
				$current_date = substr($current_date, 0, 10);
				$procure_last_collection_date = substr($data[$participant_id][0]["procure_last_collection_date"], 0, 10);
				$datetime1 = new DateTime($procure_last_collection_date);
				$datetime2 = new DateTime($current_date);
				$interval = $datetime1->diff($datetime2);
				$progression_time_in_months = (($interval->format('%y')*12) + $interval->format('%m'));
				if(!$interval->invert) $data[$participant_id][0]["procure_time_from_last_collection_months"] = $progression_time_in_months;
			}
			$data[$participant_id][0]['procure_followup_worksheets_nbr'] = sizeof($data[$participant_id][0]['procure_followup_worksheets_nbr']);
			$data[$participant_id][0]['procure_number_of_visit_with_collection'] = sizeof($data[$participant_id][0]['procure_number_of_visit_with_collection']);
		}
		
		return array(
			'header' => $header,
			'data' => $data,
			'columns_names' => null,
			'error_msg' => null);
	}
	
	function procureAliquotsReports($parameters) {
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		if(!AppController::checkLinkPermission('/InventoryManagement/Collections/detail')){
			$this->flash(__('you need privileges to access this page'), 'javascript:history.back()');
		}
		
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
			$participant_identifiers  = array_filter($parameters['Participant']['participant_identifier']);
			if($participant_identifiers) $conditions[] = "Participant.participant_identifier IN ('".implode("','",$participant_identifiers)."')";
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		//Get Controls Data
		$participant_model = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$query = "SELECT id, sample_type FROM sample_controls WHERE sample_type IN ('blood', 'serum', 'plasma', 'pbmc','centrifuged urine', 'tissue', 'rna', 'dna');";
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
					case 'pbmc tube':
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
		
		return array(
				'header' => $header,
				'data' => $data,
				'columns_names' => null,
				'error_msg' => null);
	}
}