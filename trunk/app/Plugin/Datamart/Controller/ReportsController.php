<?php
class ReportsController extends DatamartAppController {
	var $uses = array(
		"Datamart.Report",
		"Datamart.DatamartStructure",
		"Datamart.BrowsingResult",
		"Structure");

	var $paginate = array('Report' => array('limit' => pagination_amount , 'order' => 'Report.name ASC'));
		
	function index(){
		$_SESSION['report']['search_criteria'] = array(); // clear SEARCH criteria
		
		$this->request->data = $this->paginate($this->Report, array('Report.flag_active' => '1'));
		
		// Translate data
		foreach($this->request->data as $key => $data) {
			$this->request->data[$key]['Report']['name'] = __($this->request->data[$key]['Report']['name']);
			$this->request->data[$key]['Report']['description'] = __($this->request->data[$key]['Report']['description']);
		}
		
		$this->Structures->set("reports");
	}
	
	function manageReport($report_id, $csv_creation = false) {
		// Get report data
		$report = $this->Report->find('first',array('conditions' => array('Report.id' => $report_id, 'Report.flag_active' => '1')));		
		if(empty($report) 
		|| empty($report['Report']['function'])
		|| empty($report['Report']['form_alias_for_results'])
		|| empty($report['Report']['form_type_for_results'])
		|| ($report['Report']['form_type_for_results'] != 'index' && !empty($report['Report']['associated_datamart_structure_id']))) {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		// Set menu variables
		$this->set( 'atim_menu_variables', array('Report.id' => $report_id));
		$this->set('atim_menu', $this->Menus->get('/Datamart/Reports/manageReport/%%Report.id%%/'));
		
		if(empty($this->request->data) && (!empty($report['Report']['form_alias_for_search'])) && (!$csv_creation)) {
			
			// ** SEARCH FROM DISPLAY **
			
			$this->Structures->set($report['Report']['form_alias_for_search'], 'search_form_structure');	
			$_SESSION['report']['search_criteria'] = array(); // clear SEARCH criteria	
		
		} else {
			
			// ** RESULTS/ACTIONS MANAGEMENT **
			
			$linked_datamart_structure = null;
			$LinkedModel = null;
			if($report['Report']['form_type_for_results'] == 'index' && $report['Report']['associated_datamart_structure_id']) {
				// Load linked structure and model if required
				$linked_datamart_structure = $this->DatamartStructure->find('first', array('conditions' => array("DatamartStructure.id" => $report['Report']['associated_datamart_structure_id'])));
				if(empty($linked_datamart_structure)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				$LinkedModel = AppModel::getInstance($linked_datamart_structure['DatamartStructure']['plugin'], $linked_datamart_structure['DatamartStructure']['model'], true);
				$this->set('linked_datamart_structure_id', $report['Report']['associated_datamart_structure_id']);
			}
			
			// Set criteria to build report/csv
			$criteria_to_build_report = null;
			if($csv_creation) {
				if(array_key_exists('Config', $this->request->data)) {
					$config = array_merge($this->request->data['Config'], (array_key_exists(0, $this->request->data)? $this->request->data[0] : array()));
					unset($this->request->data[0]);
					unset($this->request->data['Config']);
					$this->configureCsv($config);
				}
				// Get criteria from session data for csv 
				$criteria_to_build_report = $_SESSION['report']['search_criteria'];
				if($LinkedModel) {
					// Take care about selected items
					if(!isset($this->request->data[$linked_datamart_structure['DatamartStructure']['model']][$LinkedModel->primaryKey])) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					$ids = array_filter($this->request->data[$linked_datamart_structure['DatamartStructure']['model']][$LinkedModel->primaryKey]);
					if(empty($ids)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					$criteria_to_build_report[$linked_datamart_structure['DatamartStructure']['model']][$LinkedModel->primaryKey] = $ids;
				}		
			} else {
				// Get criteria from search form
				$criteria_to_build_report = empty($this->request->data)? array() : $this->request->data;
				// Manage data from csv file			
				foreach($criteria_to_build_report as $model => $fields_parameters) {
					foreach($fields_parameters as $field => $parameters) {
						if(preg_match('/^(.+)_with_file_upload$/', $field, $matches)) {
							$matched_field_name = $matches[1];
							if(!isset($criteria_to_build_report[$model][$matched_field_name])) $criteria_to_build_report[$model][$matched_field_name] = array();
							$handle = fopen($parameters['tmp_name'], "r");
							while (($csv_data = fgetcsv($handle, 1000, csv_separator, '"')) !== FALSE) {
								$criteria_to_build_report[$model][$matched_field_name][] = $csv_data[0];
							}
							fclose($handle);
							unset($criteria_to_build_report[$model][$field]);
						}
					}
				}	
				// Manage data when launched from databrowser node having a nbr of elements > $display_limit
				if(array_key_exists('node', $criteria_to_build_report)) {
					$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $criteria_to_build_report['node']['id'])));
					$datamart_structure = $browsing_result['DatamartStructure'];
					if(empty($browsing_result) || empty($datamart_structure)) {
						$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					}
					// Get model and key name
					$model = null;
					$lookup_key_name = null;
					if($datamart_structure['control_master_model']){
						if(isset($criteria_to_build_report[$datamart_structure['model']])){
							$model_instance = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['model'], true);
							$model = $datamart_structure['model'];
							$lookup_key_name = $model_instance->primaryKey;
						}else{
							$model_instance = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['control_master_model'], true);
							$model = $datamart_structure['control_master_model'];
							$lookup_key_name = $model_instance->primaryKey;
						}	
					}else{
						$model = $datamart_structure['model'];
						$model_instance = AppModel::getInstance($datamart_structure['plugin'], $datamart_structure['model'], true);
						$lookup_key_name = $model_instance->primaryKey;
					}
					if($criteria_to_build_report[ $model ][ $lookup_key_name ] == 'all') $criteria_to_build_report[ $model ][ $lookup_key_name ] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
				}
				// Load search criteria in session
				$_SESSION['report']['search_criteria'] = $criteria_to_build_report;
			}
		
