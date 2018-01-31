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
}