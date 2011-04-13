<?php
class ReportsControllerCustom extends ReportsController {
	
	function procureConsentStat($parameters){
		
		// Build Header
		
		$start_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_start']['year'], $parameters[0]['report_date_range_start']['month'], $parameters[0]['report_date_range_start']['day']);
		$end_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_end']['year'], $parameters[0]['report_date_range_end']['month'], $parameters[0]['report_date_range_end']['day']);
		
		$title = '';
		if(!empty($parameters[0]['report_date_range_start']['year'])) {
			$title .= __('from',true) . ' ' . $start_date_for_display . ' ';
		}
		if(!empty($parameters[0]['report_date_range_end']['year'])) {
			$title .= __('to',true) . ' ' . $end_date_for_display;
		}
		$title = (empty($title))? __('no date restriction', true) : $title;
		
		$header = array(
			'title' => $title,
			'description' => null);

		// Get Data
		
		$date_from = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_start'], 'start');
		$date_to = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_end'], 'end');
			
		$conditions = array(
			'ConsentMaster.consent_control_id' => 5, 
			"ConsentMaster.consent_status = 'obtained'");
		if(strpos($date_from, '-9999') !== 0) $conditions[] = "ConsentMaster.consent_signed_date >= '$date_from'";
		if(strpos($date_to, '9999') !== 0) $conditions[] = "ConsentMaster.consent_signed_date <= '$date_to'";
	
		$fields = array(
			'YEAR(ConsentMaster.consent_signed_date) AS signed_year',
			'MONTH(ConsentMaster.consent_signed_date) AS signed_month',
			'ConsentMaster.*');
		
		$initial_data = array(0 => array(
				"denied" => 0,//TODO
				"participant" => 0,
				"blood" => 0,
				"urine" => 0,
				"questionnaire" => 0,
				"annual_followup" => 0,
				"contact_if_info_req" => 0,
				"contact_if_discovery" => 0,
				"study_other_diseases" => 0,
				"contact_if_disco_other_diseases" => 0,
				"other_contacts_if_die" => 0//TODO
			)
		);
		
		$this->ConsentMaster = AppModel::atimNew('Clinicalannotation', 'ConsentMaster', true);
		$this->ConsentMaster->unbindModel(array('hasMany' => array('ClinicalCollectionLink')));
		$tmp_data = $this->ConsentMaster->find('all', array('conditions' => $conditions, 'recursive' => '2', 'fields' => $fields, 'order' => array("ConsentMaster.consent_signed_date")));

		$data = array();
		foreach($tmp_data as $data_unit){
			$year = $data_unit[0]['signed_year'];
			$month = $data_unit[0]['signed_month'];
			$key = $year."-".$month;
			if(empty($year)) $key = __('unknown',true);
			if(!isset($data[$key])) {
					$data[$key] = $initial_data;
					$data[$key][0]['period'] = $key;
			}
			
			if($data_unit['ConsentMaster']['consent_status'] == 'denied' || $data_unit['ConsentMaster']['consent_status'] == 'withdrawn'){
				$data[$key][0]["denied"] ++;
			}
			$data[$key][0]["participant"] ++;
			if($data_unit['ConsentDetail']['use_of_blood'] == "yes"){
				$data[$key][0]["blood"] ++;
			}
			if($data_unit['ConsentDetail']['use_of_urine'] == "yes"){
				$data[$key][0]["urine"] ++;
			}
			if($data_unit['ConsentDetail']['allow_questionnaire'] == "yes"){
				$data[$key][0]["questionnaire"] ++;
			}
			if($data_unit['ConsentDetail']['urine_blood_use_for_followup'] == 'yes'){
				$data[$key][0]["annual_followup"] ++;
			}
			if($data_unit['ConsentDetail']['contact_for_additional_data'] == 'yes'){
				$data[$key][0]["contact_if_info_req"] ++;
			}
			if($data_unit['ConsentDetail']['inform_significant_discovery'] == 'yes'){
				$data[$key][0]["contact_if_discovery"] ++;
			}
			if($data_unit['ConsentDetail']['research_other_disease'] == 'yes'){
				$data[$key][0]["study_other_diseases"] ++;
			}
			if($data_unit['ConsentDetail']['inform_discovery_on_other_disease'] == 'yes'){
				$data[$key][0]["contact_if_disco_other_diseases"] ++;
			}
		}
		
		$total = $initial_data[0];
		foreach($data as $key => $data_unit){
			$sub_data_unit = $data_unit[0];
			foreach($total as $sub_key => &$value){
				$value += $sub_data_unit[$sub_key];
			}
		}
		$total['period'] = __('total', true);
		$data['total'][0] = $total;

		return array(
			"header"		=> $header,
			"data"			=> $data,
			"columns_names"	=> array(),
			"error_msg"		=> null
		);
	}	
	
