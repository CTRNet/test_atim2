<?php
class ReportsControllerCustom extends ReportsController {
	
	function participantIdentifiersSummary($parameters) {
		$header = null;
		$conditions = array();

		if(isset($parameters['Participant']['id'])) {
			//From databrowser
			$participant_ids  = array_filter($parameters['Participant']['id']);
			if($participant_ids) $conditions['MiscIdentifier.participant_id'] = $participant_ids;
		} else {
			if(isset($parameters['MiscIdentifier']['misc_identifier_control_id'])) {
				$misc_identifier_control_ids  = array_filter($parameters['MiscIdentifier']['misc_identifier_control_id']);
				if($misc_identifier_control_ids) $conditions['MiscIdentifier.misc_identifier_control_id'] = $misc_identifier_control_ids;
			}
			if(isset($parameters['MiscIdentifier']['identifier_value_start'])) {
				$identifier_value_start = (!empty($parameters['MiscIdentifier']['identifier_value_start']))? $parameters['MiscIdentifier']['identifier_value_start']: null;
				$identifier_value_end = (!empty($parameters['MiscIdentifier']['identifier_value_end']))? $parameters['MiscIdentifier']['identifier_value_end']: null;
				if($identifier_value_start) $conditions['MiscIdentifier.identifier_value >='] = $identifier_value_start;
				if($identifier_value_end) $conditions['MiscIdentifier.identifier_value <='] = $identifier_value_end;
			} else if(isset($parameters['MiscIdentifier']['identifier_value'])) {
				$identifier_values  = array_filter($parameters['MiscIdentifier']['identifier_value']);
				if($identifier_values) $conditions['MiscIdentifier.identifier_value'] = $identifier_values;
			} else {
				$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		}
		
		$misc_identifier_model = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
		$participant_ids_tmp = $misc_identifier_model->find('all', array('conditions' => $conditions, 'order' => array('MiscIdentifier.participant_id ASC'), 'fields' => array('DISTINCT MiscIdentifier.participant_id'), 'recursive' => '-1'));
		$participant_ids = array();
		foreach($participant_ids_tmp as $new_record) $participant_ids[$new_record['MiscIdentifier']['participant_id']] = $new_record['MiscIdentifier']['participant_id'];
		
		if(sizeof($participant_ids) > Configure::read('databrowser_and_report_results_display_limit')) {
			return array(
					'header' => null,
					'data' => null,
					'columns_names' => null,
					'error_msg' => 'the report contains too many results - please redefine search criteria');
		}
		
		$misc_identifiers = $misc_identifier_model->find('all', array('conditions' => array('MiscIdentifier.participant_id' => $participant_ids), 'order' => array('MiscIdentifier.participant_id ASC')));
		$data = array();
		
		foreach($misc_identifiers as $new_ident){
			$participant_id = $new_ident['Participant']['id'];
			if(!isset($data[$participant_id])) {
				$data[$participant_id] = array(
						'Participant' => array(
								'id' => $new_ident['Participant']['id'],
								'participant_identifier' => $new_ident['Participant']['participant_identifier'],
								'first_name' => $new_ident['Participant']['first_name'],
								'last_name' => $new_ident['Participant']['last_name'],
								'date_of_birth' => $new_ident['Participant']['date_of_birth'],
								'date_of_birth_accuracy' => $new_ident['Participant']['date_of_birth_accuracy']),
						'0' => array(
								'ovary_gyneco_bank_no_lab' => null,
								'breast_bank_no_lab' => null,
								'prostate_bank_no_lab' => null,
								'kidney_bank_no_lab' => null,
								'head_and_neck_bank_no_lab' => null,
								'autopsy_bank_no_lab' => null,
								'melanoma_and_skin_bank_no_lab' => null,
								'ramq_nbr' => null,
								'hotel_dieu_id_nbr' => null,
								'notre_dame_id_nbr' => null,
								'saint_luc_id_nbr' => null,
								'other_center_id_nbr' => null,
								'old_bank_no_lab' => null,
								'code_barre' => null,
								'qc_nd_study_misc_identifier_value' => '')
				);
			}
			$generated_key = str_replace(array(' ', '-', '/'), array('_','_','_'), $new_ident['MiscIdentifierControl']['misc_identifier_name']);
			if(array_key_exists($generated_key, $data[$participant_id]['0'])) {
				$data[$participant_id]['0'][$generated_key] = $new_ident['MiscIdentifier']['identifier_value'];
			} else if($new_ident['MiscIdentifier']['study_summary_id']) {
				$data[$participant_id]['0']['qc_nd_study_misc_identifier_value'] .= $new_ident['StudySummary']['title'].' ['.$new_ident['MiscIdentifier']['identifier_value']."] ";
			}
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
	
	function getAllSpecimens($parameters) {
		$header = null;
		$conditions = array("SampleMaster.id != SampleMaster.initial_specimen_sample_id");		
		// Get Parameters
		if(isset($parameters['SampleMaster']['sample_code']) || isset($parameters['SampleMaster']['qc_nd_sample_label'])) {
			//From databrowser
			$selection_labels  = array_filter($parameters['SampleMaster']['sample_code']);
			if($selection_labels) $conditions['SampleMaster.sample_code'] = $selection_labels;
			$selection_labels  = array_filter($parameters['SampleMaster']['qc_nd_sample_label']);
			$selection_labels_statements = array();		
			foreach($selection_labels as $new_label) $selection_labels_statements[] = "SampleMaster.qc_nd_sample_label LIKE '%".$new_label."%'";
			if($selection_labels_statements) $conditions[] = '('.implode(' OR ', $selection_labels_statements).')';
		} else if(isset($parameters['ViewSample']['sample_master_id'])) {
			//From databrowser
			$sample_master_ids  = array_filter($parameters['ViewSample']['sample_master_id']);
			if($sample_master_ids) $conditions['SampleMaster.id'] = $sample_master_ids;
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		// Load Model
		$view_sample_model = AppModel::getInstance("InventoryManagement", "ViewSample", true);
		$sample_master_model = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
		// Build Res
		$sample_master_model->unbindModel(array('belongsTo' => array('Collection'),'hasOne' => array('SpecimenDetail','DerivativeDetail'),'hasMany' => array('AliquotMaster')));
		$tmp_res_count = $sample_master_model->find('count', array('conditions' => $conditions, 'fields' => array('SampleMaster.*', 'SampleControl.*'), 'order' => array('SampleMaster.sample_code ASC'), 'recursive' => '0'));
		if($tmp_res_count > Configure::read('databrowser_and_report_results_display_limit')) {
			return array(
					'header' => null,
					'data' => null,
					'columns_names' => null,
					'error_msg' => 'the report contains too many results - please redefine search criteria');
		}
		$studied_samples = $sample_master_model->find('all', array('conditions' => $conditions, 'fields' => array('SampleMaster.*', 'SampleControl.*'), 'order' => array('SampleMaster.sample_code ASC'), 'recursive' => '0'));
		$res = array();
		$tmp_initial_specimens = array();
		foreach($studied_samples as $new_studied_sample) {
			$initial_specimen = isset($tmp_initial_specimens[$new_studied_sample['SampleMaster']['initial_specimen_sample_id']])?
			$tmp_initial_specimens[$new_studied_sample['SampleMaster']['initial_specimen_sample_id']]:
			$view_sample_model->find('first', array('conditions' => array('ViewSample.sample_master_id' => $new_studied_sample['SampleMaster']['initial_specimen_sample_id']), 'fields' => array('ViewSample.*, SpecimenDetail.*'), 'order' => array('ViewSample.sample_code ASC'), 'recursive' => '0'));
			$tmp_initial_specimens[$new_studied_sample['SampleMaster']['initial_specimen_sample_id']] = $initial_specimen;
			if($initial_specimen){
				if(!(array_key_exists('SelectedItemsForCsv', $parameters) && !in_array($initial_specimen['ViewSample']['sample_master_id'], $parameters['SelectedItemsForCsv']['ViewSample']['sample_master_id']))) $res[] = array_merge($new_studied_sample, $initial_specimen);
			}
		}
		return array(
				'header' => $header,
				'data' => $res,
				'columns_names' => null,
				'error_msg' => null);
	}
	
	function getAllDerivatives($parameters) {
		$header = null;
		$conditions = array();
		// Get Parameters
		if(isset($parameters['SampleMaster']['sample_code']) || isset($parameters['SampleMaster']['qc_nd_sample_label'])) {
			//From databrowser
			$selection_labels  = array_filter($parameters['SampleMaster']['sample_code']);
			if($selection_labels) $conditions['SampleMaster.sample_code'] = $selection_labels;
			$selection_labels  = array_filter($parameters['SampleMaster']['qc_nd_sample_label']);
			$selection_labels_statements = array();		
			foreach($selection_labels as $new_label) $selection_labels_statements[] = "SampleMaster.qc_nd_sample_label LIKE '%".$new_label."%'";
			if($selection_labels_statements) $conditions[] = '('.implode(' OR ', $selection_labels_statements).')';
		} else if(isset($parameters['ViewSample']['sample_master_id'])) {
			//From databrowser
			$sample_master_ids  = array_filter($parameters['ViewSample']['sample_master_id']);
			if($sample_master_ids) $conditions['SampleMaster.id'] = $sample_master_ids;
		} else {
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		// Load Model
		$view_sample_model = AppModel::getInstance("InventoryManagement", "ViewSample", true);
		$sample_master_model = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
		// Build Res
		$sample_master_model->unbindModel(array('belongsTo' => array('Collection'),'hasOne' => array('SpecimenDetail','DerivativeDetail'),'hasMany' => array('AliquotMaster')));
		$tmp_res_count =  $sample_master_model->find('count', array('conditions' => $conditions, 'fields' => array('SampleMaster.*', 'SampleControl.*'), 'order' => array('SampleMaster.sample_code ASC'), 'recursive' => '0'));
		if($tmp_res_count > Configure::read('databrowser_and_report_results_display_limit')) {
			return array(
					'header' => null,
					'data' => null,
					'columns_names' => null,
					'error_msg' => 'the report contains too many results - please redefine search criteria');
		}
		$studied_samples = $sample_master_model->find('all', array('conditions' => $conditions, 'fields' => array('SampleMaster.*', 'SampleControl.*'), 'order' => array('SampleMaster.sample_code ASC'), 'recursive' => '0'));
		$res = array();
		foreach($studied_samples as $new_studied_sample) {
			$all_derivatives_samples = $this->getChildrenSamples($view_sample_model, array($new_studied_sample['SampleMaster']['id']));
			if($all_derivatives_samples){
				foreach($all_derivatives_samples as $new_derivative_sample) {
					if(array_key_exists('SelectedItemsForCsv', $parameters) && !in_array($new_derivative_sample['ViewSample']['sample_master_id'], $parameters['SelectedItemsForCsv']['ViewSample']['sample_master_id'])) continue;
					$res[] = array_merge($new_studied_sample, $new_derivative_sample);
				}
			}
		}
		return array(
				'header' => $header,
				'data' => $res,
				'columns_names' => null,
				'error_msg' => null);
	}
}