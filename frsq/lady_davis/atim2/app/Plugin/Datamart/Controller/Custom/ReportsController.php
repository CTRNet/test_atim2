<?php

class ReportsControllerCustom extends ReportsController
{

    public function bankActiviySummary($parameters)
    {
        // 1- Build Header
        $startDateForDisplay = AppController::getFormatedDateString($parameters[0]['report_date_range_start']['year'], $parameters[0]['report_date_range_start']['month'], $parameters[0]['report_date_range_start']['day']);
        $endDateForDisplay = AppController::getFormatedDateString($parameters[0]['report_date_range_end']['year'], $parameters[0]['report_date_range_end']['month'], $parameters[0]['report_date_range_end']['day']);
        $header = array(
            'title' => __('from') . ' ' . (empty($parameters[0]['report_date_range_start']['year']) ? '?' : $startDateForDisplay) . ' ' . __('to') . ' ' . (empty($parameters[0]['report_date_range_end']['year']) ? '?' : $endDateForDisplay),
            'description' => 'n/a'
        );
        
        // 2- Search data
        $startDateForSql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_start'], 'start');
        $endDateForSql = AppController::getFormatedDatetimeSQL($parameters[0]['report_date_range_end'], 'end');
        
        $searchOnDateRange = true;
        if ((strpos($startDateForSql, '-9999') === 0) && (strpos($endDateForSql, '9999') === 0))
            $searchOnDateRange = false;
            
            // LIMIT participants based on identifiers
        
        $participantSubsetIds = array();
        $description = '';
        $MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
        $conditions = array();
        $qCroc03Nbrs = array_unique(array_filter($parameters[0]['q_croc_03_identifier_value']));
        if ($qCroc03Nbrs) {
            $conditions['OR'][] = "MiscIdentifierControl.misc_identifier_name = 'Q-CROC-03' AND (MiscIdentifier.identifier_value LIKE '%" . implode("%' OR MiscIdentifier.identifier_value LIKE '%", $qCroc03Nbrs) . "%')";
            $description = "'" . __('Q-CROC-03') . "' " . __('contains') . ': ' . implode(' ' . __('or') . ' ', $qCroc03Nbrs);
        }
        $breastBankNbrs = array_unique(array_filter($parameters[0]['breast_bank_identifier_value']));
        if ($breastBankNbrs) {
            $conditions['OR'][] = "MiscIdentifierControl.misc_identifier_name = 'Breast bank #' AND (MiscIdentifier.identifier_value LIKE '%" . implode("%' OR MiscIdentifier.identifier_value LIKE '%", $breastBankNbrs) . "%')";
            $description .= (empty($description) ? '' : ' & ') . "'" . __('Breast bank #') . "' " . __('contains') . ': ' . implode(' ' . __('or') . ' ', $breastBankNbrs);
        }
        if ($conditions) {
            $res = $MiscIdentifier->find('all', array(
                'conditions' => $conditions,
                'fields' => array(
                    'Participant.id, MiscIdentifierControl.misc_identifier_name, MiscIdentifier.identifier_value'
                ),
                'recursive' => '1'
            ));
            foreach ($res as $newRecord)
                $participantSubsetIds[] = $newRecord['Participant']['id'];
            $header['description'] = $description;
        }
        
        // Get new participant
        if (! isset($this->Participant)) {
            $this->Participant = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        }
        $conditions = $searchOnDateRange ? array(
            "Participant.created >= '$startDateForSql'",
            "Participant.created <= '$endDateForSql'"
        ) : array();
        if ($participantSubsetIds)
            $conditions['Participant.id'] = $participantSubsetIds;
        $data['0']['new_participants_nbr'] = $this->Participant->find('count', (array(
            'conditions' => $conditions
        )));
        
        // Get new consents obtained
        if (! isset($this->ConsentMaster)) {
            $this->ConsentMaster = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
        }
        $conditions = $searchOnDateRange ? array(
            "ConsentMaster.consent_signed_date >= '$startDateForSql'",
            "ConsentMaster.consent_signed_date <= '$endDateForSql'"
        ) : array();
        if ($participantSubsetIds)
            $conditions['ConsentMaster.participant_id'] = $participantSubsetIds;
        $allConsent = $this->ConsentMaster->find('count', (array(
            'conditions' => $conditions
        )));
        $conditions['ConsentMaster.consent_status'] = 'obtained';
        $allObtainedConsent = $this->ConsentMaster->find('count', (array(
            'conditions' => $conditions
        )));
        $data['0']['obtained_consents_nbr'] = "$allObtainedConsent/$allConsent";
        
        // Get new collections
        $conditions = $searchOnDateRange ? "col.collection_datetime >= '$startDateForSql' AND col.collection_datetime <= '$endDateForSql'" : 'TRUE';
        if ($participantSubsetIds)
            $conditions .= " AND col.participant_id IN (" . implode(',', $participantSubsetIds) . ")";
        $newCollectionsNbr = $this->Report->tryCatchQuery("SELECT COUNT(*) FROM (
				SELECT DISTINCT col.participant_id 
				FROM sample_masters AS sm 
				INNER JOIN collections AS col ON col.id = sm.collection_id 
				WHERE col.participant_id IS NOT NULL 
				AND col.participant_id != '0'
				AND ($conditions)
				AND col.deleted != '1'
				AND sm.deleted != '1'
			) AS res;");
        $data['0']['new_collections_nbr'] = $newCollectionsNbr[0][0]['COUNT(*)'];
        
        $arrayToReturn = array(
            'header' => $header,
            'data' => $data,
            'columns_names' => null,
            'error_msg' => null
        );
        
        return $arrayToReturn;
    }

