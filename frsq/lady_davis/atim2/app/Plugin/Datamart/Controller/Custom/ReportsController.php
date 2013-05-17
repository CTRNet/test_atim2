<?php
class ReportsControllerCustom extends ReportsController {

		

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
		
		// LIMIT participants based on identifiers
		
		$participant_subset_ids = array();
		$description = '';
		$MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
		$conditions = array();
		$q_croc_03_nbrs = array_unique(array_filter($parameters[0]['q_croc_03_identifier_value']));
		if($q_croc_03_nbrs) {
			$conditions['OR'][] = "MiscIdentifierControl.misc_identifier_name = 'Q-CROC-03' AND (MiscIdentifier.identifier_value LIKE '%".implode("%' OR MiscIdentifier.identifier_value LIKE '%", $q_croc_03_nbrs)."%')";
			$description = "'".__('Q-CROC-03')."' ".__('contains'). ': '.implode(' '.__('or').' ', $q_croc_03_nbrs);
		}
		$breast_bank_nbrs = array_unique(array_filter($parameters[0]['breast_bank_identifier_value']));
		if($breast_bank_nbrs) {
			$conditions['OR'][] = "MiscIdentifierControl.misc_identifier_name = 'Breast bank #' AND (MiscIdentifier.identifier_value LIKE '%".implode("%' OR MiscIdentifier.identifier_value LIKE '%", $breast_bank_nbrs)."%')";
			$description .= (empty($description)? '' : ' & ')."'".__('Breast bank #')."' ".__('contains'). ': '.implode(' '.__('or').' ', $breast_bank_nbrs);
		}
		if($conditions)	{
			$res = $MiscIdentifier->find('all', array('conditions' => $conditions, 'fields' => array('Participant.id, MiscIdentifierControl.misc_identifier_name, MiscIdentifier.identifier_value'), 'recursive' => '1'));
			foreach($res as $new_record) $participant_subset_ids[] = $new_record['Participant']['id'];
			$header['description'] = $description;
		}
		
		// Get new participant
		if(!isset($this->Participant)) {
			$this->Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
		}
		$conditions = $search_on_date_range? array("Participant.created >= '$start_date_for_sql'", "Participant.created <= '$end_date_for_sql'") : array();
		if($participant_subset_ids) $conditions['Participant.id']  = $participant_subset_ids;
		$data['0']['new_participants_nbr'] = $this->Participant->find('count', (array('conditions' => $conditions)));		

		// Get new consents obtained
		if(!isset($this->ConsentMaster)) {
			$this->ConsentMaster = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
		}
		$conditions = $search_on_date_range? array("ConsentMaster.consent_signed_date >= '$start_date_for_sql'", "ConsentMaster.consent_signed_date <= '$end_date_for_sql'") : array();
		if($participant_subset_ids) $conditions['ConsentMaster.participant_id']  = $participant_subset_ids;
		$all_consent = $this->ConsentMaster->find('count', (array('conditions' => $conditions)));
		$conditions['ConsentMaster.consent_status'] = 'obtained';
		$all_obtained_consent = $this->ConsentMaster->find('count', (array('conditions' => $conditions)));
		$data['0']['obtained_consents_nbr'] = "$all_obtained_consent/$all_consent";		
			
		// Get new collections
		$conditions = $search_on_date_range? "col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql'" : 'TRUE';
		if($participant_subset_ids) $conditions .= " AND col.participant_id IN (".implode(',',$participant_subset_ids).")";
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
		
		// LIMIT participants based on identifiers
		
