<?php

class ReportsControllerCustom extends ReportsController
{

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
        } elseif (isset($parameters['Participant']['participant_identifier_start'])) {
            $participantIdentifierStart = (! empty($parameters['Participant']['participant_identifier_start'])) ? $parameters['Participant']['participant_identifier_start'] : null;
            $participantIdentifierEnd = (! empty($parameters['Participant']['participant_identifier_end'])) ? $parameters['Participant']['participant_identifier_end'] : null;
            if ($participantIdentifierStart)
                $conditions[] = "Participant.participant_identifier >= '$participantIdentifierStart'";
            if ($participantIdentifierEnd)
                $conditions[] = "Participant.participant_identifier <= '$participantIdentifierEnd'";
        } elseif (isset($parameters['Participant']['participant_identifier'])) {
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
                        'health_insurance_card' => null,
                        'saint_luc_hospital_nbr' => null,
                        'notre_dame_hospital_nbr' => null,
                        'hotel_dieu_hospital_nbr' => null
                    )
                );
            }
            $data[$participantId]['0'][str_replace(array(
                ' ',
                '-'
            ), array(
                '_',
                '_'
            ), $newIdent['MiscIdentifierControl']['misc_identifier_name'])] = $newIdent['MiscIdentifier']['identifier_value'];
        }
        
        return array(
            'header' => $header,
            'data' => $data,
            'columns_names' => null,
            'error_msg' => null
        );
    }

    public function ctrnetCatalogSubmissionFileSorteByIcdCodes($parameters)
    {
        
        // 1- Build Header
        $header = array(
            'title' => __('qc_hb_report_ctrnet_catalog_sorted_by_icd_name'),
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
        
        $bankConditions = empty($bankIds) ? 'true' : 'col.bank_id IN (' . implode(',', $bankIds) . ')';
        $aliquotTypeConfitions = $parameters[0]['include_core_and_slide'][0] ? 'true' : "ac.aliquot_type NOT IN ('core','slide')";
        $whatmanPaperConfitions = $parameters[0]['include_whatman_paper'][0] ? 'true' : "ac.aliquot_type NOT IN ('whatman paper')";
        $detailOtherCount = $parameters[0]['detail_other_count'][0] ? true : false;
        
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
				AND ($bankConditions)
				AND ($aliquotTypeConfitions) 
				AND am.in_stock IN ('yes - available ','yes - not available')
			) AS res GROUP BY res.primary_icd10_code, res.collection_icd10_code;";
        // Participant
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        foreach ($queryResults as $newResult) {
            $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
            $dataKey = $ctrnetClassification . '-total';
            if (! isset($data[$dataKey])) {
                $data[$dataKey] = array(
                    'qc_hb_ctrnet_classification' => $ctrnetClassification,
                    'qc_hb_primary_icd10_codes' => array(
                        $newResult['res']['primary_icd10_code'] => $newResult['res']['primary_icd10_code']
                    ),
                    'qc_hb_collection_icd10_codes' => array(
                        $newResult['res']['collection_icd10_code'] => $newResult['res']['collection_icd10_code']
                    ),
                    'sample_type' => __('total'),
                    'cases_nbr' => $newResult['0']['nbr'],
                    'aliquots_nbr' => 0,
                    'notes' => array()
                );
            } else {
                $data[$dataKey]['qc_hb_primary_icd10_codes'][$newResult['res']['primary_icd10_code']] = $newResult['res']['primary_icd10_code'];
                $data[$dataKey]['qc_hb_collection_icd10_codes'][$newResult['res']['collection_icd10_code']] = $newResult['res']['collection_icd10_code'];
                $data[$dataKey]['cases_nbr'] = $data[$dataKey]['cases_nbr'] + $newResult['0']['nbr'];
            }
        }
        // Aliquot
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        foreach ($queryResults as $newResult) {
            $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
            $dataKey = $ctrnetClassification . '-total';
            $data[$dataKey]['aliquots_nbr'] = $data[$dataKey]['aliquots_nbr'] + $newResult['0']['nbr'];
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
				WHERE col.deleted != '1' AND ($bankConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ('tissue')
				AND ac.aliquot_type = 'block'
				AND blk.block_type = 'paraffin'
			) AS res GROUP BY res.primary_icd10_code, res.collection_icd10_code;";
        // Participant
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        foreach ($queryResults as $newResult) {
            $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
            $dataKey = $ctrnetClassification . '-FFPE';
            if (! isset($data[$dataKey])) {
                $data[$dataKey] = array(
                    'qc_hb_ctrnet_classification' => $ctrnetClassification,
                    'qc_hb_primary_icd10_codes' => array(
                        $newResult['res']['primary_icd10_code'] => $newResult['res']['primary_icd10_code']
                    ),
                    'qc_hb_collection_icd10_codes' => array(
                        $newResult['res']['collection_icd10_code'] => $newResult['res']['collection_icd10_code']
                    ),
                    'sample_type' => __('FFPE'),
                    'cases_nbr' => $newResult['0']['nbr'],
                    'aliquots_nbr' => 0,
                    'notes' => array()
                );
            } else {
                $data[$dataKey]['qc_hb_primary_icd10_codes'][$newResult['res']['primary_icd10_code']] = $newResult['res']['primary_icd10_code'];
                $data[$dataKey]['qc_hb_collection_icd10_codes'][$newResult['res']['collection_icd10_code']] = $newResult['res']['collection_icd10_code'];
                $data[$dataKey]['cases_nbr'] = $data[$dataKey]['cases_nbr'] + $newResult['0']['nbr'];
            }
        }
        // Aliquot
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        foreach ($queryResults as $newResult) {
            $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
            $dataKey = $ctrnetClassification . '-FFPE';
            $data[$dataKey]['aliquots_nbr'] = $data[$dataKey]['aliquots_nbr'] + $newResult['0']['nbr'];
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
				WHERE col.deleted != '1' AND ($bankConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ('tissue')
				AND ($aliquotTypeConfitions) 
				AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin')
			) AS res GROUP BY res.primary_icd10_code, res.collection_icd10_code;";
        // Participant
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        foreach ($queryResults as $newResult) {
            $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
            $dataKey = $ctrnetClassification . '-frozen tissue';
            if (! isset($data[$dataKey])) {
                $data[$dataKey] = array(
                    'qc_hb_ctrnet_classification' => $ctrnetClassification,
                    'qc_hb_primary_icd10_codes' => array(
                        $newResult['res']['primary_icd10_code'] => $newResult['res']['primary_icd10_code']
                    ),
                    'qc_hb_collection_icd10_codes' => array(
                        $newResult['res']['collection_icd10_code'] => $newResult['res']['collection_icd10_code']
                    ),
                    'sample_type' => __('frozen tissue'),
                    'cases_nbr' => $newResult['0']['nbr'],
                    'aliquots_nbr' => 0,
                    'notes' => array()
                );
            } else {
                $data[$dataKey]['qc_hb_primary_icd10_codes'][$newResult['res']['primary_icd10_code']] = $newResult['res']['primary_icd10_code'];
                $data[$dataKey]['qc_hb_collection_icd10_codes'][$newResult['res']['collection_icd10_code']] = $newResult['res']['collection_icd10_code'];
                $data[$dataKey]['cases_nbr'] = $data[$dataKey]['cases_nbr'] + $newResult['0']['nbr'];
            }
        }
        // Aliquot
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        foreach ($queryResults as $newResult) {
            $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
            $dataKey = $ctrnetClassification . '-frozen tissue';
            $data[$dataKey]['aliquots_nbr'] = $data[$dataKey]['aliquots_nbr'] + $newResult['0']['nbr'];
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
			WHERE col.deleted != '1' AND ($bankConditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type IN ('tissue')
			AND ($aliquotTypeConfitions) 
			AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin');";
        $queryResults = $this->Report->tryCatchQuery($sql);
        foreach ($queryResults as $newType) {
            $ctrnetClassification = $this->getCTRNetCatalogClassification($newType['primary_diagnosis']['primary_icd10_code']);
            $dataKey = $ctrnetClassification . '-frozen tissue';
            $note = __($newType['sc']['sample_type']) . ' ' . __($newType['ac']['aliquot_type']) . (empty($newType['blk']['block_type']) ? '' : ' (' . __($newType['blk']['block_type']) . ')');
            $data[$dataKey]['notes'][$note] = $note;
        }
        
        // **blood**
        // **pbmc**
        // **blood cell**
        // **plasma**
        // **serum**
        // **rna**
        // **dna**
        // **cell culture**
        
        $sampleTypes = "'blood', 'pbmc', 'blood cell', 'plasma', 'serum', 'rna', 'dna', 'cell culture'";
        
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
				WHERE col.deleted != '1' AND ($bankConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ($sampleTypes)
				AND ($whatmanPaperConfitions)	
			) AS res GROUP BY sample_type, aliquot_type, res.primary_icd10_code, res.collection_icd10_code;";
        // Participant
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        foreach ($queryResults as $newResult) {
            $sampleType = $newResult['res']['sample_type'];
            $aliquotType = $newResult['res']['aliquot_type'];
            $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
            $dataKey = $ctrnetClassification . "-$sampleType-$aliquotType";
            if (! isset($data[$dataKey])) {
                $data[$dataKey] = array(
                    'qc_hb_ctrnet_classification' => $ctrnetClassification,
                    'qc_hb_primary_icd10_codes' => array(
                        $newResult['res']['primary_icd10_code'] => $newResult['res']['primary_icd10_code']
                    ),
                    'qc_hb_collection_icd10_codes' => array(
                        $newResult['res']['collection_icd10_code'] => $newResult['res']['collection_icd10_code']
                    ),
                    'sample_type' => __($sampleType) . ' ' . __($aliquotType),
                    'cases_nbr' => $newResult['0']['nbr'],
                    'aliquots_nbr' => 0,
                    'notes' => array()
                );
            } else {
                $data[$dataKey]['qc_hb_primary_icd10_codes'][$newResult['res']['primary_icd10_code']] = $newResult['res']['primary_icd10_code'];
                $data[$dataKey]['qc_hb_collection_icd10_codes'][$newResult['res']['collection_icd10_code']] = $newResult['res']['collection_icd10_code'];
                $data[$dataKey]['cases_nbr'] = $data[$dataKey]['cases_nbr'] + $newResult['0']['nbr'];
            }
        }
        // Aliquot
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        foreach ($queryResults as $newResult) {
            $sampleType = $newResult['res']['sample_type'];
            $aliquotType = $newResult['res']['aliquot_type'];
            $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
            $dataKey = $ctrnetClassification . "-$sampleType-$aliquotType";
            $data[$dataKey]['aliquots_nbr'] = $data[$dataKey]['aliquots_nbr'] + $newResult['0']['nbr'];
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
				WHERE col.deleted != '1' AND ($bankConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type LIKE '%urine%'
			) AS res GROUP BY res.primary_icd10_code, res.collection_icd10_code;";
        // Participant
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        foreach ($queryResults as $newResult) {
            $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
            $dataKey = $ctrnetClassification . '-urine';
            if (! isset($data[$dataKey])) {
                $data[$dataKey] = array(
                    'qc_hb_ctrnet_classification' => $ctrnetClassification,
                    'qc_hb_primary_icd10_codes' => array(
                        $newResult['res']['primary_icd10_code'] => $newResult['res']['primary_icd10_code']
                    ),
                    'qc_hb_collection_icd10_codes' => array(
                        $newResult['res']['collection_icd10_code'] => $newResult['res']['collection_icd10_code']
                    ),
                    'sample_type' => __('urine'),
                    'cases_nbr' => $newResult['0']['nbr'],
                    'aliquots_nbr' => 0,
                    'notes' => array()
                );
            } else {
                $data[$dataKey]['qc_hb_primary_icd10_codes'][$newResult['res']['primary_icd10_code']] = $newResult['res']['primary_icd10_code'];
                $data[$dataKey]['qc_hb_collection_icd10_codes'][$newResult['res']['collection_icd10_code']] = $newResult['res']['collection_icd10_code'];
                $data[$dataKey]['cases_nbr'] = $data[$dataKey]['cases_nbr'] + $newResult['0']['nbr'];
            }
        }
        // Aliquot
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        foreach ($queryResults as $newResult) {
            $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
            $dataKey = $ctrnetClassification . '-urine';
            $data[$dataKey]['aliquots_nbr'] = $data[$dataKey]['aliquots_nbr'] + $newResult['0']['nbr'];
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
			WHERE col.deleted != '1' AND ($bankConditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type LIKE '%urine%'";
        $queryResults = $this->Report->tryCatchQuery($sql);
        foreach ($queryResults as $newType) {
            $ctrnetClassification = $this->getCTRNetCatalogClassification($newType['primary_diagnosis']['primary_icd10_code']);
            $dataKey = $ctrnetClassification . '-frozen tissue';
            $note = __($newType['sc']['sample_type']) . ' ' . __($newType['ac']['aliquot_type']);
            $data[$dataKey]['notes'][$note] = $note;
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
				WHERE col.deleted != '1' AND ($bankConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type LIKE '%ascite%'
			) AS res GROUP BY res.primary_icd10_code, res.collection_icd10_code;";
        // Participant
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        foreach ($queryResults as $newResult) {
            $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
            $dataKey = $ctrnetClassification . '-ascite';
            if (! isset($data[$dataKey])) {
                $data[$dataKey] = array(
                    'qc_hb_ctrnet_classification' => $ctrnetClassification,
                    'qc_hb_primary_icd10_codes' => array(
                        $newResult['res']['primary_icd10_code'] => $newResult['res']['primary_icd10_code']
                    ),
                    'qc_hb_collection_icd10_codes' => array(
                        $newResult['res']['collection_icd10_code'] => $newResult['res']['collection_icd10_code']
                    ),
                    'sample_type' => __('ascite'),
                    'cases_nbr' => $newResult['0']['nbr'],
                    'aliquots_nbr' => 0,
                    'notes' => array()
                );
            } else {
                $data[$dataKey]['qc_hb_primary_icd10_codes'][$newResult['res']['primary_icd10_code']] = $newResult['res']['primary_icd10_code'];
                $data[$dataKey]['qc_hb_collection_icd10_codes'][$newResult['res']['collection_icd10_code']] = $newResult['res']['collection_icd10_code'];
                $data[$dataKey]['cases_nbr'] = $data[$dataKey]['cases_nbr'] + $newResult['0']['nbr'];
            }
        }
        // Aliquot
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        foreach ($queryResults as $newResult) {
            $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
            $dataKey = $ctrnetClassification . '-ascite';
            $data[$dataKey]['aliquots_nbr'] = $data[$dataKey]['aliquots_nbr'] + $newResult['0']['nbr'];
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
			WHERE col.deleted != '1' AND ($bankConditions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			AND sc.sample_type LIKE '%ascite%'";
        $queryResults = $this->Report->tryCatchQuery($sql);
        foreach ($queryResults as $newType) {
            $ctrnetClassification = $this->getCTRNetCatalogClassification($newType['primary_diagnosis']['primary_icd10_code']);
            $dataKey = $ctrnetClassification . '-frozen tissue';
            $note = __($newType['sc']['sample_type']) . ' ' . __($newType['ac']['aliquot_type']);
            $data[$dataKey]['notes'][$note] = $note;
        }
        
        // **other**
        
        $otherConditions = "sc.sample_type NOT LIKE '%ascite%' AND sc.sample_type NOT LIKE '%urine%' AND sc.sample_type NOT IN ('tissue', $sampleTypes)";
        
        if ($detailOtherCount) {
            
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
					WHERE col.deleted != '1' AND ($bankConditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND ($otherConditions)
				) AS res GROUP BY sample_type, aliquot_type, res.primary_icd10_code, res.collection_icd10_code;";
            // Participant
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
            foreach ($queryResults as $newResult) {
                $sampleType = $newResult['res']['sample_type'];
                $aliquotType = $newResult['res']['aliquot_type'];
                $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
                $dataKey = $ctrnetClassification . "-$sampleType-$aliquotType";
                if (! isset($data[$dataKey])) {
                    $data[$dataKey] = array(
                        'qc_hb_ctrnet_classification' => $ctrnetClassification,
                        'qc_hb_primary_icd10_codes' => array(
                            $newResult['res']['primary_icd10_code'] => $newResult['res']['primary_icd10_code']
                        ),
                        'qc_hb_collection_icd10_codes' => array(
                            $newResult['res']['collection_icd10_code'] => $newResult['res']['collection_icd10_code']
                        ),
                        'sample_type' => __($sampleType) . ' ' . __($aliquotType),
                        'cases_nbr' => $newResult['0']['nbr'],
                        'aliquots_nbr' => 0,
                        'notes' => array()
                    );
                } else {
                    $data[$dataKey]['qc_hb_primary_icd10_codes'][$newResult['res']['primary_icd10_code']] = $newResult['res']['primary_icd10_code'];
                    $data[$dataKey]['qc_hb_collection_icd10_codes'][$newResult['res']['collection_icd10_code']] = $newResult['res']['collection_icd10_code'];
                    $data[$dataKey]['cases_nbr'] = $data[$dataKey]['cases_nbr'] + $newResult['0']['nbr'];
                }
            }
            // Aliquot
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
            foreach ($queryResults as $newResult) {
                $sampleType = $newResult['res']['sample_type'];
                $aliquotType = $newResult['res']['aliquot_type'];
                $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
                $dataKey = $ctrnetClassification . "-$sampleType-$aliquotType";
                $data[$dataKey]['aliquots_nbr'] = $data[$dataKey]['aliquots_nbr'] + $newResult['0']['nbr'];
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
					WHERE col.deleted != '1' AND ($bankConditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND ($otherConditions)
				) AS res GROUP BY res.primary_icd10_code, res.collection_icd10_code;";
            // Participant
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
            foreach ($queryResults as $newResult) {
                $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
                $dataKey = $ctrnetClassification . '-other';
                if (! isset($data[$dataKey])) {
                    $data[$dataKey] = array(
                        'qc_hb_ctrnet_classification' => $ctrnetClassification,
                        'qc_hb_primary_icd10_codes' => array(
                            $newResult['res']['primary_icd10_code'] => $newResult['res']['primary_icd10_code']
                        ),
                        'qc_hb_collection_icd10_codes' => array(
                            $newResult['res']['collection_icd10_code'] => $newResult['res']['collection_icd10_code']
                        ),
                        'sample_type' => __('other'),
                        'cases_nbr' => $newResult['0']['nbr'],
                        'aliquots_nbr' => 0,
                        'notes' => array()
                    );
                } else {
                    $data[$dataKey]['qc_hb_primary_icd10_codes'][$newResult['res']['primary_icd10_code']] = $newResult['res']['primary_icd10_code'];
                    $data[$dataKey]['qc_hb_collection_icd10_codes'][$newResult['res']['collection_icd10_code']] = $newResult['res']['collection_icd10_code'];
                    $data[$dataKey]['cases_nbr'] = $data[$dataKey]['cases_nbr'] + $newResult['0']['nbr'];
                }
            }
            // Aliquot
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
            foreach ($queryResults as $newResult) {
                $ctrnetClassification = $this->getCTRNetCatalogClassification($newResult['res']['primary_icd10_code']);
                $dataKey = $ctrnetClassification . '-other';
                $data[$dataKey]['aliquots_nbr'] = $data[$dataKey]['aliquots_nbr'] + $newResult['0']['nbr'];
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
				WHERE col.deleted != '1' AND ($bankConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND ($otherConditions)";
            $queryResults = $this->Report->tryCatchQuery($sql);
            foreach ($queryResults as $newType) {
                $ctrnetClassification = $this->getCTRNetCatalogClassification($newType['primary_diagnosis']['primary_icd10_code']);
                $dataKey = $ctrnetClassification . '-frozen tissue';
                $note = __($newType['sc']['sample_type']) . ' ' . __($newType['ac']['aliquot_type']);
                $data[$dataKey]['notes'][$note] = $note;
            }
        }
        
        foreach ($data as &$newRow) {
            foreach (array(
                'qc_hb_primary_icd10_codes',
                'qc_hb_collection_icd10_codes'
            ) as $field) {
                if (sizeof($newRow[$field]) > 10) {
                    $newRow[$field] = str_replace('%s', 10, __('more than %s'));
                } else {
                    $newRow[$field] = implode('-', array_filter($newRow[$field]));
                }
            }
            $newRow['notes'] = implode(' & ', array_filter($newRow['notes']));
        }
        ksort($data);
        
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

    public function getCTRNetCatalogClassification($primaryIcd10Code)
    {
        if ($primaryIcd10Code) {
            if (preg_match('/^C((1[5-9])|(2[0-6]))/', $primaryIcd10Code)) {
                if (preg_match('/^C181/', $primaryIcd10Code)) {
                    return 'Digestive - Appendix';
                } elseif (preg_match('/^C221/', $primaryIcd10Code)) {
                    return 'Digestive - Bile Ducts';
                } elseif (preg_match('/^C21/', $primaryIcd10Code)) {
                    return 'Digestive - Anal';
                } elseif (preg_match('/^C((18)|(19)|(20))/', $primaryIcd10Code)) {
                    return 'Digestive - Colorectal';
                } elseif (preg_match('/^C15/', $primaryIcd10Code)) {
                    return 'Digestive - Esophageal';
                } elseif (preg_match('/^C23/', $primaryIcd10Code)) {
                    return 'Digestive - Gallbladder';
                } elseif (preg_match('/^C22/', $primaryIcd10Code)) {
                    return 'Digestive - Liver';
                } elseif (preg_match('/^C25/', $primaryIcd10Code)) {
                    return 'Digestive - Pancreas';
                } elseif (preg_match('/^C17/', $primaryIcd10Code)) {
                    return 'Digestive - Small Intestine';
                } elseif (preg_match('/^C16/', $primaryIcd10Code)) {
                    return 'Digestive - Stomach';
                } else {
                    return 'Digestive - Other Digestive';
                }
            } elseif (preg_match('/^C5[1-8]/', $primaryIcd10Code)) {
                if (preg_match('/^C541/', $primaryIcd10Code)) {
                    return 'Female Genital - Endometrium';
                } elseif (preg_match('/^C570/', $primaryIcd10Code)) {
                    return 'Female Genital - Fallopian Tube';
                } elseif (preg_match('/^C53/', $primaryIcd10Code)) {
                    return 'Female Genital - Cervical';
                } elseif (preg_match('/^C56/', $primaryIcd10Code)) {
                    return 'Female Genital - Ovary';
                } elseif (preg_match('/^C48/', $primaryIcd10Code)) {
                    return 'Female Genital - Peritoneal';
                } elseif (preg_match('/^C54/', $primaryIcd10Code)) {
                    return 'Female Genital - Uterine';
                } elseif (preg_match('/^C55/', $primaryIcd10Code)) {
                    return 'Female Genital - Uterine';
                } elseif (preg_match('/^C51/', $primaryIcd10Code)) {
                    return 'Female Genital - Vulva';
                } elseif (preg_match('/^C52/', $primaryIcd10Code)) {
                    return 'Female Genital - Vagina';
                } else {
                    return 'Female Genital - Other Female Genital';
                }
            } elseif (preg_match('/^C50/', $primaryIcd10Code)) {
                return 'Breast - Breast';
            } elseif (preg_match('/^C34/', $primaryIcd10Code)) {
                return 'Thoracic - Lung';
            } elseif (preg_match('/^C45/', $primaryIcd10Code)) {
                return 'Thoracic - Mesothelioma';
            } elseif (preg_match('/^C69/', $primaryIcd10Code)) {
                return 'Ophthalmic - Eye';
            } elseif (preg_match('/^C32/', $primaryIcd10Code)) {
                return 'Head & Neck - Larynx';
            } elseif (preg_match('/^C30/', $primaryIcd10Code)) {
                return 'Head & Neck - Nasal Cavity and Sinuses';
            } elseif (preg_match('/^C31/', $primaryIcd10Code)) {
                return 'Head & Neck - Nasal Cavity and Sinuses';
            } elseif (preg_match('/^C((10)|(11))/', $primaryIcd10Code)) {
                return 'Head & Neck - Pharynx';
            } elseif (preg_match('/^C64/', $primaryIcd10Code)) {
                return 'Urinary Tract - Kidney';
            } elseif (preg_match('/^C4[34]/', $primaryIcd10Code)) {
                return 'Skin - Melanoma';
            } elseif (preg_match('/^C/', $primaryIcd10Code)) {
                return 'Other malignant neoplasms';
            } elseif (strlen($primaryIcd10Code)) {
                return 'Other than malignant neoplasms';
            }
        }
        return 'Undefined';
    }
    
    public function ivadoReport($parameters)
    {
        $header = null;
        $conditions = array();
        $joinOnMiscIdentifier = false;
        
        // Get Participants
        
        if (isset($parameters['Participant']['id'])) {
            // From databrowser
            $participantIds = array_filter($parameters['Participant']['id']);
            if ($participantIds) {
                $conditions['Participant.id'] = $participantIds;
            }
        } elseif (isset($parameters['MiscIdentifier']['id'])) {
            // From databrowser
            $miscIdentifierIds = array_filter($parameters['MiscIdentifier']['id']);
            if ($miscIdentifierIds) {
                $conditions['MiscIdentifier.id'] = $miscIdentifierIds;
            }
            $joinOnMiscIdentifier = true;
        } else {
            if (isset($parameters['MiscIdentifier']['misc_identifier_control_id'])) {
                $miscIdentifierControlIds = array_filter($parameters['MiscIdentifier']['misc_identifier_control_id']);
                if ($miscIdentifierControlIds) {
                    $conditions['MiscIdentifier.misc_identifier_control_id'] = $miscIdentifierControlIds;
                }
            }
            if (isset($parameters['MiscIdentifier']['identifier_value'])) {
                $miscIdentifierValues = array_filter($parameters['MiscIdentifier']['identifier_value']);
                if ($miscIdentifierValues) {
                    $conditions['MiscIdentifier.identifier_value'] = $miscIdentifierValues;
                }
            }
            if (isset($parameters['StudySummary']['title'])) {
                $studySummaryTitles = array_filter($parameters['StudySummary']['title']);
                if ($studySummaryTitles) {
                    $conditions['StudySummary.title'] = $studySummaryTitles;
                }
            }
            if (isset($parameters['MiscIdentifier']['identifier_value_start'])) {
                $miscIdentifierStart = (! empty($parameters['MiscIdentifier']['identifier_value_start'])) ? $parameters['MiscIdentifier']['identifier_value_start'] : null;
                $miscIdentifierEnd = (! empty($parameters['MiscIdentifier']['identifier_value_end'])) ? $parameters['MiscIdentifier']['identifier_value_end'] : null;
                if ($miscIdentifierStart)
                    $conditions[] = "MiscIdentifier.identifier_value >= '$miscIdentifierStart'";
                if ($miscIdentifierEnd)
                    $conditions[] = "MiscIdentifier.identifier_value <= '$miscIdentifierEnd'";
            }
            $joinOnMiscIdentifier = true;
        }
        
        $participantModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        if ($joinOnMiscIdentifier) {
            $miscIdentifierModel = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
            $tmpResCount = $miscIdentifierModel->find('count', array(
                'conditions' => $conditions
            ));
            if ($tmpResCount > Configure::read('databrowser_and_report_results_display_limit')) {
                return array(
                    'header' => null,
                    'data' => null,
                    'columns_names' => null,
                    'error_msg' => 'the report contains too many results - please redefine search criteria'
                );
            }
            $data = $miscIdentifierModel->find('all', array(
                'conditions' => $conditions,
                'order' => array(
                    'MiscIdentifier.identifier_value ASC'
                )
            ));
        } else {
            $tmpResCount = $participantModel->find('count', array(
                'conditions' => $conditions
            ));
            if ($tmpResCount > Configure::read('databrowser_and_report_results_display_limit')) {
                return array(
                    'header' => null,
                    'data' => null,
                    'columns_names' => null,
                    'error_msg' => 'the report contains too many results - please redefine search criteria'
                );
            }
            $data = $participantModel->find('all', array(
                'conditions' => $conditions,
                'order' => array(
                    'Participant.participant_identifier ASC'
                )
            ));
        }
        
        if (sizeof($data) > (Configure::read('databrowser_and_report_results_display_limit'))) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => 'the report contains too many results - please redefine search criteria'
            );
        }
        
        //-----------------------------------------------------------------------------------
        // Profile / Treatment / Imagery
        //-----------------------------------------------------------------------------------
        
        $participantIdsToDataKeys = array(
            '-1' => array('-1')
        );
        $participantCounter = 0;
        foreach ($data as $key => &$newParticipant) {
            if (! isset($newParticipant['MiscIdentifierControl']['misc_identifier_name'])) {
                $newParticipant['MiscIdentifierControl']['misc_identifier_name'] = 'N/A';
                $newParticipant['MiscIdentifier']['identifier_value'] = 'N/A';
                $newParticipant['StudySummary']['title'] = 'N/A';
            }
            
            // participantIdsToDataKeys
            if (!isset($participantIdsToDataKeys[$newParticipant['Participant']['id']])) {
                $participantIdsToDataKeys[$newParticipant['Participant']['id']] = array();
                $participantCounter++;
            }
            $participantIdsToDataKeys[$newParticipant['Participant']['id']][] = $key;            
            
            // Counter 
            $newParticipant['0']['qc_hb_liver_surg_counter'] = 0;
            $newParticipant['0']['qc_hb_liver_surg_counter_undisp_surg'] = '';
            
            // Imagery fields 1/1
            $newParticipant['0']['qc_hb_liver_imagery_1_pre_surg_first_step_counter'] = 0;
            $newParticipant['0']['qc_hb_liver_imagery_1_pre_surg_first_step_counter_undisp_img'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_1_1_pre_surg_first_step_event_date'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_1_1_pre_surg_first_step_event_type'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_1_1_pre_surg_first_step_r_r_nbr'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_1_2_pre_surg_first_step_event_date'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_1_2_pre_surg_first_step_event_type'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_1_2_pre_surg_first_step_r_r_nbr'] = '';
            
            // Chemo Fields 1/1
            $newParticipant['0']['qc_hb_liver_chemo_1_pre_surg_first_step_start_date'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_1_pre_surg_first_step_finish_date'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_1_pre_surg_first_step_embolization'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_1_pre_surg_first_step_qc_hb_treatment'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_1_pre_surg_first_step_num_cycles'] = '';
            
            // Imagery fields 2/1
            $newParticipant['0']['qc_hb_liver_imagery_2_pre_surg_first_step_counter'] = 0;
            $newParticipant['0']['qc_hb_liver_imagery_2_pre_surg_first_step_counter_undisp_img'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_2_1_pre_surg_first_step_event_date'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_2_1_pre_surg_first_step_event_type'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_2_1_pre_surg_first_step_r_r_nbr'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_2_2_pre_surg_first_step_event_date'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_2_2_pre_surg_first_step_event_type'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_2_2_pre_surg_first_step_r_r_nbr'] = '';
            
            // Chemo Fields 1/1
            $newParticipant['0']['qc_hb_liver_chemo_2_pre_surg_first_step_start_date'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_2_pre_surg_first_step_finish_date'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_2_pre_surg_first_step_embolization'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_2_pre_surg_first_step_qc_hb_treatment'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_2_pre_surg_first_step_num_cycles'] = '';
            
            // Imagery fields 3/1
            $newParticipant['0']['qc_hb_liver_imagery_3_pre_surg_first_step_counter'] = 0;
            $newParticipant['0']['qc_hb_liver_imagery_3_pre_surg_first_step_counter_undisp_img'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_3_1_pre_surg_first_step_event_date'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_3_1_pre_surg_first_step_event_type'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_3_1_pre_surg_first_step_r_r_nbr'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_3_2_pre_surg_first_step_event_date'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_3_2_pre_surg_first_step_event_type'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_3_2_pre_surg_first_step_r_r_nbr'] = '';
            
            // 1st Hepatectomy Fields
            $newParticipant['0']['qc_hb_liver_surg_first_step_start_date'] = '';
            $newParticipant['0']['qc_hb_liver_surg_first_step_age_at_hepatectomy'] = '';
            $newParticipant['0']['qc_hb_liver_surg_first_step_pve'] = '';
            $newParticipant['0']['qc_hb_liver_surg_first_step_principal_surgery'] = '';
            $newParticipant['0']['qc_hb_liver_surg_first_step_local_treatment'] = '';
            $newParticipant['0']['qc_hb_liver_surg_first_step_type_of_local_treatment'] = '';
            $newParticipant['0']['qc_hb_liver_surg_first_step_operative_bleeding'] = '';
            $newParticipant['0']['qc_hb_liver_surg_first_step_two_steps'] = '';
            $newParticipant['0']['qc_hb_liver_surg_first_step_clavien_score'] = '';
            
            // Imagery fields 1/2
            $newParticipant['0']['qc_hb_liver_imagery_1_pre_surg_scd_step_counter'] = 0;
            $newParticipant['0']['qc_hb_liver_imagery_1_pre_surg_scd_step_counter_undisp_img'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_1_1_pre_surg_scd_step_event_date'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_1_1_pre_surg_scd_step_event_type'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_1_1_pre_surg_scd_step_r_r_nbr'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_1_2_pre_surg_scd_step_event_date'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_1_2_pre_surg_scd_step_event_type'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_1_2_pre_surg_scd_step_r_r_nbr'] = '';
            
            // Chemo Fields 1/2
            $newParticipant['0']['qc_hb_liver_chemo_1_pre_surg_scd_step_start_date'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_1_pre_surg_scd_step_finish_date'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_1_pre_surg_scd_step_embolization'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_1_pre_surg_scd_step_qc_hb_treatment'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_1_pre_surg_scd_step_num_cycles'] = '';
            
            // Imagery fields 2/2
            $newParticipant['0']['qc_hb_liver_imagery_2_pre_surg_scd_step_counter'] = 0;
            $newParticipant['0']['qc_hb_liver_imagery_2_pre_surg_scd_step_counter_undisp_img'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_2_1_pre_surg_scd_step_event_date'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_2_1_pre_surg_scd_step_event_type'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_2_1_pre_surg_scd_step_r_r_nbr'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_2_2_pre_surg_scd_step_event_date'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_2_2_pre_surg_scd_step_event_type'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_2_2_pre_surg_scd_step_r_r_nbr'] = '';
            
            // Chemo Fields 2/2
            $newParticipant['0']['qc_hb_liver_chemo_2_pre_surg_scd_step_start_date'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_2_pre_surg_scd_step_finish_date'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_2_pre_surg_scd_step_embolization'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_2_pre_surg_scd_step_qc_hb_treatment'] = '';
            $newParticipant['0']['qc_hb_liver_chemo_2_pre_surg_scd_step_num_cycles'] = '';
            
            // Imagery fields 3/2
            $newParticipant['0']['qc_hb_liver_imagery_3_pre_surg_scd_step_counter'] = 0;
            $newParticipant['0']['qc_hb_liver_imagery_3_pre_surg_scd_step_counter_undisp_img'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_3_1_pre_surg_scd_step_event_date'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_3_1_pre_surg_scd_step_event_type'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_3_1_pre_surg_scd_step_r_r_nbr'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_3_2_pre_surg_scd_step_event_date'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_3_2_pre_surg_scd_step_event_type'] = '';
            $newParticipant['0']['qc_hb_liver_imagery_3_2_pre_surg_scd_step_r_r_nbr'] = '';
            
            // 2nd Hepatectomy Fields
            $newParticipant['0']['qc_hb_liver_surg_scd_step_start_date'] = '';
            $newParticipant['0']['qc_hb_liver_surg_scd_step_age_at_hepatectomy'] = '';
            $newParticipant['0']['qc_hb_liver_surg_scd_step_pve'] = '';
            $newParticipant['0']['qc_hb_liver_surg_scd_step_principal_surgery'] = '';
            $newParticipant['0']['qc_hb_liver_surg_scd_step_local_treatment'] = '';
            $newParticipant['0']['qc_hb_liver_surg_scd_step_type_of_local_treatment'] = '';
            $newParticipant['0']['qc_hb_liver_surg_scd_step_operative_bleeding'] = '';
            $newParticipant['0']['qc_hb_liver_surg_scd_step_two_steps'] = '';
            $newParticipant['0']['qc_hb_liver_surg_scd_step_clavien_score'] = '';
        }
        
        // Get Liver Surgery
        $structurePermissibleValuesCustomModel = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
        $principalSurgeries = $structurePermissibleValuesCustomModel->getCustomDropdown(array(
            'Surgery: Principal surgery'
        ));
        $principalSurgeries = array_merge($principalSurgeries['defined'], $principalSurgeries['previously_defined']);
        $principalSurgeries[''] = '';
        
        $sql = "SELECT TreatmentMaster.participant_id, 
            TreatmentMaster.id AS treatment_master_id,
            TreatmentMaster.start_date, 
            TreatmentMaster.start_date_accuracy, 
            TreatmentDetail.principal_surgery, 
            TreatmentDetail.local_treatment, 
            TreatmentDetail.type_of_local_treatment,
            TreatmentDetail.operative_bleeding, 
            TreatmentDetail.two_steps,
            GROUP_CONCAT(DISTINCT TreatmentExtendDetail.clavien_score ORDER BY TreatmentExtendDetail.clavien_score DESC SEPARATOR '|') AS clavien_score
            FROM treatment_masters TreatmentMaster 
            INNER JOIN qc_hb_txd_surgery_livers TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
            LEFT JOIN treatment_extend_masters TreatmentExtendMaster ON TreatmentMaster.id = TreatmentExtendMaster.treatment_master_id AND TreatmentExtendMaster.deleted <> 1
            LEFT JOIN qc_hb_txe_surgery_complications TreatmentExtendDetail ON TreatmentExtendMaster.id = TreatmentExtendDetail.treatment_extend_master_id
            WHERE TreatmentMaster.deleted <> 1
            AND TreatmentMaster.participant_id IN('".implode("','", array_keys($participantIdsToDataKeys))."')
            GROUP BY TreatmentMaster.participant_id, TreatmentMaster.id, TreatmentMaster.start_date, TreatmentMaster.start_date_accuracy, TreatmentDetail.principal_surgery, 
            TreatmentDetail.local_treatment, TreatmentDetail.type_of_local_treatment, TreatmentDetail.operative_bleeding, TreatmentDetail.two_steps
            ORDER BY TreatmentMaster.participant_id ASC, TreatmentMaster.start_date ASC";
        $queryResults = $this->Report->tryCatchQuery($sql);
        foreach ($queryResults as $newSurgery) {
            $participant_id = $newSurgery['TreatmentMaster']['participant_id'];
            if (!isset($participantIdsToDataKeys[$participant_id])) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            foreach ($participantIdsToDataKeys[$participant_id] as $key) {
                if (!isset($data[$key]) || $participant_id != $data[$key]['Participant']['id']) {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $data[$key][0]['qc_hb_liver_surg_counter']++;
                $newSurgery['0']['age_at_hepatectomy'] = '';
                if ($data[$key]['Participant']['date_of_birth'] && $newSurgery['TreatmentMaster']['start_date']) {
                    $newSurgery['0']['age_at_hepatectomy'] = $this->getDateDiffInYears($data[$key]['Participant']['date_of_birth'], $newSurgery['TreatmentMaster']['start_date']);
                }
                $clavien_score = $newSurgery['0']['clavien_score'];
                if (strlen($clavien_score)) {
                    $clavien_score = explode('|',$clavien_score);
                    $newSurgery['0']['clavien_score'] = array_shift($clavien_score);
                }
                if (!strlen($data[$key][0]['qc_hb_liver_surg_first_step_start_date'])) {
                    $data[$key][0]['qc_hb_liver_surg_first_step_start_date'] = $this->formatDateForDisplay($newSurgery['TreatmentMaster']['start_date'], $newSurgery['TreatmentMaster']['start_date_accuracy']);
                    $data[$key][0]['qc_hb_liver_surg_first_step_age_at_hepatectomy'] = $newSurgery['0']['age_at_hepatectomy'];
                    $data[$key][0]['qc_hb_liver_surg_first_step_principal_surgery'] = $newSurgery['TreatmentDetail']['principal_surgery'];
                    $data[$key][0]['qc_hb_liver_surg_first_step_local_treatment'] = $newSurgery['TreatmentDetail']['local_treatment'];
                    $data[$key][0]['qc_hb_liver_surg_first_step_type_of_local_treatment'] = $newSurgery['TreatmentDetail']['type_of_local_treatment'];
                    $data[$key][0]['qc_hb_liver_surg_first_step_operative_bleeding'] = $newSurgery['TreatmentDetail']['operative_bleeding'];
                    $data[$key][0]['qc_hb_liver_surg_first_step_two_steps'] = $newSurgery['TreatmentDetail']['two_steps'];
                    $data[$key][0]['qc_hb_liver_surg_first_step_clavien_score'] = $newSurgery['0']['clavien_score'];
                } elseif (!strlen($data[$key][0]['qc_hb_liver_surg_scd_step_start_date'])) {
                    $data[$key][0]['qc_hb_liver_surg_scd_step_start_date'] = $this->formatDateForDisplay($newSurgery['TreatmentMaster']['start_date'], $newSurgery['TreatmentMaster']['start_date_accuracy']);
                    $data[$key][0]['qc_hb_liver_surg_scd_step_age_at_hepatectomy'] = $newSurgery['0']['age_at_hepatectomy'];
                    $data[$key][0]['qc_hb_liver_surg_scd_step_principal_surgery'] = $newSurgery['TreatmentDetail']['principal_surgery'];
                    $data[$key][0]['qc_hb_liver_surg_scd_step_local_treatment'] = $newSurgery['TreatmentDetail']['local_treatment'];
                    $data[$key][0]['qc_hb_liver_surg_scd_step_type_of_local_treatment'] = $newSurgery['TreatmentDetail']['type_of_local_treatment'];
                    $data[$key][0]['qc_hb_liver_surg_scd_step_operative_bleeding'] = $newSurgery['TreatmentDetail']['operative_bleeding'];
                    $data[$key][0]['qc_hb_liver_surg_scd_step_two_steps'] = $newSurgery['TreatmentDetail']['two_steps'];
                    $data[$key][0]['qc_hb_liver_surg_scd_step_clavien_score'] = $newSurgery['0']['clavien_score'];
                } else {
                    $data[$key][0]['qc_hb_liver_surg_counter_undisp_surg'] .= 
                        (empty($data[$key][0]['qc_hb_liver_surg_counter_undisp_surg'])? '' : ' || ' ).
                        $this->formatDateForDisplay($newSurgery['TreatmentMaster']['start_date'], $newSurgery['TreatmentMaster']['start_date_accuracy']) .
                        ' ' . 
                        $principalSurgeries[$newSurgery['TreatmentDetail']['principal_surgery']];                    
                }
            }            
        }
        
        // Get PVE
        
        $sql = "SELECT EventMaster.participant_id,
            EventMaster.id AS treatment_master_id,
            EventMaster.event_date,
            EventMaster.event_date_accuracy
            FROM event_masters EventMaster
            INNER JOIN qc_hb_ed_hepatobiliary_medical_past_history_pves EventDetail ON EventMaster.id = EventDetail.event_master_id
            WHERE EventMaster.deleted <> 1
            AND EventMaster.participant_id IN('".implode("','", array_keys($participantIdsToDataKeys))."')
            ORDER BY EventMaster.participant_id ASC, EventMaster.event_date DESC";
        $queryResults = $this->Report->tryCatchQuery($sql);
        foreach ($queryResults as $newPve) {
            $participant_id = $newPve['EventMaster']['participant_id'];
            if (!isset($participantIdsToDataKeys[$participant_id])) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            foreach ($participantIdsToDataKeys[$participant_id] as $key) {
                if (!isset($data[$key]) || $participant_id != $data[$key]['Participant']['id']) {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                if ($newPve['EventMaster']['event_date']) {
                    if ($data[$key][0]['qc_hb_liver_surg_first_step_start_date'] && $newPve['EventMaster']['event_date'] <= $data[$key][0]['qc_hb_liver_surg_first_step_start_date']) {
                        if (empty($data[$key][0]['qc_hb_liver_surg_first_step_pve'])) {
                            $data[$key][0]['qc_hb_liver_surg_first_step_pve'] = $this->formatDateForDisplay($newPve['EventMaster']['event_date'], $newPve['EventMaster']['event_date_accuracy']);
                        }
                    } elseif ($data[$key][0]['qc_hb_liver_surg_scd_step_start_date'] && $newPve['EventMaster']['event_date'] <= $data[$key][0]['qc_hb_liver_surg_scd_step_start_date']) {
                        if (empty($data[$key][0]['qc_hb_liver_surg_scd_step_pve'])) {
                            $data[$key][0]['qc_hb_liver_surg_scd_step_pve'] = $this->formatDateForDisplay($newPve['EventMaster']['event_date'], $newPve['EventMaster']['event_date_accuracy']);
                        }
                    }
                }
            }
        }
        
        // Get Chemo
        
        $sql = "SELECT TreatmentControl.id, TreatmentControl.tx_method, TreatmentControl.disease_site FROM treatment_controls TreatmentControl WHERE  detail_tablename = 'txd_chemos' AND flag_active = '1';";
        $queryResults = $this->Report->tryCatchQuery($sql);
        $txControls = array();
        $txEmboControlId = null;
        foreach ($queryResults as $newTxControl) {
            $txControls[$newTxControl['TreatmentControl']['id']] = $newTxControl['TreatmentControl']['disease_site'].'-'.$newTxControl['TreatmentControl']['tx_method'];
            if ($newTxControl['TreatmentControl']['tx_method'] == 'chemo-embolization') {
                $txEmboControlId = $newTxControl['TreatmentControl']['id'];
            }
        }
        if (sizeof($txControls) != 2 || !in_array('hepatobiliary-chemotherapy', $txControls) || !in_array('hepatobiliary-chemo-embolization', $txControls)) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $sql = "SELECT TreatmentMaster.participant_id,
            TreatmentMaster.id AS treatment_master_id,
            TreatmentMaster.start_date,
            TreatmentMaster.start_date_accuracy,
            TreatmentMaster.finish_date,
            TreatmentMaster.finish_date_accuracy,
            TreatmentMaster.treatment_control_id,
            TreatmentDetail.qc_hb_treatment,
            TreatmentDetail.num_cycles
            FROM treatment_masters TreatmentMaster
            INNER JOIN txd_chemos TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
            WHERE TreatmentMaster.deleted <> 1
            AND TreatmentMaster.participant_id IN('".implode("','", array_keys($participantIdsToDataKeys))."')
            ORDER BY TreatmentMaster.participant_id ASC, TreatmentMaster.start_date DESC";
        $chemoReportKeys = array(
            'TreatmentMaster.start_date',
            'TreatmentMaster.start_date_accuracy',
            'TreatmentMaster.finish_date',
            'TreatmentMaster.finish_date_accuracy',
            'TreatmentDetail.qc_hb_treatment',
            'TreatmentDetail.num_cycles');
        $queryResults = $this->Report->tryCatchQuery($sql);
        foreach ($queryResults as $newChemo) {
            $participant_id = $newChemo['TreatmentMaster']['participant_id'];
            if (!isset($participantIdsToDataKeys[$participant_id])) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            foreach ($participantIdsToDataKeys[$participant_id] as $key) {
                if (!isset($data[$key]) || $participant_id != $data[$key]['Participant']['id']) {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                if ($newChemo['TreatmentMaster']['start_date']) {
                    if ($data[$key][0]['qc_hb_liver_surg_first_step_start_date'] && $newChemo['TreatmentMaster']['start_date'] <= $data[$key][0]['qc_hb_liver_surg_first_step_start_date']) {
                        if (empty($data[$key][0]['qc_hb_liver_chemo_2_pre_surg_first_step_start_date'])) {
                            // 2nd chemo pre liver surgery step 1
                            $chemoNbr = '2';
                            $liverSurgStep = 'first';
                            foreach ($chemoReportKeys as $modelField) {
                                list($model, $field) = explode('.', $modelField);
                                $data[$key][0]["qc_hb_liver_chemo_".$chemoNbr."_pre_surg_".$liverSurgStep."_step_".$field] = $newChemo[$model][$field];
                            }
                            $data[$key][0]["qc_hb_liver_chemo_".$chemoNbr."_pre_surg_".$liverSurgStep."_step_embolization"] = $newChemo['TreatmentMaster']['treatment_control_id'] == $txEmboControlId? 'y' : 'n';
                        } elseif (empty($data[$key][0]['qc_hb_liver_chemo_1_pre_surg_first_step_start_date'])) {
                            // 1st chemo pre liver surgery step 1
                            $chemoNbr = '1';
                            $liverSurgStep = 'first';
                            foreach ($chemoReportKeys as $modelField) {
                                list($model, $field) = explode('.', $modelField);
                                $data[$key][0]["qc_hb_liver_chemo_".$chemoNbr."_pre_surg_".$liverSurgStep."_step_".$field] = $newChemo[$model][$field];
                            }
                            $data[$key][0]["qc_hb_liver_chemo_".$chemoNbr."_pre_surg_".$liverSurgStep."_step_embolization"] = $newChemo['TreatmentMaster']['treatment_control_id'] == $txEmboControlId? 'y' : 'n';
                        }
                    } elseif ($data[$key][0]['qc_hb_liver_surg_scd_step_start_date'] && $newChemo['TreatmentMaster']['start_date'] <= $data[$key][0]['qc_hb_liver_surg_scd_step_start_date']) {
                        if (empty($data[$key][0]['qc_hb_liver_chemo_2_pre_surg_scd_step_start_date'])) {
                            // 2nd chemo pre liver surgery step 2
                            $chemoNbr = '2';
                            $liverSurgStep = 'scd';
                            foreach ($chemoReportKeys as $modelField) {
                                list($model, $field) = explode('.', $modelField);
                                $data[$key][0]["qc_hb_liver_chemo_".$chemoNbr."_pre_surg_".$liverSurgStep."_step_".$field] = $newChemo[$model][$field];
                            }
                            $data[$key][0]["qc_hb_liver_chemo_".$chemoNbr."_pre_surg_".$liverSurgStep."_step_embolization"] = $newChemo['TreatmentMaster']['treatment_control_id'] == $txEmboControlId? 'y' : 'n';
                        } elseif (empty($data[$key][0]['qc_hb_liver_chemo_1_pre_surg_scd_step_start_date'])) {
                            // 1st chemo pre liver surgery step 2
                            $chemoNbr = '1';
                            $liverSurgStep = 'scd';
                            foreach ($chemoReportKeys as $modelField) {
                                list($model, $field) = explode('.', $modelField);
                                $data[$key][0]["qc_hb_liver_chemo_".$chemoNbr."_pre_surg_".$liverSurgStep."_step_".$field] = $newChemo[$model][$field];
                            }
                            $data[$key][0]["qc_hb_liver_chemo_".$chemoNbr."_pre_surg_".$liverSurgStep."_step_embolization"] = $newChemo['TreatmentMaster']['treatment_control_id'] == $txEmboControlId? 'y' : 'n';
                        }
                    }
                }
            }
        }
        
        // Get abdominal CT-SCAN or MRI
             
        $displayedImageryCounter = 0;
        $displayedImageryWithRrnCounter = 0;
        $participantsWithRrnCounter = array();
        
        $sql = "SELECT id, event_type FROM event_controls EventControl WHERE flag_active =1 AND event_group = 'imagery' AND event_type IN ('medical imaging abdominal CT-scan', 'medical imaging abdominal MRI')";
        $queryResults = $this->Report->tryCatchQuery($sql);
        $evControls = array();
        $mriControlId = null;
        foreach ($queryResults as $newEvControl) {
            $evControls[$newEvControl['EventControl']['id']] = $newEvControl['EventControl']['event_type'];
            if ($newEvControl['EventControl']['event_type'] == 'medical imaging abdominal MRI') {
                $mriControlId = $newEvControl['EventControl']['id'];
            }
        }
        if (sizeof($evControls) != 2 || !in_array('medical imaging abdominal CT-scan', $evControls) || !in_array('medical imaging abdominal MRI', $evControls)) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $sql = "SELECT EventMaster.participant_id,
            EventMaster.id AS treatment_master_id,
            EventMaster.event_date,
            EventMaster.event_date_accuracy,
            EventMaster.event_control_id,
            EventDetail.request_nbr
            FROM event_masters EventMaster INNER JOIN qc_hb_ed_hepatobilary_medical_imagings EventDetail ON id = event_master_id
            WHERE EventMaster.deleted <> 1
            AND EventMaster.participant_id IN('".implode("','", array_keys($participantIdsToDataKeys))."')
            AND EventMaster.event_control_id IN (".implode(',', array_keys($evControls)).")
            ORDER BY EventMaster.participant_id ASC, EventMaster.event_date DESC";
        $queryResults = $this->Report->tryCatchQuery($sql);
        foreach ($queryResults as $newImagery) {
            $participant_id = $newImagery['EventMaster']['participant_id'];
            if (!isset($participantIdsToDataKeys[$participant_id])) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            foreach ($participantIdsToDataKeys[$participant_id] as $key) {
                if (!isset($data[$key]) || $participant_id != $data[$key]['Participant']['id']) {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                if ($newImagery['EventMaster']['event_date']) {
                    $displayedImageryCounter ++;
                    if (strlen($newImagery['EventDetail']['request_nbr']) > 3) {
                        $displayedImageryWithRrnCounter ++;
                        $participantsWithRrnCounter[$participant_id] = '-';
                    }
                    if ($data[$key][0]['qc_hb_liver_chemo_1_pre_surg_first_step_start_date'] && $newImagery['EventMaster']['event_date'] <= $data[$key][0]['qc_hb_liver_chemo_1_pre_surg_first_step_start_date']) {
                        $data[$key][0]['qc_hb_liver_imagery_1_pre_surg_first_step_counter']++;
                        if (empty($data[$key][0]['qc_hb_liver_imagery_1_2_pre_surg_first_step_event_date'])) {
                            $data[$key][0]['qc_hb_liver_imagery_1_2_pre_surg_first_step_event_date'] = $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']);
                            $data[$key][0]['qc_hb_liver_imagery_1_2_pre_surg_first_step_event_type'] = $newImagery['EventMaster']['event_control_id'] == $mriControlId? 'medical imaging abdominal MRI': 'medical imaging abdominal CT-scan';
                            $data[$key][0]['qc_hb_liver_imagery_1_2_pre_surg_first_step_r_r_nbr'] = $newImagery['EventDetail']['request_nbr'];
                        } elseif (empty($data[$key][0]['qc_hb_liver_imagery_1_1_pre_surg_first_step_event_date'])) {
                            $data[$key][0]['qc_hb_liver_imagery_1_1_pre_surg_first_step_event_date'] = $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']);
                            $data[$key][0]['qc_hb_liver_imagery_1_1_pre_surg_first_step_event_type'] = $newImagery['EventMaster']['event_control_id'] == $mriControlId? 'medical imaging abdominal MRI': 'medical imaging abdominal CT-scan';
                            $data[$key][0]['qc_hb_liver_imagery_1_1_pre_surg_first_step_r_r_nbr'] = $newImagery['EventDetail']['request_nbr'];
                        } else {
                            $data[$key][0]['qc_hb_liver_imagery_1_pre_surg_first_step_counter_undisp_img'] .=
                                (empty($data[$key][0]['qc_hb_liver_imagery_1_pre_surg_first_step_counter_undisp_img'])? '' : ' || ' ).
                                $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']) .
                                ' ' .
                                ($newImagery['EventMaster']['event_control_id'] == $mriControlId? __('medical imaging abdominal MRI'): __('medical imaging abdominal CT-scan'));
                        }                        
                    } elseif ($data[$key][0]['qc_hb_liver_chemo_2_pre_surg_first_step_start_date'] && $newImagery['EventMaster']['event_date'] <= $data[$key][0]['qc_hb_liver_chemo_2_pre_surg_first_step_start_date']) {
                        $data[$key][0]['qc_hb_liver_imagery_2_pre_surg_first_step_counter']++;
                        if (empty($data[$key][0]['qc_hb_liver_imagery_2_2_pre_surg_first_step_event_date'])) {
                            $data[$key][0]['qc_hb_liver_imagery_2_2_pre_surg_first_step_event_date'] = $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']);
                            $data[$key][0]['qc_hb_liver_imagery_2_2_pre_surg_first_step_event_type'] = $newImagery['EventMaster']['event_control_id'] == $mriControlId? 'medical imaging abdominal MRI': 'medical imaging abdominal CT-scan';
                            $data[$key][0]['qc_hb_liver_imagery_2_2_pre_surg_first_step_r_r_nbr'] = $newImagery['EventDetail']['request_nbr'];
                        } elseif (empty($data[$key][0]['qc_hb_liver_imagery_2_1_pre_surg_first_step_event_date'])) {
                            $data[$key][0]['qc_hb_liver_imagery_2_1_pre_surg_first_step_event_date'] = $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']);
                            $data[$key][0]['qc_hb_liver_imagery_2_1_pre_surg_first_step_event_type'] = $newImagery['EventMaster']['event_control_id'] == $mriControlId? 'medical imaging abdominal MRI': 'medical imaging abdominal CT-scan';
                            $data[$key][0]['qc_hb_liver_imagery_2_1_pre_surg_first_step_r_r_nbr'] = $newImagery['EventDetail']['request_nbr'];
                        } else {
                            $data[$key][0]['qc_hb_liver_imagery_2_pre_surg_first_step_counter_undisp_img'] .=
                                (empty($data[$key][0]['qc_hb_liver_imagery_2_pre_surg_first_step_counter_undisp_img'])? '' : ' || ' ).
                                $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']) .
                                ' ' .
                                ($newImagery['EventMaster']['event_control_id'] == $mriControlId? __('medical imaging abdominal MRI'): __('medical imaging abdominal CT-scan'));
                        }   
                    } elseif ($data[$key][0]['qc_hb_liver_surg_first_step_start_date'] && $newImagery['EventMaster']['event_date'] <= $data[$key][0]['qc_hb_liver_surg_first_step_start_date']) {
                        $data[$key][0]['qc_hb_liver_imagery_3_pre_surg_first_step_counter']++;
                        if (empty($data[$key][0]['qc_hb_liver_imagery_3_2_pre_surg_first_step_event_date'])) {
                            $data[$key][0]['qc_hb_liver_imagery_3_2_pre_surg_first_step_event_date'] = $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']);
                            $data[$key][0]['qc_hb_liver_imagery_3_2_pre_surg_first_step_event_type'] = $newImagery['EventMaster']['event_control_id'] == $mriControlId? 'medical imaging abdominal MRI': 'medical imaging abdominal CT-scan';
                            $data[$key][0]['qc_hb_liver_imagery_3_2_pre_surg_first_step_r_r_nbr'] = $newImagery['EventDetail']['request_nbr'];
                        } elseif (empty($data[$key][0]['qc_hb_liver_imagery_3_1_pre_surg_first_step_event_date'])) {
                            $data[$key][0]['qc_hb_liver_imagery_3_1_pre_surg_first_step_event_date'] = $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']);
                            $data[$key][0]['qc_hb_liver_imagery_3_1_pre_surg_first_step_event_type'] = $newImagery['EventMaster']['event_control_id'] == $mriControlId? 'medical imaging abdominal MRI': 'medical imaging abdominal CT-scan';
                            $data[$key][0]['qc_hb_liver_imagery_3_1_pre_surg_first_step_r_r_nbr'] = $newImagery['EventDetail']['request_nbr'];
                        } else {
                            $data[$key][0]['qc_hb_liver_imagery_3_pre_surg_first_step_counter_undisp_img'] .=
                                (empty($data[$key][0]['qc_hb_liver_imagery_3_pre_surg_first_step_counter_undisp_img'])? '' : ' || ' ).
                                $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']) .
                                ' ' .
                                ($newImagery['EventMaster']['event_control_id'] == $mriControlId? __('medical imaging abdominal MRI'): __('medical imaging abdominal CT-scan'));
                        }  
                    } elseif ($data[$key][0]['qc_hb_liver_chemo_1_pre_surg_scd_step_start_date'] && $newImagery['EventMaster']['event_date'] <= $data[$key][0]['qc_hb_liver_chemo_1_pre_surg_scd_step_start_date']) {
                        $data[$key][0]['qc_hb_liver_imagery_1_pre_surg_scd_step_counter']++;
                        if (empty($data[$key][0]['qc_hb_liver_imagery_1_2_pre_surg_scd_step_event_date'])) {
                            $data[$key][0]['qc_hb_liver_imagery_1_2_pre_surg_scd_step_event_date'] = $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']);
                            $data[$key][0]['qc_hb_liver_imagery_1_2_pre_surg_scd_step_event_type'] = $newImagery['EventMaster']['event_control_id'] == $mriControlId? 'medical imaging abdominal MRI': 'medical imaging abdominal CT-scan';
                            $data[$key][0]['qc_hb_liver_imagery_1_2_pre_surg_scd_step_r_r_nbr'] = $newImagery['EventDetail']['request_nbr'];
                        } elseif (empty($data[$key][0]['qc_hb_liver_imagery_1_1_pre_surg_scd_step_event_date'])) {
                            $data[$key][0]['qc_hb_liver_imagery_1_1_pre_surg_scd_step_event_date'] = $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']);
                            $data[$key][0]['qc_hb_liver_imagery_1_1_pre_surg_scd_step_event_type'] = $newImagery['EventMaster']['event_control_id'] == $mriControlId? 'medical imaging abdominal MRI': 'medical imaging abdominal CT-scan';
                            $data[$key][0]['qc_hb_liver_imagery_1_1_pre_surg_scd_step_r_r_nbr'] = $newImagery['EventDetail']['request_nbr'];
                        } else {
                            $data[$key][0]['qc_hb_liver_imagery_1_pre_surg_scd_step_counter_undisp_img'] .=
                                (empty($data[$key][0]['qc_hb_liver_imagery_1_pre_surg_scd_step_counter_undisp_img'])? '' : ' || ' ).
                                $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']) .
                                ' ' .
                                ($newImagery['EventMaster']['event_control_id'] == $mriControlId? __('medical imaging abdominal MRI'): __('medical imaging abdominal CT-scan'));
                        }  
                    } elseif ($data[$key][0]['qc_hb_liver_chemo_2_pre_surg_scd_step_start_date'] && $newImagery['EventMaster']['event_date'] <= $data[$key][0]['qc_hb_liver_chemo_2_pre_surg_scd_step_start_date']) {
                        $data[$key][0]['qc_hb_liver_imagery_2_pre_surg_scd_step_counter']++;
                        if (empty($data[$key][0]['qc_hb_liver_imagery_2_2_pre_surg_scd_step_event_date'])) {
                            $data[$key][0]['qc_hb_liver_imagery_2_2_pre_surg_scd_step_event_date'] = $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']);
                            $data[$key][0]['qc_hb_liver_imagery_2_2_pre_surg_scd_step_event_type'] = $newImagery['EventMaster']['event_control_id'] == $mriControlId? 'medical imaging abdominal MRI': 'medical imaging abdominal CT-scan';
                            $data[$key][0]['qc_hb_liver_imagery_2_2_pre_surg_scd_step_r_r_nbr'] = $newImagery['EventDetail']['request_nbr'];
                        } elseif (empty($data[$key][0]['qc_hb_liver_imagery_2_1_pre_surg_scd_step_event_date'])) {
                            $data[$key][0]['qc_hb_liver_imagery_2_1_pre_surg_scd_step_event_date'] = $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']);
                            $data[$key][0]['qc_hb_liver_imagery_2_1_pre_surg_scd_step_event_type'] = $newImagery['EventMaster']['event_control_id'] == $mriControlId? 'medical imaging abdominal MRI': 'medical imaging abdominal CT-scan';
                            $data[$key][0]['qc_hb_liver_imagery_2_1_pre_surg_scd_step_r_r_nbr'] = $newImagery['EventDetail']['request_nbr'];
                        } else {
                            $data[$key][0]['qc_hb_liver_imagery_2_pre_surg_scd_step_counter_undisp_img'] .=
                                (empty($data[$key][0]['qc_hb_liver_imagery_2_pre_surg_scd_step_counter_undisp_img'])? '' : ' || ' ).
                                $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']) .
                                ' ' .
                                ($newImagery['EventMaster']['event_control_id'] == $mriControlId? __('medical imaging abdominal MRI'): __('medical imaging abdominal CT-scan'));
                        }  
                    } elseif ($data[$key][0]['qc_hb_liver_surg_scd_step_start_date'] && $newImagery['EventMaster']['event_date'] <= $data[$key][0]['qc_hb_liver_surg_scd_step_start_date']) {
                        $data[$key][0]['qc_hb_liver_imagery_3_pre_surg_scd_step_counter']++;
                        if (empty($data[$key][0]['qc_hb_liver_imagery_3_2_pre_surg_scd_step_event_date'])) {
                            $data[$key][0]['qc_hb_liver_imagery_3_2_pre_surg_scd_step_event_date'] = $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']);
                            $data[$key][0]['qc_hb_liver_imagery_3_2_pre_surg_scd_step_event_type'] = $newImagery['EventMaster']['event_control_id'] == $mriControlId? 'medical imaging abdominal MRI': 'medical imaging abdominal CT-scan';
                            $data[$key][0]['qc_hb_liver_imagery_3_2_pre_surg_scd_step_r_r_nbr'] = $newImagery['EventDetail']['request_nbr'];
                        } elseif (empty($data[$key][0]['qc_hb_liver_imagery_3_1_pre_surg_scd_step_event_date'])) {
                            $data[$key][0]['qc_hb_liver_imagery_3_1_pre_surg_scd_step_event_date'] = $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']);
                            $data[$key][0]['qc_hb_liver_imagery_3_1_pre_surg_scd_step_event_type'] = $newImagery['EventMaster']['event_control_id'] == $mriControlId? 'medical imaging abdominal MRI': 'medical imaging abdominal CT-scan';
                            $data[$key][0]['qc_hb_liver_imagery_3_1_pre_surg_scd_step_r_r_nbr'] = $newImagery['EventDetail']['request_nbr'];
                        } else {
                            $data[$key][0]['qc_hb_liver_imagery_3_pre_surg_scd_step_counter_undisp_img'] .=
                                (empty($data[$key][0]['qc_hb_liver_imagery_3_pre_surg_scd_step_counter_undisp_img'])? '' : ' || ' ).
                                $this->formatDateForDisplay($newImagery['EventMaster']['event_date'], $newImagery['EventMaster']['event_date_accuracy']) .
                                ' ' .
                                ($newImagery['EventMaster']['event_control_id'] == $mriControlId? __('medical imaging abdominal MRI'): __('medical imaging abdominal CT-scan'));
                        }  
                    }
                }
            }
        }
        $participantsWithRrnCounter = sizeof($participantsWithRrnCounter);
        $displayedImageryWithRrnCounter = "$displayedImageryWithRrnCounter (on $displayedImageryCounter)";
        $participantsWithRrnCounter = "$participantsWithRrnCounter (on $participantCounter)";
        AppController::addWarningMsg(__('rr# statistics : %s images displayed are linked to a rr# and %s participants displayed have at least one rr#', array($displayedImageryWithRrnCounter, $participantsWithRrnCounter)));
        
        // Re-orders chemo and images when previous record is empty
        foreach ($data as &$tmpNewParticipant) {
            // Define data to move
            $moveRules = array();
            foreach (array( 'first', 'scd') as $step) {
                $moveRules[$step] = array();
                if (empty($tmpNewParticipant[0]['qc_hb_liver_chemo_1_pre_surg_' . $step . '_step_start_date']) && ! empty($tmpNewParticipant[0]['qc_hb_liver_chemo_2_pre_surg_' . $step . '_step_start_date'])) {
                    $moveRules[$step]['chemo_2_to_1'] = '-';
                } elseif (empty($tmpNewParticipant[0]['qc_hb_liver_chemo_1_pre_surg_' . $step . '_step_start_date']) 
                && empty($tmpNewParticipant[0]['qc_hb_liver_chemo_2_pre_surg_' . $step . '_step_start_date']) 
                && $tmpNewParticipant[0]['qc_hb_liver_imagery_3_pre_surg_' . $step . '_step_counter']) {
                    $moveRules[$step]['no_chemo'] = '-';
                }
                for ($tmpId = 1; $tmpId < 4; $tmpId ++) {
                    if (empty($tmpNewParticipant[0]['qc_hb_liver_imagery_' . $tmpId . '_1_pre_surg_' . $step . '_step_event_date']) && ! empty($tmpNewParticipant[0]['qc_hb_liver_imagery_' . $tmpId . '_2_pre_surg_' . $step . '_step_event_date'])) {
                        $moveRules[$step]['imagery'][$tmpId] = '-';
                    }
                }
            }
            // Move data
            foreach (array('first', 'scd') as $step) {
                if (isset($moveRules[$step]['imagery'])) {
                    foreach ($tmpNewParticipant[0] as $field => $value) {
                        foreach($moveRules[$step]['imagery'] as $tmpId => $unusedData) {
                            // Move imagery in second position to first position
                            if (preg_match('/^qc_hb_liver_imagery_' . $tmpId . '_2_pre_surg_' . $step . '_step(.*)$/', $field, $matches)) {
                                $tmpNewParticipant[0]['qc_hb_liver_imagery_' . $tmpId . '_1_pre_surg_' . $step . '_step' . $matches[1]] = $value;
                                $tmpNewParticipant[0]['qc_hb_liver_imagery_' . $tmpId . '_2_pre_surg_' . $step . '_step' . $matches[1]] = '';
                            }
                        }
                    }
                }
                if (isset($moveRules[$step]['chemo_2_to_1']) || isset($moveRules[$step]['no_chemo'])) {
                    foreach ($tmpNewParticipant[0] as $field => $value) {
                        if (isset($moveRules[$step]['chemo_2_to_1'])) {
                            // Move chemo in second position to first position
                            if (preg_match('/^qc_hb_liver_chemo_2_pre_surg_' . $step . '_step(.*)$/', $field, $matches)) {
                                $tmpNewParticipant[0]['qc_hb_liver_chemo_1_pre_surg_' . $step . '_step' . $matches[1]] = $value;
                                $tmpNewParticipant[0]['qc_hb_liver_chemo_2_pre_surg_' . $step . '_step' . $matches[1]] = '';
                            }
                            if (preg_match('/^qc_hb_liver_imagery_2(.*)_pre_surg_' . $step . '_step(.*)$/', $field, $matches)) {
                                $tmpNewParticipant[0]['qc_hb_liver_imagery_1' . $matches[1] . '_pre_surg_' . $step . '_step' . $matches[2]] = $value;
                                $tmpNewParticipant[0]['qc_hb_liver_imagery_2' . $matches[1] . '_pre_surg_' . $step . '_step' . $matches[2]] = '';
                            }
                            if (preg_match('/^qc_hb_liver_imagery_3(.*)_pre_surg_' . $step . '_step(.*)$/', $field, $matches)) {
                                $tmpNewParticipant[0]['qc_hb_liver_imagery_2' . $matches[1] . '_pre_surg_' . $step . '_step' . $matches[2]] = $value;
                                $tmpNewParticipant[0]['qc_hb_liver_imagery_3' . $matches[1] . '_pre_surg_' . $step . '_step' . $matches[2]] = '';
                            }
                        } else {
                            // Move 3rd imagery to first imagery position
                            if (preg_match('/^qc_hb_liver_imagery_3(.*)_pre_surg_' . $step . '_step(.*)$/', $field, $matches)) {
                                $tmpNewParticipant[0]['qc_hb_liver_imagery_1' . $matches[1] . '_pre_surg_' . $step . '_step' . $matches[2]] = $value;
                                $tmpNewParticipant[0]['qc_hb_liver_imagery_3' . $matches[1] . '_pre_surg_' . $step . '_step' . $matches[2]] = '';
                            }
                        }
                    }
                }
            }
            // Remove
            for ($tmpId = 1; $tmpId < 4; $tmpId ++) {
                if ($tmpNewParticipant[0]['qc_hb_liver_imagery_' . $tmpId . '_pre_surg_' . $step . '_step_counter'] == '0') {
                    $tmpNewParticipant[0]['qc_hb_liver_imagery_' . $tmpId . '_pre_surg_' . $step . '_step_counter'] = '';
                }
            }
            
            // Add fields for next section of the report
            
            $tmpNewParticipant[0]['qc_hb_liver_surg_first_recurrence_date'] = '';
            $tmpNewParticipant[0]['qc_hb_liver_surg_first_recurrence_status'] = '';
            $tmpNewParticipant[0]['localization'] = '';
            $tmpNewParticipant[0]['qc_hb_liver_last_followup_date'] = '';
            $tmpNewParticipant[0]['status'] = '';
            $tmpNewParticipant[0]['qc_hb_recurrence_treatment'] = '';

            $tmpNewParticipant[0]['qc_hb_liver_metastasis_report_date'] = '';
            $tmpNewParticipant[0]['rubbia_brandt'] = ''; 
            $tmpNewParticipant[0]['blazer'] = ''; 
            $tmpNewParticipant[0]['lesions_nbr'] = ''; 
            $tmpNewParticipant[0]['tumor_size_greatest_dimension'] = ''; 
            $tmpNewParticipant[0]['additional_dimension_a'] = ''; 
            $tmpNewParticipant[0]['additional_dimension_b'] = ''; 
            $tmpNewParticipant[0]['surgical_resection_margin'] = ''; 
            $tmpNewParticipant[0]['distance_of_tumor_from_closest_surgical_resection_margin'] = ''; 
            $tmpNewParticipant[0]['distance_unit'] = ''; 
            $tmpNewParticipant[0]['specify_margin'] = ''; 
            $tmpNewParticipant[0]['k_ras'] = ''; 
            $tmpNewParticipant[0]['k_ras_codon'] = ''; 
            $tmpNewParticipant[0]['k_ras_mutation'] = ''; 
            $tmpNewParticipant[0]['n_ras'] = ''; 
            $tmpNewParticipant[0]['n_ras_codon'] = ''; 
            $tmpNewParticipant[0]['n_ras_mutation'] = '';
        }
        
        //-----------------------------------------------------------------------------------
        // Follow-up
        //-----------------------------------------------------------------------------------
                
        $sql = "SELECT EventMaster.participant_id,
            EventMaster.id AS treatment_master_id,
            EventMaster.event_date,
            EventMaster.event_date_accuracy,
            EventMaster.event_control_id,
            EventDetail.recurrence_status,
            EventDetail.disease_status,
            EventDetail.recurrence_status,
            EventDetail.qc_hb_recurrence_localization,
            EventDetail.qc_hb_recurrence_treatment
            FROM event_masters EventMaster INNER JOIN ed_all_clinical_followups EventDetail ON id = event_master_id
            WHERE EventMaster.deleted <> 1
            AND EventMaster.participant_id IN('".implode("','", array_keys($participantIdsToDataKeys))."')
            ORDER BY EventMaster.participant_id ASC, EventMaster.event_date DESC";        
        $queryResults = $this->Report->tryCatchQuery($sql);
        foreach ($queryResults as $newFollowUp) {
            $participant_id = $newFollowUp['EventMaster']['participant_id'];
            if (!isset($participantIdsToDataKeys[$participant_id])) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            foreach ($participantIdsToDataKeys[$participant_id] as $key) {
                if (!isset($data[$key]) || $participant_id != $data[$key]['Participant']['id']) {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                // 1st recurrence
                if (preg_match('/systemic/', $newFollowUp['EventDetail']['recurrence_status'])) {
                    if ($data[$key][0]['qc_hb_liver_surg_first_step_start_date'] && $newFollowUp['EventMaster']['event_date'] >= $data[$key][0]['qc_hb_liver_surg_first_step_start_date']) {
                        if( !$data[$key][0]['qc_hb_liver_surg_first_recurrence_date']) {
                            $data[$key][0]['qc_hb_liver_surg_first_recurrence_date'] = $this->formatDateForDisplay($newFollowUp['EventMaster']['event_date'], $newFollowUp['EventMaster']['event_date_accuracy']);
                            $data[$key][0]['qc_hb_liver_surg_first_recurrence_status'] = $newFollowUp['EventDetail']['recurrence_status'];
                            $data[$key][0]['localization'] = $newFollowUp['EventDetail']['qc_hb_recurrence_localization'];
                        }
                    }
                    
                }
                // Last followup
                if (!$data[$key][0]['qc_hb_liver_last_followup_date']) {
                    $data[$key][0]['qc_hb_liver_last_followup_date'] = $this->formatDateForDisplay($newFollowUp['EventMaster']['event_date'], $newFollowUp['EventMaster']['event_date_accuracy']);
                    $data[$key][0]['status'] = $newFollowUp['EventDetail']['disease_status'];
                    $data[$key][0]['qc_hb_recurrence_treatment'] = $newFollowUp['EventDetail']['qc_hb_recurrence_treatment'];
                }
            }
        }
        
        //-----------------------------------------------------------------------------------
        // Liver Metastasis Report
        //-----------------------------------------------------------------------------------
        
        $sql = "SELECT EventMaster.participant_id,
            EventMaster.id AS treatment_master_id,
            EventMaster.event_date,
            EventMaster.event_date_accuracy,
            EventMaster.event_control_id,
            EventDetail.*
            FROM event_masters EventMaster INNER JOIN qc_hb_ed_lab_report_liver_metastases EventDetail ON id = event_master_id
            WHERE EventMaster.deleted <> 1
            AND EventMaster.participant_id IN('".implode("','", array_keys($participantIdsToDataKeys))."')
            ORDER BY EventMaster.participant_id ASC, EventMaster.event_date DESC";
        $queryResults = $this->Report->tryCatchQuery($sql);
        foreach ($queryResults as $newReport) {
            $participant_id = $newReport['EventMaster']['participant_id'];
            if (!isset($participantIdsToDataKeys[$participant_id])) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            foreach ($participantIdsToDataKeys[$participant_id] as $key) {
                if (!isset($data[$key]) || $participant_id != $data[$key]['Participant']['id']) {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                // 1st recurrence
                if ($data[$key][0]['qc_hb_liver_surg_first_step_start_date'] && $newReport['EventMaster']['event_date'] >= $data[$key][0]['qc_hb_liver_surg_first_step_start_date']) {
                    if( !$data[$key][0]['qc_hb_liver_metastasis_report_date']) {
                        $data[$key][0]['qc_hb_liver_metastasis_report_date'] = $this->formatDateForDisplay($newReport['EventMaster']['event_date'], $newReport['EventMaster']['event_date_accuracy']);
                        $data[$key]['EventDetail'] = $newReport['EventDetail'];
                    }
                }
            }
        }
        
        return array(
            'header' => $header,
            'data' => $data,
            'columns_names' => null,
            'error_msg' => null
        );
    }
    
    private function getDateDiffInYears($startDate, $endDate) {
        $months = '';
        if (!empty($startDate) && !empty($endDate)) {
            $startDateOb = new DateTime($startDate);
            $endDateOb = new DateTime($endDate);
            $interval = $startDateOb->diff($endDateOb);
            if ($interval->invert) {
                $months = 'ERR';
            } else {
                $months = $interval->y;
            }
        }
        return $months;
    }
    
    private function formatDateForDisplay($date, $accuracy) {
        $lengh = strlen($date);
        switch($accuracy) {
            case 'd':
                $lengh = strrpos($date, '-');
                break;
            case 'm':
            case 'y':
                $lengh = strpos($date, '-');
                break;
        }
        return substr($date, 0, $lengh);
    }
}