    public function sampleAndDerivativeCreationSummary($parameters)
    {
        
        // 1- Build Header
        $startDateForDisplay = AppController::getFormatedDateString($parameters[0]['report_datetime_range_start']['year'], $parameters[0]['report_datetime_range_start']['month'], $parameters[0]['report_datetime_range_start']['day']);
        $endDateForDisplay = AppController::getFormatedDateString($parameters[0]['report_datetime_range_end']['year'], $parameters[0]['report_datetime_range_end']['month'], $parameters[0]['report_datetime_range_end']['day']);
        
        $header = array(
            'title' => __('from') . ' ' . (empty($parameters[0]['report_datetime_range_start']['year']) ? '?' : $startDateForDisplay) . ' ' . __('to') . ' ' . (empty($parameters[0]['report_datetime_range_end']['year']) ? '?' : $endDateForDisplay),
            'description' => 'n/a'
        );
        
        $bankIds = array();
        foreach ($parameters[0]['bank_id'] as $bankId)
            if (! empty($bankId))
                $bankIds[] = $bankId;
        if (! empty($bankIds)) {
            $Bank = AppModel::getInstance("Administrate", "Bank", true);
            $bankList = $Bank->find('all', array(
                'conditions' => array(
                    'id' => $bankIds
                )
            ));
            $bankNames = array();
            foreach ($bankList as $newBank)
                $bankNames[] = $newBank['Bank']['name'];
            $header['description'] = __('bank') . ': ' . implode(',', $bankNames);
        }
        // 2- Search data
        
        $bankConditions = empty($bankIds) ? 'TRUE' : 'col.bank_id IN (' . implode(',', $bankIds) . ')';
        
        $startDateForSql = AppController::getFormatedDatetimeSQL($parameters[0]['report_datetime_range_start'], 'start');
        $endDateForSql = AppController::getFormatedDatetimeSQL($parameters[0]['report_datetime_range_end'], 'end');
        
        $searchOnDateRange = true;
        if ((strpos($startDateForSql, '-9999') === 0) && (strpos($endDateForSql, '9999') === 0))
            $searchOnDateRange = false;
        
        $resFinal = array();
        $tmpResFinal = array();
        
        // LIMIT participants based on identifiers
        
        $participantSubsetIds = array();
        $description = '';
        $MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
        $conditions = array();
        $qCroc03Nbrs = array_unique(array_filter($parameters[0]['q_croc_03_identifier_value']));
        if ($qCroc03Nbrs) {
            $conditions['OR'][] = "MiscIdentifierControl.misc_identifier_name = 'Q-CROC-03' AND (MiscIdentifier.identifier_value LIKE '%" . implode("%' OR MiscIdentifier.identifier_value LIKE '%", $qCroc03Nbrs) . "%')";
            $description = "'" . __('Q-CROC-03') . "' " . __('contains') . ': ' . implode(' ' . __('or') . ' ', $qCroc03Nbrs);
        }
        $breastBankNbrs = array_unique(array_filter($parameters[0]['breast_bank_identifier_value']));
        if ($breastBankNbrs) {
            $conditions['OR'][] = "MiscIdentifierControl.misc_identifier_name = 'Breast bank #' AND (MiscIdentifier.identifier_value LIKE '%" . implode("%' OR MiscIdentifier.identifier_value LIKE '%", $breastBankNbrs) . "%')";
            $description .= (empty($description) ? '' : ' & ') . "'" . __('Breast bank #') . "' " . __('contains') . ': ' . implode(' ' . __('or') . ' ', $breastBankNbrs);
        }
        if ($conditions) {
            $res = $MiscIdentifier->find('all', array(
                'conditions' => $conditions,
                'fields' => array(
                    'Participant.id, MiscIdentifierControl.misc_identifier_name, MiscIdentifier.identifier_value'
                ),
                'recursive' => '1'
            ));
            foreach ($res as $newRecord)
                $participantSubsetIds[] = $newRecord['Participant']['id'];
            $header['description'] = ($header['description'] == 'n/a') ? $description : $header['description'] . ' & ' . $description;
        }
        
        // Work on specimen
        
        $conditions = $searchOnDateRange ? "col.collection_datetime >= '$startDateForSql' AND col.collection_datetime <= '$endDateForSql'" : 'TRUE';
        $participantIdConditions = empty($participantSubsetIds) ? 'TRUE' : "col.participant_id IN (" . implode(',', $participantSubsetIds) . ")";
        $resSamples = $this->Report->tryCatchQuery("SELECT COUNT(*), sc.sample_type
			FROM sample_masters AS sm
			INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
			INNER JOIN collections AS col ON col.id = sm.collection_id
			WHERE col.participant_id IS NOT NULL
			AND col.participant_id != '0'
			AND sc.sample_category = 'specimen'
			AND ($conditions)
			AND ($participantIdConditions)
			AND ($bankConditions)
			AND sm.deleted != '1'
			GROUP BY sample_type;");
        $resParticipants = $this->Report->tryCatchQuery("SELECT COUNT(*), res.sample_type FROM (
				SELECT DISTINCT col.participant_id, sc.sample_type
				FROM sample_masters AS sm
				INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
				INNER JOIN collections AS col ON col.id = sm.collection_id
				WHERE col.participant_id IS NOT NULL
				AND col.participant_id != '0'
				AND sc.sample_category = 'specimen'
				AND ($conditions)
				AND ($participantIdConditions)
				AND ($bankConditions)
				AND sm.deleted != '1'
			) AS res GROUP BY res.sample_type;");
        
        foreach ($resSamples as $data) {
            $tmpResFinal['specimen-' . $data['sc']['sample_type']] = array(
                'SampleControl' => array(
                    'sample_category' => 'specimen',
                    'sample_type' => $data['sc']['sample_type']
                ),
                '0' => array(
                    'created_samples_nbr' => $data[0]['COUNT(*)'],
                    'matching_participant_number' => null
                )
            );
        }
        foreach ($resParticipants as $data) {
            $tmpResFinal['specimen-' . $data['res']['sample_type']]['0']['matching_participant_number'] = $data[0]['COUNT(*)'];
        }
        
        // Work on derivative
        
        $conditions = $searchOnDateRange ? "der.creation_datetime >= '$startDateForSql' AND der.creation_datetime <= '$endDateForSql'" : 'TRUE';
        $resSamples = $this->Report->tryCatchQuery("SELECT COUNT(*), sc.sample_type
				FROM sample_masters AS sm
				INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
				INNER JOIN collections AS col ON col.id = sm.collection_id
				INNER JOIN derivative_details AS der ON der.sample_master_id = sm.id
				WHERE col.participant_id IS NOT NULL
				AND col.participant_id != '0'
				AND sc.sample_category = 'derivative'
				AND ($conditions)
				AND ($participantIdConditions)
				AND ($bankConditions)
				AND sm.deleted != '1'
				GROUP BY sample_type;");
        $resParticipants = $this->Report->tryCatchQuery("SELECT COUNT(*), res.sample_type FROM (
					SELECT DISTINCT col.participant_id, sc.sample_type
					FROM sample_masters AS sm
					INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
					INNER JOIN collections AS col ON col.id = sm.collection_id
					INNER JOIN derivative_details AS der ON der.sample_master_id = sm.id
					WHERE col.participant_id IS NOT NULL
					AND col.participant_id != '0'
					AND sc.sample_category = 'derivative'
					AND ($conditions)
					AND ($participantIdConditions)
					AND ($bankConditions)
					AND sm.deleted != '1'
			) AS res GROUP BY res.sample_type;");
        
        foreach ($resSamples as $data) {
            $tmpResFinal['derivative-' . $data['sc']['sample_type']] = array(
                'SampleControl' => array(
                    'sample_category' => 'derivative',
                    'sample_type' => $data['sc']['sample_type']
                ),
                '0' => array(
                    'created_samples_nbr' => $data[0]['COUNT(*)'],
                    'matching_participant_number' => null
                )
            );
        }
        foreach ($resParticipants as $data) {
            $tmpResFinal['derivative-' . $data['res']['sample_type']]['0']['matching_participant_number'] = $data[0]['COUNT(*)'];
        }
        
        // Format data for report
        foreach ($tmpResFinal as $newSampleTypeData) {
            $resFinal[] = $newSampleTypeData;
        }
        
        $arrayToReturn = array(
            'header' => $header,
            'data' => $resFinal,
            'columns_names' => null,
            'error_msg' => null
        );
        
        return $arrayToReturn;
    }

    public function ctrnetCatalogueSubmissionFile($parameters)
    {
        
        // 1- Build Header
        $header = array(
            'title' => __('report_ctrnet_catalogue_name'),
            'description' => 'n/a'
        );
        
        $bankIds = array();
        foreach ($parameters[0]['bank_id'] as $bankId)
            if (! empty($bankId))
                $bankIds[] = $bankId;
        if (! empty($bankIds)) {
            $Bank = AppModel::getInstance("Administrate", "Bank", true);
            $bankList = $Bank->find('all', array(
                'conditions' => array(
                    'id' => $bankIds
                )
            ));
            $bankNames = array();
            foreach ($bankList as $newBank)
                $bankNames[] = $newBank['Bank']['name'];
            $header['title'] .= ' (' . __('bank') . ': ' . implode(',', $bankNames) . ')';
        }
        
        // 2- Search data
        
        $bankConditions = empty($bankIds) ? 'TRUE' : 'col.bank_id IN (' . implode(',', $bankIds) . ')';
        $aliquotTypeConfitions = $parameters[0]['include_core_and_slide'][0] ? 'TRUE' : "ac.aliquot_type NOT IN ('core','slide')";
        $whatmanPaperConfitions = $parameters[0]['include_whatman_paper'][0] ? 'TRUE' : "ac.aliquot_type NOT IN ('whatman paper')";
        $detailOtherCount = $parameters[0]['detail_other_count'][0] ? true : false;
        
        $data = array();
        
        // LIMIT participants based on identifiers
        
        $participantSubsetIds = array();
        $description = '';
        $MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
        $conditions = array();
        $qCroc03Nbrs = array_unique(array_filter($parameters[0]['q_croc_03_identifier_value']));
        if ($qCroc03Nbrs) {
            $conditions['OR'][] = "MiscIdentifierControl.misc_identifier_name = 'Q-CROC-03' AND (MiscIdentifier.identifier_value LIKE '%" . implode("%' OR MiscIdentifier.identifier_value LIKE '%", $qCroc03Nbrs) . "%')";
            $description = "'" . __('Q-CROC-03') . "' " . __('contains') . ': ' . implode(' ' . __('or') . ' ', $qCroc03Nbrs);
        }
        $breastBankNbrs = array_unique(array_filter($parameters[0]['breast_bank_identifier_value']));
        if ($breastBankNbrs) {
            $conditions['OR'][] = "MiscIdentifierControl.misc_identifier_name = 'Breast bank #' AND (MiscIdentifier.identifier_value LIKE '%" . implode("%' OR MiscIdentifier.identifier_value LIKE '%", $breastBankNbrs) . "%')";
            $description .= (empty($description) ? '' : ' & ') . "'" . __('Breast bank #') . "' " . __('contains') . ': ' . implode(' ' . __('or') . ' ', $breastBankNbrs);
        }
        if ($conditions) {
            $res = $MiscIdentifier->find('all', array(
                'conditions' => $conditions,
                'fields' => array(
                    'Participant.id, MiscIdentifierControl.misc_identifier_name, MiscIdentifier.identifier_value'
                ),
                'recursive' => '1'
            ));
            foreach ($res as $newRecord)
                $participantSubsetIds[] = $newRecord['Participant']['id'];
            $header['description'] = $description;
        }
        $participantIdConditions = empty($participantSubsetIds) ? 'TRUE' : "col.participant_id IN (" . implode(',', $participantSubsetIds) . ")";
        
        // **all**
        
        $tmpData = array(
            'sample_type' => __('total'),
            'cases_nbr' => '',
            'aliquots_nbr' => '',
            'notes' => ''
        );
        
        $sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bankConditions)
				AND ($participantIdConditions)
				AND ($aliquotTypeConfitions) 
				AND am.in_stock IN ('yes - available ','yes - not available')
			) AS res;";
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        $tmpData['cases_nbr'] = $queryResults[0][0]['nbr'];
        
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        $tmpData['aliquots_nbr'] = $queryResults[0][0]['nbr'];
        
        $data[] = $tmpData;
        
        // **FFPE**
        
        $tmpData = array(
            'sample_type' => __('FFPE'),
            'cases_nbr' => '',
            'aliquots_nbr' => '',
            'notes' => __('tissue') . ' ' . __('block') . ' (' . __('paraffin') . ')'
        );
        
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
				WHERE col.deleted != '1' AND ($bankConditions)
				AND ($participantIdConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ('tissue')
				AND ac.aliquot_type = 'block'
				AND blk.block_type = 'paraffin'
			) AS res;";
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        $tmpData['cases_nbr'] = $queryResults[0][0]['nbr'];
        
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        $tmpData['aliquots_nbr'] = $queryResults[0][0]['nbr'];
        
        $data[] = $tmpData;
        
        // **frozen tissue**
        
        $tmpData = array(
            'sample_type' => __('frozen tissue'),
            'cases_nbr' => '',
            'aliquots_nbr' => '',
            'notes' => ''
        );
        
        $sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT  %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bankConditions)
				AND ($participantIdConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ('tissue')
				AND ($aliquotTypeConfitions) 
				AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin')
			) AS res;";
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        $tmpData['cases_nbr'] = $queryResults[0][0]['nbr'];
        
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        $tmpData['aliquots_nbr'] = $queryResults[0][0]['nbr'];
        
