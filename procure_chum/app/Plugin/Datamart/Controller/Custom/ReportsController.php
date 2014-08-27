<?php
class ReportsControllerCustom extends ReportsController {
	
	function participantIdentifiersSummary($parameters) {
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
		if($tmp_res_count > self::$display_limit) {
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
	
	function procureParticipantReport($parameters) {
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
		if(isset($parameters['MiscIdentifier']['identifier_value'])) {
			$no_labos  = array_filter($parameters['MiscIdentifier']['identifier_value']);
			if($no_labos) $conditions[] = "MiscIdentifier.identifier_value IN ('".implode("','",$no_labos)."')";
		} else if(isset($parameters['MiscIdentifier']['identifier_value_start'])) {
			$identifier_value_start = (!empty($parameters['MiscIdentifier']['identifier_value_start']))? $parameters['MiscIdentifier']['identifier_value_start']: null;
			$identifier_value_end = (!empty($parameters['MiscIdentifier']['identifier_value_end']))? $parameters['MiscIdentifier']['identifier_value_end']: null;
			if($identifier_value_start) $conditions[] = "MiscIdentifier.identifier_value >= '$identifier_value_start'";
			if($identifier_value_end) $conditions[] = "MiscIdentifier.identifier_value <= '$identifier_value_end'";
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
		$query = "SELECT id FROM misc_identifier_controls WHERE flag_active = 1 AND misc_identifier_name = 'prostate bank no lab';";
		$misc_identifier_control_id = null;
		foreach($participant_model->query($query) as $res) $misc_identifier_control_id = $res['misc_identifier_controls']['id'];
		
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
			DiagnosisEventDetail.biopsy_pre_surgery_date, 
			DiagnosisEventDetail.biopsy_pre_surgery_date_accuracy,
			DiagnosisEventDetail.aps_pre_surgery_total_ng_ml,
			DiagnosisEventDetail.aps_pre_surgery_free_ng_ml,
			DiagnosisEventDetail.aps_pre_surgery_date,
			DiagnosisEventDetail.aps_pre_surgery_date_accuracy,
			MiscIdentifier.identifier_value
			FROM participants Participant
			LEFT JOIN event_masters DiagnosisEventMaster ON DiagnosisEventMaster.participant_id = Participant.id AND DiagnosisEventMaster.event_control_id = $diagnosis_event_control_id AND DiagnosisEventMaster.deleted <> 1
			LEFT JOIN $diagnosis_event_detail_tablename DiagnosisEventDetail ON DiagnosisEventDetail.event_master_id = DiagnosisEventMaster.id
			LEFT JOIN event_masters PathologyEventMaster ON PathologyEventMaster.participant_id = Participant.id AND PathologyEventMaster.event_control_id = $pathology_event_control_id AND PathologyEventMaster.deleted <> 1
			LEFT JOIN $pathology_event_detail_tablename PathologyEventDetail ON PathologyEventDetail.event_master_id = PathologyEventMaster.id
			LEFT JOIN misc_identifiers MiscIdentifier ON MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1 AND MiscIdentifier.misc_identifier_control_id = $misc_identifier_control_id
			WHERE Participant.deleted <> 1 AND ". implode(' AND ', $conditions);
		$data = array();
		foreach($participant_model->query($query) as $res) {
			$participant_id = $res['Participant']['id'];
			if(isset($data[$participant_id])) AppController::addWarningMsg('at least one participant is linked to more than one diagnosis or pathology worksheet');
			$data[$participant_id]['Participant'] = $res['Participant'];
			$data[$participant_id]['MiscIdentifier'] = $res['MiscIdentifier'];
			$data[$participant_id]['EventMaster'] = $res['PathologyEventMaster'];
			$data[$participant_id]['EventDetail'] = array_merge($res['PathologyEventDetail'], $res['DiagnosisEventDetail']);	
			$data[$participant_id]['0'] = array(
				'procure_post_op_hormono' => '',
				'procure_post_op_chemo' => '',
				'procure_post_op_radio' => '',
				'procure_pre_op_hormono' => '',
				'procure_pre_op_chemo' => '',
				'procure_pre_op_radio' => '',
				'procure_inaccurate_date_use' => '',
				'procure_pre_op_psa_date' => '',
				'procure_aborted_prostatectomy' => '',
				'procure_curietherapy' => ''
			);
			$data[$participant_id]['EventDetail']['total_ngml'] = '';
			$data[$participant_id]['TreatmentMaster']['start_date'] = '';
			$data[$participant_id]['TreatmentMaster']['start_date_accuracy'] = '';
		}
		if(sizeof($data) > self::$display_limit) {
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
		$treatment_control_id = $tx_controls['procure follow-up worksheet - treatment']['id'];
		$tx_join = array(
				'table' => 'procure_txd_followup_worksheet_treatments',
				'alias' => 'TreatmentDetail',
				'type' => 'INNER',
				'conditions' => array('TreatmentDetail.treatment_master_id = TreatmentMaster.id'));
		$conditions = array(
				'TreatmentMaster.participant_id' => $participant_ids,
				'TreatmentMaster.treatment_control_id' => $treatment_control_id,
				'TreatmentDetail.treatment_type' => 'prostatectomy');
		$all_participants_prostatectomy = $treatment_model->find('all', array('conditions' => $conditions, 'joins' => array($tx_join)));
		foreach($all_participants_prostatectomy as $new_prostatectomy) {
			$participant_id = $new_prostatectomy['TreatmentMaster']['participant_id'];
			$data[$participant_id]['TreatmentMaster']['start_date'] = $new_prostatectomy['TreatmentMaster']['start_date'];
			$data[$participant_id]['TreatmentMaster']['start_date_accuracy'] = $new_prostatectomy['TreatmentMaster']['start_date_accuracy'];
		}
		$conditions = array(
				'TreatmentMaster.participant_id' => $participant_ids,
				'TreatmentMaster.treatment_control_id' => $treatment_control_id,
				'TreatmentMaster.start_date IS NOT NULL',
				'OR' => array("TreatmentDetail.treatment_type LIKE '%radiotherapy%'", "TreatmentDetail.treatment_type LIKE '%hormonotherapy%'", "TreatmentDetail.treatment_type LIKE '%chemotherapy%'"));
		$all_participants_treatment = $treatment_model->find('all', array('conditions' => $conditions, 'joins' => array($tx_join)));
		foreach($all_participants_treatment as $new_treatment) {
			$participant_id = $new_treatment['TreatmentMaster']['participant_id'];
			$pathology_report_date = $data[$participant_id]['TreatmentMaster']['start_date'];
			$pathology_report_date_accuracy = $data[$participant_id]['TreatmentMaster']['start_date_accuracy'];
			if($pathology_report_date) {
				$administrated_treatment_types = array();
				if(preg_match('/chemotherapy/', $new_treatment['TreatmentDetail']['treatment_type'])) $administrated_treatment_types[] = 'chemo';
				if(preg_match('/hormonotherapy/', $new_treatment['TreatmentDetail']['treatment_type'])) $administrated_treatment_types[] = 'hormono';
				if(preg_match('/radiotherapy/', $new_treatment['TreatmentDetail']['treatment_type'])) $administrated_treatment_types[] = 'radio';
				if($administrated_treatment_types) {
					if($pathology_report_date_accuracy != 'c' || $new_treatment['TreatmentMaster']['start_date_accuracy'] != 'c') {
						$inaccurate_date = true;
						$data[$participant_id][0]['procure_inaccurate_date_use'] = 'y';
					}
					if($new_treatment['TreatmentMaster']['start_date'] < $pathology_report_date) {
						foreach($administrated_treatment_types as $tx_type) $data[$participant_id][0]['procure_pre_op_'.$tx_type] = 'y';
					} else if($new_treatment['TreatmentMaster']['start_date'] > $pathology_report_date) {
						foreach($administrated_treatment_types as $tx_type) $data[$participant_id][0]['procure_post_op_'.$tx_type] = 'y';
					}
				}
			}
		}
		$conditions = array(
				'TreatmentMaster.participant_id' => $participant_ids,
				'TreatmentMaster.treatment_control_id' => $treatment_control_id,
				'TreatmentDetail.treatment_type' => array('aborted prostatectomy', 'curietherapy'));
		$all_participants_other_treatment = $treatment_model->find('all', array('conditions' => $conditions, 'joins' => array($tx_join)));
		foreach($all_participants_other_treatment as $new_other_treatment) {
			$participant_id = $new_other_treatment['TreatmentMaster']['participant_id'];
			if($new_other_treatment['TreatmentDetail']['treatment_type'] == 'curietherapy') {
				$data[$participant_id][0]['procure_curietherapy'] = 'y';
			} else {
				$data[$participant_id][0]['procure_aborted_prostatectomy'] = 'y';
			}
		}
		
		//Analyze participants psa
		$event_model = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
		$event_control_id = $event_controls['procure follow-up worksheet - aps']['id'];
		$all_participants_psa = $event_model->find('all', array('conditions' => array('EventMaster.participant_id' => $participant_ids, 'EventMaster.event_control_id' => $event_control_id, 'EventMaster.event_date IS NOT NULL')));
		foreach($all_participants_psa as $new_psa) {
			$participant_id = $new_psa['EventMaster']['participant_id'];
			$pathology_report_date = $data[$participant_id]['TreatmentMaster']['start_date'];
			$pathology_report_date_accuracy = $data[$participant_id]['TreatmentMaster']['start_date_accuracy'];
			if($pathology_report_date) {
				if($pathology_report_date_accuracy != 'c' || $new_psa['EventMaster']['event_date_accuracy'] != 'c') {
					$inaccurate_date = true;
					$data[$participant_id][0]['procure_inaccurate_date_use'] = 'y';
				}
				if($new_psa['EventMaster']['event_date'] < $pathology_report_date) {
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
			}
		}
		
		if($inaccurate_date) AppController::addWarningMsg(__('at least one participant summary is based on inaccurate date'));
		
		return array(
				'header' => $header,
				'data' => $data,
				'columns_names' => null,
				'error_msg' => null);
	}
	
}