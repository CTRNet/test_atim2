<?php
class ReportsControllerCustom extends ReportsController {

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
	
	function createTissueAndBuffyCoatDNASummary($parameters) {
		
		// 1- Set Search Criteria
		
		$criteria_array = array();
		if(array_key_exists('Participant', $parameters) && array_key_exists('id', $parameters['Participant'])) {
			// From databrowser or batchset
			$criteria_array[] = "Participant.id IN ('".implode("','", array_filter($parameters['Participant']['id']))."')";
		} else if(array_key_exists('ViewAliquot', $parameters) && array_key_exists('aliquot_master_id', $parameters['ViewAliquot'])) {
			// From databrowser or batchset
			$criteria_array[] = "AliquotMaster_TissueBlock_BcTube.id IN ('".implode("','", array_filter($parameters['ViewAliquot']['aliquot_master_id']))."')";
		} else if(array_key_exists('AliquotMaster', $parameters) && array_key_exists('id', $parameters['AliquotMaster'])) {
			// From databrowser or batchset
			$criteria_array[] = "AliquotMaster_TissueBlock_BcTube.id IN ('".implode("','", array_filter($parameters['AliquotMaster']['id']))."')";
		} else {
			$criteria_array = array();
			if(array_key_exists('ViewCollection', $parameters)) {
				if(array_key_exists('participant_identifier', $parameters['ViewCollection'])) {
					$participant_identifiers = array_filter($parameters['ViewCollection']['participant_identifier']);			
					if($participant_identifiers) $criteria_array[] = "Participant.participant_identifier IN ('".implode("','", $participant_identifiers)."')";
				} else if(array_key_exists('participant_identifier_start', $parameters['ViewCollection'])) {
					$tmp_conditions = array();
					if(strlen($parameters['ViewCollection']['participant_identifier_start'])) $tmp_conditions[] = "Participant.participant_identifier >= '".$parameters['ViewCollection']['participant_identifier_start']."'";
					if(strlen($parameters['ViewCollection']['participant_identifier_end'])) $tmp_conditions[] = "Participant.participant_identifier <= '".$parameters['ViewCollection']['participant_identifier_end']."'";
					if($tmp_conditions) $criteria_array[] = implode(" AND ",$tmp_conditions);
				}
			}
			if(array_key_exists('ViewCollection', $parameters)) {
				if(array_key_exists('misc_identifier_value', $parameters['ViewCollection'])) {
					$misc_identifier_values = array_filter($parameters['ViewCollection']['misc_identifier_value']);
					if($misc_identifier_values) $criteria_array[] = "MiscIdentifier.misc_identifier_value IN ('".implode("','", $misc_identifier_values)."')";
				} else if(array_key_exists('misc_identifier_value_start', $parameters['ViewCollection'])) {
					return array(
						'header' => null,
						'data' => null,
						'columns_names' => null,
						'error_msg' => 'no bank identifier search based on range defintion is supported');
				}
			}
			if(array_key_exists('AliquotMaster', $parameters)) {
				if(array_key_exists('aliquot_label', $parameters['AliquotMaster'])) {
					$aliquot_label_values = array_filter($parameters['AliquotMaster']['aliquot_label']);
					if($aliquot_label_values) $criteria_array[] = "AliquotMaster_TissueBlock_BcTube.aliquot_label IN ('".implode("','", $aliquot_label_values)."')";
				} else if(array_key_exists('aliquot_label_start', $parameters['AliquotMaster'])) {	
					return array(
						'header' => null,
						'data' => null,
						'columns_names' => null,
						'error_msg' => 'no aliquot label search based on range defintion is supported');
				}
			}
		}
		if(empty($criteria_array)) {
			return array(
				'header' => null,
				'data' => null,
				'columns_names' => null,
				'error_msg' => 'at least one criteria has to be entered');
		}
		
		$criteria = implode(" AND ", $criteria_array);
		
		// 2- Search data
		
		$tisue_control_id = null;
		$tisue_tube_control_id = null;
		$tisue_block_control_id = null;
		$buffy_coat_control_id = null;
		$buffy_coat_tube_control_id = null;
		$dna_control_id = null;
		$dna_tube_control_id = null;
		$rna_control_id = null;
		$rna_tube_control_id = null;
		$res_control_ids = $this->Report->tryCatchQuery("
			SELECT sample_controls.id, sample_controls.sample_type, aliquot_controls.id, aliquot_controls.aliquot_type
			FROM aliquot_controls INNER JOIN sample_controls ON sample_controls.id = aliquot_controls.sample_control_id
			WHERE aliquot_controls.flag_active = 1
			AND sample_controls.sample_type IN ('DNA','tissue', 'RNA', 'pbmc') AND aliquot_controls.aliquot_type IN ('block','tube');");
		foreach($res_control_ids as $new_control) {
			switch($new_control['sample_controls']['sample_type'].$new_control['aliquot_controls']['aliquot_type']) {
				case 'tissueblock':
					$tisue_control_id = $new_control['sample_controls']['id'];
					$tisue_block_control_id = $new_control['aliquot_controls']['id'];
					break;
				case 'tissuetube':
					$tisue_tube_control_id = $new_control['aliquot_controls']['id'];
					break;
				case 'pbmctube':
					$buffy_coat_control_id = $new_control['sample_controls']['id'];
					$buffy_coat_tube_control_id = $new_control['aliquot_controls']['id'];
					break;
				case 'dnatube':
					$dna_control_id = $new_control['sample_controls']['id'];
					$dna_tube_control_id = $new_control['aliquot_controls']['id'];
					break;
				case 'rnatube':
					$rna_control_id = $new_control['sample_controls']['id'];
					$rna_tube_control_id = $new_control['aliquot_controls']['id'];
					break;
			}
		}
		
		$tissues_blocks_and_buffy_coat_data = array();
		
		$empty_aliquots_subarray = array(
				'ViewAliquot' => array(
						'sample_type' => '',
						'aliquot_type' => ''),
				'AliquotMaster' => array(
						'barcode' => '',
						'aliquot_label' => ''),
				'ViewCollection' => array(
						'misc_identifier_value' =>  '',
						'participant_identifier' => '',
						'qc_lady_specimen_type_precision' => '',
						'qc_lady_visit' => ''),
				'AliquotDetail' => array(
						'tissue_tube_aliquot_master_id' => null,
						'qc_lady_storage_solution' => '',
						'qc_lady_storage_method' => ''),
				'AliquotReviewDetail' => array(
						'aliquot_review_master_id' => null,
						'tumor_percentage' => '',
						'necrosis_percentage_itz' => '',
						'cellularity_percentage_itz' => '',
						'stroma_percentage_itz' => '')
		);
		
		// Get tissue block data
		$all_data = $this->Report->tryCatchQuery("
			SELECT
			Participant.id AS participant_id,
			Participant.participant_identifier,
				
			Collection.id AS collection_id,
			Collection.qc_lady_specimen_type_precision,
			Collection.qc_lady_visit,
			MiscIdentifier.identifier_value AS misc_identifier_value,
				
			AliquotMaster_TissueBlock_BcTube.id AS block_aliquot_master_id,
			AliquotMaster_TissueBlock_BcTube.aliquot_label AS block_aliquot_label,
			AliquotMaster_TissueBlock_BcTube.barcode AS block_barcode,
			
			AliquotDetail_TissueTube.aliquot_master_id AS tissue_tube_aliquot_master_id,
			AliquotDetail_TissueTube.qc_lady_storage_solution,
			AliquotDetail_TissueTube.qc_lady_storage_method,
				
			AliquotReviewDetail.aliquot_review_master_id,
			AliquotReviewDetail.tumor_percentage,
			AliquotReviewDetail.cellularity_percentage_itz,
			AliquotReviewDetail.necrosis_percentage_itz,
			AliquotReviewDetail.stroma_percentage_itz
				
			FROM collections Collection
			INNER JOIN aliquot_masters AS AliquotMaster_TissueBlock_BcTube ON AliquotMaster_TissueBlock_BcTube.collection_id = Collection.id AND AliquotMaster_TissueBlock_BcTube.deleted <> 1 AND AliquotMaster_TissueBlock_BcTube.aliquot_control_id = $tisue_block_control_id
	
			LEFT JOIN realiquotings ON AliquotMaster_TissueBlock_BcTube.id = realiquotings.child_aliquot_master_id AND realiquotings.deleted <> 1
			LEFT JOIN aliquot_masters AS AliquotMaster_TissueTube ON AliquotMaster_TissueTube.id = realiquotings.parent_aliquot_master_id AND AliquotMaster_TissueTube.deleted <> 1 AND AliquotMaster_TissueTube.aliquot_control_id = $tisue_tube_control_id
			LEFT JOIN ad_tubes AS AliquotDetail_TissueTube ON AliquotDetail_TissueTube.aliquot_master_id = AliquotMaster_TissueTube.id
				
			LEFT JOIN aliquot_review_masters AS AliquotReviewMaster ON AliquotReviewMaster.aliquot_master_id = AliquotMaster_TissueBlock_BcTube.id AND AliquotReviewMaster.deleted <> 1
			LEFT JOIN qc_lady_ar_qcrocs AS AliquotReviewDetail ON AliquotReviewDetail.aliquot_review_master_id = AliquotReviewMaster.id
				
			LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
			LEFT JOIN misc_identifiers AS MiscIdentifier ON Collection.misc_identifier_id = MiscIdentifier.id AND MiscIdentifier.deleted <> 1
	
			WHERE $criteria
	
		ORDER BY MiscIdentifier.identifier_value, Collection.id, AliquotMaster_TissueBlock_BcTube.id;");
		
		$tissue_blocks_having_many_reviews = array();
		$tissue_blocks_having_many_aliquots_source = array();
		foreach($all_data as $new_row) {
			$block_aliquot_master_id = $new_row['AliquotMaster_TissueBlock_BcTube']['block_aliquot_master_id'];
			if(!array_key_exists($block_aliquot_master_id, $tissues_blocks_and_buffy_coat_data)) {
				$tissues_blocks_and_buffy_coat_data[$block_aliquot_master_id] = $empty_aliquots_subarray;
				$tissues_blocks_and_buffy_coat_data[$block_aliquot_master_id]['ViewAliquot']['sample_type'] = 'tissue';
				$tissues_blocks_and_buffy_coat_data[$block_aliquot_master_id]['ViewAliquot']['aliquot_type'] = 'block';
				$tissues_blocks_and_buffy_coat_data[$block_aliquot_master_id]['AliquotMaster']['aliquot_label'] = $new_row['AliquotMaster_TissueBlock_BcTube']['block_aliquot_label'];
				$tissues_blocks_and_buffy_coat_data[$block_aliquot_master_id]['AliquotMaster']['barcode'] = $new_row['AliquotMaster_TissueBlock_BcTube']['block_barcode'];
				$tissues_blocks_and_buffy_coat_data[$block_aliquot_master_id]['ViewCollection']['misc_identifier_value'] = $new_row['MiscIdentifier']['misc_identifier_value'];
				$tissues_blocks_and_buffy_coat_data[$block_aliquot_master_id]['ViewCollection']['participant_identifier'] = $new_row['Participant']['participant_identifier'];
				$tissues_blocks_and_buffy_coat_data[$block_aliquot_master_id]['ViewCollection']['qc_lady_specimen_type_precision'] = $new_row['Collection']['qc_lady_specimen_type_precision'];			
				$tissues_blocks_and_buffy_coat_data[$block_aliquot_master_id]['ViewCollection']['qc_lady_visit'] = $new_row['Collection']['qc_lady_visit'];			
			}
			
			if($new_row['AliquotDetail_TissueTube']['tissue_tube_aliquot_master_id']) {			
				if(is_null($tissues_blocks_and_buffy_coat_data[$block_aliquot_master_id]['AliquotDetail']['tissue_tube_aliquot_master_id'])) {
					$tissues_blocks_and_buffy_coat_data[$block_aliquot_master_id]['AliquotDetail'] = array(
						'tissue_tube_aliquot_master_id' => $new_row['AliquotDetail_TissueTube']['tissue_tube_aliquot_master_id'],
						'qc_lady_storage_solution' => $new_row['AliquotDetail_TissueTube']['qc_lady_storage_solution'],
						'qc_lady_storage_method' => $new_row['AliquotDetail_TissueTube']['qc_lady_storage_method']);
				} else if($tissues_blocks_and_buffy_coat_data[$block_aliquot_master_id]['AliquotDetail']['tissue_tube_aliquot_master_id'] != $new_row['AliquotDetail_TissueTube']['tissue_tube_aliquot_master_id']) {
					$tissue_blocks_having_many_aliquots_source[] = $new_row['AliquotMaster_TissueBlock_BcTube']['block_aliquot_label'];
				}			
			}
			
			if($new_row['AliquotReviewDetail']['aliquot_review_master_id']) {
				if(!$tissues_blocks_and_buffy_coat_data[$block_aliquot_master_id]['AliquotReviewDetail']['aliquot_review_master_id']) {
					$tissues_blocks_and_buffy_coat_data[$block_aliquot_master_id]['AliquotReviewDetail'] = array(
						'aliquot_review_master_id' => $new_row['AliquotReviewDetail']['aliquot_review_master_id'],
						'tumor_percentage' => $new_row['AliquotReviewDetail']['tumor_percentage'],
						'necrosis_percentage_itz' => $new_row['AliquotReviewDetail']['necrosis_percentage_itz'],
						'cellularity_percentage_itz' => $new_row['AliquotReviewDetail']['cellularity_percentage_itz'],
						'stroma_percentage_itz' => $new_row['AliquotReviewDetail']['stroma_percentage_itz']);
				} else if($tissues_blocks_and_buffy_coat_data[$block_aliquot_master_id]['AliquotReviewDetail']['aliquot_review_master_id'] != $new_row['AliquotReviewDetail']['aliquot_review_master_id']) {
					$tissue_blocks_having_many_reviews[] = $new_row['AliquotMaster_TissueBlock_BcTube']['block_aliquot_label'];
				}
			}
		}
		if($tissue_blocks_having_many_reviews) AppController::addWarningMsg(__('some blocks have been attached to many reviews').' - '.str_replace('%s', '"'.implode('", "', $tissue_blocks_having_many_reviews).'"', __('see # %s')));
		if($tissue_blocks_having_many_aliquots_source) AppController::addWarningMsg(__('some blocks are linked to many aliquots source').' - '.str_replace('%s', '"'.implode('", "', $tissue_blocks_having_many_aliquots_source).'"', __('see # %s')));
		
		// Get buffy coat data
		$all_data = $this->Report->tryCatchQuery("
			SELECT
			Participant.id AS participant_id,
			Participant.participant_identifier,
	
			Collection.id AS collection_id,
			Collection.qc_lady_specimen_type_precision,
			Collection.qc_lady_visit,
			MiscIdentifier.identifier_value AS misc_identifier_value,
	
			AliquotMaster_TissueBlock_BcTube.id AS bc_tube_aliquot_master_id,
			AliquotMaster_TissueBlock_BcTube.aliquot_label AS bc_tube_aliquot_label,
			AliquotMaster_TissueBlock_BcTube.barcode AS bc_tube_barcode
	
			FROM collections Collection
			INNER JOIN aliquot_masters AS AliquotMaster_TissueBlock_BcTube ON AliquotMaster_TissueBlock_BcTube.collection_id = Collection.id AND AliquotMaster_TissueBlock_BcTube.deleted <> 1 AND AliquotMaster_TissueBlock_BcTube.aliquot_control_id = $buffy_coat_tube_control_id
	
			LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
			LEFT JOIN misc_identifiers AS MiscIdentifier ON Collection.misc_identifier_id = MiscIdentifier.id AND MiscIdentifier.deleted <> 1
	
			WHERE $criteria
	
			ORDER BY MiscIdentifier.identifier_value, Collection.id, AliquotMaster_TissueBlock_BcTube.id;");
		
		foreach($all_data as $new_row) {
			$bc_tube_aliquot_master_id = $new_row['AliquotMaster_TissueBlock_BcTube']['bc_tube_aliquot_master_id'];
			if(array_key_exists($bc_tube_aliquot_master_id, $tissues_blocks_and_buffy_coat_data)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			$tissues_blocks_and_buffy_coat_data[$bc_tube_aliquot_master_id] = $empty_aliquots_subarray;
			$tissues_blocks_and_buffy_coat_data[$bc_tube_aliquot_master_id]['ViewAliquot']['sample_type'] = 'pbmc';
			$tissues_blocks_and_buffy_coat_data[$bc_tube_aliquot_master_id]['ViewAliquot']['aliquot_type'] = 'tube';
			$tissues_blocks_and_buffy_coat_data[$bc_tube_aliquot_master_id]['AliquotMaster']['aliquot_label'] = $new_row['AliquotMaster_TissueBlock_BcTube']['bc_tube_aliquot_label'];
			$tissues_blocks_and_buffy_coat_data[$bc_tube_aliquot_master_id]['AliquotMaster']['barcode'] = $new_row['AliquotMaster_TissueBlock_BcTube']['bc_tube_barcode'];
			$tissues_blocks_and_buffy_coat_data[$bc_tube_aliquot_master_id]['ViewCollection']['misc_identifier_value'] = $new_row['MiscIdentifier']['misc_identifier_value'];
			$tissues_blocks_and_buffy_coat_data[$bc_tube_aliquot_master_id]['ViewCollection']['participant_identifier'] = $new_row['Participant']['participant_identifier'];
			$tissues_blocks_and_buffy_coat_data[$bc_tube_aliquot_master_id]['ViewCollection']['qc_lady_specimen_type_precision'] = $new_row['Collection']['qc_lady_specimen_type_precision'];
			$tissues_blocks_and_buffy_coat_data[$bc_tube_aliquot_master_id]['ViewCollection']['qc_lady_visit'] = $new_row['Collection']['qc_lady_visit'];
		}
		
		// Get DNA/RNA samples volumes sorted by sample 		
		$dna_rna_sample_data = $this->Report->tryCatchQuery("
			SELECT
			AliquotMaster_TissueBlock_BcTube.id AS block_aliquot_master_id,
			SampleMaster_DnaRna.id dna_rna_sample_master_id,
			AliquotMaster_DnaRna.current_volume
			FROM aliquot_masters AS AliquotMaster_TissueBlock_BcTube
			INNER JOIN source_aliquots SourceAliquot_ToDnaRna ON SourceAliquot_ToDnaRna.aliquot_master_id = AliquotMaster_TissueBlock_BcTube.id AND SourceAliquot_ToDnaRna.deleted <> 1
			INNER JOIN sample_masters AS SampleMaster_DnaRna ON SampleMaster_DnaRna.id = SourceAliquot_ToDnaRna.sample_master_id AND SampleMaster_DnaRna.deleted <> 1 AND SampleMaster_DnaRna.sample_control_id IN ($rna_control_id, $dna_control_id) 
			INNER JOIN aliquot_masters AS AliquotMaster_DnaRna ON AliquotMaster_DnaRna.sample_master_id = SampleMaster_DnaRna.id AND AliquotMaster_DnaRna.deleted <> 1 AND AliquotMaster_DnaRna.in_stock != 'no'
			WHERE AliquotMaster_TissueBlock_BcTube.id IN ('".implode("','",array_keys($tissues_blocks_and_buffy_coat_data))."')
			ORDER BY SampleMaster_DnaRna.id;");
		$dna_rna_samples_volumes = array();
		foreach($dna_rna_sample_data as $new_dna_rna) {
			if($new_dna_rna['AliquotMaster_DnaRna']['current_volume']) {
				if(!isset($dna_rna_samples_volumes[$new_dna_rna['SampleMaster_DnaRna']['dna_rna_sample_master_id']])) $dna_rna_samples_volumes[$new_dna_rna['SampleMaster_DnaRna']['dna_rna_sample_master_id']] = 0;
				$dna_rna_samples_volumes[$new_dna_rna['SampleMaster_DnaRna']['dna_rna_sample_master_id']] += $new_dna_rna['AliquotMaster_DnaRna']['current_volume'];
			}
		}
		
		// DNA/RNA QC
		$dna_rna_qc_data = $this->Report->tryCatchQuery("
			SELECT
			AliquotMaster_TissueBlock_BcTube.id AS source_aliquot_master_id,
			SampleMaster_DnaRna.id dna_rna_sample_master_id,
			SampleMaster_DnaRna.sample_code,
			SampleControl_DnaRna.sample_type,
				
			QualityCtrl_DnaRna.type,
			QualityCtrl_DnaRna.qc_lady_rin_score,
			QualityCtrl_DnaRna.qc_lady_260_230_score,
			QualityCtrl_DnaRna.qc_lady_260_280_score,
			QualityCtrl_DnaRna.concentration,
			QualityCtrl_DnaRna.concentration_unit,
				
			AliquotMaster_TestedDnaRnaTube.current_volume
			
			FROM aliquot_masters AS AliquotMaster_TissueBlock_BcTube
			INNER JOIN source_aliquots SourceAliquot_ToDnaRna ON SourceAliquot_ToDnaRna.aliquot_master_id = AliquotMaster_TissueBlock_BcTube.id AND SourceAliquot_ToDnaRna.deleted <> 1
			INNER JOIN sample_masters AS SampleMaster_DnaRna ON SampleMaster_DnaRna.id = SourceAliquot_ToDnaRna.sample_master_id AND SampleMaster_DnaRna.deleted <> 1 AND SampleMaster_DnaRna.sample_control_id IN ($rna_control_id, $dna_control_id)
			INNER JOIN sample_controls AS SampleControl_DnaRna ON SampleControl_DnaRna.id = SampleMaster_DnaRna.sample_control_id
			INNER JOIN quality_ctrls AS QualityCtrl_DnaRna ON QualityCtrl_DnaRna.sample_master_id = SampleMaster_DnaRna.id AND QualityCtrl_DnaRna.deleted <> 1
			LEFT JOIN aliquot_masters AS AliquotMaster_TestedDnaRnaTube ON AliquotMaster_TestedDnaRnaTube.id = QualityCtrl_DnaRna.aliquot_master_id AND AliquotMaster_TestedDnaRnaTube.deleted <> 1 AND AliquotMaster_TestedDnaRnaTube.in_stock != 'no'
			WHERE AliquotMaster_TissueBlock_BcTube.id IN ('".implode("','",array_keys($tissues_blocks_and_buffy_coat_data))."') AND QualityCtrl_DnaRna.type IN ('bioanalyzer','Nanodrop','PicoGreen')
			ORDER BY AliquotMaster_TissueBlock_BcTube.id, SampleMaster_DnaRna.id, QualityCtrl_DnaRna.date;");
		$all_block_and_buffy_coat_dna_rna_qcs = array();
		foreach($dna_rna_qc_data as $new_qc_data) {
			$source_aliquot_master_id = $new_qc_data['AliquotMaster_TissueBlock_BcTube']['source_aliquot_master_id'];
			$dna_rna_sample_master_id = $new_qc_data['SampleMaster_DnaRna']['dna_rna_sample_master_id'];
			$dna_rna_sample_type = $new_qc_data['SampleControl_DnaRna']['sample_type'];
			
			if(!isset($all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id])) {
				$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id] = array(
					'next_nano_drop_key' => '0', 
					'next_pico_green_bioanalyzer_key' => '0'
				);
			}
			
			$calculated_quantity = '-';
			$calculated_quantity_of_tested_aliquot = '-';
			if(array_key_exists($dna_rna_sample_master_id, $dna_rna_samples_volumes) && strlen($new_qc_data['QualityCtrl_DnaRna']['concentration'])) {
				$div = 1;
				switch($new_qc_data['QualityCtrl_DnaRna']['concentration_unit']) {
					case 'pg/ul':
						$div = 1000;
					case 'ng/ul':
						$div = 1000*$div;
					case 'ug/ul':
						$calculated_quantity = $new_qc_data['QualityCtrl_DnaRna']['concentration']*$dna_rna_samples_volumes[$dna_rna_sample_master_id]/$div;
						if(strlen($new_qc_data['AliquotMaster_TestedDnaRnaTube']['current_volume'])) $calculated_quantity_of_tested_aliquot = $new_qc_data['QualityCtrl_DnaRna']['concentration']*$new_qc_data['AliquotMaster_TestedDnaRnaTube']['current_volume']/$div;
						break;
					default:
						$calculated_quantity = __('concentration unit missing');
						if(strlen($new_qc_data['AliquotMaster_TestedDnaRnaTube']['current_volume'])) $calculated_quantity_of_tested_aliquot = __('concentration unit missing');
				}
			}
			switch($new_qc_data['QualityCtrl_DnaRna']['type']) {
				case 'Nanodrop':
					$next_nano_drop_key = $all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['next_nano_drop_key'];
					$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['next_nano_drop_key'] += 1;
					if($dna_rna_sample_type == 'dna') {
						$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['data'][$next_nano_drop_key]['qc_lady_qc_dna_sample_code'] = $new_qc_data['SampleMaster_DnaRna']['sample_code'];
						$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['data'][$next_nano_drop_key]['qc_lady_qc_nano_drop_dna_260_280'] = $new_qc_data['QualityCtrl_DnaRna']['qc_lady_260_280_score'];
						$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['data'][$next_nano_drop_key]['qc_lady_qc_nano_drop_dna_yield_ug'] = $calculated_quantity;
						$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['data'][$next_nano_drop_key]['qc_lady_qc_nano_drop_tested_dna_yield_ug'] = $calculated_quantity_of_tested_aliquot;
					} else if($dna_rna_sample_type == 'rna'){
						$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['data'][$next_nano_drop_key]['qc_lady_qc_rna_sample_code'] = $new_qc_data['SampleMaster_DnaRna']['sample_code'];
						$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['data'][$next_nano_drop_key]['qc_lady_qc_nano_drop_rna_260_280'] = $new_qc_data['QualityCtrl_DnaRna']['qc_lady_260_280_score'];
						$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['data'][$next_nano_drop_key]['qc_lady_qc_nano_drop_rna_yield_ug'] = $calculated_quantity;
						$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['data'][$next_nano_drop_key]['qc_lady_qc_nano_drop_tested_rna_yield_ug'] = $calculated_quantity_of_tested_aliquot;
					}
					break;
				case 'PicoGreen':
				case 'bioanalyzer':
					$next_pico_green_bioanalyzer_key = $all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['next_pico_green_bioanalyzer_key'];
					$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['next_pico_green_bioanalyzer_key'] += 1;
					if($dna_rna_sample_type == 'dna' && $new_qc_data['QualityCtrl_DnaRna']['type'] == 'PicoGreen') {
						$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['data'][$next_pico_green_bioanalyzer_key]['qc_lady_qc_dna_sample_code'] = $new_qc_data['SampleMaster_DnaRna']['sample_code'];
						$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['data'][$next_pico_green_bioanalyzer_key]['qc_lady_qc_pico_green_dna_yield_ug'] = $calculated_quantity;
						$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['data'][$next_pico_green_bioanalyzer_key]['qc_lady_qc_pico_green_tested_dna_yield_ug'] = $calculated_quantity_of_tested_aliquot;
					} else if($dna_rna_sample_type == 'rna' && $new_qc_data['QualityCtrl_DnaRna']['type'] == 'bioanalyzer'){
						$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['data'][$next_pico_green_bioanalyzer_key]['qc_lady_qc_rna_sample_code'] = $new_qc_data['SampleMaster_DnaRna']['sample_code'];
						$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['data'][$next_pico_green_bioanalyzer_key]['qc_lady_qc_bioanalyzer_rna_rin'] = $new_qc_data['QualityCtrl_DnaRna']['qc_lady_rin_score'];
						$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['data'][$next_pico_green_bioanalyzer_key]['qc_lady_qc_bioanalyzer_rna_yield_ug'] = $calculated_quantity;
						$all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id][$dna_rna_sample_type][$dna_rna_sample_master_id]['data'][$next_pico_green_bioanalyzer_key]['qc_lady_qc_bioanalyzer_tested_rna_yield_ug'] = $calculated_quantity_of_tested_aliquot;
					}
					break;	
			}
		}	
		foreach($all_block_and_buffy_coat_dna_rna_qcs as $source_aliquot_master_id => &$new_block_dna_rna) {
			$new_block_dna_rna['formated_qcs'] = array();
			foreach(array('dna','rna') as $new_sample_type) {
				$formated_qc_key = 0 ;
				if(isset($new_block_dna_rna[$new_sample_type])) {
					foreach($new_block_dna_rna[$new_sample_type] as $tmp_1) {
						if(array_key_exists('data', $tmp_1)) { 
							foreach($tmp_1['data'] as $new_sample_type_qc) {
								$new_block_dna_rna['formated_qcs'][$formated_qc_key] = array_merge($new_sample_type_qc, (isset($new_block_dna_rna['formated_qcs'][$formated_qc_key])? $new_block_dna_rna['formated_qcs'][$formated_qc_key] : array()));
								$formated_qc_key++;
							}						
						}

					}
				}
				unset($new_block_dna_rna[$new_sample_type]);
			}
		}
		
		// Merge Block/buffy coat data and DNA RNA QCs
		$empty_qc_sub_array = array(
			'qc_lady_qc_rna_sample_code' => '',
			'qc_lady_qc_nano_drop_rna_yield_ug' => '',
			'qc_lady_qc_nano_drop_tested_rna_yield_ug' => '',
			'qc_lady_qc_nano_drop_rna_260_280' => '',
			'qc_lady_qc_bioanalyzer_rna_yield_ug' => '',
			'qc_lady_qc_bioanalyzer_tested_rna_yield_ug' => '',
			'qc_lady_qc_bioanalyzer_rna_rin' => '',
			'qc_lady_qc_dna_sample_code' => '',
			'qc_lady_qc_nano_drop_dna_yield_ug' => '',
			'qc_lady_qc_nano_drop_tested_dna_yield_ug' => '',
			'qc_lady_qc_nano_drop_dna_260_280' => '',
			'qc_lady_qc_pico_green_dna_yield_ug' => '',
			'qc_lady_qc_pico_green_tested_dna_yield_ug' => '');
		
		$final_data = array();
		foreach($tissues_blocks_and_buffy_coat_data as $source_aliquot_master_id => $block_and_buffy_coat_data) {	
			if(array_key_exists($source_aliquot_master_id, $all_block_and_buffy_coat_dna_rna_qcs) && !empty($all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id]['formated_qcs'])) {
				$first_row = true;
				foreach($all_block_and_buffy_coat_dna_rna_qcs[$source_aliquot_master_id]['formated_qcs'] as $new_qc_data_set) {
					if($first_row) {
						$block_and_buffy_coat_data['Generated'] = array_merge($empty_qc_sub_array, $new_qc_data_set);
						$final_data[] = $block_and_buffy_coat_data;
					} else {
						$new_block_and_buffy_coat_data = $empty_aliquots_subarray;
						$new_block_and_buffy_coat_data['ViewAliquot']['sample_type'] = $block_and_buffy_coat_data['ViewAliquot']['sample_type'];
						$new_block_and_buffy_coat_data['ViewAliquot']['aliquot_type'] = $block_and_buffy_coat_data['ViewAliquot']['aliquot_type'];
						$new_block_and_buffy_coat_data['AliquotMaster']['barcode'] = $block_and_buffy_coat_data['AliquotMaster']['barcode'];
						$new_block_and_buffy_coat_data['AliquotMaster']['aliquot_label'] = $block_and_buffy_coat_data['AliquotMaster']['aliquot_label'];
						$new_block_and_buffy_coat_data['Generated'] = array_merge($empty_qc_sub_array, $new_qc_data_set);
						$final_data[] = $new_block_and_buffy_coat_data;
					}
					$first_row = false;
				}
			} else {
				$block_and_buffy_coat_data['Generated'] = $empty_qc_sub_array;
				$final_data[] = $block_and_buffy_coat_data;
			}
		}
		
		$array_to_return = array(
			'header' => null, 
			'data' => $final_data, 
			'columns_names' => null,
			'error_msg' => null);
		
		return $array_to_return;		
	}
	
	
	
	
}