        $sql = "
			SELECT DISTINCT sc.sample_type,ac.aliquot_type,blk.block_type
			FROM collections AS col
			INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
			INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
			INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
			INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
			INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
			LEFT JOIN ad_blocks AS blk ON blk.aliquot_master_id = am.id
			WHERE col.deleted != '1' AND ($bankConditions)
			AND ($participantIdConditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type IN ('tissue')
				AND ($aliquotTypeConfitions) 
			AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin');";
        $queryResults = $this->Report->tryCatchQuery($sql);
        foreach ($queryResults as $newType)
            $tmpData['notes'] .= (empty($tmpData['notes']) ? '' : ' & ') . __($newType['sc']['sample_type']) . ' ' . __($newType['ac']['aliquot_type']) . (empty($newType['blk']['block_type']) ? '' : ' (' . __($newType['blk']['block_type']) . ')');
        
        $data[] = $tmpData;
        
        // **blood**
        // **pbmc**
        // **blood cell**
        // **plasma**
        // **serum**
        // **rna**
        // **dna**
        // **cell culture**
        
        $sampleTypes = "'blood', 'pbmc', 'blood cell', 'plasma', 'serum', 'rna', 'dna', 'cell culture'";
        
        $tmpData = array();
        $sql = "
			SELECT count(*) AS nbr,sample_type, aliquot_type FROM (
				SELECT DISTINCT  %%id%%, sc.sample_type, ac.aliquot_type
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bankConditions)
				AND ($participantIdConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ($sampleTypes)
				AND ($whatmanPaperConfitions)	
			) AS res GROUP BY sample_type, aliquot_type;";
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        foreach ($queryResults as $newRes) {
            $sampleType = $newRes['res']['sample_type'];
            $aliquotType = $newRes['res']['aliquot_type'];
            $tmpData[$sampleType . $aliquotType] = array(
                'sample_type' => __($sampleType) . ' ' . __($aliquotType),
                'cases_nbr' => $newRes[0]['nbr'],
                'aliquots_nbr' => '',
                'notes' => ''
            );
        }
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        foreach ($queryResults as $newRes) {
            $sampleType = $newRes['res']['sample_type'];
            $aliquotType = $newRes['res']['aliquot_type'];
            $tmpData[$sampleType . $aliquotType]['aliquots_nbr'] = $newRes[0]['nbr'];
            $data[] = $tmpData[$sampleType . $aliquotType];
        }
        
        // **Urine**
        
        $tmpData = array(
            'sample_type' => __('urine'),
            'cases_nbr' => '',
            'aliquots_nbr' => '',
            'notes' => ''
        );
        $sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT  %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bankConditions)
				AND ($participantIdConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type LIKE '%urine%'
			) AS res;";
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        $tmpData['cases_nbr'] = $queryResults[0][0]['nbr'];
        
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        $tmpData['aliquots_nbr'] = $queryResults[0][0]['nbr'];
        
