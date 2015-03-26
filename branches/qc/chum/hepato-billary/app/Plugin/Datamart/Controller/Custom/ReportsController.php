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
								'health_insurance_card' => null,
								'saint_luc_hospital_nbr' => null,
								'notre_dame_hospital_nbr' => null,
								'hotel_dieu_hospital_nbr' => null)
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
	
	function ctrnetCatalogSubmissionFileSorteByIcdCodes($parameters) {
			
		// 1- Build Header
		$header = array(
				'title' => __('qc_hb_report_ctrnet_catalog_sorted_by_icd_name'),
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
		
		$sql = "
			SELECT count(*) AS nbr, res.primary_icd10_code, res.collection_icd10_code FROM (
				SELECT DISTINCT %%id%%, primary_diagnosis.icd10_code primary_icd10_code, collection_diagnosis.icd10_code collection_icd10_code
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				LEFT JOIN diagnosis_masters AS collection_diagnosis ON collection_diagnosis.id = col.diagnosis_master_id
				LEFT JOIN diagnosis_masters AS primary_diagnosis ON primary_diagnosis.id = collection_diagnosis.primary_id
				WHERE col.deleted != '1' 
				AND ($bank_conditions)
				AND ($aliquot_type_confitions) 
				AND am.in_stock IN ('yes - available ','yes - not available')
			) AS res GROUP BY res.primary_icd10_code, res.collection_icd10_code;";	
		//Participant	
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		foreach($query_results as $new_result) {
			$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
			$data_key = $ctrnet_classification.'-total';
			if(!isset($data[$data_key])) {
				$data[$data_key] = array(
					'qc_hb_ctrnet_classification' => $ctrnet_classification,
					'qc_hb_primary_icd10_codes' => array($new_result['res']['primary_icd10_code'] => $new_result['res']['primary_icd10_code']),
					'qc_hb_collection_icd10_codes' => array($new_result['res']['collection_icd10_code'] => $new_result['res']['collection_icd10_code']),
					'sample_type' => __('total'),
					'cases_nbr' => $new_result['0']['nbr'],
					'aliquots_nbr' => 0,
					'notes' => array());
			} else {
				$data[$data_key]['qc_hb_primary_icd10_codes'][$new_result['res']['primary_icd10_code']] = $new_result['res']['primary_icd10_code'];
				$data[$data_key]['qc_hb_collection_icd10_codes'][$new_result['res']['collection_icd10_code']] = $new_result['res']['collection_icd10_code'];
				$data[$data_key]['cases_nbr'] = $data[$data_key]['cases_nbr'] + $new_result['0']['nbr'];
			}
		}
		//Aliquot
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		foreach($query_results as $new_result) {
			$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
			$data_key = $ctrnet_classification.'-total';
			$data[$data_key]['aliquots_nbr'] = $data[$data_key]['aliquots_nbr'] + $new_result['0']['nbr'];
		}
		
		// **FFPE**
		
		$sql = "	
			SELECT count(*) AS nbr, res.primary_icd10_code, res.collection_icd10_code FROM (
				SELECT DISTINCT  %%id%%, primary_diagnosis.icd10_code primary_icd10_code, collection_diagnosis.icd10_code collection_icd10_code
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				INNER JOIN ad_blocks AS blk ON blk.aliquot_master_id = am.id
				LEFT JOIN diagnosis_masters AS collection_diagnosis ON collection_diagnosis.id = col.diagnosis_master_id
				LEFT JOIN diagnosis_masters AS primary_diagnosis ON primary_diagnosis.id = collection_diagnosis.primary_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ('tissue')
				AND ac.aliquot_type = 'block'
				AND blk.block_type = 'paraffin'
			) AS res GROUP BY res.primary_icd10_code, res.collection_icd10_code;";
		//Participant
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		foreach($query_results as $new_result) {
			$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
			$data_key = $ctrnet_classification.'-FFPE';
			if(!isset($data[$data_key])) {
				$data[$data_key] = array(
					'qc_hb_ctrnet_classification' => $ctrnet_classification,
					'qc_hb_primary_icd10_codes' => array($new_result['res']['primary_icd10_code'] => $new_result['res']['primary_icd10_code']),
					'qc_hb_collection_icd10_codes' => array($new_result['res']['collection_icd10_code'] => $new_result['res']['collection_icd10_code']),
					'sample_type' => __('FFPE'),
					'cases_nbr' => $new_result['0']['nbr'],
					'aliquots_nbr' => 0,
					'notes' => array());
			} else {
				$data[$data_key]['qc_hb_primary_icd10_codes'][$new_result['res']['primary_icd10_code']] = $new_result['res']['primary_icd10_code'];
				$data[$data_key]['qc_hb_collection_icd10_codes'][$new_result['res']['collection_icd10_code']] = $new_result['res']['collection_icd10_code'];
				$data[$data_key]['cases_nbr'] = $data[$data_key]['cases_nbr'] + $new_result['0']['nbr'];
			}
		}
		//Aliquot
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		foreach($query_results as $new_result) {
			$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
			$data_key = $ctrnet_classification.'-FFPE';
			$data[$data_key]['aliquots_nbr'] = $data[$data_key]['aliquots_nbr'] + $new_result['0']['nbr'];
		}
		
		// **frozen tissue**
		
		$sql = "
			SELECT count(*) AS nbr, res.primary_icd10_code, res.collection_icd10_code FROM (
				SELECT DISTINCT  %%id%%, primary_diagnosis.icd10_code primary_icd10_code, collection_diagnosis.icd10_code collection_icd10_code
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				LEFT JOIN diagnosis_masters AS collection_diagnosis ON collection_diagnosis.id = col.diagnosis_master_id
				LEFT JOIN diagnosis_masters AS primary_diagnosis ON primary_diagnosis.id = collection_diagnosis.primary_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ('tissue')
				AND ($aliquot_type_confitions) 
				AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin')
			) AS res GROUP BY res.primary_icd10_code, res.collection_icd10_code;";
		//Participant
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		foreach($query_results as $new_result) {
			$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
			$data_key = $ctrnet_classification.'-frozen tissue';
			if(!isset($data[$data_key])) {
				$data[$data_key] = array(
					'qc_hb_ctrnet_classification' => $ctrnet_classification,
					'qc_hb_primary_icd10_codes' => array($new_result['res']['primary_icd10_code'] => $new_result['res']['primary_icd10_code']),
					'qc_hb_collection_icd10_codes' => array($new_result['res']['collection_icd10_code'] => $new_result['res']['collection_icd10_code']),
					'sample_type' => __('frozen tissue'),
					'cases_nbr' => $new_result['0']['nbr'],
					'aliquots_nbr' => 0,
					'notes' => array());
			} else {
				$data[$data_key]['qc_hb_primary_icd10_codes'][$new_result['res']['primary_icd10_code']] = $new_result['res']['primary_icd10_code'];
				$data[$data_key]['qc_hb_collection_icd10_codes'][$new_result['res']['collection_icd10_code']] = $new_result['res']['collection_icd10_code'];
				$data[$data_key]['cases_nbr'] = $data[$data_key]['cases_nbr'] + $new_result['0']['nbr'];
			}
		}
		//Aliquot
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		foreach($query_results as $new_result) {
			$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
			$data_key = $ctrnet_classification.'-frozen tissue';
			$data[$data_key]['aliquots_nbr'] = $data[$data_key]['aliquots_nbr'] + $new_result['0']['nbr'];
		}
		
		$sql = "
			SELECT DISTINCT sc.sample_type,ac.aliquot_type,blk.block_type, primary_diagnosis.icd10_code primary_icd10_code, collection_diagnosis.icd10_code collection_icd10_code
			FROM collections AS col
			INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
			INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
			INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
			INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
			INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
			LEFT JOIN ad_blocks AS blk ON blk.aliquot_master_id = am.id
			LEFT JOIN diagnosis_masters AS collection_diagnosis ON collection_diagnosis.id = col.diagnosis_master_id
			LEFT JOIN diagnosis_masters AS primary_diagnosis ON primary_diagnosis.id = collection_diagnosis.primary_id
			WHERE col.deleted != '1' AND ($bank_conditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type IN ('tissue')
			AND ($aliquot_type_confitions) 
			AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin');";
		$query_results = $this->Report->tryCatchQuery($sql);		
		foreach($query_results as $new_type) {
			$ctrnet_classification = $this->getCTRNetCatalogClassification($new_type['primary_diagnosis']['primary_icd10_code']);
			$data_key = $ctrnet_classification.'-frozen tissue';
			$note =  __($new_type['sc']['sample_type']).' '.__($new_type['ac']['aliquot_type']).(empty($new_type['blk']['block_type'])? '' : ' ('.__($new_type['blk']['block_type']).')');
			$data[$data_key]['notes'][$note] = $note;
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
		
		$sql = "
			SELECT count(*) AS nbr,sample_type, aliquot_type, res.primary_icd10_code, res.collection_icd10_code FROM (
				SELECT DISTINCT  %%id%%, sc.sample_type, ac.aliquot_type, primary_diagnosis.icd10_code primary_icd10_code, collection_diagnosis.icd10_code collection_icd10_code
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				LEFT JOIN diagnosis_masters AS collection_diagnosis ON collection_diagnosis.id = col.diagnosis_master_id
				LEFT JOIN diagnosis_masters AS primary_diagnosis ON primary_diagnosis.id = collection_diagnosis.primary_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ($sample_types)
				AND ($whatman_paper_confitions)	
			) AS res GROUP BY sample_type, aliquot_type, res.primary_icd10_code, res.collection_icd10_code;";
		//Participant
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		foreach($query_results as $new_result) {
			$sample_type = $new_result['res']['sample_type'];
			$aliquot_type = $new_result['res']['aliquot_type'];
			$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
			$data_key = $ctrnet_classification."-$sample_type-$aliquot_type";
			if(!isset($data[$data_key])) {
				$data[$data_key] = array(
					'qc_hb_ctrnet_classification' => $ctrnet_classification,
					'qc_hb_primary_icd10_codes' => array($new_result['res']['primary_icd10_code'] => $new_result['res']['primary_icd10_code']),
					'qc_hb_collection_icd10_codes' => array($new_result['res']['collection_icd10_code'] => $new_result['res']['collection_icd10_code']),
					'sample_type' => __($sample_type).' '.__($aliquot_type),
					'cases_nbr' => $new_result['0']['nbr'],
					'aliquots_nbr' => 0,
					'notes' => array());
			} else {
				$data[$data_key]['qc_hb_primary_icd10_codes'][$new_result['res']['primary_icd10_code']] = $new_result['res']['primary_icd10_code'];
				$data[$data_key]['qc_hb_collection_icd10_codes'][$new_result['res']['collection_icd10_code']] = $new_result['res']['collection_icd10_code'];
				$data[$data_key]['cases_nbr'] = $data[$data_key]['cases_nbr'] + $new_result['0']['nbr'];
			}
		}
		//Aliquot
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		foreach($query_results as $new_result) {
			$sample_type = $new_result['res']['sample_type'];
			$aliquot_type = $new_result['res']['aliquot_type'];
			$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
			$data_key = $ctrnet_classification."-$sample_type-$aliquot_type";
			$data[$data_key]['aliquots_nbr'] = $data[$data_key]['aliquots_nbr'] + $new_result['0']['nbr'];
		}
		
		// **Urine**	

		$sql = "
			SELECT count(*) AS nbr, res.primary_icd10_code, res.collection_icd10_code FROM (
				SELECT DISTINCT  %%id%%, primary_diagnosis.icd10_code primary_icd10_code, collection_diagnosis.icd10_code collection_icd10_code
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				LEFT JOIN diagnosis_masters AS collection_diagnosis ON collection_diagnosis.id = col.diagnosis_master_id
				LEFT JOIN diagnosis_masters AS primary_diagnosis ON primary_diagnosis.id = collection_diagnosis.primary_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type LIKE '%urine%'
			) AS res GROUP BY res.primary_icd10_code, res.collection_icd10_code;";
		//Participant
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		foreach($query_results as $new_result) {
			$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
			$data_key = $ctrnet_classification.'-urine';
			if(!isset($data[$data_key])) {
				$data[$data_key] = array(
					'qc_hb_ctrnet_classification' => $ctrnet_classification,
					'qc_hb_primary_icd10_codes' => array($new_result['res']['primary_icd10_code'] => $new_result['res']['primary_icd10_code']),
					'qc_hb_collection_icd10_codes' => array($new_result['res']['collection_icd10_code'] => $new_result['res']['collection_icd10_code']),
					'sample_type' => __('urine'),
					'cases_nbr' => $new_result['0']['nbr'],
					'aliquots_nbr' => 0,
					'notes' => array());
			} else {
				$data[$data_key]['qc_hb_primary_icd10_codes'][$new_result['res']['primary_icd10_code']] = $new_result['res']['primary_icd10_code'];
				$data[$data_key]['qc_hb_collection_icd10_codes'][$new_result['res']['collection_icd10_code']] = $new_result['res']['collection_icd10_code'];
				$data[$data_key]['cases_nbr'] = $data[$data_key]['cases_nbr'] + $new_result['0']['nbr'];
			}
		}
		//Aliquot
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		foreach($query_results as $new_result) {
			$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
			$data_key = $ctrnet_classification.'-urine';
			$data[$data_key]['aliquots_nbr'] = $data[$data_key]['aliquots_nbr'] + $new_result['0']['nbr'];
		}
		
		$sql = "
			SELECT DISTINCT sc.sample_type,ac.aliquot_type, primary_diagnosis.icd10_code primary_icd10_code, collection_diagnosis.icd10_code collection_icd10_code
			FROM collections AS col
			INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
			INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
			INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
			INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
			LEFT JOIN diagnosis_masters AS collection_diagnosis ON collection_diagnosis.id = col.diagnosis_master_id
			LEFT JOIN diagnosis_masters AS primary_diagnosis ON primary_diagnosis.id = collection_diagnosis.primary_id
			WHERE col.deleted != '1' AND ($bank_conditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type LIKE '%urine%'";
		$query_results = $this->Report->tryCatchQuery($sql);
		foreach($query_results as $new_type) {
			$ctrnet_classification = $this->getCTRNetCatalogClassification($new_type['primary_diagnosis']['primary_icd10_code']);
			$data_key = $ctrnet_classification.'-frozen tissue';
			$note =  __($new_type['sc']['sample_type']).' '.__($new_type['ac']['aliquot_type']);
			$data[$data_key]['notes'][$note] = $note;
		}
		
		// **Ascite**
		
		$sql = "
			SELECT count(*) AS nbr, res.primary_icd10_code, res.collection_icd10_code FROM (
				SELECT DISTINCT  %%id%%, primary_diagnosis.icd10_code primary_icd10_code, collection_diagnosis.icd10_code collection_icd10_code
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				LEFT JOIN diagnosis_masters AS collection_diagnosis ON collection_diagnosis.id = col.diagnosis_master_id
				LEFT JOIN diagnosis_masters AS primary_diagnosis ON primary_diagnosis.id = collection_diagnosis.primary_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type LIKE '%ascite%'
			) AS res GROUP BY res.primary_icd10_code, res.collection_icd10_code;";
		//Participant
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
		foreach($query_results as $new_result) {
			$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
			$data_key = $ctrnet_classification.'-ascite';
			if(!isset($data[$data_key])) {
				$data[$data_key] = array(
						'qc_hb_ctrnet_classification' => $ctrnet_classification,
						'qc_hb_primary_icd10_codes' => array($new_result['res']['primary_icd10_code'] => $new_result['res']['primary_icd10_code']),
						'qc_hb_collection_icd10_codes' => array($new_result['res']['collection_icd10_code'] => $new_result['res']['collection_icd10_code']),
						'sample_type' => __('ascite'),
						'cases_nbr' => $new_result['0']['nbr'],
						'aliquots_nbr' => 0,
						'notes' => array());
			} else {
				$data[$data_key]['qc_hb_primary_icd10_codes'][$new_result['res']['primary_icd10_code']] = $new_result['res']['primary_icd10_code'];
				$data[$data_key]['qc_hb_collection_icd10_codes'][$new_result['res']['collection_icd10_code']] = $new_result['res']['collection_icd10_code'];
				$data[$data_key]['cases_nbr'] = $data[$data_key]['cases_nbr'] + $new_result['0']['nbr'];
			}
		}
		//Aliquot
		$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
		foreach($query_results as $new_result) {
			$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
			$data_key = $ctrnet_classification.'-ascite';
			$data[$data_key]['aliquots_nbr'] = $data[$data_key]['aliquots_nbr'] + $new_result['0']['nbr'];
		}		

		$sql = "
			SELECT DISTINCT sc.sample_type,ac.aliquot_type, primary_diagnosis.icd10_code primary_icd10_code, collection_diagnosis.icd10_code collection_icd10_code
			FROM collections AS col
			INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
			INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
			INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
			INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
			LEFT JOIN diagnosis_masters AS collection_diagnosis ON collection_diagnosis.id = col.diagnosis_master_id
			LEFT JOIN diagnosis_masters AS primary_diagnosis ON primary_diagnosis.id = collection_diagnosis.primary_id
			WHERE col.deleted != '1' AND ($bank_conditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type LIKE '%ascite%'";
		$query_results = $this->Report->tryCatchQuery($sql);
		foreach($query_results as $new_type) {
			$ctrnet_classification = $this->getCTRNetCatalogClassification($new_type['primary_diagnosis']['primary_icd10_code']);
			$data_key = $ctrnet_classification.'-frozen tissue';
			$note =  __($new_type['sc']['sample_type']).' '.__($new_type['ac']['aliquot_type']);		
			$data[$data_key]['notes'][$note] = $note;
		}
		
		// **other**
		
		$other_conditions = "sc.sample_type NOT LIKE '%ascite%' AND sc.sample_type NOT LIKE '%urine%' AND sc.sample_type NOT IN ('tissue', $sample_types)";
		
		if($detail_other_count) {
			
			$sql = "
				SELECT count(*) AS nbr,sample_type, aliquot_type, res.primary_icd10_code, res.collection_icd10_code FROM (
					SELECT DISTINCT  %%id%%, sc.sample_type, ac.aliquot_type, primary_diagnosis.icd10_code primary_icd10_code, collection_diagnosis.icd10_code collection_icd10_code
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
					INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
					INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
					INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
					LEFT JOIN diagnosis_masters AS collection_diagnosis ON collection_diagnosis.id = col.diagnosis_master_id
					LEFT JOIN diagnosis_masters AS primary_diagnosis ON primary_diagnosis.id = collection_diagnosis.primary_id
					WHERE col.deleted != '1' AND ($bank_conditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND ($other_conditions)
				) AS res GROUP BY sample_type, aliquot_type, res.primary_icd10_code, res.collection_icd10_code;";
			//Participant
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
			foreach($query_results as $new_result) {
				$sample_type = $new_result['res']['sample_type'];
				$aliquot_type = $new_result['res']['aliquot_type'];
				$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
				$data_key = $ctrnet_classification."-$sample_type-$aliquot_type";
				if(!isset($data[$data_key])) {
					$data[$data_key] = array(
						'qc_hb_ctrnet_classification' => $ctrnet_classification,
						'qc_hb_primary_icd10_codes' => array($new_result['res']['primary_icd10_code'] => $new_result['res']['primary_icd10_code']),
						'qc_hb_collection_icd10_codes' => array($new_result['res']['collection_icd10_code'] => $new_result['res']['collection_icd10_code']),
						'sample_type' => __($sample_type).' '.__($aliquot_type),
						'cases_nbr' => $new_result['0']['nbr'],
						'aliquots_nbr' => 0,
						'notes' => array());
				} else {
					$data[$data_key]['qc_hb_primary_icd10_codes'][$new_result['res']['primary_icd10_code']] = $new_result['res']['primary_icd10_code'];
					$data[$data_key]['qc_hb_collection_icd10_codes'][$new_result['res']['collection_icd10_code']] = $new_result['res']['collection_icd10_code'];
					$data[$data_key]['cases_nbr'] = $data[$data_key]['cases_nbr'] + $new_result['0']['nbr'];
				}
			}
			//Aliquot
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
			foreach($query_results as $new_result) {
				$sample_type = $new_result['res']['sample_type'];
				$aliquot_type = $new_result['res']['aliquot_type'];
				$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
				$data_key = $ctrnet_classification."-$sample_type-$aliquot_type";
				$data[$data_key]['aliquots_nbr'] = $data[$data_key]['aliquots_nbr'] + $new_result['0']['nbr'];
			}

		} else {
			
			$sql = "
				SELECT count(*) AS nbr, res.primary_icd10_code, res.collection_icd10_code FROM (
					SELECT DISTINCT  %%id%%, primary_diagnosis.icd10_code primary_icd10_code, collection_diagnosis.icd10_code collection_icd10_code
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
					INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
					INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
					INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
					LEFT JOIN diagnosis_masters AS collection_diagnosis ON collection_diagnosis.id = col.diagnosis_master_id
					LEFT JOIN diagnosis_masters AS primary_diagnosis ON primary_diagnosis.id = collection_diagnosis.primary_id
					WHERE col.deleted != '1' AND ($bank_conditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND ($other_conditions)
				) AS res GROUP BY res.primary_icd10_code, res.collection_icd10_code;";
				//Participant
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','col.participant_id',$sql));
			foreach($query_results as $new_result) {
				$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
				$data_key = $ctrnet_classification.'-other';
				if(!isset($data[$data_key])) {
					$data[$data_key] = array(
							'qc_hb_ctrnet_classification' => $ctrnet_classification,
							'qc_hb_primary_icd10_codes' => array($new_result['res']['primary_icd10_code'] => $new_result['res']['primary_icd10_code']),
							'qc_hb_collection_icd10_codes' => array($new_result['res']['collection_icd10_code'] => $new_result['res']['collection_icd10_code']),
							'sample_type' => __('other'),
							'cases_nbr' => $new_result['0']['nbr'],
							'aliquots_nbr' => 0,
							'notes' => array());
				} else {
					$data[$data_key]['qc_hb_primary_icd10_codes'][$new_result['res']['primary_icd10_code']] = $new_result['res']['primary_icd10_code'];
					$data[$data_key]['qc_hb_collection_icd10_codes'][$new_result['res']['collection_icd10_code']] = $new_result['res']['collection_icd10_code'];
					$data[$data_key]['cases_nbr'] = $data[$data_key]['cases_nbr'] + $new_result['0']['nbr'];
				}
			}
			//Aliquot
			$query_results = $this->Report->tryCatchQuery(str_replace('%%id%%','am.id',$sql));
			foreach($query_results as $new_result) {
				$ctrnet_classification = $this->getCTRNetCatalogClassification($new_result['res']['primary_icd10_code']);
				$data_key = $ctrnet_classification.'-other';
				$data[$data_key]['aliquots_nbr'] = $data[$data_key]['aliquots_nbr'] + $new_result['0']['nbr'];
			}	
			
			$sql = "
				SELECT DISTINCT sc.sample_type,ac.aliquot_type, primary_diagnosis.icd10_code primary_icd10_code, collection_diagnosis.icd10_code collection_icd10_code
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				LEFT JOIN diagnosis_masters AS collection_diagnosis ON collection_diagnosis.id = col.diagnosis_master_id
				LEFT JOIN diagnosis_masters AS primary_diagnosis ON primary_diagnosis.id = collection_diagnosis.primary_id
				WHERE col.deleted != '1' AND ($bank_conditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND ($other_conditions)";
			$query_results = $this->Report->tryCatchQuery($sql);
			foreach($query_results as $new_type) {
				$ctrnet_classification = $this->getCTRNetCatalogClassification($new_type['primary_diagnosis']['primary_icd10_code']);
				$data_key = $ctrnet_classification.'-frozen tissue';
				$note =  __($new_type['sc']['sample_type']).' '.__($new_type['ac']['aliquot_type']);		
				$data[$data_key]['notes'][$note] = $note;
			}
		}
		
		foreach($data as &$new_row) {
			foreach(array('qc_hb_primary_icd10_codes', 'qc_hb_collection_icd10_codes') as $field) {
				if(sizeof($new_row[$field]) > 10) {
					$new_row[$field] = str_replace('%s', 10, __('more than %s'));
				} else {
					$new_row[$field] = implode('-', array_filter($new_row[$field]));
				}
			}
			$new_row['notes'] = implode(' & ', array_filter($new_row['notes']));				
		}
		ksort($data);
		
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
	
	function getCTRNetCatalogClassification($primary_icd_10_code) {
		if($primary_icd_10_code) {
			if(preg_match('/^C((1[5-9])|(2[0-6]))/',$primary_icd_10_code)) {
				if(preg_match('/^C181/',$primary_icd_10_code)) {
					return 'Digestive - Appendix';
				} else if(preg_match('/^C221/',$primary_icd_10_code)) {
					return 'Digestive - Bile Ducts';
				} else if(preg_match('/^C21/',$primary_icd_10_code)) {
					return 'Digestive - Anal';
				} else if(preg_match('/^C((18)|(19)|(20))/',$primary_icd_10_code)) {
					return 'Digestive - Colorectal';
				} else if(preg_match('/^C15/',$primary_icd_10_code)) {
					return 'Digestive - Esophageal';
				} else if(preg_match('/^C23/',$primary_icd_10_code)) {
					return 'Digestive - Gallbladder';
				} else if(preg_match('/^C22/',$primary_icd_10_code)) {
					return 'Digestive - Liver';
				} else if(preg_match('/^C25/',$primary_icd_10_code)) {
					return 'Digestive - Pancreas';
				} else if(preg_match('/^C17/',$primary_icd_10_code)) {
					return 'Digestive - Small Intestine';
				} else if(preg_match('/^C16/',$primary_icd_10_code)) {
					return 'Digestive - Stomach';
				} else {
					return 'Digestive - Other Digestive';
				}
			} else if (preg_match('/^C5[1-8]/',$primary_icd_10_code)) {
				if(preg_match('/^C541/',$primary_icd_10_code)) {
					return 'Female Genital - Endometrium';
				} else if(preg_match('/^C570/',$primary_icd_10_code)) {
					return 'Female Genital - Fallopian Tube';
				} else if(preg_match('/^C53/',$primary_icd_10_code)) {
					return 'Female Genital - Cervical';
				} else if(preg_match('/^C56/',$primary_icd_10_code)) {
					return 'Female Genital - Ovary';
				} else if(preg_match('/^C48/',$primary_icd_10_code)) {
					return 'Female Genital - Peritoneal';
				} else if(preg_match('/^C54/',$primary_icd_10_code)) {
					return 'Female Genital - Uterine';
				} else if(preg_match('/^C55/',$primary_icd_10_code)) {
					return 'Female Genital - Uterine';
				} else if(preg_match('/^C51/',$primary_icd_10_code)) {
					return 'Female Genital - Vulva';
				} else if(preg_match('/^C52/',$primary_icd_10_code)) {
					return 'Female Genital - Vagina';
				} else {
					return 'Female Genital - Other Female Genital';
				} 
				
			} else if (preg_match('/^C50/',$primary_icd_10_code)) {
				return 'Breast - Breast';
			} else if (preg_match('/^C34/',$primary_icd_10_code)) {
				return 'Thoracic - Lung';
			} else if (preg_match('/^C45/',$primary_icd_10_code)) {
				return 'Thoracic - Mesothelioma';
			} else if (preg_match('/^C69/',$primary_icd_10_code)) {
				return 'Ophthalmic - Eye';
			} else if (preg_match('/^C32/',$primary_icd_10_code)) {
				return 'Head & Neck - Larynx';
			} else if (preg_match('/^C30/',$primary_icd_10_code)) {
				return 'Head & Neck - Nasal Cavity and Sinuses';
			} else if (preg_match('/^C31/',$primary_icd_10_code)) {
				return 'Head & Neck - Nasal Cavity and Sinuses';
			} else if (preg_match('/^C((10)|(11))/',$primary_icd_10_code)) {
				return 'Head & Neck - Pharynx';
			} else if (preg_match('/^C64/',$primary_icd_10_code)) {
				return 'Urinary Tract - Kidney';
			} else if (preg_match('/^C4[34]/',$primary_icd_10_code)) {
				return 'Skin - Melanoma';
			} else if (preg_match('/^C/',$primary_icd_10_code)) {
				return 'Other malignant neoplasms';	
			} else if (strlen($primary_icd_10_code)) {
				return 'Other than malignant neoplasms';
			}
		}
		return 'Undefined';
	}
}