	function aliquotSpentTimesCalulations($parameters, $default_unit = 'mn') {
		$array_to_return = array(
			'header' => null, 
			'data' => null, 
			'columns_names' => null,
			'error_msg' => null);
			
		// Get aliquot id
		if(!isset($this->AliquotMaster)) $this->AliquotMaster = AppModel::atimNew("inventorymanagement", "AliquotMaster", true);
		
		$aliquot_master_ids = array();
		if(isset($parameters['ViewAliquot']['aliquot_master_id'])) {
			if(is_array($parameters['ViewAliquot']['aliquot_master_id'])) {
				$aliquot_master_ids = array_filter($parameters['ViewAliquot']['aliquot_master_id']);
			} else {
				$aliquot_master_ids = explode(',', $parameters['ViewAliquot']['aliquot_master_id']);
			}	
		} else if(isset($parameters['AliquotMaster']) && array_key_exists('barcode', $parameters['AliquotMaster'])) {
			
			$conditions = array(
				"OR" => array("AliquotMaster.barcode" => $parameters['AliquotMaster']['barcode'],
				"AliquotMaster.aliquot_label" => $parameters['AliquotMaster']['aliquot_label']));
			$aliquot_master_ids = $this->AliquotMaster->find('list', array('fields' => array('AliquotMaster.id'), 'conditions' => $conditions, 'recursive' => -1));
		} else {
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		if(empty($aliquot_master_ids)) {
			$array_to_return['error_msg'] = 'no aliquot has been found';
		} else {
			
			if(isset($parameters['0']['report_spent_time_display_mode'][0]) && (!empty($parameters['0']['report_spent_time_display_mode'][0]))) {
				$default_unit = $parameters['0']['report_spent_time_display_mode'][0];
			}
			
			$aliquot_master_ids[] = 0;
			$aliquots = $this->Report->query(
				"SELECT al.barcode, al.aliquot_label, samp.sample_type, al.aliquot_type,
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
				$new_data['AliquotMaster']['aliquot_label'] = $new_record['al']['aliquot_label'];
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
		
		$array_to_return['header'] = __('unit' , true) . ': ' .  __($default_unit, true);

		return $array_to_return;
	}
	
	function bankActiviySummary($parameters) {
		
		// 1- Build Header
		$start_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_start']['year'], $parameters[0]['report_date_range_start']['month'], $parameters[0]['report_date_range_start']['day']);
		$end_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_end']['year'], $parameters[0]['report_date_range_end']['month'], $parameters[0]['report_date_range_end']['day']);
		
		$title = __('bank', true) . ': ' ;
		$description = '';
		if(!empty($parameters['Collection']['bank_id'][0])) {
			// find bank	
			$res_1 = $this->Report->query("SELECT name FROM banks WHERE id = '".$parameters['Collection']['bank_id'][0]."' AND deleted != '1';");
			if(empty($res_1)) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			$title .= $res_1['0']['banks']['name'];
		} else {
			$title .= __('all',true);
		}
		
		if(!empty($parameters[0]['report_date_range_start']['year'])) {
			$description .= __('from',true) . ' ' . $start_date_for_display . ' ';
		}
		if(!empty($parameters[0]['report_date_range_end']['year'])) {
			$description .= __('to',true) . ' ' . $end_date_for_display;
		}
		$description = (empty($description))? __('no date restriction', true) : $description;
		
		$header = array(
			'title' => $title,
			'description' => $description);

		// 2- Search data
		$data = array();
		
		$start_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_start'], 'start');
		$end_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_end'], 'end');

		$search_on_date_range = true;
		if((strpos($start_date_for_sql, '-9999') === 0) && (strpos($end_date_for_sql, '9999') === 0)) $search_on_date_range = false;
		
		// NEW PARTICIPANTS
		
		$participant_sql = "";
		$participant_conditions = $search_on_date_range? "part.created >= '$start_date_for_sql' AND part.created <= '$end_date_for_sql'" : 'TRUE';
		if(empty($parameters['Collection']['bank_id'][0])) {
			// No bank restriction
			$participant_sql = "SELECT DISTINCT part.id FROM participants AS part WHERE part.deleted != '1' AND ($participant_conditions)";
		} else {
			// Bank restriction
			$participant_sql = 
				"SELECT DISTINCT part.id
				FROM participants AS part 
				INNER JOIN misc_identifiers AS ident ON ident.participant_id = part.id AND ident.deleted != '1'
				INNER JOIN banks AS bk ON ident.misc_identifier_control_id = bk.misc_identifier_control_id AND  bk.deleted != '1'
				WHERE part.deleted != '1' 
				AND ($participant_conditions)
				AND bk.id = '".$parameters['Collection']['bank_id'][0]."'";
		}	
		
		$new_participants_nbr = $this->Report->query("SELECT COUNT(*) FROM ($participant_sql) AS res");
		$data['0']['new_participants_nbr'] = $new_participants_nbr[0][0]['COUNT(*)'];

		// NEW CONSENTS
		
		$consent_sql = "";
		$consent_conditions = $search_on_date_range? "cs.consent_signed_date >= '$start_date_for_sql' AND cs.consent_signed_date <= '$end_date_for_sql'" : 'TRUE';
		if(empty($parameters['Collection']['bank_id'][0])) {
			// No bank restriction
			$consent_sql = "SELECT DISTINCT cs.id FROM consent_masters AS cs WHERE cs.consent_status = 'obtained' AND cs.deleted != '1' AND ($consent_conditions)";
		} else {
			// Bank restriction
			$consent_sql = 
				"SELECT DISTINCT cs.id
				FROM consent_masters AS cs 
				INNER JOIN misc_identifiers AS ident ON ident.participant_id = cs.participant_id AND ident.deleted != '1'
				INNER JOIN banks AS bk ON ident.misc_identifier_control_id = bk.misc_identifier_control_id AND  bk.deleted != '1'
				WHERE cs.deleted != '1' AND cs.consent_status = 'obtained' 
				AND ($consent_conditions)
				AND bk.id = '".$parameters['Collection']['bank_id'][0]."'";
		}	
		
		$new_consents_nbr = $this->Report->query("SELECT COUNT(*) FROM ($consent_sql) AS res");
		$data['0']['obtained_consents_nbr'] = $new_consents_nbr[0][0]['COUNT(*)'];		
		
		// NEW COLLECTIONS
		
		$bank_conditions = empty($parameters['Collection']['bank_id'][0])? 'TRUE' : "col.bank_id = '".$parameters['Collection']['bank_id'][0]."'";
				
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
				AND ($bank_conditions)
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
		$start_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_start']['year'], $parameters[0]['report_date_range_start']['month'], $parameters[0]['report_date_range_start']['day']);
		$end_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_end']['year'], $parameters[0]['report_date_range_end']['month'], $parameters[0]['report_date_range_end']['day']);
		
		$title = __('bank', true) . ': ' ;
		$description = '';
		if(!empty($parameters['Collection']['bank_id'][0])) {
			// find bank	
			$res_1 = $this->Report->query("SELECT name FROM banks WHERE id = '".$parameters['Collection']['bank_id'][0]."' AND deleted != '1';");
			if(empty($res_1)) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			$title .= $res_1['0']['banks']['name'];
		} else {
			$title .= __('all',true);
		}
		
		if(!empty($parameters[0]['report_date_range_start']['year'])) {
			$description .= __('from',true) . ' ' . $start_date_for_display . ' ';
		}
		if(!empty($parameters[0]['report_date_range_end']['year'])) {
			$description .= __('to',true) . ' ' . $end_date_for_display;
		}
		$description = (empty($description))? __('no date restriction', true) : $description;
		
		$header = array(
			'title' => $title,
			'description' => $description);

		// 2- Search data
		$start_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_start'], 'start');
		$end_date_for_sql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_end'], 'end');
		
		$search_on_date_range = true;
		if((strpos($start_date_for_sql, '-9999') === 0) && (strpos($end_date_for_sql, '9999') === 0)) $search_on_date_range = false;
		
		$res_final = array();
		$tmp_res_final = array();
		
		$bank_conditions = empty($parameters['Collection']['bank_id'][0])? 'TRUE' : "col.bank_id = '".$parameters['Collection']['bank_id'][0]."'";
			
		// Work on specimen
		$conditions = $search_on_date_range? "col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql'" : 'TRUE';
		$res_1 = $this->Report->query(
			"SELECT COUNT(*), sm.sample_type
			FROM sample_masters AS sm 
			INNER JOIN collections AS col ON col.id = sm.collection_id 
			WHERE sm.sample_category = 'specimen'
			AND ($conditions)
			AND ($bank_conditions)
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
				AND ($bank_conditions)
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
			INNER JOIN collections AS col ON col.id = sm.collection_id 
			INNER JOIN derivative_details AS der ON der.sample_master_id = sm.id 
			WHERE sm.sample_category = 'derivative'
			AND ($bank_conditions)
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
				INNER JOIN collections AS col ON col.id = sm.collection_id 
				INNER JOIN derivative_details AS der ON der.sample_master_id = sm.id 
				INNER JOIN clinical_collection_links AS link ON link.collection_id = sm.collection_id 
				WHERE link.participant_id IS NOT NULL 
				AND link.participant_id != '0'
				AND sm.sample_category = 'derivative'
				AND ($conditions)
				AND ($bank_conditions)
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
	
	
	
	
}