			// Get and manage results
			$data_returned_by_fct = call_user_func_array(array($this , $report['Report']['function']), array($criteria_to_build_report));
			if(empty($data_returned_by_fct) 
			|| (!array_key_exists('header', $data_returned_by_fct))
			|| (!array_key_exists('data', $data_returned_by_fct)) 
			|| (!array_key_exists('columns_names', $data_returned_by_fct)) 
			|| (!array_key_exists('error_msg', $data_returned_by_fct))) {
				// Wrong array keys returned by custom function
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			
			} else if(!empty($data_returned_by_fct['error_msg'])) {
				// Error detected by custom function -> Display custom error message with empty form
				$this->request->data = array();
				$this->Structures->set('empty', 'result_form_structure');
				$this->set('result_form_type', 'index');
				$this->set('display_new_search', (empty($report['Report']['form_alias_for_search'])? false:true));
				$this->set('csv_creation', false);
				$this->Report->validationErrors[][] = $data_returned_by_fct['error_msg'];
			
			} else {
				// Set data for display/csv
				$this->request->data = $data_returned_by_fct['data'];
				$this->Structures->set($report['Report']['form_alias_for_results'], 'result_form_structure');
				$this->set('result_form_type', $report['Report']['form_type_for_results']);
				$this->set('result_header', $data_returned_by_fct['header']);
				$this->set('result_columns_names', $data_returned_by_fct['columns_names']);
				$this->set('display_new_search', (empty($report['Report']['form_alias_for_search'])? false:true));
				$this->set('csv_creation', $csv_creation);
				
				if($csv_creation) {
					Configure::write('debug', 0);
					$this->layout = false;
					
				} else if($linked_datamart_structure) {	
					//Code to be able to launch actions from report linked to structure and model
					$this->set('linked_datamart_structure_model_name', $linked_datamart_structure['DatamartStructure']['model']);
					$this->set('linked_datamart_structure_key_name', $LinkedModel->primaryKey);
					if($linked_datamart_structure['DatamartStructure']['index_link']) 	$this->set('linked_datamart_structure_links', $linked_datamart_structure['DatamartStructure']['index_link']);
					$linked_datamart_structure_actions = $this->DatamartStructure->getDropdownOptions(
						$linked_datamart_structure['DatamartStructure']['plugin'],
						$linked_datamart_structure['DatamartStructure']['model'], 
						$LinkedModel->primaryKey, 
						null, 
						null, 
						null, 
						null,
						false);
					$csv_action = "javascript:setCsvPopup('Datamart/Reports/manageReport/$report_id/1/');";
					$linked_datamart_structure_actions[] = array(
							'value' => '0',
							'label' => __('export as CSV file (comma-separated values)'),
							'value' => sprintf($csv_action, 0)
					);
					$linked_datamart_structure_actions[] = array(
						'label'	=> __("initiate browsing"),
						'value'	=> "Datamart/Browser/batchToDatabrowser/".$linked_datamart_structure['DatamartStructure']['model']."/report/"
					);
					$this->set('linked_datamart_structure_actions', $linked_datamart_structure_actions);
				}
			}
		}
	}

	// -------------------------------------------------------------------------------------------------------------------
	// FUNCTIONS ADDED TO THE CONTROLLER AS EXAMPLE
	// -------------------------------------------------------------------------------------------------------------------
	
	function bankActiviySummary($parameters) {
		// 1- Build Header
		$start_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_start']['year'], $parameters[0]['report_date_range_start']['month'], $parameters[0]['report_date_range_start']['day']);
		$end_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_end']['year'], $parameters[0]['report_date_range_end']['month'], $parameters[0]['report_date_range_end']['day']);
		$header = array(
			'title' => __('from').' '.(empty($parameters[0]['report_date_range_start']['year'])?'?':$start_date_for_display).' '.__('to').' '.(empty($parameters[0]['report_date_range_end']['year'])?'?':$end_date_for_display), 
			'description' => 'n/a');

		// 2- Search data
		$start_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_start'], 'start');
		$end_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_end'], 'end');

		$search_on_date_range = true;
		if((strpos($start_date_for_sql, '-9999') === 0) && (strpos($end_date_for_sql, '9999') === 0)) $search_on_date_range = false;
		
		// Get new participant
		if(!isset($this->Participant)) {
			$this->Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		}
		$conditions = $search_on_date_range? array("Participant.created >= '$start_date_for_sql'", "Participant.created <= '$end_date_for_sql'") : array();
		$data['0']['new_participants_nbr'] = $this->Participant->find('count', (array('conditions' => $conditions)));		

		// Get new consents obtained
		if(!isset($this->ConsentMaster)) {
			$this->ConsentMaster = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
		}
		$conditions = $search_on_date_range? array("ConsentMaster.consent_signed_date >= '$start_date_for_sql'", "ConsentMaster.consent_signed_date <= '$end_date_for_sql'") : array();
		$all_consent = $this->ConsentMaster->find('count', (array('conditions' => $conditions)));
		$conditions['ConsentMaster.consent_status'] = 'obtained';
		$all_obtained_consent = $this->ConsentMaster->find('count', (array('conditions' => $conditions)));
		$data['0']['obtained_consents_nbr'] = "$all_obtained_consent/$all_consent";
		
		// Get new collections
		$conditions = $search_on_date_range? "col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql'" : 'TRUE';
		$new_collections_nbr = $this->Report->tryCatchQuery(
			"SELECT COUNT(*) FROM (
				SELECT DISTINCT col.participant_id 
				FROM sample_masters AS sm 
				INNER JOIN collections AS col ON col.id = sm.collection_id 
				WHERE col.participant_id IS NOT NULL 
				AND col.participant_id != '0'
				AND ($conditions)
				AND col.deleted != '1'
				AND sm.deleted != '1'
			) AS res;");
		$data['0']['new_collections_nbr'] = $new_collections_nbr[0][0]['COUNT(*)'];
		
		$array_to_return = array(
			'header' => $header, 
			'data' => $data, 
			'columns_names' => null,
			'error_msg' => null);
		
		return $array_to_return;
	}
	
	function sampleAndDerivativeCreationSummary($parameters) {
			
		// 1- Build Header
		$start_date_for_display = AppController::getFormatedDateString($parameters[0]['report_datetime_range_start']['year'], $parameters[0]['report_datetime_range_start']['month'], $parameters[0]['report_datetime_range_start']['day']);
		$end_date_for_display = AppController::getFormatedDateString($parameters[0]['report_datetime_range_end']['year'], $parameters[0]['report_datetime_range_end']['month'], $parameters[0]['report_datetime_range_end']['day']);
		
		$header = array(
			'title' => __('from').' '.(empty($parameters[0]['report_datetime_range_start']['year'])?'?':$start_date_for_display).' '.__('to').' '.(empty($parameters[0]['report_datetime_range_end']['year'])?'?':$end_date_for_display), 
			'description' => 'n/a');
		
		$bank_ids = array();
		foreach($parameters[0]['bank_id'] as $bank_id) if(!empty($bank_id)) $bank_ids[] = $bank_id;
		if(!empty($bank_ids)) {
			$Bank = AppModel::getInstance("Administrate", "Bank", true);
			$bank_list = $Bank->find('all', array('conditions' => array('id' => $bank_ids)));
			$bank_names = array();
			foreach($bank_list as $new_bank) $bank_names[] = $new_bank['Bank']['name'];
			$header['description'] = __('bank'). ': '.implode(',',$bank_names);
		}	

		// 2- Search data
		
		$bank_conditions = empty($bank_ids)? 'TRUE' : 'col.bank_id IN ('. implode(',',$bank_ids).')';
			
		$start_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_datetime_range_start'], 'start');
		$end_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_datetime_range_end'], 'end');
		
		$search_on_date_range = true;
		if((strpos($start_date_for_sql, '-9999') === 0) && (strpos($end_date_for_sql, '9999') === 0)) $search_on_date_range = false;
		
		$res_final = array();
		$tmp_res_final = array();
		
		// Work on specimen
		
		$conditions = $search_on_date_range? "col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql'" : 'TRUE';
		$res_samples = $this->Report->tryCatchQuery(
			"SELECT COUNT(*), sc.sample_type
			FROM sample_masters AS sm
			INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
			INNER JOIN collections AS col ON col.id = sm.collection_id
			WHERE col.participant_id IS NOT NULL
			AND col.participant_id != '0'
			AND sc.sample_category = 'specimen'
			AND ($conditions)
			AND ($bank_conditions)
			AND sm.deleted != '1'
			GROUP BY sample_type;"
		);		
		$res_participants = $this->Report->tryCatchQuery(
			"SELECT COUNT(*), res.sample_type FROM (
				SELECT DISTINCT col.participant_id, sc.sample_type
				FROM sample_masters AS sm
				INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
				INNER JOIN collections AS col ON col.id = sm.collection_id
				WHERE col.participant_id IS NOT NULL
				AND col.participant_id != '0'
				AND sc.sample_category = 'specimen'
				AND ($conditions)
				AND ($bank_conditions)
				AND sm.deleted != '1'
			) AS res GROUP BY res.sample_type;"
		);		
		
		foreach($res_samples as $data) {
			$tmp_res_final['specimen-'.$data['sc']['sample_type']] = array(
				'SampleControl' => array('sample_category' => 'specimen', 'sample_type'=> $data['sc']['sample_type']),
				'0' => array('created_samples_nbr' => $data[0]['COUNT(*)'], 'matching_participant_number' => null));
		}
		foreach($res_participants as $data) {
			$tmp_res_final['specimen-'.$data['res']['sample_type']]['0']['matching_participant_number'] = $data[0]['COUNT(*)'];
		}
		
		// Work on derivative
		
		$conditions = $search_on_date_range? "der.creation_datetime >= '$start_date_for_sql' AND der.creation_datetime <= '$end_date_for_sql'" : 'TRUE';
		$res_samples = $this->Report->tryCatchQuery(
				"SELECT COUNT(*), sc.sample_type
				FROM sample_masters AS sm
				INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
				INNER JOIN collections AS col ON col.id = sm.collection_id
				INNER JOIN derivative_details AS der ON der.sample_master_id = sm.id
				WHERE col.participant_id IS NOT NULL
				AND col.participant_id != '0'
				AND sc.sample_category = 'derivative'
				AND ($conditions)
				AND ($bank_conditions)
				AND sm.deleted != '1'
				GROUP BY sample_type;"
		);
		$res_participants = $this->Report->tryCatchQuery(
			"SELECT COUNT(*), res.sample_type FROM (
					SELECT DISTINCT col.participant_id, sc.sample_type
					FROM sample_masters AS sm
					INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
					INNER JOIN collections AS col ON col.id = sm.collection_id
					INNER JOIN derivative_details AS der ON der.sample_master_id = sm.id
					WHERE col.participant_id IS NOT NULL
					AND col.participant_id != '0'
					AND sc.sample_category = 'derivative'
					AND ($conditions)
					AND ($bank_conditions)
					AND sm.deleted != '1'
			) AS res GROUP BY res.sample_type;"
		);
	
		foreach($res_samples as $data) {
			$tmp_res_final['derivative-'.$data['sc']['sample_type']] = array(
					'SampleControl' => array('sample_category' => 'derivative', 'sample_type'=> $data['sc']['sample_type']),
					'0' => array('created_samples_nbr' => $data[0]['COUNT(*)'], 'matching_participant_number' => null));
		}
		foreach($res_participants as $data) {
			$tmp_res_final['derivative-'.$data['res']['sample_type']]['0']['matching_participant_number'] = $data[0]['COUNT(*)'];
		}		
		
		// Format data for report
		foreach($tmp_res_final as $new_sample_type_data) {
			$res_final[] = $new_sample_type_data;
		}	
			
		$array_to_return = array(
			'header' => $header, 
			'data' => $res_final, 
			'columns_names' => null,
			'error_msg' => null);
		
		return $array_to_return;		
	}
	
	function bankActiviySummaryPerPeriod($parameters) {
		if(empty($parameters[0]['report_date_range_period']['0'])) {
			return array('error_msg' => 'no period has been defined', 'header' => null, 'data' => null, 'columns_names' => null);		
		}
		$month_period = ($parameters[0]['report_date_range_period']['0'] == 'month')? true:false;
		
		// 1- Build Header
		$start_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_start']['year'], $parameters[0]['report_date_range_start']['month'], $parameters[0]['report_date_range_start']['day']);
		$end_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_end']['year'], $parameters[0]['report_date_range_end']['month'], $parameters[0]['report_date_range_end']['day']);
		$header = array(
			'title' => __('from').' '.(empty($parameters[0]['report_date_range_start']['year'])?'?':$start_date_for_display).' '.__('to').' '.(empty($parameters[0]['report_date_range_end']['year'])?'?':$end_date_for_display), 
			'description' => 'n/a');

		// 2- Search data
		$start_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_start'], 'start');
		$end_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_end'], 'end');

		$search_on_date_range = true;
		if((strpos($start_date_for_sql, '-9999') === 0) && (strpos($end_date_for_sql, '9999') === 0)) $search_on_date_range = false;
		
		$arr_format_month_to_string = AppController::getCalInfo(false);
		
		$tmp_res = array();
		$date_key_list = array();
		
		// Get new participant
		$conditions = $search_on_date_range? "Participant.created >= '$start_date_for_sql' AND Participant.created <= '$end_date_for_sql'" : 'TRUE';
		$participant_res = $this->Report->tryCatchQuery(
			"SELECT COUNT(*), YEAR(Participant.created) AS created_year".($month_period? ", MONTH(Participant.created) AS created_month": "").
			" FROM participants AS Participant 
			WHERE ($conditions) AND Participant.deleted != 1 
			GROUP BY created_year".($month_period? ", created_month": "").";");
		foreach($participant_res as $new_data) {
			$date_key = '';
			$date_value = __('unknown');
			if(!empty($new_data['0']['created_year'])) {
				if($month_period) {
					$date_key = $new_data['0']['created_year']."-".((strlen($new_data['0']['created_month']) == 1)?"0":"").$new_data['0']['created_month'];
					$date_value = $arr_format_month_to_string[$new_data['0']['created_month']].' '.$new_data['0']['created_year'];
				} else {
					$date_key = $new_data['0']['created_year'];
					$date_value = $new_data['0']['created_year'];
				}
			}
			
			$date_key_list[$date_key] = $date_value;
			$tmp_res['0']['new_participants_nbr'][$date_value] = $new_data['0']['COUNT(*)'];
		}

		// Get new consents obtained
		$conditions = $search_on_date_range? "ConsentMaster.consent_signed_date >= '$start_date_for_sql' AND ConsentMaster.consent_signed_date <= '$end_date_for_sql'" : 'TRUE';
		$consent_res = $this->Report->tryCatchQuery(
			"SELECT COUNT(*), YEAR(ConsentMaster.consent_signed_date) AS signed_year".($month_period? ", MONTH(ConsentMaster.consent_signed_date) AS signed_month": "").
			" FROM consent_masters AS ConsentMaster
			WHERE ($conditions) AND ConsentMaster.deleted != 1 
			GROUP BY signed_year".($month_period? ", signed_month": "").";");
		foreach($consent_res as $new_data) {
			$date_key = '';
			$date_value = __('unknown');
			if(!empty($new_data['0']['signed_year'])) {
				if($month_period) {
					$date_key = $new_data['0']['signed_year']."-".((strlen($new_data['0']['signed_month']) == 1)?"0":"").$new_data['0']['signed_month'];
					$date_value = $arr_format_month_to_string[$new_data['0']['signed_month']].' '.$new_data['0']['signed_year'];
				} else {
					$date_key = $new_data['0']['signed_year'];
					$date_value = $new_data['0']['signed_year'];
				}
			}
			
			$date_key_list[$date_key] = $date_value;
			$tmp_res['0']['obtained_consents_nbr'][$date_value] = $new_data['0']['COUNT(*)'];
		}
		
		// Get new collections
		$conditions = $search_on_date_range? "col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql'" : 'TRUE';
		$collection_res = $this->Report->tryCatchQuery(
			"SELECT COUNT(*), res.collection_year".($month_period? ", res.collection_month": "")." FROM (
				SELECT DISTINCT col.participant_id, YEAR(col.collection_datetime) AS collection_year".($month_period? ", MONTH(col.collection_datetime) AS collection_month": "").
				" FROM sample_masters AS sm 
				INNER JOIN collections AS col ON col.id = sm.collection_id 
				WHERE col.participant_id IS NOT NULL 
				AND col.participant_id != '0'
				AND ($conditions)
				AND col.deleted != '1'
				AND sm.deleted != '1'
			) AS res
			GROUP BY res.collection_year".($month_period? ", res.collection_month": "").";");
		foreach($collection_res as $new_data) {
			$date_key = '';
			$date_value = __('unknown');
			if(!empty($new_data['res']['collection_year'])) {
				if($month_period) {
					$date_key = $new_data['res']['collection_year']."-".((strlen($new_data['res']['collection_month']) == 1)?"0":"").$new_data['res']['collection_month'];
					$date_value = $arr_format_month_to_string[$new_data['res']['collection_month']].' '.$new_data['res']['collection_year'];
				} else {
					$date_key = $new_data['res']['collection_year'];
					$date_value = $new_data['res']['collection_year'];
				}
			}
			
			$date_key_list[$date_key] = $date_value;
			$tmp_res['0']['new_collections_nbr'][$date_value] = $new_data['0']['COUNT(*)'];
		}
			
		ksort($date_key_list);
		$error_msg = null;
		if(sizeof($date_key_list) > 20) {
			$error_msg = 'number of report columns will be too big, please redefine parameters';
		}
			
		$array_to_return = array(
			'header' => $header, 
			'data' => $tmp_res,
			'columns_names' => array_values($date_key_list),
			'error_msg' => $error_msg);
		
		return $array_to_return;
	}
	
	function ctrnetCatalogueSubmissionFile($parameters) {
			
		// 1- Build Header
		$header = array(
				'title' => __('report_ctrnet_catalogue_name'),
				'description' => 'n/a');
	
		$bank_ids = array();
		foreach($parameters[0]['bank_id'] as $bank_id) if(!empty($bank_id)) $bank_ids[] = $bank_id;
		if(!empty($bank_ids)) {
			$Bank = AppModel::getInstance("Administrate", "Bank", true);
			$bank_list = $Bank->find('all', array('conditions' => array('id' => $bank_ids)));
			$bank_names = array();
			foreach($bank_list as $new_bank) $bank_names[] = $new_bank['Bank']['name'];
			$header['title'] .= ' ('.__('bank'). ': '.implode(',', $bank_names).')';
		}
		
		// 2- Search data
	
		$bank_conditions = empty($bank_ids)? 'TRUE' : 'col.bank_id IN ('. implode(',',$bank_ids).')';
		$aliquot_type_confitions = $parameters[0]['include_core_and_slide'][0]? 'TRUE' : "ac.aliquot_type NOT IN ('core','slide')";
		$whatman_paper_confitions = $parameters[0]['include_whatman_paper'][0]? 'TRUE' : "ac.aliquot_type NOT IN ('whatman paper')";
		$detail_other_count = $parameters[0]['detail_other_count'][0]? true : false;
				
		$data = array();
				
		// **all**
		
		$tmp_data = array('sample_type' => __('total'), 'cases_nbr' => '', 'aliquots_nbr' => '', 'notes' => '');
		
		$sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' 
				AND ($bank_conditions)
				AND ($aliquot_type_confitions) 
				AND am.in_stock IN ('yes - available ','yes - not available')
			) AS res;";		
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		$tmp_data['cases_nbr'] =  $query_results[0][0]['nbr'];
		
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		$tmp_data['aliquots_nbr'] =  $query_results[0][0]['nbr'];

		$data[] = $tmp_data;
		
		// **FFPE**
		
		$tmp_data = array('sample_type' => __('FFPE'), 'cases_nbr' => '', 'aliquots_nbr' => '', 'notes' => __('tissue').' '.__('block').' ('.__('paraffin').')');
		
		$sql = "	
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT  %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				INNER JOIN ad_blocks AS blk ON blk.aliquot_master_id = am.id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ('tissue')
				AND ac.aliquot_type = 'block'
				AND blk.block_type = 'paraffin'
			) AS res;";
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		$tmp_data['cases_nbr'] =  $query_results[0][0]['nbr'];
		
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		$tmp_data['aliquots_nbr'] =  $query_results[0][0]['nbr'];
		
		$data[] = $tmp_data;
		
		// **frozen tissue**
		
		$tmp_data = array('sample_type' => __('frozen tissue'), 'cases_nbr' => '', 'aliquots_nbr' => '', 'notes' => '');
		
		$sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT  %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ('tissue')
				AND ($aliquot_type_confitions) 
				AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin')
			) AS res;";
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		$tmp_data['cases_nbr'] =  $query_results[0][0]['nbr'];
		
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		$tmp_data['aliquots_nbr'] =  $query_results[0][0]['nbr'];
		
		$sql = "
			SELECT DISTINCT sc.sample_type,ac.aliquot_type,blk.block_type
			FROM collections AS col
			INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
			INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
			INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
			INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
			INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
			LEFT JOIN ad_blocks AS blk ON blk.aliquot_master_id = am.id
			WHERE col.deleted != '1' AND ($bank_conditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type IN ('tissue')
				AND ($aliquot_type_confitions) 
			AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin');";
		$query_results = $this->Report->tryCatchQuery($sql);		
		foreach($query_results as $new_type) $tmp_data['notes'] .= (empty($tmp_data['notes'])? '' : ' & ').__($new_type['sc']['sample_type']).' '.__($new_type['ac']['aliquot_type']).(empty($new_type['blk']['block_type'])? '' : ' ('.__($new_type['blk']['block_type']).')');

		$data[] = $tmp_data;		
		
		// **blood**
		// **pbmc**
		// **blood cell**
		// **plasma**
		// **serum**
		// **rna**
		// **dna**
		// **cell culture**
		
		$sample_types = "'blood', 'pbmc', 'blood cell', 'plasma', 'serum', 'rna', 'dna', 'cell culture'";
		
		$tmp_data = array();
		$sql = "
			SELECT count(*) AS nbr,sample_type, aliquot_type FROM (
				SELECT DISTINCT  %%id%%, sc.sample_type, ac.aliquot_type
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ($sample_types)
				AND ($whatman_paper_confitions)	
			) AS res GROUP BY sample_type, aliquot_type;";
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		foreach($query_results as $new_res) {
			$sample_type = $new_res['res']['sample_type'];
			$aliquot_type = $new_res['res']['aliquot_type'];
			$tmp_data[$sample_type.$aliquot_type] = array('sample_type' => __($sample_type).' '.__($aliquot_type), 'cases_nbr' => $new_res[0]['nbr'], 'aliquots_nbr' => '', 'notes' => '');
		}
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		foreach($query_results as $new_res) {
			$sample_type = $new_res['res']['sample_type'];
			$aliquot_type = $new_res['res']['aliquot_type'];
			$tmp_data[$sample_type.$aliquot_type]['aliquots_nbr'] = $new_res[0]['nbr'];
			$data[] = $tmp_data[$sample_type.$aliquot_type];
		}
		
		// **Urine**	

		$tmp_data = array('sample_type' => __('urine'), 'cases_nbr' => '', 'aliquots_nbr' => '', 'notes' => '');
		$sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT  %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type LIKE '%urine%'
			) AS res;";
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		$tmp_data['cases_nbr'] =  $query_results[0][0]['nbr'];
		
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		$tmp_data['aliquots_nbr'] =  $query_results[0][0]['nbr'];
		
		$sql = "
			SELECT DISTINCT sc.sample_type,ac.aliquot_type
			FROM collections AS col
			INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
			INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
			INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
			INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
			WHERE col.deleted != '1' AND ($bank_conditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type LIKE '%urine%'";
		$query_results = $this->Report->tryCatchQuery($sql);
		foreach($query_results as $new_type) $tmp_data['notes'] .= (empty($tmp_data['notes'])? '' : ' & ').__($new_type['sc']['sample_type']).' '.__($new_type['ac']['aliquot_type']);
		
		$data[] = $tmp_data;
		
		// **Ascite**
		
		$tmp_data = array('sample_type' => __('ascite'), 'cases_nbr' => '', 'aliquots_nbr' => '', 'notes' => '');
		$sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT  %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type LIKE '%ascite%'
			) AS res;";
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
				$tmp_data['cases_nbr'] =  $query_results[0][0]['nbr'];
		
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		$tmp_data['aliquots_nbr'] =  $query_results[0][0]['nbr'];

		$sql = "
			SELECT DISTINCT sc.sample_type,ac.aliquot_type
			FROM collections AS col
			INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
			INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
			INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
			INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
			WHERE col.deleted != '1' AND ($bank_conditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type LIKE '%ascite%'";
		$query_results = $this->Report->tryCatchQuery($sql);
		foreach($query_results as $new_type) $tmp_data['notes'] .= (empty($tmp_data['notes'])? '' : ' & ').__($new_type['sc']['sample_type']).' '.__($new_type['ac']['aliquot_type']);		

		$data[] = $tmp_data;
		
		// **other**
		
		$other_conditions = "sc.sample_type NOT LIKE '%ascite%' AND sc.sample_type NOT LIKE '%urine%' AND sc.sample_type NOT IN ('tissue', $sample_types)";
		
		if($detail_other_count) {
			
			$tmp_data = array();
			$sql = "
				SELECT count(*) AS nbr,sample_type, aliquot_type FROM (
					SELECT DISTINCT  %%id%%, sc.sample_type, ac.aliquot_type
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
					INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
					INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
					INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
					WHERE col.deleted != '1' AND ($bank_conditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND ($other_conditions)
				) AS res GROUP BY sample_type, aliquot_type;";
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
			foreach($query_results as $new_res) {
				$sample_type = $new_res['res']['sample_type'];
				$aliquot_type = $new_res['res']['aliquot_type'];
				$tmp_data[$sample_type.$aliquot_type] = array('sample_type' => __($sample_type).' '.__($aliquot_type), 'cases_nbr' => $new_res[0]['nbr'], 'aliquots_nbr' => '', 'notes' => '');
			}
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
			foreach($query_results as $new_res) {
				$sample_type = $new_res['res']['sample_type'];
				$aliquot_type = $new_res['res']['aliquot_type'];
				$tmp_data[$sample_type.$aliquot_type]['aliquots_nbr'] = $new_res[0]['nbr'];
				$data[] = $tmp_data[$sample_type.$aliquot_type];
			}			

		} else {
			
			$tmp_data = array('sample_type' => __('other'), 'cases_nbr' => '', 'aliquots_nbr' => '', 'notes' => '');
			$sql = "
				SELECT count(*) AS nbr FROM (
					SELECT DISTINCT  %%id%%
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
					INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
					INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
					INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
					WHERE col.deleted != '1' AND ($bank_conditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND ($other_conditions)
				) AS res;";
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
			$tmp_data['cases_nbr'] =  $query_results[0][0]['nbr'];
			
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
					$tmp_data['aliquots_nbr'] =  $query_results[0][0]['nbr'];
			
			$sql = "
				SELECT DISTINCT sc.sample_type,ac.aliquot_type
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND ($other_conditions)";
			$query_results = $this->Report->tryCatchQuery($sql);
			foreach($query_results as $new_type) $tmp_data['notes'] .= (empty($tmp_data['notes'])? '' : ' & ').__($new_type['sc']['sample_type']).' '.__($new_type['ac']['aliquot_type']);
			
			$data[] = $tmp_data;
		}
		
		
		// Format data form display
		
		$final_data = array();
		foreach($data as $new_row) {
			if($new_row['cases_nbr']) {
				$final_data[][0] = $new_row;
			}
		}

		$array_to_return = array(
			'header' => $header,
			'data' => $final_data,
			'columns_names' => null,
			'error_msg' => null);
	
		return $array_to_return;
	}
	
	function participantIdentifiersSummary($parameters) {
		$header = null;
		$conditions = array();
		
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
		$misc_identifiers = $misc_identifier_model->find('all', array('conditions' => $conditions, 'order' => array('MiscIdentifier.participant_id ASC')));
		if(sizeof($misc_identifiers) > 1000) {
			return array(
				'header' => null,
				'data' => null,
				'columns_names' => null,
				'error_msg' => 'more than 1000 records are returned by the query - please redefine search criteria');
		}
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
						'#BR' => null,
						'#PR' => null,
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
}