		$participant_subset_ids = array();
		$description = '';
		$MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
		$conditions = array();
		$q_croc_03_nbrs = array_unique(array_filter($parameters[0]['q_croc_03_identifier_value']));
		if($q_croc_03_nbrs) {
			$conditions['OR'][] = "MiscIdentifierControl.misc_identifier_name = 'Q-CROC-03' AND (MiscIdentifier.identifier_value LIKE '%".implode("%' OR MiscIdentifier.identifier_value LIKE '%", $q_croc_03_nbrs)."%')";
			$description = "'".__('Q-CROC-03')."' ".__('contains'). ': '.implode(' '.__('or').' ', $q_croc_03_nbrs);
		}
		$breast_bank_nbrs = array_unique(array_filter($parameters[0]['breast_bank_identifier_value']));
		if($breast_bank_nbrs) {
			$conditions['OR'][] = "MiscIdentifierControl.misc_identifier_name = 'Breast bank #' AND (MiscIdentifier.identifier_value LIKE '%".implode("%' OR MiscIdentifier.identifier_value LIKE '%", $breast_bank_nbrs)."%')";
			$description .= (empty($description)? '' : ' & ')."'".__('Breast bank #')."' ".__('contains'). ': '.implode(' '.__('or').' ', $breast_bank_nbrs);
		}
		if($conditions)	{
			$res = $MiscIdentifier->find('all', array('conditions' => $conditions, 'fields' => array('Participant.id, MiscIdentifierControl.misc_identifier_name, MiscIdentifier.identifier_value'), 'recursive' => '1'));
			foreach($res as $new_record) $participant_subset_ids[] = $new_record['Participant']['id'];
			$header['description'] = ($header['description'] == 'n/a')? $description : $header['description'].' & '.$description;
		}
		
		// Work on specimen
		
		$conditions = $search_on_date_range? "col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql'" : 'TRUE';
		$participant_id_conditions = empty($participant_subset_ids)? 'TRUE' : "col.participant_id IN (".implode(',',$participant_subset_ids).")";
		$res_samples = $this->Report->tryCatchQuery(
			"SELECT COUNT(*), sc.sample_type
			FROM sample_masters AS sm
			INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
			INNER JOIN collections AS col ON col.id = sm.collection_id
			WHERE col.participant_id IS NOT NULL
			AND col.participant_id != '0'
			AND sc.sample_category = 'specimen'
			AND ($conditions)
			AND ($participant_id_conditions)
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
				AND ($participant_id_conditions)
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
				AND ($participant_id_conditions)
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
					AND ($participant_id_conditions)
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
		
		// LIMIT participants based on identifiers
		
		$participant_subset_ids = array();
		$description = '';
		$MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
		$conditions = array();
		$q_croc_03_nbrs = array_unique(array_filter($parameters[0]['q_croc_03_identifier_value']));
		if($q_croc_03_nbrs) {
			$conditions['OR'][] = "MiscIdentifierControl.misc_identifier_name = 'Q-CROC-03' AND (MiscIdentifier.identifier_value LIKE '%".implode("%' OR MiscIdentifier.identifier_value LIKE '%", $q_croc_03_nbrs)."%')";
			$description = "'".__('Q-CROC-03')."' ".__('contains'). ': '.implode(' '.__('or').' ', $q_croc_03_nbrs);
		}
		$breast_bank_nbrs = array_unique(array_filter($parameters[0]['breast_bank_identifier_value']));
		if($breast_bank_nbrs) {
			$conditions['OR'][] = "MiscIdentifierControl.misc_identifier_name = 'Breast bank #' AND (MiscIdentifier.identifier_value LIKE '%".implode("%' OR MiscIdentifier.identifier_value LIKE '%", $breast_bank_nbrs)."%')";
			$description .= (empty($description)? '' : ' & ')."'".__('Breast bank #')."' ".__('contains'). ': '.implode(' '.__('or').' ', $breast_bank_nbrs);
		}
		if($conditions)	{
			$res = $MiscIdentifier->find('all', array('conditions' => $conditions, 'fields' => array('Participant.id, MiscIdentifierControl.misc_identifier_name, MiscIdentifier.identifier_value'), 'recursive' => '1'));
			foreach($res as $new_record) $participant_subset_ids[] = $new_record['Participant']['id'];
			$header['description'] = $description;
		}
		$participant_id_conditions = empty($participant_subset_ids)? 'TRUE' : "col.participant_id IN (".implode(',',$participant_subset_ids).")";
				
		// **all**
		
		$tmp_data = array('sample_type' => __('total'), 'cases_nbr' => '', 'aliquots_nbr' => '', 'notes' => '');
		
		$sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND ($participant_id_conditions)
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
				AND ($participant_id_conditions)
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
				AND ($participant_id_conditions)
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
			AND ($participant_id_conditions)
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
				AND ($participant_id_conditions)
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
				AND ($participant_id_conditions)
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
			AND ($participant_id_conditions)
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
				AND ($participant_id_conditions)
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
			AND ($participant_id_conditions)
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
					AND ($participant_id_conditions)
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
					AND ($participant_id_conditions)
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
				AND ($participant_id_conditions)
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