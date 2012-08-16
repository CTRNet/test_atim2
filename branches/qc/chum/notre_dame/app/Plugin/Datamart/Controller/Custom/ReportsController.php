<?php
class ReportsControllerCustom extends ReportsController {
	
	function procureConsentStat($parameters){

pr('TO Review');exit;
		
		// Build Header
		
		$start_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_start']['year'], $parameters[0]['report_date_range_start']['month'], $parameters[0]['report_date_range_start']['day']);
		$end_date_for_display = AppController::getFormatedDateString($parameters[0]['report_date_range_end']['year'], $parameters[0]['report_date_range_end']['month'], $parameters[0]['report_date_range_end']['day']);
		
		$title = '';
		if(!empty($parameters[0]['report_date_range_start']['year'])) {
			$title .= __('from') . ' ' . $start_date_for_display . ' ';
		}
		if(!empty($parameters[0]['report_date_range_end']['year'])) {
			$title .= __('to') . ' ' . $end_date_for_display;
		}
		$title = (empty($title))? __('no date restriction') : $title;
		
		$header = array(
			'title' => $title,
			'description' => null
		);

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
				"other_contacts_if_die" => 0,//TODO
				"stop_followup" => 0,
				"stop_questionnaire" => 0
			)
		);
		
		$this->ConsentMaster = AppModel::getInstance('ClinicalAnnotation', 'ConsentMaster', true);
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
			if($data_unit['ConsentDetail']['use_of_blood'] == "y"){
				$data[$key][0]["blood"] ++;
			}
			if($data_unit['ConsentDetail']['use_of_urine'] == "y"){
				$data[$key][0]["urine"] ++;
			}
			if($data_unit['ConsentDetail']['allow_questionnaire'] == "y"){
				$data[$key][0]["questionnaire"] ++;
			}
			if($data_unit['ConsentDetail']['urine_blood_use_for_followup'] == 'y'){
				$data[$key][0]["annual_followup"] ++;
			}
			if($data_unit['ConsentDetail']['contact_for_additional_data'] == 'y'){
				$data[$key][0]["contact_if_info_req"] ++;
			}
			if($data_unit['ConsentDetail']['inform_significant_discovery'] == 'y'){
				$data[$key][0]["contact_if_discovery"] ++;
			}
			if($data_unit['ConsentDetail']['research_other_disease'] == 'y'){
				$data[$key][0]["study_other_diseases"] ++;
			}
			if($data_unit['ConsentDetail']['inform_discovery_on_other_disease'] == 'y'){
				$data[$key][0]["contact_if_disco_other_diseases"] ++;
			}
			if($data_unit['ConsentDetail']['stop_followup'] == 'y'){
				$data[$key][0]["stop_followup"] ++;
			}
			if($data_unit['ConsentDetail']['stop_questionnaire'] == 'y'){
				$data[$key][0]["stop_questionnaire"] ++;
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
	
	function bankingNd(array $parameters){

pr('TO Review');exit;
				
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

		$date_from = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_start'], 'start');
		$date_to = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_end'], 'end');
		
		$bank_ids = array_filter($parameters[0]['bank_id']);
		$bank_model = AppModel::getInstance("Administrate", "Bank", true);
		if(empty($bank_ids)){
			$banks = $bank_model->find('all', array('conditions' => array('Bank.misc_identifier_control_id !=' => '0')));
		}else{
			$banks = $bank_model->find('all', array('conditions' => array('Bank.misc_identifier_control_id !=' => '0', "Bank.id" => $bank_ids)));
		}
		
		$participant_model = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		$participant_ids_raw = $participant_model->find('all', array('fields' => ('Participant.id'), 'conditions' => array('Participant.created >=' => $date_from, 'Participant.created <=' => $date_to)));
		$participant_ids = array();
		foreach($participant_ids_raw as $participant){
			$participant_ids[] = $participant['Participant']['id'];
		}
		
		$mi_model = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
		$sample_model = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
		
		$data = array();
		
		$consent_clause = "";
		
		foreach($banks as $bank){
			$bank_id = $bank['Bank']['id'];
			
			$sample_data =$sample_model->tryCatchQuery(
				"SELECT SUM(IF(SpecimenDetail.type_code = 'NOV', 1, 0)) AS nov, SUM(IF(SpecimenDetail.type_code = 'TOV', 1, 0)) AS tov,
				SUM(IF(SpecimenDetail.type_code = 'BOV', 1, 0)) AS bov, SUM(IF(SpecimenDetail.type_code = 'OV', 1, 0)) AS ov,
				SUM(IF(SampleDetail.blood_type = 'EDTA', 1, 0)) AS edta, SUM(IF(SampleDetail.blood_type = 'gel SST', 1, 0)) AS sst,
				SUM(IF(SampleMaster.sample_control_id IN(11, 12, 13), 1, 0)) AS other 
				FROM sample_masters AS SampleMaster
				INNER JOIN collections AS Collection ON SampleMaster.collection_id=Collection.id AND Collection.bank_id='".$bank_id."'
				".$consent_clause." 
				LEFT JOIN specimen_details AS SpecimenDetail ON SampleMaster.id=SpecimenDetail.sample_master_id
				LEFT JOIN sd_spe_bloods AS SampleDetail ON SampleMaster.id=SampleDetail.sample_master_id
				WHERE SampleMaster.created BETWEEN '".$date_from."' AND '".$date_to."'"
			);
			
			$data[] = array(
				'0' => array(
					'bank_id'				=> $bank_id,
					'new_patients'			=> $mi_model->find('count', array('conditions' => array('MiscIdentifier.misc_identifier_control_id' => $bank['Bank']['misc_identifier_control_id'], 'MiscIdentifier.participant_id' => $participant_ids))),
					'normal_tissues'		=> $sample_data[0][0]['nov'],
					'tumoral_tissues'		=> $sample_data[0][0]['tov'],
					'benin_tissues' 		=> $sample_data[0][0]['bov'],
					'ascite'				=> $sample_data[0][0]['ov'],
					'blood_collection'		=> $sample_data[0][0]['edta'],
					'serum'					=> $sample_data[0][0]['sst'],
					'derivative_products'	=> $sample_data[0][0]['other'],
				)
			);
		}
		
		if(count($data) > 1){
			//add "total" row
			$keys = array_keys($data[0][0]);
			array_shift($keys);
			//init
			$total = array();
			foreach($keys as $key){
				$total[$key] = 0;
			}
			//sum
			foreach($data as $data_unit){
				$data_sub_unit = $data_unit[0];
				foreach($keys as $key){
					$total[$key] += $data_sub_unit[$key];
				}
			}
			$total['bank_id'] = __("total", true);
			$data[] = array("0" => $total);
		}
		
		
		return array(
			'header' => $header, 
			'data' => $data, 
			'columns_names' => null,
			'error_msg' => null);
	}
	
	function participantIdentificationsList(array $parameters){

		// Check parameters
		
		$no_labo_min = (!empty($parameters['0']['no_labo_value_start']))? $parameters['0']['no_labo_value_start']: null;
		$no_labo_max = (!empty($parameters['0']['no_labo_value_end']))? $parameters['0']['no_labo_value_end']: null;
		
		if((!empty($no_labo_min) && !is_numeric($no_labo_min))|| (!empty($no_labo_max) && !is_numeric($no_labo_max))) {
			return array(
				'header' => null, 
				'data' => null, 
				'columns_names' => null,
				'error_msg' => 'no labo should be a numeric value');
		}
		
		$misc_identifier_control_ids = array();
		foreach($parameters['0']['no_labo_misc_identifier_control_id'] as $new_id) {
			if(!empty($new_id)) $misc_identifier_control_ids[] = $new_id;
		}

		if(empty($misc_identifier_control_ids)) {
			return array(
				'header' => null, 
				'data' => null, 
				'columns_names' => null,
				'error_msg' => 'a no labo type should be selected');
		}

		// Build titles
		
		$title = '';
		$separator = '';
		$control_model = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifierControl", true);
		$misc_identifier_control_data = $control_model->find('all', array('conditions' => array('MiscIdentifierControl.id' => $misc_identifier_control_ids)));
		foreach($misc_identifier_control_data as $new_data) {
			$title .= $separator.__($new_data['MiscIdentifierControl']['misc_identifier_name'], true);	
			$separator = ' & ';	
		}
				
		$description = __('no labo', true).' : ';
		if($no_labo_min|| $no_labo_max) {
			if($no_labo_min) $description .= $no_labo_min.' < ';
			if($no_labo_max) $description .= ' < '.$no_labo_max;
		} else {
			$description .= __('all',true);
		}
		
		$header = array(
			'title' => $title,
			'description' => $description);
		
		// Build data
		
		$misc_identifier_model = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
		
		$conditions = array('MiscIdentifier.misc_identifier_control_id' => $misc_identifier_control_ids);
		if($no_labo_min) $conditions[] = 'MiscIdentifier.identifier_value >='. $no_labo_min;
		if($no_labo_max) $conditions[] = 'MiscIdentifier.identifier_value <='. $no_labo_max;
		$misc_identifier_participant_ids = $misc_identifier_model->find('all', array('conditions' => $conditions, 'fields' => array('DISTINCT MiscIdentifier.participant_id'), 'recursive' => '-1'));
		
		$participant_ids = array();
		foreach($misc_identifier_participant_ids as $new_id) $participant_ids[] = $new_id['MiscIdentifier']['participant_id'];
		
		if(sizeof($misc_identifier_participant_ids) > 3000) {
			return array(
				'header' => null, 
				'data' => null, 
				'columns_names' => null,
				'error_msg' => 'more than 3000 records are returned by the query - please redefine search criteria');
		}
		
		$misc_identifiers = $misc_identifier_model->find('all', array('conditions' => array('MiscIdentifier.participant_id' => $participant_ids), 'order' => array('MiscIdentifier.participant_id ASC')));
		$data = array();
		foreach($misc_identifiers as $new_ident){
			$participant_id = $new_ident['Participant']['id'];
			if(!isset($data[$participant_id])) {
				$data[$participant_id][0] = array( 
					'first_name' => $new_ident['Participant']['first_name'],
					'last_name' => $new_ident['Participant']['last_name'],
					'breast_bank_no_lab' => null,
					'prostate_bank_no_lab' => null,
					'head_and_neck_bank_no_lab' => null,
					'kidney_bank_no_lab' => null,
					'ovary_bank_no_lab' => null,
					'hotel_dieu_id_nbr' => null,
					'notre_dame_id_nbr' => null,
					'other_center_id_nbr' => null,
					'saint_luc_id_nbr' => null,
					'ramq_nbr' => null,
					'code_barre' => null,
					'old_bank_no_lab' => null,
					'participant_patho_identifier' => null);
			}
			
			$data[$participant_id][0][str_replace(array(' ', '-'), array('_','_'),$new_ident['MiscIdentifierControl']['misc_identifier_name'])] = $new_ident['MiscIdentifier']['identifier_value'];
		}		
		
		return array(
			'header' => $header, 
			'data' => $data, 
			'columns_names' => null,
			'error_msg' => null);
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
		$include_tissue_storage_details = $parameters[0]['include_tissue_storage_details'][0]? true : false;
		
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

		$tmp_data = array();
		$sql = "
			SELECT count(*) AS nbr, tissue_nature FROM (
				SELECT DISTINCT  %%id%%, tiss.tissue_nature
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
			) AS res GROUP BY tissue_nature;";
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		foreach($query_results as $new_res) {
			$tissue_nature = $new_res['res']['tissue_nature'];
			$tmp_data[$tissue_nature] = array('sample_type' => __('FFPE').' '.__($tissue_nature), 'cases_nbr' => $new_res[0]['nbr'], 'aliquots_nbr' => '', 'notes' => '');
		}
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		foreach($query_results as $new_res) {
			$tissue_nature = $new_res['res']['tissue_nature'];
			$tmp_data[$tissue_nature]['aliquots_nbr'] = $new_res[0]['nbr'];
			$data[] = $tmp_data[$tissue_nature];
		}

		// **frozen tissue**

		if(!$include_tissue_storage_details) {
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
			$notes = '';
			foreach($query_results as $new_type) $notes .= (empty($notes)? '' : ' & ').__($new_type['sc']['sample_type']).' '.__($new_type['ac']['aliquot_type']).(empty($new_type['blk']['block_type'])? '' : ' ('.__($new_type['blk']['block_type']).')');
			
			$tmp_data = array();
			$sql = "
				SELECT count(*) AS nbr, tissue_nature  FROM (
					SELECT DISTINCT  %%id%%, tiss.tissue_nature
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
				) AS res GROUP BY tissue_nature;";
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
			foreach($query_results as $new_res) {
				$tissue_nature = $new_res['res']['tissue_nature'];
				$tmp_data[$tissue_nature] = array('sample_type' => __('frozen tissue').' '.__($tissue_nature), 'cases_nbr' => $new_res[0]['nbr'], 'aliquots_nbr' => '', 'notes' => $notes);
			}
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
			foreach($query_results as $new_res) {
				$tissue_nature = $new_res['res']['tissue_nature'];
				$tmp_data[$tissue_nature]['aliquots_nbr'] = $new_res[0]['nbr'];
				$data[] = $tmp_data[$tissue_nature];
			}
			
		} else {
			
			// block + other
			
			$sql = "
				SELECT DISTINCT sc.sample_type,ac.aliquot_type, IFNULL(blk.block_type,'') AS block_type
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
				AND ac.aliquot_type NOT IN ('tube')
				AND ($aliquot_type_confitions)
				AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin');";
			$query_results = $this->Report->tryCatchQuery($sql);
			$notes = '';
			foreach($query_results as $new_type) $notes .= (empty($notes)? '' : ' & ').__($new_type['sc']['sample_type']).' '.__($new_type['ac']['aliquot_type']).(empty($new_type['0']['block_type'])? '' : ' ('.__($new_type['0']['block_type']).')');
						
			$tmp_data = array();
			$sql = "
				SELECT count(*) AS nbr, tissue_nature  FROM (
					SELECT DISTINCT  %%id%%, tiss.tissue_nature
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
					INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
					INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
					INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
					INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
					WHERE col.deleted != '1' AND ($bank_conditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND sc.sample_type IN ('tissue')
					AND ac.aliquot_type NOT IN ('tube')
					AND ($aliquot_type_confitions)
					AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin')
				) AS res GROUP BY tissue_nature;";
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
			foreach($query_results as $new_res) {
					$tissue_nature = $new_res['res']['tissue_nature'];
					$tmp_data[$tissue_nature] = array('sample_type' => __('frozen tissue').' '.__($tissue_nature), 'cases_nbr' => $new_res[0]['nbr'], 'aliquots_nbr' => '', 'notes' => $notes);
			}
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
			foreach($query_results as $new_res) {
				$tissue_nature = $new_res['res']['tissue_nature'];
				$tmp_data[$tissue_nature]['aliquots_nbr'] = $new_res[0]['nbr'];
				$data[] = $tmp_data[$tissue_nature];
			}			
			
			// tube
				
			$tmp_data = array();
			$sql = "
				SELECT count(*) AS nbr, tissue_nature, tmp_storage_solution  FROM (
					SELECT DISTINCT  %%id%%, tiss.tissue_nature, IFNULL(tb.tmp_storage_solution,'') AS tmp_storage_solution
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
					INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
					INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
					INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
					INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
					INNER JOIN ad_tubes as tb ON tb.aliquot_master_id = am.id
					WHERE col.deleted != '1' AND ($bank_conditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND sc.sample_type IN ('tissue')
					AND ac.aliquot_type IN ('tube')
				) AS res GROUP BY tissue_nature, tmp_storage_solution;";
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
			foreach($query_results as $new_res) {
				$tissue_nature = $new_res['res']['tissue_nature'];
				$tmp_storage_solution = $new_res['res']['tmp_storage_solution'];
				$tmp_data[$tissue_nature.$tmp_storage_solution] = array('sample_type' => __('frozen tissue tube').' '.__($tissue_nature). (empty($tmp_storage_solution)? '' : ' (' .__($tmp_storage_solution).')'), 'cases_nbr' => $new_res[0]['nbr'], 'aliquots_nbr' => '', 'notes' => '');
			}
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
			foreach($query_results as $new_res) {
				$tissue_nature = $new_res['res']['tissue_nature'];
				$tmp_storage_solution = $new_res['res']['tmp_storage_solution'];
				$tmp_data[$tissue_nature.$tmp_storage_solution]['aliquots_nbr'] = $new_res[0]['nbr'];
				$data[] = $tmp_data[$tissue_nature.$tmp_storage_solution];
			}	
		}

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
		
		// **tissue rna**
		// **tissue dna**
		// **tissue cell culture**		
		
		if($parameters[0]['display_tissue_derivative_count_split_per_nature'][0]) {
		
			$sample_types = "'rna', 'dna', 'cell culture'";
			
			$tmp_data = array();
			$sql = "
				SELECT count(*) AS nbr,sample_type, aliquot_type, tissue_nature FROM (
					SELECT DISTINCT  %%id%%, sc.sample_type, ac.aliquot_type, tiss.tissue_nature
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
					INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
					INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
					INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
					INNER JOIN sample_masters AS spec ON sm.initial_specimen_sample_id = spec.id
					INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = spec.id
					WHERE col.deleted != '1' AND ($bank_conditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND sc.sample_type IN ($sample_types)
				) AS res GROUP BY sample_type, aliquot_type, tissue_nature;";
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
			foreach($query_results as $new_res) {
			$sample_type = $new_res['res']['sample_type'];
			$aliquot_type = $new_res['res']['aliquot_type'];
			$tissu_nature = $new_res['res']['tissue_nature'];
			$tmp_data[$sample_type.$aliquot_type.$tissu_nature] = array('sample_type' => __('tissue '.$sample_type).' '.__($aliquot_type) . ' ('. __('nature') .': '.__($tissu_nature).')', 'cases_nbr' => $new_res[0]['nbr'], 'aliquots_nbr' => '', 'notes' => '');
			}
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
					foreach($query_results as $new_res) {
					$sample_type = $new_res['res']['sample_type'];
					$aliquot_type = $new_res['res']['aliquot_type'];
					$tissu_nature = $new_res['res']['tissue_nature'];
					$tmp_data[$sample_type.$aliquot_type.$tissu_nature]['aliquots_nbr'] = $new_res[0]['nbr'];
					$data[] = $tmp_data[$sample_type.$aliquot_type.$tissu_nature];
			}
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
	
	
}