        $sql = "
			SELECT DISTINCT sc.sample_type,ac.aliquot_type
			FROM collections AS col
			INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
			INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
			INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
			INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
			WHERE col.deleted != '1' AND ($bankConditions)
			AND ($participantIdConditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type LIKE '%urine%'";
        $queryResults = $this->Report->tryCatchQuery($sql);
        foreach ($queryResults as $newType)
            $tmpData['notes'] .= (empty($tmpData['notes']) ? '' : ' & ') . __($newType['sc']['sample_type']) . ' ' . __($newType['ac']['aliquot_type']);
        
        $data[] = $tmpData;
        
        // **Ascite**
        
        $tmpData = array(
            'sample_type' => __('ascite'),
            'cases_nbr' => '',
            'aliquots_nbr' => '',
            'notes' => ''
        );
        $sql = "
			SELECT count(*) AS nbr FROM (
				SELECT DISTINCT  %%id%%
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bankConditions)
				AND ($participantIdConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type LIKE '%ascite%'
			) AS res;";
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        $tmpData['cases_nbr'] = $queryResults[0][0]['nbr'];
        
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        $tmpData['aliquots_nbr'] = $queryResults[0][0]['nbr'];
        
        $sql = "
			SELECT DISTINCT sc.sample_type,ac.aliquot_type
			FROM collections AS col
			INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
			INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
			INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
			INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
			WHERE col.deleted != '1' AND ($bankConditions)
			AND ($participantIdConditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type LIKE '%ascite%'";
        $queryResults = $this->Report->tryCatchQuery($sql);
        foreach ($queryResults as $newType)
            $tmpData['notes'] .= (empty($tmpData['notes']) ? '' : ' & ') . __($newType['sc']['sample_type']) . ' ' . __($newType['ac']['aliquot_type']);
        
        $data[] = $tmpData;
        
        // **other**
        
        $otherConditions = "sc.sample_type NOT LIKE '%ascite%' AND sc.sample_type NOT LIKE '%urine%' AND sc.sample_type NOT IN ('tissue', $sampleTypes)";
        
        if ($detailOtherCount) {
            
            $tmpData = array();
            $sql = "
				SELECT count(*) AS nbr,sample_type, aliquot_type FROM (
					SELECT DISTINCT  %%id%%, sc.sample_type, ac.aliquot_type
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
					INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
					INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
					INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
					WHERE col.deleted != '1' AND ($bankConditions)
					AND ($participantIdConditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND ($otherConditions)
				) AS res GROUP BY sample_type, aliquot_type;";
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
            foreach ($queryResults as $newRes) {
                $sampleType = $newRes['res']['sample_type'];
                $aliquotType = $newRes['res']['aliquot_type'];
                $tmpData[$sampleType . $aliquotType] = array(
                    'sample_type' => __($sampleType) . ' ' . __($aliquotType),
                    'cases_nbr' => $newRes[0]['nbr'],
                    'aliquots_nbr' => '',
                    'notes' => ''
                );
            }
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
            foreach ($queryResults as $newRes) {
                $sampleType = $newRes['res']['sample_type'];
                $aliquotType = $newRes['res']['aliquot_type'];
                $tmpData[$sampleType . $aliquotType]['aliquots_nbr'] = $newRes[0]['nbr'];
                $data[] = $tmpData[$sampleType . $aliquotType];
            }
        } else {
            
            $tmpData = array(
                'sample_type' => __('other'),
                'cases_nbr' => '',
                'aliquots_nbr' => '',
                'notes' => ''
            );
            $sql = "
				SELECT count(*) AS nbr FROM (
					SELECT DISTINCT  %%id%%
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
					INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
					INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
					INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
					WHERE col.deleted != '1' AND ($bankConditions)
					AND ($participantIdConditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND ($otherConditions)
				) AS res;";
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
            $tmpData['cases_nbr'] = $queryResults[0][0]['nbr'];
            
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
            $tmpData['aliquots_nbr'] = $queryResults[0][0]['nbr'];
            
            $sql = "
				SELECT DISTINCT sc.sample_type,ac.aliquot_type
				FROM collections AS col
				INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
				INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
				INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
				INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
				WHERE col.deleted != '1' AND ($bankConditions)
				AND ($participantIdConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND ($otherConditions)";
            $queryResults = $this->Report->tryCatchQuery($sql);
            foreach ($queryResults as $newType)
                $tmpData['notes'] .= (empty($tmpData['notes']) ? '' : ' & ') . __($newType['sc']['sample_type']) . ' ' . __($newType['ac']['aliquot_type']);
            
            $data[] = $tmpData;
        }
        
        // Format data form display
        
        $finalData = array();
        foreach ($data as $newRow) {
            if ($newRow['cases_nbr']) {
                $finalData[][0] = $newRow;
            }
        }
        
        $arrayToReturn = array(
            'header' => $header,
            'data' => $finalData,
            'columns_names' => null,
            'error_msg' => null
        );
        
        return $arrayToReturn;
    }

    public function createTissueAndBuffyCoatDNASummary($parameters)
    {
        
        // 1- Set Search Criteria
        $criteriaArray = array();
        if (array_key_exists('Participant', $parameters) && array_key_exists('id', $parameters['Participant'])) {
            // From databrowser or batchset
            $criteriaArray[] = "Participant.id IN ('" . implode("','", array_filter($parameters['Participant']['id'])) . "')";
        } else 
            if (array_key_exists('ViewAliquot', $parameters) && array_key_exists('aliquot_master_id', $parameters['ViewAliquot'])) {
                // From databrowser or batchset
                $criteriaArray[] = "AliquotMaster_TissueBlock_BcTube.id IN ('" . implode("','", array_filter($parameters['ViewAliquot']['aliquot_master_id'])) . "')";
            } else 
                if (array_key_exists('AliquotMaster', $parameters) && array_key_exists('id', $parameters['AliquotMaster'])) {
                    // From databrowser or batchset
                    $criteriaArray[] = "AliquotMaster_TissueBlock_BcTube.id IN ('" . implode("','", array_filter($parameters['AliquotMaster']['id'])) . "')";
                } else {
                    $criteriaArray = array();
                    if (array_key_exists('ViewCollection', $parameters)) {
                        if (array_key_exists('participant_identifier', $parameters['ViewCollection'])) {
                            $participantIdentifiers = array_filter($parameters['ViewCollection']['participant_identifier']);
                            if ($participantIdentifiers)
                                $criteriaArray[] = "Participant.participant_identifier IN ('" . implode("','", $participantIdentifiers) . "')";
                        } else 
                            if (array_key_exists('participant_identifier_start', $parameters['ViewCollection'])) {
                                $tmpConditions = array();
                                if (strlen($parameters['ViewCollection']['participant_identifier_start']))
                                    $tmpConditions[] = "Participant.participant_identifier >= '" . $parameters['ViewCollection']['participant_identifier_start'] . "'";
                                if (strlen($parameters['ViewCollection']['participant_identifier_end']))
                                    $tmpConditions[] = "Participant.participant_identifier <= '" . $parameters['ViewCollection']['participant_identifier_end'] . "'";
                                if ($tmpConditions)
                                    $criteriaArray[] = implode(" AND ", $tmpConditions);
                            }
                    }
                    if (array_key_exists('ViewCollection', $parameters)) {
                        if (array_key_exists('misc_identifier_value', $parameters['ViewCollection'])) {
                            $miscIdentifierValues = array_filter($parameters['ViewCollection']['misc_identifier_value']);
                            if ($miscIdentifierValues)
                                $criteriaArray[] = "MiscIdentifier.identifier_value IN ('" . implode("','", $miscIdentifierValues) . "')";
                        } else 
                            if (array_key_exists('misc_identifier_value_start', $parameters['ViewCollection'])) {
                                return array(
                                    'header' => null,
                                    'data' => null,
                                    'columns_names' => null,
                                    'error_msg' => 'no bank identifier search based on range defintion is supported'
                                );
                            }
                    }
                    if (array_key_exists('AliquotMaster', $parameters)) {
                        if (array_key_exists('aliquot_label', $parameters['AliquotMaster'])) {
                            $aliquotLabelValues = array_filter($parameters['AliquotMaster']['aliquot_label']);
                            if ($aliquotLabelValues)
                                $criteriaArray[] = "AliquotMaster_TissueBlock_BcTube.aliquot_label IN ('" . implode("','", $aliquotLabelValues) . "')";
                        } else 
                            if (array_key_exists('aliquot_label_start', $parameters['AliquotMaster'])) {
                                return array(
                                    'header' => null,
                                    'data' => null,
                                    'columns_names' => null,
                                    'error_msg' => 'no aliquot label search based on range defintion is supported'
                                );
                            }
                    }
                }
        if (empty($criteriaArray)) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => 'at least one criteria has to be entered'
            );
        }
        
        $criteria = implode(" AND ", $criteriaArray);
        
        // 2- Search data
        
        $tisueControlId = null;
        $tisueTubeControlId = null;
        $tisueBlockControlId = null;
        $buffyCoatControlId = null;
        $buffyCoatTubeControlId = null;
        $dnaControlId = null;
        $dnaTubeControlId = null;
        $rnaControlId = null;
        $rnaTubeControlId = null;
        $resControlIds = $this->Report->tryCatchQuery("
			SELECT sample_controls.id, sample_controls.sample_type, aliquot_controls.id, aliquot_controls.aliquot_type
			FROM aliquot_controls INNER JOIN sample_controls ON sample_controls.id = aliquot_controls.sample_control_id
			WHERE aliquot_controls.flag_active = 1
			AND sample_controls.sample_type IN ('DNA','tissue', 'RNA', 'pbmc') AND aliquot_controls.aliquot_type IN ('block','tube');");
        foreach ($resControlIds as $newControl) {
            switch ($newControl['sample_controls']['sample_type'] . $newControl['aliquot_controls']['aliquot_type']) {
                case 'tissueblock':
                    $tisueControlId = $newControl['sample_controls']['id'];
                    $tisueBlockControlId = $newControl['aliquot_controls']['id'];
                    break;
                case 'tissuetube':
                    $tisueTubeControlId = $newControl['aliquot_controls']['id'];
                    break;
                case 'pbmctube':
                    $buffyCoatControlId = $newControl['sample_controls']['id'];
                    $buffyCoatTubeControlId = $newControl['aliquot_controls']['id'];
                    break;
                case 'dnatube':
                    $dnaControlId = $newControl['sample_controls']['id'];
                    $dnaTubeControlId = $newControl['aliquot_controls']['id'];
                    break;
                case 'rnatube':
                    $rnaControlId = $newControl['sample_controls']['id'];
                    $rnaTubeControlId = $newControl['aliquot_controls']['id'];
                    break;
            }
        }
        
        $tissuesBlocksAndBuffyCoatData = array();
        
        $emptyAliquotsSubarray = array(
            'ViewAliquot' => array(
                'sample_type' => '',
                'aliquot_type' => ''
            ),
            'AliquotMaster' => array(
                'barcode' => '',
                'aliquot_label' => ''
            ),
            'ViewCollection' => array(
                'misc_identifier_value' => '',
                'participant_identifier' => '',
                'qc_lady_specimen_type_precision' => '',
                'qc_lady_visit' => ''
            ),
            'AliquotDetail' => array(
                'tissue_tube_aliquot_master_id' => null,
                'qc_lady_storage_solution' => '',
                'qc_lady_storage_method' => ''
            ),
            'AliquotReviewDetail' => array(
                'aliquot_review_master_id' => null,
                'tumor_percentage' => '',
                'necrosis_percentage_itz' => '',
                'cellularity_percentage_itz' => '',
                'stroma_percentage_itz' => ''
            )
        );
        
        // Get tissue block data
        $allData = $this->Report->tryCatchQuery("
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
			INNER JOIN aliquot_masters AS AliquotMaster_TissueBlock_BcTube ON AliquotMaster_TissueBlock_BcTube.collection_id = Collection.id AND AliquotMaster_TissueBlock_BcTube.deleted <> 1 AND AliquotMaster_TissueBlock_BcTube.aliquot_control_id = $tisueBlockControlId
	
			LEFT JOIN realiquotings ON AliquotMaster_TissueBlock_BcTube.id = realiquotings.child_aliquot_master_id AND realiquotings.deleted <> 1
			LEFT JOIN aliquot_masters AS AliquotMaster_TissueTube ON AliquotMaster_TissueTube.id = realiquotings.parent_aliquot_master_id AND AliquotMaster_TissueTube.deleted <> 1 AND AliquotMaster_TissueTube.aliquot_control_id = $tisueTubeControlId
			LEFT JOIN ad_tubes AS AliquotDetail_TissueTube ON AliquotDetail_TissueTube.aliquot_master_id = AliquotMaster_TissueTube.id
				
			LEFT JOIN aliquot_review_masters AS AliquotReviewMaster ON AliquotReviewMaster.aliquot_master_id = AliquotMaster_TissueBlock_BcTube.id AND AliquotReviewMaster.deleted <> 1
			LEFT JOIN qc_lady_ar_qcrocs AS AliquotReviewDetail ON AliquotReviewDetail.aliquot_review_master_id = AliquotReviewMaster.id
				
			LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
			LEFT JOIN misc_identifiers AS MiscIdentifier ON Collection.misc_identifier_id = MiscIdentifier.id AND MiscIdentifier.deleted <> 1
	
			WHERE $criteria
	
		ORDER BY MiscIdentifier.identifier_value, Collection.id, AliquotMaster_TissueBlock_BcTube.id;");
        
        $tissueBlocksHavingManyReviews = array();
        $tissueBlocksHavingManyAliquotsSource = array();
        foreach ($allData as $newRow) {
            $blockAliquotMasterId = $newRow['AliquotMaster_TissueBlock_BcTube']['block_aliquot_master_id'];
            if (! array_key_exists($blockAliquotMasterId, $tissuesBlocksAndBuffyCoatData)) {
                $tissuesBlocksAndBuffyCoatData[$blockAliquotMasterId] = $emptyAliquotsSubarray;
                $tissuesBlocksAndBuffyCoatData[$blockAliquotMasterId]['ViewAliquot']['sample_type'] = 'tissue';
                $tissuesBlocksAndBuffyCoatData[$blockAliquotMasterId]['ViewAliquot']['aliquot_type'] = 'block';
                $tissuesBlocksAndBuffyCoatData[$blockAliquotMasterId]['AliquotMaster']['aliquot_label'] = $newRow['AliquotMaster_TissueBlock_BcTube']['block_aliquot_label'];
                $tissuesBlocksAndBuffyCoatData[$blockAliquotMasterId]['AliquotMaster']['barcode'] = $newRow['AliquotMaster_TissueBlock_BcTube']['block_barcode'];
                $tissuesBlocksAndBuffyCoatData[$blockAliquotMasterId]['ViewCollection']['misc_identifier_value'] = $newRow['MiscIdentifier']['misc_identifier_value'];
                $tissuesBlocksAndBuffyCoatData[$blockAliquotMasterId]['ViewCollection']['participant_identifier'] = $newRow['Participant']['participant_identifier'];
                $tissuesBlocksAndBuffyCoatData[$blockAliquotMasterId]['ViewCollection']['qc_lady_specimen_type_precision'] = $newRow['Collection']['qc_lady_specimen_type_precision'];
                $tissuesBlocksAndBuffyCoatData[$blockAliquotMasterId]['ViewCollection']['qc_lady_visit'] = $newRow['Collection']['qc_lady_visit'];
            }
            
            if ($newRow['AliquotDetail_TissueTube']['tissue_tube_aliquot_master_id']) {
                if (is_null($tissuesBlocksAndBuffyCoatData[$blockAliquotMasterId]['AliquotDetail']['tissue_tube_aliquot_master_id'])) {
                    $tissuesBlocksAndBuffyCoatData[$blockAliquotMasterId]['AliquotDetail'] = array(
                        'tissue_tube_aliquot_master_id' => $newRow['AliquotDetail_TissueTube']['tissue_tube_aliquot_master_id'],
                        'qc_lady_storage_solution' => $newRow['AliquotDetail_TissueTube']['qc_lady_storage_solution'],
                        'qc_lady_storage_method' => $newRow['AliquotDetail_TissueTube']['qc_lady_storage_method']
                    );
                } else 
                    if ($tissuesBlocksAndBuffyCoatData[$blockAliquotMasterId]['AliquotDetail']['tissue_tube_aliquot_master_id'] != $newRow['AliquotDetail_TissueTube']['tissue_tube_aliquot_master_id']) {
                        $tissueBlocksHavingManyAliquotsSource[] = $newRow['AliquotMaster_TissueBlock_BcTube']['block_aliquot_label'];
                    }
            }
            
            if ($newRow['AliquotReviewDetail']['aliquot_review_master_id']) {
                if (! $tissuesBlocksAndBuffyCoatData[$blockAliquotMasterId]['AliquotReviewDetail']['aliquot_review_master_id']) {
                    $tissuesBlocksAndBuffyCoatData[$blockAliquotMasterId]['AliquotReviewDetail'] = array(
                        'aliquot_review_master_id' => $newRow['AliquotReviewDetail']['aliquot_review_master_id'],
                        'tumor_percentage' => $newRow['AliquotReviewDetail']['tumor_percentage'],
                        'necrosis_percentage_itz' => $newRow['AliquotReviewDetail']['necrosis_percentage_itz'],
                        'cellularity_percentage_itz' => $newRow['AliquotReviewDetail']['cellularity_percentage_itz'],
                        'stroma_percentage_itz' => $newRow['AliquotReviewDetail']['stroma_percentage_itz']
                    );
                } else 
                    if ($tissuesBlocksAndBuffyCoatData[$blockAliquotMasterId]['AliquotReviewDetail']['aliquot_review_master_id'] != $newRow['AliquotReviewDetail']['aliquot_review_master_id']) {
                        $tissueBlocksHavingManyReviews[] = $newRow['AliquotMaster_TissueBlock_BcTube']['block_aliquot_label'];
                    }
            }
        }
        if ($tissueBlocksHavingManyReviews)
            AppController::addWarningMsg(__('some blocks have been attached to many reviews') . ' - ' . str_replace('%s', '"' . implode('", "', $tissueBlocksHavingManyReviews) . '"', __('see # %s')));
        if ($tissueBlocksHavingManyAliquotsSource)
            AppController::addWarningMsg(__('some blocks are linked to many aliquots source') . ' - ' . str_replace('%s', '"' . implode('", "', $tissueBlocksHavingManyAliquotsSource) . '"', __('see # %s')));
            
            // Get buffy coat data
        $allData = $this->Report->tryCatchQuery("
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
			INNER JOIN aliquot_masters AS AliquotMaster_TissueBlock_BcTube ON AliquotMaster_TissueBlock_BcTube.collection_id = Collection.id AND AliquotMaster_TissueBlock_BcTube.deleted <> 1 AND AliquotMaster_TissueBlock_BcTube.aliquot_control_id = $buffyCoatTubeControlId
	
			LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
			LEFT JOIN misc_identifiers AS MiscIdentifier ON Collection.misc_identifier_id = MiscIdentifier.id AND MiscIdentifier.deleted <> 1
	
			WHERE $criteria
	
			ORDER BY MiscIdentifier.identifier_value, Collection.id, AliquotMaster_TissueBlock_BcTube.id;");
        
        foreach ($allData as $newRow) {
            $bcTubeAliquotMasterId = $newRow['AliquotMaster_TissueBlock_BcTube']['bc_tube_aliquot_master_id'];
            if (array_key_exists($bcTubeAliquotMasterId, $tissuesBlocksAndBuffyCoatData))
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            $tissuesBlocksAndBuffyCoatData[$bcTubeAliquotMasterId] = $emptyAliquotsSubarray;
            $tissuesBlocksAndBuffyCoatData[$bcTubeAliquotMasterId]['ViewAliquot']['sample_type'] = 'pbmc';
            $tissuesBlocksAndBuffyCoatData[$bcTubeAliquotMasterId]['ViewAliquot']['aliquot_type'] = 'tube';
            $tissuesBlocksAndBuffyCoatData[$bcTubeAliquotMasterId]['AliquotMaster']['aliquot_label'] = $newRow['AliquotMaster_TissueBlock_BcTube']['bc_tube_aliquot_label'];
            $tissuesBlocksAndBuffyCoatData[$bcTubeAliquotMasterId]['AliquotMaster']['barcode'] = $newRow['AliquotMaster_TissueBlock_BcTube']['bc_tube_barcode'];
            $tissuesBlocksAndBuffyCoatData[$bcTubeAliquotMasterId]['ViewCollection']['misc_identifier_value'] = $newRow['MiscIdentifier']['misc_identifier_value'];
            $tissuesBlocksAndBuffyCoatData[$bcTubeAliquotMasterId]['ViewCollection']['participant_identifier'] = $newRow['Participant']['participant_identifier'];
            $tissuesBlocksAndBuffyCoatData[$bcTubeAliquotMasterId]['ViewCollection']['qc_lady_specimen_type_precision'] = $newRow['Collection']['qc_lady_specimen_type_precision'];
            $tissuesBlocksAndBuffyCoatData[$bcTubeAliquotMasterId]['ViewCollection']['qc_lady_visit'] = $newRow['Collection']['qc_lady_visit'];
        }
        
        // Get DNA/RNA samples volumes sorted by sample
        $dnaRnaSampleData = $this->Report->tryCatchQuery("
			SELECT
			AliquotMaster_TissueBlock_BcTube.id AS block_aliquot_master_id,
			SampleMaster_DnaRna.id dna_rna_sample_master_id,
			AliquotMaster_DnaRna.current_volume
			FROM aliquot_masters AS AliquotMaster_TissueBlock_BcTube
			INNER JOIN source_aliquots SourceAliquot_ToDnaRna ON SourceAliquot_ToDnaRna.aliquot_master_id = AliquotMaster_TissueBlock_BcTube.id AND SourceAliquot_ToDnaRna.deleted <> 1
			INNER JOIN sample_masters AS SampleMaster_DnaRna ON SampleMaster_DnaRna.id = SourceAliquot_ToDnaRna.sample_master_id AND SampleMaster_DnaRna.deleted <> 1 AND SampleMaster_DnaRna.sample_control_id IN ($rnaControlId, $dnaControlId) 
			INNER JOIN aliquot_masters AS AliquotMaster_DnaRna ON AliquotMaster_DnaRna.sample_master_id = SampleMaster_DnaRna.id AND AliquotMaster_DnaRna.deleted <> 1 AND AliquotMaster_DnaRna.in_stock != 'no'
			WHERE AliquotMaster_TissueBlock_BcTube.id IN ('" . implode("','", array_keys($tissuesBlocksAndBuffyCoatData)) . "')
			ORDER BY SampleMaster_DnaRna.id;");
        $dnaRnaSamplesVolumes = array();
        foreach ($dnaRnaSampleData as $newDnaRna) {
            if ($newDnaRna['AliquotMaster_DnaRna']['current_volume']) {
                if (! isset($dnaRnaSamplesVolumes[$newDnaRna['SampleMaster_DnaRna']['dna_rna_sample_master_id']]))
                    $dnaRnaSamplesVolumes[$newDnaRna['SampleMaster_DnaRna']['dna_rna_sample_master_id']] = 0;
                $dnaRnaSamplesVolumes[$newDnaRna['SampleMaster_DnaRna']['dna_rna_sample_master_id']] += $newDnaRna['AliquotMaster_DnaRna']['current_volume'];
            }
        }
        
        // DNA/RNA QC
        $dnaRnaQcData = $this->Report->tryCatchQuery("
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
			INNER JOIN sample_masters AS SampleMaster_DnaRna ON SampleMaster_DnaRna.id = SourceAliquot_ToDnaRna.sample_master_id AND SampleMaster_DnaRna.deleted <> 1 AND SampleMaster_DnaRna.sample_control_id IN ($rnaControlId, $dnaControlId)
			INNER JOIN sample_controls AS SampleControl_DnaRna ON SampleControl_DnaRna.id = SampleMaster_DnaRna.sample_control_id
			INNER JOIN quality_ctrls AS QualityCtrl_DnaRna ON QualityCtrl_DnaRna.sample_master_id = SampleMaster_DnaRna.id AND QualityCtrl_DnaRna.deleted <> 1
			LEFT JOIN aliquot_masters AS AliquotMaster_TestedDnaRnaTube ON AliquotMaster_TestedDnaRnaTube.id = QualityCtrl_DnaRna.aliquot_master_id AND AliquotMaster_TestedDnaRnaTube.deleted <> 1 AND AliquotMaster_TestedDnaRnaTube.in_stock != 'no'
			WHERE AliquotMaster_TissueBlock_BcTube.id IN ('" . implode("','", array_keys($tissuesBlocksAndBuffyCoatData)) . "') AND QualityCtrl_DnaRna.type IN ('bioanalyzer','Nanodrop','PicoGreen')
			ORDER BY AliquotMaster_TissueBlock_BcTube.id, SampleMaster_DnaRna.id, QualityCtrl_DnaRna.date;");
        $allBlockAndBuffyCoatDnaRnaQcs = array();
        foreach ($dnaRnaQcData as $newQcData) {
            $sourceAliquotMasterId = $newQcData['AliquotMaster_TissueBlock_BcTube']['source_aliquot_master_id'];
            $dnaRnaSampleMasterId = $newQcData['SampleMaster_DnaRna']['dna_rna_sample_master_id'];
            $dnaRnaSampleType = $newQcData['SampleControl_DnaRna']['sample_type'];
            
            if (! isset($allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId])) {
                $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId] = array(
                    'next_nano_drop_key' => '0',
                    'next_pico_green_bioanalyzer_key' => '0'
                );
            }
            
            $calculatedQuantity = '-';
            $calculatedQuantityOfTestedAliquot = '-';
            if (array_key_exists($dnaRnaSampleMasterId, $dnaRnaSamplesVolumes) && strlen($newQcData['QualityCtrl_DnaRna']['concentration'])) {
                $div = 1;
                switch ($newQcData['QualityCtrl_DnaRna']['concentration_unit']) {
                    case 'pg/ul':
                        $div = 1000;
                    case 'ng/ul':
                        $div = 1000 * $div;
                    case 'ug/ul':
                        $calculatedQuantity = $newQcData['QualityCtrl_DnaRna']['concentration'] * $dnaRnaSamplesVolumes[$dnaRnaSampleMasterId] / $div;
                        if (strlen($newQcData['AliquotMaster_TestedDnaRnaTube']['current_volume']))
                            $calculatedQuantityOfTestedAliquot = $newQcData['QualityCtrl_DnaRna']['concentration'] * $newQcData['AliquotMaster_TestedDnaRnaTube']['current_volume'] / $div;
                        break;
                    default:
                        $calculatedQuantity = __('concentration unit missing');
                        if (strlen($newQcData['AliquotMaster_TestedDnaRnaTube']['current_volume']))
                            $calculatedQuantityOfTestedAliquot = __('concentration unit missing');
                }
            }
            switch ($newQcData['QualityCtrl_DnaRna']['type']) {
                case 'Nanodrop':
                    $nextNanoDropKey = $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['next_nano_drop_key'];
                    $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['next_nano_drop_key'] += 1;
                    if ($dnaRnaSampleType == 'dna') {
                        $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['data'][$nextNanoDropKey]['qc_lady_qc_dna_sample_code'] = $newQcData['SampleMaster_DnaRna']['sample_code'];
                        $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['data'][$nextNanoDropKey]['qc_lady_qc_nano_drop_dna_260_280'] = $newQcData['QualityCtrl_DnaRna']['qc_lady_260_280_score'];
                        $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['data'][$nextNanoDropKey]['qc_lady_qc_nano_drop_dna_yield_ug'] = $calculatedQuantity;
                        $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['data'][$nextNanoDropKey]['qc_lady_qc_nano_drop_tested_dna_yield_ug'] = $calculatedQuantityOfTestedAliquot;
                    } else 
                        if ($dnaRnaSampleType == 'rna') {
                            $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['data'][$nextNanoDropKey]['qc_lady_qc_rna_sample_code'] = $newQcData['SampleMaster_DnaRna']['sample_code'];
                            $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['data'][$nextNanoDropKey]['qc_lady_qc_nano_drop_rna_260_280'] = $newQcData['QualityCtrl_DnaRna']['qc_lady_260_280_score'];
                            $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['data'][$nextNanoDropKey]['qc_lady_qc_nano_drop_rna_yield_ug'] = $calculatedQuantity;
                            $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['data'][$nextNanoDropKey]['qc_lady_qc_nano_drop_tested_rna_yield_ug'] = $calculatedQuantityOfTestedAliquot;
                        }
                    break;
                case 'PicoGreen':
                case 'bioanalyzer':
                    $nextPicoGreenBioanalyzerKey = $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['next_pico_green_bioanalyzer_key'];
                    $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['next_pico_green_bioanalyzer_key'] += 1;
                    if ($dnaRnaSampleType == 'dna' && $newQcData['QualityCtrl_DnaRna']['type'] == 'PicoGreen') {
                        $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['data'][$nextPicoGreenBioanalyzerKey]['qc_lady_qc_dna_sample_code'] = $newQcData['SampleMaster_DnaRna']['sample_code'];
                        $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['data'][$nextPicoGreenBioanalyzerKey]['qc_lady_qc_pico_green_dna_yield_ug'] = $calculatedQuantity;
                        $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['data'][$nextPicoGreenBioanalyzerKey]['qc_lady_qc_pico_green_tested_dna_yield_ug'] = $calculatedQuantityOfTestedAliquot;
                    } else 
                        if ($dnaRnaSampleType == 'rna' && $newQcData['QualityCtrl_DnaRna']['type'] == 'bioanalyzer') {
                            $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['data'][$nextPicoGreenBioanalyzerKey]['qc_lady_qc_rna_sample_code'] = $newQcData['SampleMaster_DnaRna']['sample_code'];
                            $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['data'][$nextPicoGreenBioanalyzerKey]['qc_lady_qc_bioanalyzer_rna_rin'] = $newQcData['QualityCtrl_DnaRna']['qc_lady_rin_score'];
                            $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['data'][$nextPicoGreenBioanalyzerKey]['qc_lady_qc_bioanalyzer_rna_yield_ug'] = $calculatedQuantity;
                            $allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId][$dnaRnaSampleType][$dnaRnaSampleMasterId]['data'][$nextPicoGreenBioanalyzerKey]['qc_lady_qc_bioanalyzer_tested_rna_yield_ug'] = $calculatedQuantityOfTestedAliquot;
                        }
                    break;
            }
        }
        foreach ($allBlockAndBuffyCoatDnaRnaQcs as $sourceAliquotMasterId => &$newBlockDnaRna) {
            $newBlockDnaRna['formated_qcs'] = array();
            foreach (array(
                'dna',
                'rna'
            ) as $newSampleType) {
                $formatedQcKey = 0;
                if (isset($newBlockDnaRna[$newSampleType])) {
                    foreach ($newBlockDnaRna[$newSampleType] as $tmp1) {
                        if (array_key_exists('data', $tmp1)) {
                            foreach ($tmp1['data'] as $newSampleTypeQc) {
                                $newBlockDnaRna['formated_qcs'][$formatedQcKey] = array_merge($newSampleTypeQc, (isset($newBlockDnaRna['formated_qcs'][$formatedQcKey]) ? $newBlockDnaRna['formated_qcs'][$formatedQcKey] : array()));
                                $formatedQcKey ++;
                            }
                        }
                    }
                }
                unset($newBlockDnaRna[$newSampleType]);
            }
        }
        
        // Merge Block/buffy coat data and DNA RNA QCs
        $emptyQcSubArray = array(
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
            'qc_lady_qc_pico_green_tested_dna_yield_ug' => ''
        );
        
        $finalData = array();
        foreach ($tissuesBlocksAndBuffyCoatData as $sourceAliquotMasterId => $blockAndBuffyCoatData) {
            if (array_key_exists($sourceAliquotMasterId, $allBlockAndBuffyCoatDnaRnaQcs) && ! empty($allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId]['formated_qcs'])) {
                $firstRow = true;
                foreach ($allBlockAndBuffyCoatDnaRnaQcs[$sourceAliquotMasterId]['formated_qcs'] as $newQcDataSet) {
                    if ($firstRow) {
                        $blockAndBuffyCoatData['Generated'] = array_merge($emptyQcSubArray, $newQcDataSet);
                        $finalData[] = $blockAndBuffyCoatData;
                    } else {
                        $newBlockAndBuffyCoatData = $emptyAliquotsSubarray;
                        $newBlockAndBuffyCoatData['ViewAliquot']['sample_type'] = $blockAndBuffyCoatData['ViewAliquot']['sample_type'];
                        $newBlockAndBuffyCoatData['ViewAliquot']['aliquot_type'] = $blockAndBuffyCoatData['ViewAliquot']['aliquot_type'];
                        $newBlockAndBuffyCoatData['AliquotMaster']['barcode'] = $blockAndBuffyCoatData['AliquotMaster']['barcode'];
                        $newBlockAndBuffyCoatData['AliquotMaster']['aliquot_label'] = $blockAndBuffyCoatData['AliquotMaster']['aliquot_label'];
                        $newBlockAndBuffyCoatData['Generated'] = array_merge($emptyQcSubArray, $newQcDataSet);
                        $finalData[] = $newBlockAndBuffyCoatData;
                    }
                    $firstRow = false;
                }
            } else {
                $blockAndBuffyCoatData['Generated'] = $emptyQcSubArray;
                $finalData[] = $blockAndBuffyCoatData;
            }
        }
        
        $arrayToReturn = array(
            'header' => null,
            'data' => $finalData,
            'columns_names' => null,
            'error_msg' => null
        );
        
        return $arrayToReturn;
    }

    public function participantIdentifiersSummary($parameters)
    {
        $header = null;
        $conditions = array();
        
        if (isset($parameters['SelectedItemsForCsv']['Participant']['id']))
            $parameters['Participant']['id'] = $parameters['SelectedItemsForCsv']['Participant']['id'];
        if (isset($parameters['Participant']['id'])) {
            // From databrowser
            $participantIds = array_filter($parameters['Participant']['id']);
            if ($participantIds)
                $conditions['Participant.id'] = $participantIds;
        } else 
            if (isset($parameters['Participant']['participant_identifier_start'])) {
                $participantIdentifierStart = (! empty($parameters['Participant']['participant_identifier_start'])) ? $parameters['Participant']['participant_identifier_start'] : null;
                $participantIdentifierEnd = (! empty($parameters['Participant']['participant_identifier_end'])) ? $parameters['Participant']['participant_identifier_end'] : null;
                if ($participantIdentifierStart)
                    $conditions[] = "Participant.participant_identifier >= '$participantIdentifierStart'";
                if ($participantIdentifierEnd)
                    $conditions[] = "Participant.participant_identifier <= '$participantIdentifierEnd'";
            } else 
                if (isset($parameters['Participant']['participant_identifier'])) {
                    $participantIdentifiers = array_filter($parameters['Participant']['participant_identifier']);
                    if ($participantIdentifiers)
                        $conditions['Participant.participant_identifier'] = $participantIdentifiers;
                } else {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
        
        $miscIdentifierModel = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
        $tmpResCount = $miscIdentifierModel->find('count', array(
            'conditions' => $conditions,
            'order' => array(
                'MiscIdentifier.participant_id ASC'
            )
        ));
        if ($tmpResCount > Configure::read('databrowser_and_report_results_display_limit')) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => 'the report contains too many results - please redefine search criteria'
            );
        }
        $miscIdentifiers = $miscIdentifierModel->find('all', array(
            'conditions' => $conditions,
            'order' => array(
                'MiscIdentifier.participant_id ASC'
            )
        ));
        $data = array();
        foreach ($miscIdentifiers as $newIdent) {
            $participantId = $newIdent['Participant']['id'];
            if (! isset($data[$participantId])) {
                $data[$participantId] = array(
                    'Participant' => array(
                        'id' => $newIdent['Participant']['id'],
                        'participant_identifier' => $newIdent['Participant']['participant_identifier'],
                        'first_name' => $newIdent['Participant']['first_name'],
                        'last_name' => $newIdent['Participant']['last_name']
                    ),
                    '0' => array(
                        'RAMQ' => '',
                        'JGH' => '',
                        'Sardo' => '',
                        'Breast_bank' => '',
                        'Q_CROC_03' => ''
                    )
                );
            }
            $identKey = str_replace(array(
                ' #',
                ' ',
                '-'
            ), array(
                '',
                '_',
                '_'
            ), $newIdent['MiscIdentifierControl']['misc_identifier_name']);
            $data[$participantId]['0'][$identKey] .= (empty($data[$participantId]['0'][$identKey]) ? '' : ' & ') . $newIdent['MiscIdentifier']['identifier_value'];
        }
        return array(
            'header' => $header,
            'data' => $data,
            'columns_names' => null,
            'error_msg' => null
        );
    }
}