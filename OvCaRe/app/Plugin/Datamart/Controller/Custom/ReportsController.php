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
								'medical_record_number' => null,
								'personal_health_number' => null,
								'bcca_number' => null)
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
	
	function ovcareCasesReceivedMonthlyReport($parameters) {
		if(!AppController::checkLinkPermission('/InventoryManagement/Collections/detail') || !AppController::checkLinkPermission('/InventoryManagement/Collections/detail')){
			return array(
				'header' => array(),
				'data' => array(),
				'columns_names' => null,
				'error_msg' => 'you need privileges to access this page');
		}
		
		// 1- Build Criteria
		
		$years = array_filter($parameters['0']['year']);	
		if(empty($years)) {
			return array(
				'header' => array(),
				'data' => array(),
				'columns_names' => null,
				'error_msg' => 'please select the year of this report');
		} else if(sizeof($years) > 1) {
			return array(
				'header' => array(),
				'data' => array(),
				'columns_names' => null,
				'error_msg' => 'only one year can be selected');
		}
		$year = array_shift($years);
		$start_date_for_sql = AppController::getFormatedDatetimeSQL(array('year' => $year), 'start');
		$end_date_for_sql = AppController::getFormatedDatetimeSQL(array('year' => $year), 'end');
		
		$study_summary_ids = implode(',', array_filter($parameters[0]['study_summary_id']));
		
		$linked_to = array_filter($parameters[0]['ovcare_study_applied_to']);
		if($linked_to) {
			if(sizeof($linked_to) > 1)
				return array(
					'header' => array(),
					'data' => array(),
					'columns_names' => null,
					'error_msg' => 'only one linked to value can be selected');
			$linked_to = array_shift($linked_to);
		} else {
			$linked_to = 'all';
		}		
		
		// 2- Build header
		
		$header = array(
			'title' => __('studies')." on $year : ",
			'description' => null);
		if($study_summary_ids) {
			$query = "SELECT title FROM study_summaries WHERE id IN ($study_summary_ids) AND deleted <> 1";
			$study_titles = array();
			foreach($this->Report->tryCatchQuery($query) as $new_study) $study_titles[] = "'".$new_study['study_summaries']['title']."'";
			$header['title'] .= implode(' & ', $study_titles);
			$header['description'] = __('linked to').' : '.($linked_to == 'all'? __('all records') : __($linked_to));
		} else {
			$header['title'] = __('all')." on $year (".__('no study selection').')';
		}
		
		// 3- Get data
		
		$data = array();
		for($id = 1; $id < 13; $id++) $data["ovcare_month_$id"] = array();
		
		$sample_control_model = AppModel::getInstance("InventoryManagement", "SampleControl", true);
		$columns_names = array();
		foreach($sample_control_model->getPermissibleSamplesArray(null) as $new_specimen) $columns_names[__($new_specimen['SampleControl']['sample_type'])] = __($new_specimen['SampleControl']['sample_type']);
		ksort($columns_names);	
		
		$total_nbr = array();
		
		$query = "SELECT count(*) AS nbr_of_cases, collection_month, sample_type
			FROM (
				SELECT DISTINCT col.participant_id, 
				MONTH(col.collection_datetime) AS collection_month,
				sc.sample_type
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id AND sc.sample_category = 'specimen'
				WHERE col.participant_id IS NOT NULL
				AND col.participant_id != '0'
				AND (col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql') 
				AND col.deleted != '1'
				AND sm.deleted != '1'
			) AS res GROUP BY collection_month, sample_type
			ORDER BY sample_type";
		$collection_res = $this->Report->tryCatchQuery($query);
		foreach($collection_res as $new_data) {
				$column_key = __($new_data['res']['sample_type']);
				$data['ovcare_month_'.$new_data['res']['collection_month']][$column_key] = $new_data['0']['nbr_of_cases'];
				$columns_names[$column_key] = $column_key;
				if(!isset($total_nbr[$column_key])) $total_nbr[$column_key] = 0;
				$total_nbr[$column_key] += $new_data['0']['nbr_of_cases'];
		}
		
		if($study_summary_ids) {
			$link_index = 0;
			if(preg_match('/collection/', $linked_to)) $link_index += 1;
			if(preg_match('/aliquot/', $linked_to)) $link_index += 2;
			if(preg_match('/event/', $linked_to)) $link_index += 4;
			if(!$link_index) $link_index = 7;
			
			$study_queries = array();
			if(in_array($link_index, array(1,3,7))) {
				$study_queries[] = "SELECT DISTINCT col.participant_id,
					MONTH(col.collection_datetime) AS collection_month,
					sm.initial_specimen_sample_type,
					st.title AS study
					FROM collections AS col
					INNER JOIN study_summaries AS st ON col.ovcare_study_summary_id = st.id
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id
					WHERE col.participant_id IS NOT NULL AND col.participant_id != '0' AND col.deleted != '1'
					AND (col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql')
					AND sm.deleted != '1'
					AND st.deleted != '1' AND st.id IN ($study_summary_ids)";
			}
			if(in_array($link_index, array(2,3,6,7))) {
				$study_queries[] = "SELECT DISTINCT col.participant_id,
					MONTH(col.collection_datetime) AS collection_month,
					sm.initial_specimen_sample_type,
					st.title AS study
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id
					INNER JOIN aliquot_masters AS am ON sm.id = am.sample_master_id 
					INNER JOIN study_summaries AS st ON am.study_summary_id = st.id
					WHERE col.participant_id IS NOT NULL AND col.participant_id != '0' AND col.deleted != '1'
					AND (col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql')
					AND sm.deleted != '1'
					AND am.deleted != '1'
					AND st.deleted != '1' AND st.id IN ($study_summary_ids)";
			}		
			if(in_array($link_index, array(4,6,7))) {
				$study_queries[] = "SELECT DISTINCT col.participant_id,
				MONTH(col.collection_datetime) AS collection_month,
				sm.initial_specimen_sample_type,
				st.title AS study
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id
				INNER JOIN aliquot_masters AS am ON sm.id = am.sample_master_id
				INNER JOIN aliquot_internal_uses AS au ON am.id = au.aliquot_master_id
				INNER JOIN study_summaries AS st ON au.study_summary_id = st.id
				WHERE col.participant_id IS NOT NULL AND col.participant_id != '0' AND col.deleted != '1'
				AND (col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql')
				AND sm.deleted != '1'
				AND am.deleted != '1'
				AND au.deleted <> 1
				AND st.deleted != '1' AND st.id IN ($study_summary_ids)";
			}
			if(!$study_queries) $this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
			$study_queries = implode(' UNION ALL ', $study_queries);
			
			$query = "SELECT count(*) AS nbr_of_cases, collection_month, initial_specimen_sample_type, study
				FROM (
					SELECT DISTINCT res2.participant_id,
					res2.collection_month,
					res2.initial_specimen_sample_type,
					res2.study
					FROM (
						$study_queries
					) res2
				) AS res GROUP BY collection_month, initial_specimen_sample_type, study
				ORDER BY study, initial_specimen_sample_type";
			
			$collection_res = $this->Report->tryCatchQuery($query);
			foreach($collection_res as $new_data) {
				$column_key = $new_data['res']['study'].' - '.__($new_data['res']['initial_specimen_sample_type']);
				$data['ovcare_month_'.$new_data['res']['collection_month']][$column_key] = $new_data['0']['nbr_of_cases'];
				$columns_names[$column_key] = $column_key;
				if(!isset($total_nbr[$column_key])) $total_nbr[$column_key] = 0;
				$total_nbr[$column_key] += $new_data['0']['nbr_of_cases'];
			}	
		}
		
		$data['ovcare_total'] = $total_nbr;
		
		$array_to_return = array(
			'header' => $header,
			'data' => array('0' => $data),
			'columns_names' => array_values($columns_names),
			'error_msg' => null);
		
		return $array_to_return;
	}
	
	function ovcareCasesReceivedAnnualReport($parameters) {
		if(!AppController::checkLinkPermission('/InventoryManagement/Collections/detail') || !AppController::checkLinkPermission('/InventoryManagement/Collections/detail')){
			return array(
				'header' => array(),
				'data' => array(),
				'columns_names' => null,
				'error_msg' => 'you need privileges to access this page');
		}
		
		// 1- Build Criteria
		
		$study_summary_ids = implode(',', array_filter($parameters[0]['study_summary_id']));
		$linked_to = array_filter($parameters[0]['ovcare_study_applied_to']);
		if($linked_to) {
			if(sizeof($linked_to) > 1)
				return array(
					'header' => array(),
					'data' => array(),
					'columns_names' => null,
					'error_msg' => 'only one linked to value can be selected');
			$linked_to = array_shift($linked_to);
		} else {
			$linked_to = 'all';
		}
		
		// 2- Build header
		
		$header = array(
			'title' => __('study').' : '.__('no study selection'), 
			'description' => null);
		if($study_summary_ids) {
			$query = "SELECT title FROM study_summaries WHERE id IN ($study_summary_ids) AND deleted <> 1";
			$study_titles = array();
			foreach($this->Report->tryCatchQuery($query) as $new_study) $study_titles[] = "'".$new_study['study_summaries']['title']."'";
			$header['title'] = __('study').' : '.implode(' & ', $study_titles);
			$header['description'] = __('linked to').' : '.($linked_to == 'all'? __('all records') : __($linked_to));			
		}
		
		// 3- Get data
		$data = array('ovcare_year_other' => array());
		for($id = 2000; $id < 2021; $id++) $data["ovcare_year_$id"] = array();
		
		$sample_control_model = AppModel::getInstance("InventoryManagement", "SampleControl", true);
		$columns_names = array();
		foreach($sample_control_model->getPermissibleSamplesArray(null) as $new_specimen) $columns_names[__($new_specimen['SampleControl']['sample_type'])] = __($new_specimen['SampleControl']['sample_type']);
		ksort($columns_names);	
		
		$total_nbr = array();
		
		$query = "SELECT count(*) AS nbr_of_cases, collection_year, sample_type
			FROM (
				SELECT DISTINCT col.participant_id, 
				YEAR(col.collection_datetime) AS collection_year,
				sc.sample_type
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id AND sc.sample_category = 'specimen'
				WHERE col.participant_id IS NOT NULL
				AND col.participant_id != '0'
				AND col.deleted != '1'
				AND sm.deleted != '1'
			) AS res GROUP BY collection_year, sample_type
			ORDER BY sample_type";
		$collection_res = $this->Report->tryCatchQuery($query);
		foreach($collection_res as $new_data) {
				$column_key = __($new_data['res']['sample_type']);	
				If(!is_null($new_data['res']['collection_year']) && $new_data['res']['collection_year'] >= '2000' && $new_data['res']['collection_year'] <= '2020') {
					$data['ovcare_year_'.$new_data['res']['collection_year']][$column_key] = $new_data['0']['nbr_of_cases'];
				} else {
					if(!array_key_exists($column_key, $data['ovcare_year_other'])) $data['ovcare_year_other'][$column_key]  = 0;
					$data['ovcare_year_other'][$column_key] += $new_data['0']['nbr_of_cases'];
				}
				$columns_names[$column_key] = $column_key;
				if(!isset($total_nbr[$column_key])) $total_nbr[$column_key] = 0;
				$total_nbr[$column_key] += $new_data['0']['nbr_of_cases'];
		}
		
		if($study_summary_ids) {
			$link_index = 0;
			if(preg_match('/collection/', $linked_to)) $link_index += 1;
			if(preg_match('/aliquot/', $linked_to)) $link_index += 2;
			if(preg_match('/event/', $linked_to)) $link_index += 4;
			if(!$link_index) $link_index = 7;
			
			$study_queries = array();
			if(in_array($link_index, array(1,3,7))) {
				$study_queries[] = "SELECT DISTINCT col.participant_id,
					YEAR(col.collection_datetime) AS collection_year,
					sm.initial_specimen_sample_type,
					st.title AS study
					FROM collections AS col
					INNER JOIN study_summaries AS st ON col.ovcare_study_summary_id = st.id
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id
					WHERE col.participant_id IS NOT NULL AND col.participant_id != '0' AND col.deleted != '1'
					AND sm.deleted != '1'
					AND st.deleted != '1' AND st.id IN ($study_summary_ids)";
			}
			if(in_array($link_index, array(2,3,6,7))) {
				$study_queries[] = "SELECT DISTINCT col.participant_id,
					YEAR(col.collection_datetime) AS collection_year,
					sm.initial_specimen_sample_type,
					st.title AS study
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id
					INNER JOIN aliquot_masters AS am ON sm.id = am.sample_master_id 
					INNER JOIN study_summaries AS st ON am.study_summary_id = st.id
					WHERE col.participant_id IS NOT NULL AND col.participant_id != '0' AND col.deleted != '1'
					AND sm.deleted != '1'
					AND am.deleted != '1'
					AND st.deleted != '1' AND st.id IN ($study_summary_ids)";
			}		
			if(in_array($link_index, array(4,6,7))) {
				$study_queries[] = "SELECT DISTINCT col.participant_id,
				YEAR(col.collection_datetime) AS collection_year,
				sm.initial_specimen_sample_type,
				st.title AS study
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id
				INNER JOIN aliquot_masters AS am ON sm.id = am.sample_master_id
				INNER JOIN aliquot_internal_uses AS au ON am.id = au.aliquot_master_id
				INNER JOIN study_summaries AS st ON au.study_summary_id = st.id
				WHERE col.participant_id IS NOT NULL AND col.participant_id != '0' AND col.deleted != '1'
				AND sm.deleted != '1'
				AND am.deleted != '1'
				AND au.deleted <> 1
				AND st.deleted != '1' AND st.id IN ($study_summary_ids)";
			}
			if(!$study_queries) $this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
			$study_queries = implode(' UNION ALL ', $study_queries);
			$query = "SELECT count(*) AS nbr_of_cases, collection_year, initial_specimen_sample_type, study
				FROM (
					SELECT DISTINCT res2.participant_id,
					res2.collection_year,
					res2.initial_specimen_sample_type,
					res2.study
					FROM (
						$study_queries
					) AS res2
				) AS res GROUP BY collection_year, initial_specimen_sample_type, study
				ORDER BY initial_specimen_sample_type";
			$collection_res = $this->Report->tryCatchQuery($query);
			foreach($collection_res as $new_data) {
				$column_key = $new_data['res']['study'].' - '.__($new_data['res']['initial_specimen_sample_type']);
				If(!is_null($new_data['res']['collection_year']) && $new_data['res']['collection_year'] >= '2000' && $new_data['res']['collection_year'] <= '2020') {
					$data['ovcare_year_'.$new_data['res']['collection_year']][$column_key] = $new_data['0']['nbr_of_cases'];
				} else {
					if(!array_key_exists($column_key, $data['ovcare_year_other'])) $data['ovcare_year_other'][$column_key]  = 0;
					$data['ovcare_year_other'][$column_key] += $new_data['0']['nbr_of_cases'];
				}
				$columns_names[$column_key] = $column_key;
				if(!isset($total_nbr[$column_key])) $total_nbr[$column_key] = 0;
				$total_nbr[$column_key] += $new_data['0']['nbr_of_cases'];
			}
		}
		
		$data['ovcare_total'] = $total_nbr;
		
		$array_to_return = array(
			'header' => $header,
			'data' => array('0' => $data),
			'columns_names' => array_values($columns_names),
			'error_msg' => null);
		
		return $array_to_return;
	}
	
}