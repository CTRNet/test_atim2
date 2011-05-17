<?php
class ReportsController extends DatamartAppController {
	var $uses = array(
		"Datamart.Report",
		"Datamart.DatamartStructure",
		"Structure");

	var $paginate = array('Report' => array('limit' => pagination_amount , 'order' => 'Report.name ASC'));
		
	function index(){
		$_SESSION['report']['search_criteria'] = array(); // clear SEARCH criteria
		
		$this->data = $this->paginate($this->Report, array('Report.flag_active' => '1'));
		
		// Translate data
		foreach($this->data as $key => $data) {
			$this->data[$key]['Report']['name'] = __($this->data[$key]['Report']['name'], true);
			$this->data[$key]['Report']['description'] = __($this->data[$key]['Report']['description'], true);
		}
		
		$this->Structures->set("reports");
	}
	
	function manageReport($report_id, $csv_creation = false) {
		// Get report data
		$report = $this->Report->find('first',array('conditions' => array('Report.id' => $report_id, 'Report.flag_active' => '1')));		
		if(empty($report) 
		|| empty($report['Report']['function'])
		|| empty($report['Report']['form_alias_for_results'])
		|| empty($report['Report']['form_type_for_results'])) {
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		// Set menu variables
		$this->set( 'atim_menu_variables', array('Report.id' => $report_id));

		$display_search_form = false;
		if(empty($this->data) && (!empty($report['Report']['form_alias_for_search'])) && (!$csv_creation)) {
			// User just launched the report process & the search form should be displayed
			$this->Structures->set($report['Report']['form_alias_for_search'], 'search_form_structure');
			$display_search_form = true;	
			$_SESSION['report']['search_criteria'] = array(); // clear SEARCH criteria			
		
		} else {
			// Launch function to build report
			$data_to_build_report = null;
			if($csv_creation) {
				$data_to_build_report = $_SESSION['report']['search_criteria'];
			} else {
				$data_to_build_report = empty($this->data)? array() : $this->data;
				$_SESSION['report']['search_criteria'] = $data_to_build_report;
			}
	
			$this->data = null;			
			
			$data_returned_by_fct = call_user_func_array(array($this , $report['Report']['function']), array($data_to_build_report));
			if(empty($data_returned_by_fct) 
			|| (!array_key_exists('header', $data_returned_by_fct))
			|| (!array_key_exists('data', $data_returned_by_fct)) 
			|| (!array_key_exists('columns_names', $data_returned_by_fct)) 
			|| (!array_key_exists('error_msg', $data_returned_by_fct))) {
				$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			
			if(!empty($data_returned_by_fct['error_msg'])) {
				$this->data = array();
				$this->Structures->set('empty', 'result_form_structure');
				$this->set('result_form_type', 'index');
				$this->set('display_new_search', (empty($report['Report']['form_alias_for_search'])? false:true));
				$this->Report->validationErrors[] = $data_returned_by_fct['error_msg'];
				$csv_creation = false;
			} else {
				// Set data for display
				$this->data = $data_returned_by_fct['data'];
				$this->Structures->set($report['Report']['form_alias_for_results'], 'result_form_structure');
				$this->set('result_form_type', $report['Report']['form_type_for_results']);
				$this->set('result_header', $data_returned_by_fct['header']);
				$this->set('result_columns_names', $data_returned_by_fct['columns_names']);
				$this->set('display_new_search', (empty($report['Report']['form_alias_for_search'])? false:true));
				
				if($csv_creation) {
					Configure::write('debug', 0);
					$this->layout = false;
				}
			}
		}
		
		$this->set('csv_creation', $csv_creation);
		$this->set('display_search_form', $display_search_form);
	}

	// -------------------------------------------------------------------------------------------------------------------
	// FUNCTIONS ADDED TO THE CONTROLLER AS EXAMPLE
	// -------------------------------------------------------------------------------------------------------------------
	
	function bankActiviySummary($parameters) {
		// 1- Build Header
		$start_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_start']['year'], $parameters[0]['report_date_range_start']['month'], $parameters[0]['report_date_range_start']['day']);
		$end_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_end']['year'], $parameters[0]['report_date_range_end']['month'], $parameters[0]['report_date_range_end']['day']);
		$header = array(
			'title' => __('from',true).' '.(empty($parameters[0]['report_date_range_start']['year'])?'?':$start_date_for_display).' '.__('to',true).' '.(empty($parameters[0]['report_date_range_end']['year'])?'?':$end_date_for_display), 
			'description' => 'n/a');

		// 2- Search data
		$start_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_start'], 'start');
		$end_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_end'], 'end');

		$search_on_date_range = true;
		if((strpos($start_date_for_sql, '-9999') === 0) && (strpos($end_date_for_sql, '9999') === 0)) $search_on_date_range = false;
		
		// Get new participant
		if(!isset($this->Participant)) {
			$this->Participant = AppModel::getInstance("Clinicalannotation", "Participant", true);
		}
		$conditions = $search_on_date_range? array("Participant.created >= '$start_date_for_sql'", "Participant.created <= '$end_date_for_sql'") : array();
		$data['0']['new_participants_nbr'] = $this->Participant->find('count', (array('conditions' => $conditions)));		

		// Get new consents obtained
		if(!isset($this->ConsentMaster)) {
			$this->ConsentMaster = AppModel::getInstance("Clinicalannotation", "ConsentMaster", true);
		}
		$conditions = $search_on_date_range? array("ConsentMaster.consent_signed_date >= '$start_date_for_sql'", "ConsentMaster.consent_signed_date <= '$end_date_for_sql'") : array();
		$data['0']['obtained_consents_nbr'] = $this->ConsentMaster->find('count', (array('conditions' => $conditions)));		
		
		// Get new collections
		$conditions = $search_on_date_range? "col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql'" : 'TRUE';
		$new_collections_nbr = $this->Report->query(
			"SELECT COUNT(*) FROM (
				SELECT DISTINCT link.participant_id 
				FROM sample_masters AS sm 
				INNER JOIN collections AS col ON col.id = sm.collection_id 
				INNER JOIN clinical_collection_links AS link ON link.collection_id = col.id 
				WHERE link.participant_id IS NOT NULL 
				AND link.participant_id != '0'
				AND ($conditions)
				AND col.deleted != '1'
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
			'title' => __('from',true).' '.(empty($parameters[0]['report_datetime_range_start']['year'])?'?':$start_date_for_display).' '.__('to',true).' '.(empty($parameters[0]['report_datetime_range_end']['year'])?'?':$end_date_for_display), 
			'description' => 'n/a');

		// 2- Search data
		$start_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_datetime_range_start'], 'start');
		$end_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_datetime_range_end'], 'end');
		
		$search_on_date_range = true;
		if((strpos($start_date_for_sql, '-9999') === 0) && (strpos($end_date_for_sql, '9999') === 0)) $search_on_date_range = false;
		
		$res_final = array();
		$tmp_res_final = array();
		
		// Work on specimen
		$conditions = $search_on_date_range? "col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql'" : 'TRUE';
		$res_1 = $this->Report->query(
			"SELECT COUNT(*), sm.sample_type
			FROM sample_masters AS sm 
			INNER JOIN collections AS col ON col.id = sm.collection_id 
			WHERE sm.sample_category = 'specimen'
			AND ($conditions)
			AND sm.deleted != '1'
			GROUP BY sample_type;");
		foreach($res_1 as $data) {
			$tmp_res_final[$data['sm']['sample_type']] = array(
				'SampleMaster' => array('sample_category' => 'specimen', 'sample_type'=> $data['sm']['sample_type']),
				'0' => array('created_samples_nbr' => $data[0]['COUNT(*)'], 'matching_participant_number' => null));
		}	
		$res_2 = $this->Report->query(
			"SELECT COUNT(*), res.sample_type FROM (
				SELECT DISTINCT link.participant_id, sm.sample_type  
				FROM sample_masters AS sm 
				INNER JOIN collections AS col ON col.id = sm.collection_id 
				INNER JOIN clinical_collection_links AS link ON link.collection_id = col.id 
				WHERE link.participant_id IS NOT NULL 
				AND link.participant_id != '0'
				AND sm.sample_category = 'specimen'
				AND ($conditions)
				AND sm.deleted != '1'
			) AS res GROUP BY res.sample_type;");
		foreach($res_2 as $data) {
			$tmp_res_final[$data['res']['sample_type']]['0']['matching_participant_number'] = $data[0]['COUNT(*)'];
		}
		
		// Work on derivative
		$conditions = $search_on_date_range? "der.creation_datetime >= '$start_date_for_sql' AND der.creation_datetime <= '$end_date_for_sql'" : 'TRUE';
		$res_1 = $this->Report->query(
			"SELECT COUNT(*), sm.sample_type
			FROM sample_masters AS sm 
			INNER JOIN derivative_details AS der ON der.sample_master_id = sm.id 
			WHERE sm.sample_category = 'derivative'
			AND ($conditions)
			AND sm.deleted != '1'
			GROUP BY sample_type;");
		foreach($res_1 as $data) {
			$tmp_res_final[$data['sm']['sample_type']] = array(
				'SampleMaster' => array('sample_category' => 'derivative', 'sample_type'=> $data['sm']['sample_type']),
				'0' => array('created_samples_nbr' => $data[0]['COUNT(*)'], 'matching_participant_number' => null));
		}
		$res_2 = $this->Report->query(
			"SELECT COUNT(*), res.sample_type FROM (
				SELECT DISTINCT link.participant_id, sm.sample_type  
				FROM sample_masters AS sm 
				INNER JOIN derivative_details AS der ON der.sample_master_id = sm.id 
				INNER JOIN clinical_collection_links AS link ON link.collection_id = sm.collection_id 
				WHERE link.participant_id IS NOT NULL 
				AND link.participant_id != '0'
				AND sm.sample_category = 'derivative'
				AND ($conditions)
				AND sm.deleted != '1'
			) AS res GROUP BY res.sample_type;");
		foreach($res_2 as $data) {
			$tmp_res_final[$data['res']['sample_type']]['0']['matching_participant_number'] = $data[0]['COUNT(*)'];
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
			return array('error_msg' => 'no perido has been defined', 'header' => null, 'data' => null, 'columns_names' => null);		
		}
		$month_period = ($parameters[0]['report_date_range_period']['0'] == 'month')? true:false;
		
		// 1- Build Header
		$start_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_start']['year'], $parameters[0]['report_date_range_start']['month'], $parameters[0]['report_date_range_start']['day']);
		$end_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_end']['year'], $parameters[0]['report_date_range_end']['month'], $parameters[0]['report_date_range_end']['day']);
		$header = array(
			'title' => __('from',true).' '.(empty($parameters[0]['report_date_range_start']['year'])?'?':$start_date_for_display).' '.__('to',true).' '.(empty($parameters[0]['report_date_range_end']['year'])?'?':$end_date_for_display), 
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
		$participant_res = $this->Report->query(
			"SELECT COUNT(*), YEAR(Participant.created) AS created_year".($month_period? ", MONTH(Participant.created) AS created_month": "").
			" FROM participants AS Participant 
			WHERE ($conditions) AND Participant.deleted != 1 
			GROUP BY created_year".($month_period? ", created_month": "").";");
		foreach($participant_res as $new_data) {
			$date_key = '';
			$date_value = __('unknown',true);
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
		$consent_res = $this->Report->query(
			"SELECT COUNT(*), YEAR(ConsentMaster.consent_signed_date) AS signed_year".($month_period? ", MONTH(ConsentMaster.consent_signed_date) AS signed_month": "").
			" FROM consent_masters AS ConsentMaster
			WHERE ($conditions) AND ConsentMaster.deleted != 1 
			GROUP BY signed_year".($month_period? ", signed_month": "").";");
		foreach($consent_res as $new_data) {
			$date_key = '';
			$date_value = __('unknown',true);
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
		$collection_res = $this->Report->query(
			"SELECT COUNT(*), res.collection_year".($month_period? ", res.collection_month": "")." FROM (
				SELECT DISTINCT link.participant_id, YEAR(col.collection_datetime) AS collection_year".($month_period? ", MONTH(col.collection_datetime) AS collection_month": "").
				" FROM sample_masters AS sm 
				INNER JOIN collections AS col ON col.id = sm.collection_id 
				INNER JOIN clinical_collection_links AS link ON link.collection_id = col.id 
				WHERE link.participant_id IS NOT NULL 
				AND link.participant_id != '0'
				AND ($conditions)
				AND col.deleted != '1'
			) AS res
			GROUP BY res.collection_year".($month_period? ", res.collection_month": "").";");
		foreach($collection_res as $new_data) {
			$date_key = '';
			$date_value = __('unknown',true);
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
	
	function aliquotSpentTimesCalulations($parameters, $default_unit = 'full') {
		$array_to_return = array(
			'header' => null, 
			'data' => null, 
			'columns_names' => null,
			'error_msg' => null);

		// Get aliquot id
		if(!isset($this->AliquotMaster)) $this->AliquotMaster = AppModel::getInstance("inventorymanagement", "AliquotMaster", true);
		
		$aliquot_master_ids = array();
		if(isset($parameters['ViewAliquot']['aliquot_master_id'])) {
			if(is_array($parameters['ViewAliquot']['aliquot_master_id'])) {
				$aliquot_master_ids = array_filter($parameters['ViewAliquot']['aliquot_master_id']);
			} else {
				$aliquot_master_ids = explode(',', $parameters['ViewAliquot']['aliquot_master_id']);
			}	
		} else if(isset($parameters['AliquotMaster']) && array_key_exists('barcode', $parameters['AliquotMaster'])) {
			$aliquot_master_ids = $this->AliquotMaster->find('list', array('fields' => array('AliquotMaster.id'), 'conditions' => array("AliquotMaster.barcode" => $parameters['AliquotMaster']['barcode']), 'recursive' => -1));
		} else {
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		if(empty($aliquot_master_ids)) {
			$array_to_return['error_msg'] = 'no aliquot has been found';
		} else {
			if(isset($parameters['0']['report_spent_time_display_mode'])) {
				$default_unit = $parameters['0']['report_spent_time_display_mode'][0];
			}
					
			$aliquot_master_ids[] = 0;
			$aliquots = $this->Report->query(
				"SELECT al.barcode, samp.sample_type, al.aliquot_type,
				col.collection_datetime, spec_det.reception_datetime, der_det.creation_datetime, al.storage_datetime
				FROM aliquot_masters AS al 
				INNER JOIN sample_masters AS samp ON samp.id = al.sample_master_id AND samp.deleted != 1
				INNER JOIN collections AS col ON col.id = al.collection_id AND col.deleted != 1
				INNER JOIN sample_masters AS spec ON spec.id = samp.initial_specimen_sample_id AND spec.deleted != 1			
				INNER JOIN specimen_details AS spec_det ON spec.id = spec_det.sample_master_id AND spec_det.deleted != 1
				LEFT JOIN derivative_details AS der_det ON der_det.sample_master_id = samp.id AND der_det.deleted != 1
				WHERE al.deleted != 1 AND al.id IN (".implode(',', $aliquot_master_ids).")"); 

			$data = array();
			foreach($aliquots as $new_record) {
				$new_data = array();
				$new_data['SampleMaster']['sample_type'] = $new_record['samp']['sample_type'];
				$new_data['AliquotMaster']['aliquot_type'] = $new_record['al']['aliquot_type'];
				$new_data['AliquotMaster']['barcode'] = $new_record['al']['barcode'];
				
				$coll_to_stor_spent_time_msg = AppModel::getSpentTime($new_record['col']['collection_datetime'], $new_record['al']['storage_datetime']);
				$rec_to_stor_spent_time_msg = AppModel::getSpentTime($new_record['spec_det']['reception_datetime'], $new_record['al']['storage_datetime']);
				$creat_to_stor_spent_time_msg = AppModel::getSpentTime($new_record['der_det']['creation_datetime'], $new_record['al']['storage_datetime']);
						
				if($default_unit == 'mn') {
					$new_data['Generated']['coll_to_stor_spent_time_msg'] = empty($coll_to_stor_spent_time_msg['message'])? (((($coll_to_stor_spent_time_msg['days']*24) + $coll_to_stor_spent_time_msg['hours'])*60) + $coll_to_stor_spent_time_msg['minutes']): '';
					$new_data['Generated']['rec_to_stor_spent_time_msg'] = empty($rec_to_stor_spent_time_msg['message'])? (((($rec_to_stor_spent_time_msg['days']*24) + $rec_to_stor_spent_time_msg['hours'])*60) + $rec_to_stor_spent_time_msg['minutes']): '';
					$new_data['Generated']['creat_to_stor_spent_time_msg'] = empty($creat_to_stor_spent_time_msg['message'])? (((($creat_to_stor_spent_time_msg['days']*24) + $creat_to_stor_spent_time_msg['hours'])*60) + $creat_to_stor_spent_time_msg['minutes']): '';
										
				} else {
					$new_data['Generated']['coll_to_stor_spent_time_msg'] = AppModel::manageSpentTimeDataDisplay($coll_to_stor_spent_time_msg);
					$new_data['Generated']['rec_to_stor_spent_time_msg'] = AppModel::manageSpentTimeDataDisplay($rec_to_stor_spent_time_msg);
					$new_data['Generated']['creat_to_stor_spent_time_msg'] = AppModel::manageSpentTimeDataDisplay($creat_to_stor_spent_time_msg);
				}
				
				$data[] = $new_data;
			}
			
			$array_to_return['data'] = $data;
		}
		
		return $array_to_return;
	}
	
}