<?php

class ReportsControllerCustom extends ReportsController
{

    public function participantIdentifiersSummary($parameters)
    {
        if (!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null , true));
        }
        if (!AppController::checkLinkPermission('/ClinicalAnnotation/MiscIdentifiers/listall')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null , true));
        }
        
        $header = null;
        $conditions = array();
        
        if (isset($parameters['Participant']['id'])) {
            // From databrowser
            $participantIds = array_filter($parameters['Participant']['id']);
            if ($participantIds)
                $conditions['MiscIdentifier.participant_id'] = $participantIds;
        } else {
            if (isset($parameters['MiscIdentifier']['misc_identifier_control_id'])) {
                $miscIdentifierControlIds = array_filter($parameters['MiscIdentifier']['misc_identifier_control_id']);
                if ($miscIdentifierControlIds)
                    $conditions['MiscIdentifier.misc_identifier_control_id'] = $miscIdentifierControlIds;
            }
            if (isset($parameters['MiscIdentifier']['identifier_value_start'])) {
                $identifierValueStart = (! empty($parameters['MiscIdentifier']['identifier_value_start'])) ? $parameters['MiscIdentifier']['identifier_value_start'] : null;
                $identifierValueEnd = (! empty($parameters['MiscIdentifier']['identifier_value_end'])) ? $parameters['MiscIdentifier']['identifier_value_end'] : null;
                if ($identifierValueStart)
                    $conditions['MiscIdentifier.identifier_value >='] = $identifierValueStart;
                if ($identifierValueEnd)
                    $conditions['MiscIdentifier.identifier_value <='] = $identifierValueEnd;
            } elseif (isset($parameters['MiscIdentifier']['identifier_value'])) {
                $identifierValues = array_filter($parameters['MiscIdentifier']['identifier_value']);
                if ($identifierValues)
                    $conditions['MiscIdentifier.identifier_value'] = $identifierValues;
            } else {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        }
        
        $miscIdentifierModel = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
        $participantIdsTmp = $miscIdentifierModel->find('all', array(
            'conditions' => $conditions,
            'order' => array(
                'MiscIdentifier.participant_id ASC'
            ),
            'fields' => array(
                'DISTINCT MiscIdentifier.participant_id'
            ),
            'recursive' => -1
        ));
        $participantIds = array();
        foreach ($participantIdsTmp as $newRecord)
            $participantIds[$newRecord['MiscIdentifier']['participant_id']] = $newRecord['MiscIdentifier']['participant_id'];
        
        if (sizeof($participantIds) > Configure::read('databrowser_and_report_results_display_limit')) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => 'the report contains too many results - please redefine search criteria'
            );
        }
        
        $miscIdentifiers = $miscIdentifierModel->find('all', array(
            'conditions' => array(
                'MiscIdentifier.participant_id' => $participantIds
            ),
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
                        'last_name' => $newIdent['Participant']['last_name'],
                        'qc_nd_sardo_rec_number' => $newIdent['Participant']['qc_nd_sardo_rec_number'],
                        'date_of_birth' => $newIdent['Participant']['date_of_birth'],
                        'date_of_birth_accuracy' => $newIdent['Participant']['date_of_birth_accuracy']
                    ),
                    '0' => array(
                        'ovary_gyneco_bank_no_lab' => null,
                        'breast_bank_no_lab' => null,
                        'prostate_bank_no_lab' => null,
                        'kidney_bank_no_lab' => null,
                        'head_and_neck_bank_no_lab' => null,
                        'autopsy_bank_no_lab' => null,
                        'melanoma_and_skin_bank_no_lab' => null,
                        'colorectal_bank_no_lab' => null,
                        'pulmonary_bank_no_lab' => null,
                        'provaq_bank_no_lab' => null,
                        'adrenal_bank_no_lab' => null,
                        'ramq_nbr' => null,
                        'hotel_dieu_id_nbr' => null,
                        'notre_dame_id_nbr' => null,
                        'saint_luc_id_nbr' => null,
                        'other_center_id_nbr' => null,
                        'old_bank_no_lab' => null,
                        'old_breast_bank_no_lab' => null,
                        'old_ovary_bank_no_lab' => null,
                        'code_barre' => null,
                        'qc_nd_study_misc_identifier_value' => ''
                    )
                );
            }
            $generatedKey = str_replace(array(
                ' ',
                '-',
                '/'
            ), array(
                '_',
                '_',
                '_'
            ), $newIdent['MiscIdentifierControl']['misc_identifier_name']);
            if (array_key_exists($generatedKey, $data[$participantId]['0'])) {
                $data[$participantId]['0'][$generatedKey] = $newIdent['MiscIdentifier']['identifier_value'];
            } elseif ($newIdent['MiscIdentifier']['study_summary_id']) {
                $data[$participantId]['0']['qc_nd_study_misc_identifier_value'] .= $newIdent['StudySummary']['title'] . ' [' . $newIdent['MiscIdentifier']['identifier_value'] . "] ";
            }
        }
        
        return array(
            'header' => $header,
            'data' => $data,
            'columns_names' => null,
            'error_msg' => null
        );
    }

    public function participantIdentifiersRamqError($parameters)
    {

        if (!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null , true));        }
        if (!AppController::checkLinkPermission('/ClinicalAnnotation/MiscIdentifiers/listall')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null , true));
        }

        $header = null;
        $conditions = array();
     
        if (isset($parameters['Group']['bank_id'])) {
            // From databrowser
            $bankIds = array_filter($parameters['Group']['bank_id']);
            if ($bankIds){
                $conditions['Group.bank_id'] = $bankIds;
            }
        }
        
        $condition=(empty($bankIds)?array():array('Bank.id='.$bankIds[0]));
        
        $miscIdentifierModel = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
        $participantModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        if (!empty($condition)){
            $joins = array(
                array(
                    'table' => 'misc_identifiers',
                    'alias' => 'MiscIdentifier',
                    'type' => 'INNER',
                    'conditions' => array(
                        'Participant.id = MiscIdentifier.participant_id'
                    )
                ),
                array(
                    'table' => 'banks',
                    'alias' => 'Bank',
                    'type' => 'INNER',
                    'conditions' => array(
                        'Bank.misc_identifier_control_id = MiscIdentifier.misc_identifier_control_id'
                    )
                )
            );

            $participantIds=$participantModel->find('list', array('conditions'=>$condition, 'joins' => $joins));
            $participantIds=array_keys($participantIds);

            $joins = array(
                array(
                    'table' => 'misc_identifiers',
                    'alias' => 'MiscIdentifier',
                    'type' => 'INNER',
                    'conditions' => array(
                        'Participant.id = MiscIdentifier.participant_id'
                    )
                )
            );
            //'MiscIdentifier.misc_identifier_control_id'=>7 for RAMQ
            $condition=array('Participant.id'=>$participantIds, 'MiscIdentifier.misc_identifier_control_id'=>7); 
            $fields=array('Participant.id','Participant.first_name','Participant.last_name','Participant.date_of_birth','Participant.date_of_birth_accuracy','Participant.sex','MiscIdentifier.identifier_value');

            $participantList=$miscIdentifierModel->find('all', array('conditions'=>$condition, 'fields'=>$fields));
        }else{
            //'MiscIdentifier.misc_identifier_control_id'=>7 for RAMQ
            $condition=array('MiscIdentifier.misc_identifier_control_id'=>7); 
            $fields=array('Participant.id','Participant.first_name','Participant.last_name','Participant.date_of_birth','Participant.date_of_birth_accuracy','Participant.sex','MiscIdentifier.identifier_value');
            $participantList=$miscIdentifierModel->find('all', array('conditions'=>$condition, 'fields'=>$fields));
        }
        
        
        $data=array();
        foreach ($participantList as $item) {
            $notes=array();
            $id=$item['Participant']['id'];
            $firstName=normalizeChars($item['Participant']['first_name']);
            $lastName=normalizeChars($item['Participant']['last_name'], false);
            $dateOfBirth=normalizeChars($item['Participant']['date_of_birth']);
            $dateOfBirthAccuracy=normalizeChars($item['Participant']['date_of_birth_accuracy']);
            $sex=normalizeChars($item['Participant']['sex']);
            $ramq=normalizeChars($item['MiscIdentifier']['identifier_value']);
            
            if (strlen($lastName)<3){
                if (strlen($lastName)==2){
                    $lastNameRamq=$lastName.'X';
                }else{
                    $notes[]=__("Last name missed");
                }
            }else{
                $lastNameWithoutSpace =  strtr($lastName, array(' '=>''));
                $lastNameSpaceToX =  strtr($lastName, array(' '=>'X'));
                $lastNameRamq=substr($lastNameWithoutSpace, 0, 3);
                if ($lastNameRamq!==substr($ramq, 0, 3)){
                    $lastNameRamq=substr($lastNameSpaceToX, 0, 3);
                }
            }
            
            if (strlen($firstName)==0){
                $notes[]=__("First name missed");
            }else{
                $firstNameRamq=substr($firstName, 0, 1);
            }

            if ($sex!='F' && $sex!='M'){
                $notes[]=__("Undefined Sex");
                $sexNameRamq=-1;
            }else{
                $sexNameRamq=($sex=='F')?50:0;
            }
           
            if (strlen($dateOfBirth)!=8){
                $notes[]=__("Unknown date of birth");
            }elseif ($dateOfBirthAccuracy!=='C'){
                $notes[]=__("Approximate date of birth");
            }else{
                $yearRamq=substr($dateOfBirth, 2, 2);
                if ($sexNameRamq>=0){
                    $monthRamq=sprintf("%02d", ((int)substr($dateOfBirth, 4, 2)+$sexNameRamq));
                }
                $dayRamq=substr($dateOfBirth, 6, 2);
            }
            
            $ramqNumber="";
            if (empty($notes))
            {
                $ramqNumber=$lastNameRamq.$firstNameRamq.$yearRamq.$monthRamq.$dayRamq;

                if (substr($ramq, 0, 10)!=$ramqNumber){
                    $notes[]=__("Problem in ramq");
                }
            }
            $notes=implode("\n", $notes);

            if (!empty($notes)){
                $var=array();
                $var['Participant']['id']=$id;
                $var['Participant']['first_name']=$item['Participant']['first_name'];
                $var['Participant']['last_name']=$item['Participant']['last_name'];
                $var['Participant']['sex']=$item['Participant']['sex'];
                $var['Participant']['date_of_birth']=$item['Participant']['date_of_birth'];
                $var['Participant']['date_of_birth_accuracy']=$item['Participant']['date_of_birth_accuracy'];
                $var['0']['qc_nd_ramq']=$item['MiscIdentifier']['identifier_value'];
                $var['0']['qc_nd_ramq_generated']=$ramqNumber;
                $var['0']['qc_nd_notes']=$notes;
                $data[$id]=$var;
            }
        }
        
        return array(
            'header' => $header,
            'data' => $data,
            'columns_names' => null,
            'error_msg' => null
        );
    }
        
    public function ctrnetCatalogueSubmissionFile($parameters)
    {
        if (! AppController::checkLinkPermission('/InventoryManagement/Collections/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null , true));
        }
        
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
        $includeTissueStorageDetails = $parameters[0]['include_tissue_storage_details'][0] ? true : false;
        
        $data = array();
        
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
			WHERE col.deleted != '1'
			AND ($bankConditions)
			AND ($aliquotTypeConfitions)
			AND am.in_stock IN ('yes - available ','yes - not available')
			) AS res;";
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        $tmpData['cases_nbr'] = $queryResults[0][0]['nbr'];
        
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        $tmpData['aliquots_nbr'] = $queryResults[0][0]['nbr'];
        
        $data[] = $tmpData;
        
        // **FFPE**
        
        $tmpData = array();
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
				WHERE col.deleted != '1' AND ($bankConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ('tissue')
				AND ac.aliquot_type = 'block'
				AND blk.block_type = 'paraffin'
			) AS res GROUP BY tissue_nature;";
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
        foreach ($queryResults as $newRes) {
            $tissueNature = $newRes['res']['tissue_nature'];
            $tmpData[$tissueNature] = array(
                'sample_type' => __('FFPE') . ' ' . __($tissueNature),
                'cases_nbr' => $newRes[0]['nbr'],
                'aliquots_nbr' => '',
                'notes' => ''
            );
        }
        $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
        foreach ($queryResults as $newRes) {
            $tissueNature = $newRes['res']['tissue_nature'];
            $tmpData[$tissueNature]['aliquots_nbr'] = $newRes[0]['nbr'];
            $data[] = $tmpData[$tissueNature];
        }
        
        // **frozen tissue**
        
        if (! $includeTissueStorageDetails) {
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
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ('tissue')
				AND ($aliquotTypeConfitions)
				AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin');";
            $queryResults = $this->Report->tryCatchQuery($sql);
            $notes = '';
            foreach ($queryResults as $newType)
                $notes .= (empty($notes) ? '' : ' & ') . __($newType['sc']['sample_type']) . ' ' . __($newType['ac']['aliquot_type']) . (empty($newType['blk']['block_type']) ? '' : ' (' . __($newType['blk']['block_type']) . ')');
            
            $tmpData = array();
            $sql = "
				SELECT count(*) AS nbr, tissue_nature  FROM (
					SELECT DISTINCT  %%id%%, tiss.tissue_nature
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
					INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
					INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
					INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
					INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
					WHERE col.deleted != '1' AND ($bankConditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND sc.sample_type IN ('tissue')
					AND ($aliquotTypeConfitions)
					AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin')
				) AS res GROUP BY tissue_nature;";
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
            foreach ($queryResults as $newRes) {
                $tissueNature = $newRes['res']['tissue_nature'];
                $tmpData[$tissueNature] = array(
                    'sample_type' => __('frozen tissue') . ' ' . __($tissueNature),
                    'cases_nbr' => $newRes[0]['nbr'],
                    'aliquots_nbr' => '',
                    'notes' => $notes
                );
            }
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
            foreach ($queryResults as $newRes) {
                $tissueNature = $newRes['res']['tissue_nature'];
                $tmpData[$tissueNature]['aliquots_nbr'] = $newRes[0]['nbr'];
                $data[] = $tmpData[$tissueNature];
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
				WHERE col.deleted != '1' AND ($bankConditions)
				AND am.in_stock IN ('yes - available ','yes - not available')
				AND sc.sample_type IN ('tissue')
				AND ac.aliquot_type NOT IN ('tube')
				AND ($aliquotTypeConfitions)
				AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin');";
            $queryResults = $this->Report->tryCatchQuery($sql);
            $notes = '';
            foreach ($queryResults as $newType)
                $notes .= (empty($notes) ? '' : ' & ') . __($newType['sc']['sample_type']) . ' ' . __($newType['ac']['aliquot_type']) . (empty($newType['0']['block_type']) ? '' : ' (' . __($newType['0']['block_type']) . ')');
            
            $tmpData = array();
            $sql = "
				SELECT count(*) AS nbr, tissue_nature  FROM (
					SELECT DISTINCT  %%id%%, tiss.tissue_nature
					FROM collections AS col
					INNER JOIN sample_masters AS sm ON col.id = sm.collection_id AND sm.deleted != '1'
					INNER JOIN sample_controls AS sc ON sc.id = sm.sample_control_id
					INNER JOIN sd_spe_tissues AS tiss ON tiss.sample_master_id = sm.id
					INNER JOIN aliquot_masters AS am ON am.sample_master_id = sm.id AND am.deleted != '1'
					INNER JOIN aliquot_controls AS ac ON ac.id = am.aliquot_control_id
					WHERE col.deleted != '1' AND ($bankConditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND sc.sample_type IN ('tissue')
					AND ac.aliquot_type NOT IN ('tube')
					AND ($aliquotTypeConfitions)
					AND am.id NOT IN (SELECT aliquot_master_id FROM ad_blocks WHERE block_type = 'paraffin')
				) AS res GROUP BY tissue_nature;";
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
            foreach ($queryResults as $newRes) {
                $tissueNature = $newRes['res']['tissue_nature'];
                $tmpData[$tissueNature] = array(
                    'sample_type' => __('frozen tissue') . ' ' . __($tissueNature),
                    'cases_nbr' => $newRes[0]['nbr'],
                    'aliquots_nbr' => '',
                    'notes' => $notes
                );
            }
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
            foreach ($queryResults as $newRes) {
                $tissueNature = $newRes['res']['tissue_nature'];
                $tmpData[$tissueNature]['aliquots_nbr'] = $newRes[0]['nbr'];
                $data[] = $tmpData[$tissueNature];
            }
            
            // tube
            
            $tmpData = array();
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
					WHERE col.deleted != '1' AND ($bankConditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND sc.sample_type IN ('tissue')
					AND ac.aliquot_type IN ('tube')
				) AS res GROUP BY tissue_nature, tmp_storage_solution;";
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
            foreach ($queryResults as $newRes) {
                $tissueNature = $newRes['res']['tissue_nature'];
                $tmpStorageSolution = $newRes['res']['tmp_storage_solution'];
                $tmpData[$tissueNature . $tmpStorageSolution] = array(
                    'sample_type' => __('frozen tissue tube') . ' ' . __($tissueNature) . (empty($tmpStorageSolution) ? '' : ' (' . __($tmpStorageSolution) . ')'),
                    'cases_nbr' => $newRes[0]['nbr'],
                    'aliquots_nbr' => '',
                    'notes' => ''
                );
            }
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
            foreach ($queryResults as $newRes) {
                $tissueNature = $newRes['res']['tissue_nature'];
                $tmpStorageSolution = $newRes['res']['tmp_storage_solution'];
                $tmpData[$tissueNature . $tmpStorageSolution]['aliquots_nbr'] = $newRes[0]['nbr'];
                $data[] = $tmpData[$tissueNature . $tmpStorageSolution];
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
        
        // **tissue rna**
        // **tissue dna**
        // **tissue cell culture**
        
        if ($parameters[0]['display_tissue_derivative_count_split_per_nature'][0]) {
            
            $sampleTypes = "'rna', 'dna', 'cell culture'";
            
            $tmpData = array();
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
					WHERE col.deleted != '1' AND ($bankConditions)
					AND am.in_stock IN ('yes - available ','yes - not available')
					AND sc.sample_type IN ($sampleTypes)
				) AS res GROUP BY sample_type, aliquot_type, tissue_nature;";
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'col.participant_id', $sql));
            foreach ($queryResults as $newRes) {
                $sampleType = $newRes['res']['sample_type'];
                $aliquotType = $newRes['res']['aliquot_type'];
                $tissuNature = $newRes['res']['tissue_nature'];
                $tmpData[$sampleType . $aliquotType . $tissuNature] = array(
                    'sample_type' => __('tissue ' . $sampleType) . ' ' . __($aliquotType) . ' (' . __('nature') . ': ' . __($tissuNature) . ')',
                    'cases_nbr' => $newRes[0]['nbr'],
                    'aliquots_nbr' => '',
                    'notes' => ''
                );
            }
            $queryResults = $this->Report->tryCatchQuery(str_replace('%%id%%', 'am.id', $sql));
            foreach ($queryResults as $newRes) {
                $sampleType = $newRes['res']['sample_type'];
                $aliquotType = $newRes['res']['aliquot_type'];
                $tissuNature = $newRes['res']['tissue_nature'];
                $tmpData[$sampleType . $aliquotType . $tissuNature]['aliquots_nbr'] = $newRes[0]['nbr'];
                $data[] = $tmpData[$sampleType . $aliquotType . $tissuNature];
            }
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

    public function getAllSpecimens($parameters)
    {
        if (! AppController::checkLinkPermission('/InventoryManagement/SampleMasters/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null , true));
        }
        $header = null;
        $conditions = array(
            "SampleMaster.id != SampleMaster.initial_specimen_sample_id"
        );
        // Get Parameters
        if (isset($parameters['SampleMaster']['sample_code']) || isset($parameters['SampleMaster']['qc_nd_sample_label'])) {
            // From databrowser
            $selectionLabels = array_filter($parameters['SampleMaster']['sample_code']);
            if ($selectionLabels)
                $conditions['SampleMaster.sample_code'] = $selectionLabels;
            $selectionLabels = array_filter($parameters['SampleMaster']['qc_nd_sample_label']);
            $selectionLabelsStatements = array();
            foreach ($selectionLabels as $newLabel)
                $selectionLabelsStatements[] = "SampleMaster.qc_nd_sample_label LIKE '%" . $newLabel . "%'";
            if ($selectionLabelsStatements)
                $conditions[] = '(' . implode(' OR ', $selectionLabelsStatements) . ')';
        } elseif (isset($parameters['ViewSample']['sample_master_id'])) {
            // From databrowser
            $sampleMasterIds = array_filter($parameters['ViewSample']['sample_master_id']);
            if ($sampleMasterIds)
                $conditions['SampleMaster.id'] = $sampleMasterIds;
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        // Load Model
        $viewSampleModel = AppModel::getInstance("InventoryManagement", "ViewSample", true);
        $sampleMasterModel = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
        // Build Res
        $sampleMasterModel->unbindModel(array(
            'belongsTo' => array(
                'Collection'
            ),
            'hasOne' => array(
                'SpecimenDetail',
                'DerivativeDetail'
            ),
            'hasMany' => array(
                'AliquotMaster'
            )
        ));
        $tmpResCount = $sampleMasterModel->find('count', array(
            'conditions' => $conditions,
            'fields' => array(
                'SampleMaster.*',
                'SampleControl.*'
            ),
            'order' => array(
                'SampleMaster.sample_code ASC'
            ),
            'recursive' => 0
        ));
        if ($tmpResCount > Configure::read('databrowser_and_report_results_display_limit')) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => 'the report contains too many results - please redefine search criteria'
            );
        }
        $studiedSamples = $sampleMasterModel->find('all', array(
            'conditions' => $conditions,
            'fields' => array(
                'SampleMaster.*',
                'SampleControl.*'
            ),
            'order' => array(
                'SampleMaster.sample_code ASC'
            ),
            'recursive' => 0
        ));
        $res = array();
        $tmpInitialSpecimens = array();
        foreach ($studiedSamples as $newStudiedSample) {
            $initialSpecimen = isset($tmpInitialSpecimens[$newStudiedSample['SampleMaster']['initial_specimen_sample_id']]) ? $tmpInitialSpecimens[$newStudiedSample['SampleMaster']['initial_specimen_sample_id']] : $viewSampleModel->find('first', array(
                'conditions' => array(
                    'ViewSample.sample_master_id' => $newStudiedSample['SampleMaster']['initial_specimen_sample_id']
                ),
                'fields' => array(
                    'ViewSample.*, SpecimenDetail.*'
                ),
                'order' => array(
                    'ViewSample.sample_code ASC'
                ),
                'recursive' => 0
            ));
            $tmpInitialSpecimens[$newStudiedSample['SampleMaster']['initial_specimen_sample_id']] = $initialSpecimen;
            if ($initialSpecimen) {
                if (! (array_key_exists('SelectedItemsForCsv', $parameters) && ! in_array($initialSpecimen['ViewSample']['sample_master_id'], $parameters['SelectedItemsForCsv']['ViewSample']['sample_master_id'])))
                    $res[] = array_merge($newStudiedSample, $initialSpecimen);
            }
        }
        return array(
            'header' => $header,
            'data' => $res,
            'columns_names' => null,
            'error_msg' => null
        );
    }

    public function getAllDerivatives($parameters)
    {
        if (! AppController::checkLinkPermission('/InventoryManagement/SampleMasters/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null , true));
        }
        $header = null;
        $conditions = array();
        // Get Parameters
        if (isset($parameters['SampleMaster']['sample_code']) || isset($parameters['SampleMaster']['qc_nd_sample_label'])) {
            // From databrowser
            $selectionLabels = array_filter($parameters['SampleMaster']['sample_code']);
            if ($selectionLabels)
                $conditions['SampleMaster.sample_code'] = $selectionLabels;
            $selectionLabels = array_filter($parameters['SampleMaster']['qc_nd_sample_label']);
            $selectionLabelsStatements = array();
            foreach ($selectionLabels as $newLabel)
                $selectionLabelsStatements[] = "SampleMaster.qc_nd_sample_label LIKE '%" . $newLabel . "%'";
            if ($selectionLabelsStatements)
                $conditions[] = '(' . implode(' OR ', $selectionLabelsStatements) . ')';
        } elseif (isset($parameters['ViewSample']['sample_master_id'])) {
            // From databrowser
            $sampleMasterIds = array_filter($parameters['ViewSample']['sample_master_id']);
            if ($sampleMasterIds)
                $conditions['SampleMaster.id'] = $sampleMasterIds;
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        // Load Model
        $viewSampleModel = AppModel::getInstance("InventoryManagement", "ViewSample", true);
        $sampleMasterModel = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
        // Build Res
        $sampleMasterModel->unbindModel(array(
            'belongsTo' => array(
                'Collection'
            ),
            'hasOne' => array(
                'SpecimenDetail',
                'DerivativeDetail'
            ),
            'hasMany' => array(
                'AliquotMaster'
            )
        ));
        $tmpResCount = $sampleMasterModel->find('count', array(
            'conditions' => $conditions,
            'fields' => array(
                'SampleMaster.*',
                'SampleControl.*'
            ),
            'order' => array(
                'SampleMaster.sample_code ASC'
            ),
            'recursive' => 0
        ));
        if ($tmpResCount > Configure::read('databrowser_and_report_results_display_limit')) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => 'the report contains too many results - please redefine search criteria'
            );
        }
        $studiedSamples = $sampleMasterModel->find('all', array(
            'conditions' => $conditions,
            'fields' => array(
                'SampleMaster.*',
                'SampleControl.*'
            ),
            'order' => array(
                'SampleMaster.sample_code ASC'
            ),
            'recursive' => 0
        ));
        $res = array();
        foreach ($studiedSamples as $newStudiedSample) {
            $allDerivativesSamples = $this->getChildrenSamples($viewSampleModel, array(
                $newStudiedSample['SampleMaster']['id']
            ));
            if ($allDerivativesSamples) {
                foreach ($allDerivativesSamples as $newDerivativeSample) {
                    if (array_key_exists('SelectedItemsForCsv', $parameters) && ! in_array($newDerivativeSample['ViewSample']['sample_master_id'], $parameters['SelectedItemsForCsv']['ViewSample']['sample_master_id']))
                        continue;
                    $res[] = array_merge($newStudiedSample, $newDerivativeSample);
                }
            }
        }
        return array(
            'header' => $header,
            'data' => $res,
            'columns_names' => null,
            'error_msg' => null
        );
    }
}