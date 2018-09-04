<?php

class ReportsControllerCustom extends ReportsController
{

    public function participantIdentifiersSummary($parameters)
    {
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/MiscIdentifiers/listall')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
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
                        'RAMQ' => null,
// *** PROCURE CHUM *****************************************************
                        'prostate_bank_no_lab' => null,
                        'ramq_nbr' => null,
                        'hotel_dieu_id_nbr' => null,
                        'notre_dame_id_nbr' => null,
                        'saint_luc_id_nbr' => null,
                        'participant_patho_identifier' => null
//*** END PROCURE CHUM *****************************************************
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

    public function procureDiagnosisAndTreatmentReports($parameters)
    {
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/TreatmentMasters/listall')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/EventMasters/listall')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        $displayExactSearchWarning = false;
        $header = null;
        $conditions = array(
            'TRUE'
        );
        if (isset($parameters['Participant']['id']) && ! empty($parameters['Participant']['id'])) {
            // From databrowser
            $participantIds = array_filter($parameters['Participant']['id']);
            if ($participantIds)
                $conditions[] = "Participant.id IN ('" . implode("','", $participantIds) . "')";
        } elseif (isset($parameters['Participant']['participant_identifier_start'])) {
            $participantIdentifierStart = (! empty($parameters['Participant']['participant_identifier_start'])) ? $parameters['Participant']['participant_identifier_start'] : null;
            $participantIdentifierEnd = (! empty($parameters['Participant']['participant_identifier_end'])) ? $parameters['Participant']['participant_identifier_end'] : null;
            if ($participantIdentifierStart)
                $conditions[] = "Participant.participant_identifier >= '$participantIdentifierStart'";
            if ($participantIdentifierEnd)
                $conditions[] = "Participant.participant_identifier <= '$participantIdentifierEnd'";
        } elseif (isset($parameters['Participant']['participant_identifier'])) {
            $displayExactSearchWarning = true;
            $participantIdentifiers = array_filter($parameters['Participant']['participant_identifier']);
            if ($participantIdentifiers)
                $conditions[] = "Participant.participant_identifier IN ('" . implode("','", $participantIdentifiers) . "')";
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (isset($parameters['0']['procure_participant_identifier_prefix'])) {
            $procureParticipantIdentifierPrefix = array_filter($parameters['0']['procure_participant_identifier_prefix']);
            if ($procureParticipantIdentifierPrefix) {
                $prefixConditions = array();
                foreach ($procureParticipantIdentifierPrefix as $prefix) {
                    if (! in_array($prefix, array(
                        's'
                    ))) {
                        $prefixConditions[] = "Participant.participant_identifier LIKE 'PS$prefix%'";
                    }
                }
                if ($prefixConditions) {
                    $conditions[] = '(' . implode(' OR ', $prefixConditions) . ')';
                } else {
                    $conditions[] = "Participant.participant_identifier LIKE '-1'";
                }
            }
        }
// *** PROCURE CHUM *****************************************************
        if (isset($parameters['MiscIdentifier']['identifier_value'])) {
            $noLabos = array_filter($parameters['MiscIdentifier']['identifier_value']);
            if ($noLabos)
                $conditions[] = "MiscIdentifier.identifier_value IN ('" . implode("','", $noLabos) . "')";
        } else 
            if (isset($parameters['MiscIdentifier']['identifier_value_start'])) {
                $identifierValueStart = (! empty($parameters['MiscIdentifier']['identifier_value_start'])) ? $parameters['MiscIdentifier']['identifier_value_start'] : null;
                $identifierValueEnd = (! empty($parameters['MiscIdentifier']['identifier_value_end'])) ? $parameters['MiscIdentifier']['identifier_value_end'] : null;
                if ($identifierValueStart)
                    $conditions[] = "MiscIdentifier.identifier_value >= '$identifierValueStart'";
                if ($identifierValueEnd)
                    $conditions[] = "MiscIdentifier.identifier_value <= '$identifierValueEnd'";
            }
//*** END PROCURE CHUM *****************************************************
        
        // Get Controls Data
        $participantModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        $query = "SELECT id,event_type, detail_tablename FROM event_controls WHERE flag_active = 1;";
        $eventControls = array();
        foreach ($participantModel->query($query) as $res)
            $eventControls[$res['event_controls']['event_type']] = array(
                'id' => $res['event_controls']['id'],
                'detail_tablename' => $res['event_controls']['detail_tablename']
            );
        $query = "SELECT id,tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1;";
        $txControls = array();
        foreach ($participantModel->query($query) as $res) {
            $txControls[$res['treatment_controls']['tx_method']] = array(
                'id' => $res['treatment_controls']['id'],
                'detail_tablename' => $res['treatment_controls']['detail_tablename']
            );
        }
        $diagnosisEventControlId = $eventControls['prostate cancer - diagnosis']['id'];
        $diagnosisEventDetailTablename = $eventControls['prostate cancer - diagnosis']['detail_tablename'];
        $pathologyEventControlId = $eventControls['procure pathology report']['id'];
        $pathologyEventDetailTablename = $eventControls['procure pathology report']['detail_tablename'];
        $followupTreatmentControlId = $txControls['treatment']['id'];
        $followupTreatmentDetailTablename = $txControls['treatment']['detail_tablename'];
        
        if (! $diagnosisEventControlId || ! $pathologyEventControlId)
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            
// *** PROCURE CHUM *****************************************************
        $query = "SELECT id FROM misc_identifier_controls WHERE flag_active = 1 AND misc_identifier_name = 'prostate bank no lab';";
        $miscIdentifierControlId = null;
        foreach ($participantModel->query($query) as $res)
            $miscIdentifierControlId = $res['misc_identifier_controls']['id'];
//*** END PROCURE CHUM *****************************************************

            // Get participants data
        $query = "SELECT 
			Participant.id,
			Participant.participant_identifier, 
			Participant.vital_status,
			Participant.date_of_death,
			Participant.date_of_death_accuracy,
			Participant.procure_cause_of_death,
-- *** PROCURE CHUM *****************************************************
			MiscIdentifier.identifier_value,
-- *** END PROCURE CHUM *****************************************************
			PathologyEventMaster.event_date, 
			PathologyEventMaster.event_date_accuracy, 
			PathologyEventDetail.path_number, 
			EventDetail.biopsy_pre_surgery_date, 
			EventDetail.biopsy_pre_surgery_date_accuracy
			FROM participants Participant
			LEFT JOIN event_masters EventMaster ON EventMaster.participant_id = Participant.id AND EventMaster.event_control_id = $diagnosisEventControlId AND EventMaster.deleted <> 1
			LEFT JOIN $diagnosisEventDetailTablename EventDetail ON EventDetail.event_master_id = EventMaster.id
			LEFT JOIN event_masters PathologyEventMaster ON PathologyEventMaster.participant_id = Participant.id AND PathologyEventMaster.event_control_id = $pathologyEventControlId AND PathologyEventMaster.deleted <> 1
			LEFT JOIN $pathologyEventDetailTablename PathologyEventDetail ON PathologyEventDetail.event_master_id = PathologyEventMaster.id
-- *** PROCURE CHUM *****************************************************
			LEFT JOIN misc_identifiers MiscIdentifier ON MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1 AND MiscIdentifier.misc_identifier_control_id = $miscIdentifierControlId
-- *** END PROCURE CHUM *****************************************************
			WHERE Participant.deleted <> 1 AND " . implode(' AND ', $conditions);
        $data = array();
        $displayWarning = false;
        foreach ($participantModel->query($query) as $res) {
            $participantId = $res['Participant']['id'];
            if (isset($data[$participantId]))
                $displayWarning = true;
            $data[$participantId]['Participant'] = $res['Participant'];
            $data[$participantId]['TreatmentMaster']['start_date'] = null;
            $data[$participantId]['TreatmentMaster']['start_date_accuracy'] = null;
//*** PROCURE CHUM *****************************************************
			$data[$participantId]['MiscIdentifier'] = $res['MiscIdentifier'];
//*** END PROCURE CHUM *****************************************************
            $data[$participantId]['EventMaster'] = $res['PathologyEventMaster'];
            $data[$participantId]['EventDetail'] = array_merge($res['PathologyEventDetail'], $res['EventDetail']);
            $data[$participantId]['0'] = array(
                'procure_post_op_hormono' => '',
                'procure_post_op_chemo' => '',
                'procure_post_op_radio' => '',
                'procure_post_op_brachy' => '',
                'procure_pre_op_hormono' => '',
                'procure_pre_op_chemo' => '',
                'procure_pre_op_radio' => '',
                'procure_pre_op_brachy' => '',
                'procure_CRPC' => '',
                'procure_inaccurate_date_use' => '',
                'procure_pre_op_psa_date' => '',
                'procure_pre_op_psa_date_accuracy' => '',
                'procure_first_bcr_date' => '',
                'procure_first_bcr_date_accuracy' => '',
                'procure_first_clinical_recurrence_date' => '',
                'procure_first_clinical_recurrence_date_accuracy' => '',
                'procure_first_clinical_recurrence_test' => '',
                'procure_first_clinical_recurrence_site' => '',
                'procure_first_positive_exam_date' => '',
                'procure_first_positive_exam_date_accuracy' => '',
                'procure_first_positive_exam_test' => '',
                'procure_first_positive_exam_site' => ''
            );
            $data[$participantId]['EventDetail']['psa_total_ngml'] = '';
        }
        if (sizeof($data) > Configure::read('databrowser_and_report_results_display_limit')) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => 'the report contains too many results - please redefine search criteria'
            );
        }
        if ($displayWarning)
            AppController::addWarningMsg('at least one participant is linked to more than one diagnosis or pathology worksheet');
        
        $participantIds = array_keys($data);
        $inaccurateDate = false;
        
        // Analyze participants treatments
        $treatmentModel = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
        $txJoin = array(
            'table' => $followupTreatmentDetailTablename,
            'alias' => 'TreatmentDetail',
            'type' => 'INNER',
            'conditions' => array(
                'TreatmentDetail.treatment_master_id = TreatmentMaster.id'
            )
        );
        // Get prostatectomy date
        $conditions = array(
            'TreatmentMaster.participant_id' => $participantIds,
            'TreatmentMaster.treatment_control_id' => $followupTreatmentControlId,
            'TreatmentMaster.start_date IS NOT NULL',
            "TreatmentDetail.treatment_type" => 'surgery',
            "TreatmentDetail.surgery_type LIKE 'prostatectomy%'"
        );
        $allParticipantsProstatectomy = $treatmentModel->find('all', array(
            'conditions' => $conditions,
            'joins' => array(
                $txJoin
            ),
            'order' => array(
                'TreatmentMaster.start_date ASC'
            )
        ));
        foreach ($allParticipantsProstatectomy as $newProstatectomy) {
            $participantId = $newProstatectomy['TreatmentMaster']['participant_id'];
            if (! $data[$participantId]['TreatmentMaster']['start_date']) {
                $data[$participantId]['TreatmentMaster']['start_date'] = $newProstatectomy['TreatmentMaster']['start_date'];
                $data[$participantId]['TreatmentMaster']['start_date_accuracy'] = $newProstatectomy['TreatmentMaster']['start_date_accuracy'];
            }
        }
        // Search Pre and Post Operative Treatments
        $conditions = array(
            'TreatmentMaster.participant_id' => $participantIds,
            'TreatmentMaster.treatment_control_id' => $followupTreatmentControlId,
            'TreatmentMaster.start_date IS NOT NULL',
            'OR' => array(
                "TreatmentDetail.treatment_type LIKE '%radiotherapy%'",
                "TreatmentDetail.treatment_type LIKE '%hormonotherapy%'",
                "TreatmentDetail.treatment_type LIKE '%chemotherapy%'",
                "TreatmentDetail.treatment_type LIKE '%brachytherapy%'"
            )
        );
        $allParticipantsTreatment = $treatmentModel->find('all', array(
            'conditions' => $conditions,
            'joins' => array(
                $txJoin
            )
        ));
        foreach ($allParticipantsTreatment as $newTreatment) {
            $participantId = $newTreatment['TreatmentMaster']['participant_id'];
            $prostatectomyDate = $data[$participantId]['TreatmentMaster']['start_date'];
            $prostatectomyDateAccuracy = $data[$participantId]['TreatmentMaster']['start_date_accuracy'];
            if ($prostatectomyDate) {
                $administratedTreatmentTypes = array();
                if (preg_match('/chemotherapy/', $newTreatment['TreatmentDetail']['treatment_type']))
                    $administratedTreatmentTypes[] = 'chemo';
                if (preg_match('/hormonotherapy/', $newTreatment['TreatmentDetail']['treatment_type']))
                    $administratedTreatmentTypes[] = 'hormono';
                if (preg_match('/radiotherapy/', $newTreatment['TreatmentDetail']['treatment_type']))
                    $administratedTreatmentTypes[] = 'radio';
                if (preg_match('/brachytherapy/', $newTreatment['TreatmentDetail']['treatment_type']))
                    $administratedTreatmentTypes[] = 'brachy';
                if ($administratedTreatmentTypes) {
                    if ($prostatectomyDateAccuracy != 'c' || $newTreatment['TreatmentMaster']['start_date_accuracy'] != 'c') {
                        $inaccurateDate = true;
                        $data[$participantId][0]['procure_inaccurate_date_use'] = 'y';
                    }
                    if ($newTreatment['TreatmentMaster']['start_date'] < $prostatectomyDate) {
                        foreach ($administratedTreatmentTypes as $txType)
                            $data[$participantId][0]['procure_pre_op_' . $txType] = 'y';
                    } elseif ($newTreatment['TreatmentMaster']['start_date'] > $prostatectomyDate) {
                        foreach ($administratedTreatmentTypes as $txType)
                            $data[$participantId][0]['procure_post_op_' . $txType] = 'y';
                    }
                }
            }
        }
        // Get CRPC
        $eventModel = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
        $conditions = array(
            'EventMaster.participant_id' => $participantIds,
            'EventMaster.event_control_id' => $eventControls['clinical note']['id'],
            'EventDetail.type' => 'CRPC'
        );
        $exJoin = array(
            'table' => $eventControls['clinical note']['detail_tablename'],
            'alias' => 'EventDetail',
            'type' => 'INNER',
            'conditions' => array(
                'EventDetail.event_master_id = EventMaster.id'
            )
        );
        $allParticipantsCRPC = $eventModel->find('all', array(
            'conditions' => $conditions,
            'joins' => array(
                $exJoin
            )
        ));
        foreach ($allParticipantsCRPC as $newCRPC) {
            $participantId = $newCRPC['EventMaster']['participant_id'];
            $data[$participantId]['0']['procure_CRPC'] = 'y';
        }
        // Analyze participants psa
        $eventModel = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
        $eventControlId = $eventControls['laboratory']['id'];
        $allParticipantsPsa = $eventModel->find('all', array(
            'conditions' => array(
                'EventMaster.participant_id' => $participantIds,
                'EventMaster.event_control_id' => $eventControlId,
                'EventMaster.event_date IS NOT NULL'
            ),
            'order' => array(
                'EventMaster.event_date ASC'
            )
        ));
        foreach ($allParticipantsPsa as $newPsa) {
            $participantId = $newPsa['EventMaster']['participant_id'];
            $prostatectomyDate = $data[$participantId]['TreatmentMaster']['start_date'];
            $prostatectomyDateAccuracy = $data[$participantId]['TreatmentMaster']['start_date_accuracy'];
            if ($prostatectomyDate) {
                if ($prostatectomyDateAccuracy != 'c' || $newPsa['EventMaster']['event_date_accuracy'] != 'c') {
                    $inaccurateDate = true;
                    $data[$participantId][0]['procure_inaccurate_date_use'] = 'y';
                }
                if ($newPsa['EventMaster']['event_date'] <= $prostatectomyDate) {
                    // PSA pre-surgery
                    $data[$participantId]['0']['procure_pre_op_psa_date'] = $this->procureFormatDate($newPsa['EventMaster']['event_date'], $newPsa['EventMaster']['event_date_accuracy']);
                    $data[$participantId]['0']['procure_pre_op_psa_date_accuracy'] = $newPsa['EventMaster']['event_date_accuracy'];
                    $data[$participantId]['EventDetail']['psa_total_ngml'] = $newPsa['EventDetail']['psa_total_ngml'];
                }
                if ($newPsa['EventDetail']['biochemical_relapse'] == 'y' && empty($data[$participantId]['0']['procure_first_bcr_date'])) {
                    // 1st BCR
                    $data[$participantId]['0']['procure_first_bcr_date'] = $this->procureFormatDate($newPsa['EventMaster']['event_date'], $newPsa['EventMaster']['event_date_accuracy']);
                    $data[$participantId]['0']['procure_first_bcr_date_accuracy'] = $newPsa['EventMaster']['event_date_accuracy'];
                }
            }
        }
        
        // Analyze participants 1st clinical recurrence
        $eventControlId = $eventControls['clinical exam']['id'];
        $allParticipantsTest = $eventModel->find('all', array(
            'conditions' => array(
                'EventMaster.participant_id' => $participantIds,
                'EventMaster.event_control_id' => $eventControlId,
                'EventMaster.event_date IS NOT NULL',
                'OR' => array(
                    'EventDetail.clinical_relapse' => 'y',
                    'EventDetail.results' => 'positive'
                )
            ),
            'order' => array(
                'EventMaster.event_date ASC'
            )
        ));
        foreach ($allParticipantsTest as $newTest) {
            $participantId = $newTest['EventMaster']['participant_id'];
            $prostatectomyDate = $data[$participantId]['TreatmentMaster']['start_date'];
            $prostatectomyDateAccuracy = $data[$participantId]['TreatmentMaster']['start_date_accuracy'];
            if ($prostatectomyDate) {
                if ($prostatectomyDateAccuracy != 'c' || $newTest['EventMaster']['event_date_accuracy'] != 'c') {
                    $inaccurateDate = true;
                    $data[$participantId][0]['procure_inaccurate_date_use'] = 'y';
                }
                if ($newTest['EventMaster']['event_date'] > $prostatectomyDate) {
                    if (empty($data[$participantId]['0']['procure_first_clinical_recurrence_test']) && $newTest['EventDetail']['clinical_relapse'] == 'y') {
                        $data[$participantId]['0']['procure_first_clinical_recurrence_date'] = $this->procureFormatDate($newTest['EventMaster']['event_date'], $newTest['EventMaster']['event_date_accuracy']);
                        $data[$participantId]['0']['procure_first_clinical_recurrence_date_accuracy'] = $newTest['EventMaster']['event_date_accuracy'];
                        $data[$participantId]['0']['procure_first_clinical_recurrence_test'] = $newTest['EventDetail']['type'];
                        $data[$participantId]['0']['procure_first_clinical_recurrence_site'] = $newTest['EventDetail']['site_precision'];
                    }
                    if (empty($data[$participantId]['0']['procure_first_positive_exam_test']) && $newTest['EventDetail']['results'] == 'positive') {
                        $data[$participantId]['0']['procure_first_positive_exam_date'] = $this->procureFormatDate($newTest['EventMaster']['event_date'], $newTest['EventMaster']['event_date_accuracy']);
                        $data[$participantId]['0']['procure_first_positive_exam_date_accuracy'] = $newTest['EventMaster']['event_date_accuracy'];
                        $data[$participantId]['0']['procure_first_positive_exam_test'] = $newTest['EventDetail']['type'];
                        $data[$participantId]['0']['procure_first_positive_exam_site'] = $newTest['EventDetail']['site_precision'];
                    }
                }
            }
        }
        
        if ($inaccurateDate)
            AppController::addWarningMsg(__('at least one participant summary is based on inaccurate date'));
        
        if ($displayExactSearchWarning)
            AppController::addWarningMsg(__('all searches are considered as exact searches'));
        
        return array(
            'header' => $header,
            'data' => $data,
            'columns_names' => null,
            'error_msg' => null
        );
    }

    public function procureFollowUpReports($parameters)
    {
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/TreatmentMasters/listall')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/EventMasters/listall')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        if (! AppController::checkLinkPermission('/InventoryManagement/Collections/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        $displayExactSearchWarning = false;
        $header = null;
        $conditions = array(
            'TRUE'
        );
        if (isset($parameters['Participant']['id']) && ! empty($parameters['Participant']['id'])) {
            // From databrowser
            $participantIds = array_filter($parameters['Participant']['id']);
            if ($participantIds)
                $conditions[] = "Participant.id IN ('" . implode("','", $participantIds) . "')";
        } elseif (isset($parameters['Participant']['participant_identifier_start'])) {
            $participantIdentifierStart = (! empty($parameters['Participant']['participant_identifier_start'])) ? $parameters['Participant']['participant_identifier_start'] : null;
            $participantIdentifierEnd = (! empty($parameters['Participant']['participant_identifier_end'])) ? $parameters['Participant']['participant_identifier_end'] : null;
            if ($participantIdentifierStart)
                $conditions[] = "Participant.participant_identifier >= '$participantIdentifierStart'";
            if ($participantIdentifierEnd)
                $conditions[] = "Participant.participant_identifier <= '$participantIdentifierEnd'";
        } elseif (isset($parameters['Participant']['participant_identifier'])) {
            $displayExactSearchWarning = true;
            $participantIdentifiers = array_filter($parameters['Participant']['participant_identifier']);
            if ($participantIdentifiers)
                $conditions[] = "Participant.participant_identifier IN ('" . implode("','", $participantIdentifiers) . "')";
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (isset($parameters['0']['procure_participant_identifier_prefix'])) {
            $procureParticipantIdentifierPrefix = array_filter($parameters['0']['procure_participant_identifier_prefix']);
            if ($procureParticipantIdentifierPrefix) {
                $prefixConditions = array();
                foreach ($procureParticipantIdentifierPrefix as $prefix) {
                    if (! in_array($prefix, array(
                        's'
                    ))) {
                        $prefixConditions[] = "Participant.participant_identifier LIKE 'PS$prefix%'";
                    }
                }
                if ($prefixConditions) {
                    $conditions[] = '(' . implode(' OR ', $prefixConditions) . ')';
                } else {
                    $conditions[] = "Participant.participant_identifier LIKE '-1'";
                }
            }
        }
// *** PROCURE CHUM *****************************************************
        if (isset($parameters['MiscIdentifier']['identifier_value'])) {
            $noLabos = array_filter($parameters['MiscIdentifier']['identifier_value']);
            if ($noLabos)
                $conditions[] = "MiscIdentifier.identifier_value IN ('" . implode("','", $noLabos) . "')";
        } elseif (isset($parameters['MiscIdentifier']['identifier_value_start'])) {
            $identifierValueStart = (! empty($parameters['MiscIdentifier']['identifier_value_start'])) ? $parameters['MiscIdentifier']['identifier_value_start'] : null;
            $identifierValueEnd = (! empty($parameters['MiscIdentifier']['identifier_value_end'])) ? $parameters['MiscIdentifier']['identifier_value_end'] : null;
            if ($identifierValueStart)
                $conditions[] = "MiscIdentifier.identifier_value >= '$identifierValueStart'";
            if ($identifierValueEnd)
                $conditions[] = "MiscIdentifier.identifier_value <= '$identifierValueEnd'";
        }
//*** END PROCURE CHUM *****************************************************
        
        // Get Controls Data
        $participantModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        $query = "SELECT id,event_type, detail_tablename FROM event_controls WHERE flag_active = 1;";
        $eventControls = array();
        foreach ($participantModel->query($query) as $res)
            $eventControls[$res['event_controls']['event_type']] = array(
                'id' => $res['event_controls']['id'],
                'detail_tablename' => $res['event_controls']['detail_tablename']
            );
        $followupEventControlId = $eventControls['visit - contact']['id'];
        $followupEventDetailTablename = $eventControls['visit - contact']['detail_tablename'];
        if (! $followupEventControlId)
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $query = "SELECT id,tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1;";
        $txControls = array();
        foreach ($participantModel->query($query) as $res)
            $txControls[$res['treatment_controls']['tx_method']] = array(
                'id' => $res['treatment_controls']['id'],
                'detail_tablename' => $res['treatment_controls']['detail_tablename']
            );
        $treatmentControlId = $txControls['treatment']['id'];
        $treatmentControlDetailTablename = $txControls['treatment']['detail_tablename'];
        $medicationTreatmentControlId = $txControls['procure medication worksheet']['id'];
        $medicationTreatmentControlDetailTablename = $txControls['procure medication worksheet']['detail_tablename'];
        $query = "SELECT id, detail_tablename, sample_type FROM sample_controls WHERE sample_type IN ('blood','urine', 'tissue');";
        $sampleControls = array();
        $bloodDetailTablename = '';
        foreach ($participantModel->query($query) as $res) {
            $sampleControls[$res['sample_controls']['id']] = $res['sample_controls']['sample_type'];
            if ($res['sample_controls']['sample_type'] == 'blood')
                $bloodDetailTablename = $res['sample_controls']['detail_tablename'];
        }
// *** PROCURE CHUM *****************************************************
        $query = "SELECT id, misc_identifier_name FROM misc_identifier_controls WHERE flag_active = 1 AND misc_identifier_name IN ('ramq nbr', 'prostate bank no lab');";
        $miscIdentifierControlIds = null;
        foreach ($participant_model->query($query) as $res)
            $miscIdentifierControlIds[$res['misc_identifier_controls']['misc_identifier_name']] = $res['misc_identifier_controls']['id'];
//*** END PROCURE CHUM *****************************************************
        
        $maxVisit = 20;
        $emptyFormArray = array(
            'procure_prostatectomy_date' => '',
            'procure_prostatectomy_date_accuracy' => '',
            'procure_last_collection_date' => '',
            'procure_last_collection_date_accuracy' => '',
            'procure_time_from_last_collection_months' => '',
            'procure_followup_worksheets_nbr' => array(),
            'procure_medication_worksheets_nbr' => array(),
            'procure_number_of_visit_with_collection' => array()
        );
        for ($tmpVisitId = 1; $tmpVisitId < $maxVisit; $tmpVisitId ++) {
            $visitId = (strlen($tmpVisitId) == 1) ? '0' . $tmpVisitId : $tmpVisitId;
            $emptyFormArray["procure_" . $visitId . "_followup_worksheet_date"] = null;
            $emptyFormArray["procure_" . $visitId . "_followup_worksheet_date_accuracy"] = null;
            $emptyFormArray["procure_" . $visitId . "_followup_worksheet_month"] = null;
            $emptyFormArray["procure_" . $visitId . "_medication_worksheet_date"] = null;
            $emptyFormArray["procure_" . $visitId . "_medication_worksheet_date_accuracy"] = null;
            $emptyFormArray["procure_" . $visitId . "_medication_worksheet_month"] = null;
            $emptyFormArray["procure_" . $visitId . "_first_collection_date"] = null;
            $emptyFormArray["procure_" . $visitId . "_first_collection_date_accuracy"] = null;
            $emptyFormArray["procure_" . $visitId . "_first_collection_month"] = null;
            $emptyFormArray["procure_" . $visitId . "_paxgene_collected"] = '';
            $emptyFormArray["procure_" . $visitId . "_serum_collected"] = '';
            $emptyFormArray["procure_" . $visitId . "_urine_collected"] = '';
            $emptyFormArray["procure_" . $visitId . "_k2_EDTA_collected"] = '';
            $emptyFormArray["procure_" . $visitId . "_tissue_collected"] = '';
        }
        
        // Get participants data + followup
        $query = "SELECT
			Participant.id,
			Participant.participant_identifier,
-- *** PROCURE CHUM *****************************************************
			Participant.first_name,
			Participant.last_name,
			Participant.participant_identifier,
			MiscIdentifier.identifier_value,
			MiscIdentifierRamq.identifier_value AS qc_nd_ramq,
-- *** END PROCURE CHUM *****************************************************
			EventMaster.procure_form_identification,
			EventMaster.event_date,
			EventMaster.event_date_accuracy
			FROM participants Participant
-- *** PROCURE CHUM *****************************************************
			LEFT JOIN misc_identifiers MiscIdentifier ON MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1 AND MiscIdentifier.misc_identifier_control_id = ".$miscIdentifierControlIds['prostate bank no lab']."
			LEFT JOIN misc_identifiers MiscIdentifierRamq ON MiscIdentifierRamq.participant_id = Participant.id AND MiscIdentifierRamq.deleted <> 1 AND MiscIdentifierRamq.misc_identifier_control_id = ".$miscIdentifierControlIds['ramq nbr']."		
-- *** END PROCURE CHUM *****************************************************
			LEFT JOIN event_masters EventMaster ON EventMaster.participant_id = Participant.id AND EventMaster.event_control_id = $followupEventControlId AND EventMaster.deleted <> 1
			LEFT JOIN $followupEventDetailTablename EventDetail ON EventDetail.event_master_id = EventMaster.id
			WHERE Participant.deleted <> 1 AND " . implode(' AND ', $conditions);
        $data = array();
        $displayWarning1 = false;
        $displayWarning2 = false;
        foreach ($participantModel->query($query) as $res) {
            $participantId = $res['Participant']['id'];
            if (! isset($data[$participantId]))
                $data[$participantId] = array(
                    'Participant' => $res['Participant'],
// *** PROCURE CHUM *****************************************************
                    'MiscIdentifier' => $res['MiscIdentifier'],
                    'Generated' => array_merge($res['MiscIdentifierRamq'], array(
                        'qc_nd_all_phone_numbers' => ''
                    )),
//*** END PROCURE CHUM *****************************************************
                    '0' => $emptyFormArray
                );
            $procureFormIdentification = $res['EventMaster']['procure_form_identification'];
            if ($procureFormIdentification) {
                if (preg_match("/^PS[0-9]P0[0-9]+ V(([0])|(0[1-9])|(1[0-9])) -(FSP)[0-9]+$/", $procureFormIdentification, $matches)) {
                    $visitId = $matches[1];
                    if ($visitId != '0') {
                        if (empty($data[$participantId][0]["procure_" . $visitId . "_followup_worksheet_date"])) {
                            $data[$participantId][0]["procure_" . $visitId . "_followup_worksheet_date"] = $this->procureFormatDate($res['EventMaster']['event_date'], $res['EventMaster']['event_date_accuracy']);
                            $data[$participantId][0]["procure_" . $visitId . "_followup_worksheet_date_accuracy"] = $res['EventMaster']['event_date_accuracy'];
                            $data[$participantId][0]['procure_followup_worksheets_nbr'][$visitId] = '-';
                        } else {
                            $displayWarning1 = true;
                        }
                    }
                } else {
                    $displayWarning2 = true;
                }
            }
        }
        if (sizeof($data) > Configure::read('databrowser_and_report_results_display_limit')) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => 'the report contains too many results - please redefine search criteria'
            );
        }
        if ($displayWarning1)
            AppController::addWarningMsg(__('at least one patient is linked to more than one followup worksheet for the same visit'));
        if ($displayWarning2)
            AppController::addWarningMsg(__('at least one procure form identification format is not supported'));
            
// *** PROCURE CHUM *****************************************************
        // Get phone numbers
        $query = "SELECT participant_id, GROUP_CONCAT(phone SEPARATOR '####') AS phone_1, GROUP_CONCAT(phone_secondary SEPARATOR '####') AS phone_2
			FROM participant_contacts
			WHERE relationship = 'the participant'
			AND (phone NOT LIKE '' OR phone_secondary NOT LIKE '')
			AND deleted <>1
			AND participant_id IN (" . implode(',', array_keys($data)) . ")
			GROUP BY participant_id;";
        foreach ($participantModel->query($query) as $res) {
            $participantId = $res['participant_contacts']['participant_id'];
            $participantPhones = array_filter(array_merge(explode('####', $res['0']['phone_1']), explode('####', $res['0']['phone_2'])));
            if ($participantPhones) {
                $data[$participantId]['Generated']['qc_nd_all_phone_numbers'] = implode(" & ", $participantPhones);
            }
        }
//*** END PROCURE CHUM *****************************************************
        
            // Get medication
        $query = "SELECT
			TreatmentMaster.participant_id,
			TreatmentMaster.procure_form_identification,
			TreatmentMaster.start_date,
			TreatmentMaster.start_date_accuracy
			FROM treatment_masters TreatmentMaster 
			WHERE TreatmentMaster.deleted <> 1 AND TreatmentMaster.treatment_control_id = $medicationTreatmentControlId AND TreatmentMaster.participant_id IN (" . implode(',', array_keys($data)) . ")
			AND TreatmentMaster.start_date IS NOT NULL AND TreatmentMaster.start_date NOT LIKE ''
			ORDER BY TreatmentMaster.start_date ASC;";
        foreach ($participantModel->query($query) as $res) {
            $participantId = $res['TreatmentMaster']['participant_id'];
            $procureFormIdentification = $res['TreatmentMaster']['procure_form_identification'];
            if ($procureFormIdentification) {
                if (preg_match("/^PS[0-9]P0[0-9]+ V(([0])|(0[1-9])|(1[0-9])) -(MED)[0-9]+$/", $procureFormIdentification, $matches)) {
                    $visitId = $matches[1];
                    if ($visitId != '0') {
                        if (empty($data[$participantId][0]["procure_" . $visitId . "_medication_worksheet_date"])) {
                            $data[$participantId][0]["procure_" . $visitId . "_medication_worksheet_date"] = $this->procureFormatDate($res['TreatmentMaster']['start_date'], $res['TreatmentMaster']['start_date_accuracy']);
                            $data[$participantId][0]["procure_" . $visitId . "_medication_worksheet_date_accuracy"] = $res['TreatmentMaster']['start_date_accuracy'];
                            $data[$participantId][0]['procure_medication_worksheets_nbr'][$visitId] = '-';
                        }
                    }
                }
            }
        }
        
        // Get prostatectomy
        if ($data) {
            $query = "SELECT
				TreatmentMaster.participant_id,
				TreatmentMaster.start_date,
				TreatmentMaster.start_date_accuracy
				FROM treatment_masters TreatmentMaster 
				INNER JOIN $treatmentControlDetailTablename TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
				WHERE TreatmentMaster.deleted <> 1 AND TreatmentMaster.treatment_control_id = $treatmentControlId AND TreatmentMaster.participant_id IN (" . implode(',', array_keys($data)) . ")
				AND TreatmentDetail.treatment_type = 'prostatectomy'
				AND TreatmentMaster.start_date IS NOT NULL AND TreatmentMaster.start_date NOT LIKE ''
				ORDER BY TreatmentMaster.start_date ASC;";
            foreach ($participantModel->query($query) as $res) {
                $participantId = $res['TreatmentMaster']['participant_id'];
                if (! strlen($data[$participantId][0]["procure_prostatectomy_date"])) {
                    $data[$participantId][0]["procure_prostatectomy_date"] = $this->procureFormatDate($res['TreatmentMaster']['start_date'], $res['TreatmentMaster']['start_date_accuracy']);
                    $data[$participantId][0]["procure_prostatectomy_date_accuracy"] = $res['TreatmentMaster']['start_date_accuracy'];
                }
            }
        }
        
        // Get blood, urine and tissue
        if ($data) {
            $query = "SELECT 
				Collection.participant_id,
				Collection.procure_visit,
				Collection.collection_datetime,
				Collection.collection_datetime_accuracy,
				SampleMaster.sample_control_id,
				SampleDetail.blood_type
				FROM collections Collection 
				INNER JOIN sample_masters AS SampleMaster ON SampleMaster.collection_id = Collection.id AND SampleMaster.deleted <> 1
				LEFT JOIN $bloodDetailTablename AS SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
				WHERE sample_control_id IN (" . implode(',', array_keys($sampleControls)) . ")
				AND Collection.participant_id IN (" . implode(',', array_keys($data)) . ");";
            foreach ($participantModel->query($query) as $res) {
                $participantId = $res['Collection']['participant_id'];
                $visitId = str_replace('V', '', $res['Collection']['procure_visit']);
                if (strlen($res['Collection']['collection_datetime'])) {
                    $recordCollectionDate = false;
                    if (! strlen($data[$participantId][0]["procure_" . $visitId . "_first_collection_date"])) {
                        $recordCollectionDate = true;
                    } elseif ($res['Collection']['collection_datetime'] < $data[$participantId][0]["procure_" . $visitId . "_first_collection_date"]) {
                        $recordCollectionDate = true;
                    }
                    if ($recordCollectionDate) {
                        $firstCollectionDateAccuracy = $res['Collection']['collection_datetime_accuracy'];
                        if (! in_array($firstCollectionDateAccuracy, array(
                            'y',
                            'm',
                            'd'
                        )))
                            $firstCollectionDateAccuracy = 'c';
                        $res['Collection']['collection_datetime_accuracy'] = str_replace(array(
                            'h',
                            'i'
                        ), array(
                            'c',
                            'c'
                        ), $res['Collection']['collection_datetime_accuracy']);
                        $data[$participantId][0]["procure_" . $visitId . "_first_collection_date"] = $this->procureFormatDate(substr($res['Collection']['collection_datetime'], 0, 10), $res['Collection']['collection_datetime_accuracy']);
                        $data[$participantId][0]["procure_" . $visitId . "_first_collection_date_accuracy"] = $res['Collection']['collection_datetime_accuracy'];
                        $data[$participantId][0]['procure_number_of_visit_with_collection'][$visitId] = '-';
                    }
                    if (empty($data[$participantId][0]["procure_last_collection_date"]) || $data[$participantId][0]["procure_last_collection_date"] < $res['Collection']['collection_datetime']) {
                        $res['Collection']['collection_datetime_accuracy'] = str_replace(array(
                            'h',
                            'i'
                        ), array(
                            'c',
                            'c'
                        ), $res['Collection']['collection_datetime_accuracy']);
                        $data[$participantId][0]["procure_last_collection_date"] = $this->procureFormatDate(substr($res['Collection']['collection_datetime'], 0, 10), $res['Collection']['collection_datetime_accuracy']);
                        $data[$participantId][0]["procure_last_collection_date_accuracy"] = $res['Collection']['collection_datetime_accuracy'];
                    }
                }
                if ($sampleControls[$res['SampleMaster']['sample_control_id']] == 'blood') {
                    $sampleType = str_replace('k2-EDTA', 'k2_EDTA', $res['SampleDetail']['blood_type']);
                } elseif ($sampleControls[$res['SampleMaster']['sample_control_id']] == 'urine') {
                    $sampleType = 'urine';
                } elseif ($sampleControls[$res['SampleMaster']['sample_control_id']] == 'tissue') {
                    $sampleType = 'tissue';
                } else {
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $data[$participantId][0]["procure_" . $visitId . "_" . $sampleType . "_collected"] = 'y';
            }
        }
        
        // Calculate last fields
        
        $monthsStrg = __('months');
        $query = "SELECT NOW() FROM users LIMIT 0,1;";
        $res = $participantModel->query($query);
        $currentDate = $res[0][0]['NOW()'];
        foreach ($data as $participantId => &$participantData) {
            if (! empty($participantData[0]["procure_last_collection_date"])) {
                $currentDate = substr($currentDate, 0, 10);
                $procureLastCollectionDate = substr($participantData[0]["procure_last_collection_date"], 0, 10);
                $datetime1 = new DateTime($procureLastCollectionDate);
                $datetime2 = new DateTime($currentDate);
                $interval = $datetime1->diff($datetime2);
                $progressionTimeInMonths = (($interval->format('%y') * 12) + $interval->format('%m'));
                if (! $interval->invert)
                    $participantData[0]["procure_time_from_last_collection_months"] = $progressionTimeInMonths;
            }
            $participantData[0]['procure_followup_worksheets_nbr'] = sizeof($participantData[0]['procure_followup_worksheets_nbr']);
            $participantData[0]['procure_medication_worksheets_nbr'] = sizeof($participantData[0]['procure_medication_worksheets_nbr']);
            $participantData[0]['procure_number_of_visit_with_collection'] = sizeof($participantData[0]['procure_number_of_visit_with_collection']);
            // Calculate spend time in month between visit and prostatectomy
            if ($participantData[0]['procure_prostatectomy_date']) {
                $stratDate = $participantData[0]['procure_prostatectomy_date'];
                if (strlen($stratDate) == 4) {
                    $stratDate .= '-06-01';
                } elseif (strlen($stratDate) == 7) {
                    $stratDate .= '-01';
                }
                $prostatectomyDatetime = new DateTime($stratDate);
                for ($tmpVisitId = 1; $tmpVisitId < $maxVisit; $tmpVisitId ++) {
                    $visitId = (strlen($tmpVisitId) == 1) ? '0' . $tmpVisitId : $tmpVisitId;
                    foreach (array(
                        'followup_worksheet',
                        'medication_worksheet',
                        'first_collection'
                    ) as $subStrgField)
                        if ($participantData[0]["procure_" . $visitId . "_" . $subStrgField . "_date"]) {
                            $accuracy = ($participantData[0]['procure_prostatectomy_date_accuracy'] . $participantData[0]["procure_" . $visitId . "_" . $subStrgField . "_date_accuracy"] != 'cc') ? '±' : '';
                            $finishDate = $participantData[0]["procure_" . $visitId . "_" . $subStrgField . "_date"];
                            if (strlen($finishDate) == 4) {
                                $finishDate .= '-06-01';
                            } elseif (strlen($finishDate) == 7) {
                                $finishDate .= '-01';
                            }
                            $visitDatetime = new DateTime($finishDate);
                            $interval = $prostatectomyDatetime->diff($visitDatetime);
                            $timeInMonths = (($interval->format('%y') * 12) + $interval->format('%m'));
                            if (! $interval->invert) {
                                $participantData[0]["procure_" . $visitId . "_" . $subStrgField . "_month"] = '(' . $accuracy . $timeInMonths . ' ' . $monthsStrg . ')';
                            } else {
                                $participantData[0]["procure_" . $visitId . "_" . $subStrgField . "_month"] = '(-' . $timeInMonths . ' ' . $monthsStrg . ')';
                            }
                        }
                }
            }
        }
        
        if ($displayExactSearchWarning)
            AppController::addWarningMsg(__('all searches are considered as exact searches'));
        
        return array(
            'header' => $header,
            'data' => $data,
            'columns_names' => null,
            'error_msg' => null
        );
    }

    public function procureAliquotsReports($parameters)
    {
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        if (! AppController::checkLinkPermission('/InventoryManagement/Collections/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        $displayExactSearchWarning = false;
        $header = null;
        $conditions = array(
            'TRUE'
        );
        if (isset($parameters['Participant']['id']) && ! empty($parameters['Participant']['id'])) {
            // From databrowser
            $participantIds = array_filter($parameters['Participant']['id']);
            if ($participantIds)
                $conditions[] = "Participant.id IN ('" . implode("','", $participantIds) . "')";
        } elseif (isset($parameters['Participant']['participant_identifier_start'])) {
            $participantIdentifierStart = (! empty($parameters['Participant']['participant_identifier_start'])) ? $parameters['Participant']['participant_identifier_start'] : null;
            $participantIdentifierEnd = (! empty($parameters['Participant']['participant_identifier_end'])) ? $parameters['Participant']['participant_identifier_end'] : null;
            if ($participantIdentifierStart)
                $conditions[] = "Participant.participant_identifier >= '$participantIdentifierStart'";
            if ($participantIdentifierEnd)
                $conditions[] = "Participant.participant_identifier <= '$participantIdentifierEnd'";
        } elseif (isset($parameters['Participant']['participant_identifier'])) {
            $displayExactSearchWarning = true;
            $participantIdentifiers = array_filter($parameters['Participant']['participant_identifier']);
            if ($participantIdentifiers)
                $conditions[] = "Participant.participant_identifier IN ('" . implode("','", $participantIdentifiers) . "')";
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (isset($parameters['0']['procure_participant_identifier_prefix'])) {
            $procureParticipantIdentifierPrefix = array_filter($parameters['0']['procure_participant_identifier_prefix']);
            if ($procureParticipantIdentifierPrefix) {
                $prefixConditions = array();
                foreach ($procureParticipantIdentifierPrefix as $prefix) {
                    if (! in_array($prefix, array(
                        's'
                    ))) {
                        $prefixConditions[] = "Participant.participant_identifier LIKE 'PS$prefix%'";
                    }
                }
                if ($prefixConditions) {
                    $conditions[] = '(' . implode(' OR ', $prefixConditions) . ')';
                } else {
                    $conditions[] = "Participant.participant_identifier LIKE '-1'";
                }
            }
        }
// *** PROCURE CHUM *****************************************************
        if (isset($parameters['MiscIdentifier']['identifier_value'])) {
            $noLabos = array_filter($parameters['MiscIdentifier']['identifier_value']);
            if ($noLabos)
                $conditions[] = "MiscIdentifier.identifier_value IN ('" . implode("','", $noLabos) . "')";
        } elseif (isset($parameters['MiscIdentifier']['identifier_value_start'])) {
            $identifierValueStart = (! empty($parameters['MiscIdentifier']['identifier_value_start'])) ? $parameters['MiscIdentifier']['identifier_value_start'] : null;
            $identifierValueEnd = (! empty($parameters['MiscIdentifier']['identifier_value_end'])) ? $parameters['MiscIdentifier']['identifier_value_end'] : null;
            if ($identifierValueStart)
                $conditions[] = "MiscIdentifier.identifier_value >= '$identifierValueStart'";
            if ($identifierValueEnd)
                $conditions[] = "MiscIdentifier.identifier_value <= '$identifierValueEnd'";
        }
//*** END PROCURE CHUM *****************************************************
        
        // Get Controls Data
        $participantModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        $query = "SELECT id, sample_type FROM sample_controls WHERE sample_type IN ('blood', 'serum', 'plasma', 'pbmc', 'buffy coat', 'centrifuged urine', 'tissue', 'rna', 'dna');";
        $sampleControls = array();
        foreach ($participantModel->query($query) as $res) {
            $sampleControls[$res['sample_controls']['id']] = $res['sample_controls']['sample_type'];
        }
        $query = "SELECT id, sample_control_id, aliquot_type FROM aliquot_controls WHERE sample_control_id IN (" . implode(',', array_keys($sampleControls)) . ") AND flag_active = 1;";
        $aliquotcontrols = array();
        foreach ($participantModel->query($query) as $res) {
            $aliquotcontrols[$res['aliquot_controls']['id']] = $sampleControls[$res['aliquot_controls']['sample_control_id']] . ' ' . $res['aliquot_controls']['aliquot_type'];
        }
// *** PROCURE CHUM *****************************************************
        $query = "SELECT id, misc_identifier_name FROM misc_identifier_controls WHERE flag_active = 1 AND misc_identifier_name IN ('ramq nbr', 'prostate bank no lab');";
        $miscIdentifierControlIds = null;
        foreach ($participant_model->query($query) as $res)
            $miscIdentifierControlIds[$res['misc_identifier_controls']['misc_identifier_name']] = $res['misc_identifier_controls']['id'];
//*** END PROCURE CHUM *****************************************************
                
        // Get participants data + aliquots count
        $query = "SELECT
			count(*) AS nbr_of_aliquots,
			Participant.id,
			Participant.participant_identifier,
-- *** PROCURE CHUM *****************************************************
			MiscIdentifier.identifier_value,
-- *** END PROCURE CHUM *****************************************************
			Collection.procure_visit,
			AliquotMaster.aliquot_control_id,
			AliquotMaster.in_stock,
			AliquotDetail.block_type,
			BloodDetail.blood_type
			FROM participants Participant
			INNER JOIN collections Collection ON Collection.participant_id = Participant.id
			INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id
			LEFT JOIN ad_blocks AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id
			LEFT JOIN sd_spe_bloods BloodDetail ON BloodDetail.sample_master_id = AliquotMaster.sample_master_id
-- *** PROCURE CHUM *****************************************************
			LEFT JOIN misc_identifiers MiscIdentifier ON MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1 AND MiscIdentifier.misc_identifier_control_id = $miscIdentifierControlId
-- *** END PROCURE CHUM *****************************************************
            WHERE Participant.deleted <> 1 AND " . implode(' AND ', $conditions) . " 
			AND AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id IN (" . implode(',', array_keys($aliquotcontrols)) . ")
			GROUP BY 
			Participant.id,
			Participant.participant_identifier,
			Collection.procure_visit,
			AliquotMaster.aliquot_control_id,
			AliquotDetail.block_type,
			BloodDetail.blood_type,
			AliquotMaster.in_stock";
        $emptyFormArray = array();
        for ($tmpVisitId = 1; $tmpVisitId < 20; $tmpVisitId ++) {
            $visitId = (strlen($tmpVisitId) == 1) ? '0' . $tmpVisitId : $tmpVisitId;
            if ($tmpVisitId == 1)
                $emptyFormArray["procure_" . $visitId . "_FRZ"] = '';
            if ($tmpVisitId == 1)
                $emptyFormArray["procure_" . $visitId . "_Paraffin"] = '';
            $emptyFormArray["procure_" . $visitId . "_SER"] = '';
            $emptyFormArray["procure_" . $visitId . "_RNB"] = '';
            $emptyFormArray["procure_" . $visitId . "_PLA"] = '';
            $emptyFormArray["procure_" . $visitId . "_BFC"] = '';
            $emptyFormArray["procure_" . $visitId . "_WHT"] = '';
            $emptyFormArray["procure_" . $visitId . "_URN"] = '';
            $emptyFormArray["procure_" . $visitId . "_RNA"] = '';
            $emptyFormArray["procure_" . $visitId . "_DNA"] = '';
        }
        $data = array();
        foreach ($participantModel->query($query) as $res) {
            $participantId = $res['Participant']['id'];
            if (! isset($data[$participantId]))
                $data[$participantId] = array(
                    'Participant' => $res['Participant'],
                    '0' => $emptyFormArray
                );
// *** PROCURE CHUM *****************************************************
            if (! isset($data[$participantId]['MiscIdentifier']))
                $data[$participantId]['MiscIdentifier'] = $res['MiscIdentifier'];
//*** END PROCURE CHUM *****************************************************
            $reportAliquotKey = '';
            if (isset($aliquotcontrols[$res['AliquotMaster']['aliquot_control_id']])) {
                switch ($aliquotcontrols[$res['AliquotMaster']['aliquot_control_id']]) {
                    case 'tissue block':
                        if ($res['AliquotDetail']['block_type'] == 'frozen') {
                            $reportAliquotKey = 'FRZ';
                        } elseif ($res['AliquotDetail']['block_type'] == 'paraffin') {
                            $reportAliquotKey = 'Paraffin';
                        }
                        break;
                    case 'blood tube':
                        if ($res['BloodDetail']['blood_type'] == 'paxgene') {
                            $reportAliquotKey = 'RNB';
                        }
                        break;
                    case 'serum tube':
                        $reportAliquotKey = 'SER';
                        break;
                    case 'plasma tube':
                        $reportAliquotKey = 'PLA';
                        break;
                    case 'pbmc':
                        $reportAliquotKey = 'PBMC';
                        break;
                    case 'buffy coat tube':
                        $reportAliquotKey = 'BFC';
                        break;
                    case 'blood whatman paper':
                        $reportAliquotKey = 'WHT';
                        break;
                    case 'centrifuged urine tube':
                        $reportAliquotKey = 'URN';
                        break;
                    case 'rna tube':
                        $reportAliquotKey = 'RNA';
                        break;
                    case 'dna tube':
                        $reportAliquotKey = 'DNA';
                        break;
                }
            }
            if ($reportAliquotKey) {
                $reportAliquotKey = "procure_" . str_replace('V', '', $res['Collection']['procure_visit']) . "_$reportAliquotKey";
                $nbrAliquot = ($res['AliquotMaster']['in_stock'] == 'no') ? '0' : $res['0']['nbr_of_aliquots'];
                if (! strlen($data[$participantId][0][$reportAliquotKey])) {
                    $data[$participantId][0][$reportAliquotKey] = $nbrAliquot;
                } else {
                    $data[$participantId][0][$reportAliquotKey] += $nbrAliquot;
                }
            }
        }
        if (sizeof($data) > Configure::read('databrowser_and_report_results_display_limit')) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => 'the report contains too many results - please redefine search criteria'
            );
        }
        
        if ($displayExactSearchWarning)
            AppController::addWarningMsg(__('all searches are considered as exact searches'));
        
        return array(
            'header' => $header,
            'data' => $data,
            'columns_names' => null,
            'error_msg' => null
        );
    }

    public function procureBcrDetection($parameters)
    {
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/TreatmentMasters/listall')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/EventMasters/listall')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        $displayExactSearchWarning = false;
        $header = null;
        $conditions = array(
            'TRUE'
        );
        if (isset($parameters['Participant']['id']) && ! empty($parameters['Participant']['id'])) {
            // From databrowser
            $participantIds = array_filter($parameters['Participant']['id']);
            if ($participantIds)
                $conditions[] = "Participant.id IN ('" . implode("','", $participantIds) . "')";
        } elseif (isset($parameters['Participant']['participant_identifier_start'])) {
            $participantIdentifierStart = (! empty($parameters['Participant']['participant_identifier_start'])) ? $parameters['Participant']['participant_identifier_start'] : null;
            $participantIdentifierEnd = (! empty($parameters['Participant']['participant_identifier_end'])) ? $parameters['Participant']['participant_identifier_end'] : null;
            if ($participantIdentifierStart)
                $conditions[] = "Participant.participant_identifier >= '$participantIdentifierStart'";
            if ($participantIdentifierEnd)
                $conditions[] = "Participant.participant_identifier <= '$participantIdentifierEnd'";
        } elseif (isset($parameters['Participant']['participant_identifier'])) {
            $displayExactSearchWarning = true;
            $participantIdentifiers = array_filter($parameters['Participant']['participant_identifier']);
            if ($participantIdentifiers)
                $conditions[] = "Participant.participant_identifier IN ('" . implode("','", $participantIdentifiers) . "')";
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (isset($parameters['0']['procure_participant_identifier_prefix'])) {
            $procureParticipantIdentifierPrefix = array_filter($parameters['0']['procure_participant_identifier_prefix']);
            if ($procureParticipantIdentifierPrefix) {
                $prefixConditions = array();
                foreach ($procureParticipantIdentifierPrefix as $prefix) {
                    if (! in_array($prefix, array(
                        's'
                    ))) {
                        $prefixConditions[] = "Participant.participant_identifier LIKE 'PS$prefix%'";
                    }
                }
                if ($prefixConditions) {
                    $conditions[] = '(' . implode(' OR ', $prefixConditions) . ')';
                } else {
                    $conditions[] = "Participant.participant_identifier LIKE '-1'";
                }
            }
        }
// *** PROCURE CHUM *****************************************************
        if (isset($parameters['MiscIdentifier']['identifier_value'])) {
            $noLabos = array_filter($parameters['MiscIdentifier']['identifier_value']);
            if ($noLabos)
                $conditions[] = "MiscIdentifier.identifier_value IN ('" . implode("','", $noLabos) . "')";
        } elseif (isset($parameters['MiscIdentifier']['identifier_value_start'])) {
            $identifierValueStart = (! empty($parameters['MiscIdentifier']['identifier_value_start'])) ? $parameters['MiscIdentifier']['identifier_value_start'] : null;
            $identifierValueEnd = (! empty($parameters['MiscIdentifier']['identifier_value_end'])) ? $parameters['MiscIdentifier']['identifier_value_end'] : null;
            if ($identifierValueStart)
                $conditions[] = "MiscIdentifier.identifier_value >= '$identifierValueStart'";
            if ($identifierValueEnd)
                $conditions[] = "MiscIdentifier.identifier_value <= '$identifierValueEnd'";
        }
//*** END PROCURE CHUM *****************************************************
        
        $procurePsaLevel = 0.2;
        if (isset($parameters['0']['procure_psa_level']['0']) && $parameters['0']['procure_psa_level']['0']) {
            $parameters['0']['procure_psa_level']['0'] = str_replace(',', '.', $parameters['0']['procure_psa_level']['0']);
            if (! preg_match('/^([0-9]+(\.[0-9]*){0,1}){0,1}$/', $parameters['0']['procure_psa_level']['0'])) {
                return array(
                    'header' => null,
                    'data' => null,
                    'columns_names' => null,
                    'error_msg' => 'wrong procure_psa_level value'
                );
            }
            $procurePsaLevel = $parameters['0']['procure_psa_level']['0'];
        }
        $procureNbrOfSuccesivePsa = 2;
        if (isset($parameters['0']['procure_nbr_of_succesive_psa']['0']) && $parameters['0']['procure_nbr_of_succesive_psa']['0']) {
            $procureNbrOfSuccesivePsa = $parameters['0']['procure_nbr_of_succesive_psa']['0'];
        }
        
        $header = array(
            'title' => __('report parameters'),
            'description' => __('psa level') . ' : ' . $procurePsaLevel . ' ng/ml & ' . __('number of successive PSA') . ' : ' . $procureNbrOfSuccesivePsa
        );
        
        // Get Controls Data
        $participantModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        $query = "SELECT id,event_type, detail_tablename FROM event_controls WHERE flag_active = 1;";
        $eventControls = array();
        foreach ($participantModel->query($query) as $res)
            $eventControls[$res['event_controls']['event_type']] = array(
                'id' => $res['event_controls']['id'],
                'detail_tablename' => $res['event_controls']['detail_tablename']
            );
        $query = "SELECT id,tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1;";
        $txControls = array();
        foreach ($participantModel->query($query) as $res) {
            $txControls[$res['treatment_controls']['tx_method']] = array(
                'id' => $res['treatment_controls']['id'],
                'detail_tablename' => $res['treatment_controls']['detail_tablename']
            );
        }
        
        $followupTreatmentControlId = $txControls['treatment']['id'];
        $followupTreatmentDetailTablename = $txControls['treatment']['detail_tablename'];
// *** PROCURE CHUM *****************************************************
        $query = "SELECT id, misc_identifier_name FROM misc_identifier_controls WHERE flag_active = 1 AND misc_identifier_name IN ('ramq nbr', 'prostate bank no lab');";
        $miscIdentifierControlIds = null;
        foreach ($participantModel->query($query) as $res)
            $miscIdentifierControlIds[$res['misc_identifier_controls']['misc_identifier_name']] = $res['misc_identifier_controls']['id'];
//*** END PROCURE CHUM *****************************************************
        
        // Get participants data
        $query = "SELECT
			Participant.id,
-- *** PROCURE CHUM *****************************************************
			MiscIdentifier.identifier_value,
-- *** END PROCURE CHUM *****************************************************
			Participant.participant_identifier
			FROM participants Participant
-- *** PROCURE CHUM *****************************************************
			LEFT JOIN misc_identifiers MiscIdentifier ON MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1 AND MiscIdentifier.misc_identifier_control_id = $miscIdentifierControlId
-- *** END PROCURE CHUM *****************************************************
            WHERE Participant.deleted <> 1 AND " . implode(' AND ', $conditions);
        $data = array();
        foreach ($participantModel->query($query) as $res) {
            $participantId = $res['Participant']['id'];
            $data[$participantId]['Participant'] = $res['Participant'];
//*** PROCURE CHUM *****************************************************
			$data[$participantId]['MiscIdentifier'] = $res['MiscIdentifier'];
//*** END PROCURE CHUM *****************************************************	
            $data[$participantId]['TreatmentMaster']['start_date'] = null;
            $data[$participantId]['TreatmentMaster']['start_date_accuracy'] = null;
            $data[$participantId]['0'] = array(
                'procure_inaccurate_date_use' => '',
                'procure_detected_pre_bcr_psa' => '',
                'procure_detected_pre_bcr_psa_date' => '',
                'procure_detected_pre_bcr_psa_date_accuracy' => '',
                'procure_detected_bcr_psa' => '',
                'procure_detected_bcr_psa_date' => '',
                'procure_detected_bcr_psa_date_accuracy' => '',
                'procure_detected_post_bcr_psa' => '',
                'procure_detected_post_bcr_psa_date' => '',
                'procure_detected_post_bcr_psa_date_accuracy' => '',
                'procure_atim_bcr_psa' => '',
                'procure_atim_bcr_psa_date' => '',
                'procure_atim_bcr_psa_date_accuracy' => '',
                'procure_detected_bcr_conclusion' => 'n/a'
            );
            $data[$participantId]['tmp_all_psa'] = array();
        }
        if (sizeof($data) > Configure::read('databrowser_and_report_results_display_limit')) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => 'the report contains too many results - please redefine search criteria'
            );
        }
        
        $participantIds = array_keys($data);
        $inaccurateDate = false;
        
        // Analyze participants treatments
        $treatmentModel = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
        $txJoin = array(
            'table' => $followupTreatmentDetailTablename,
            'alias' => 'TreatmentDetail',
            'type' => 'INNER',
            'conditions' => array(
                'TreatmentDetail.treatment_master_id = TreatmentMaster.id'
            )
        );
        // Get prostatectomy date
        $conditions = array(
            'TreatmentMaster.participant_id' => $participantIds,
            'TreatmentMaster.treatment_control_id' => $followupTreatmentControlId,
            'TreatmentMaster.start_date IS NOT NULL',
            "TreatmentDetail.treatment_type" => 'surgery',
            "TreatmentDetail.surgery_type LIKE 'prostatectomy%'"
        );
        $allParticipantsProstatectomy = $treatmentModel->find('all', array(
            'conditions' => $conditions,
            'joins' => array(
                $txJoin
            ),
            'order' => array(
                'TreatmentMaster.start_date ASC'
            )
        ));
        foreach ($allParticipantsProstatectomy as $newProstatectomy) {
            $participantId = $newProstatectomy['TreatmentMaster']['participant_id'];
            if (! $data[$participantId]['TreatmentMaster']['start_date']) {
                $data[$participantId]['TreatmentMaster']['start_date'] = $newProstatectomy['TreatmentMaster']['start_date'];
                $data[$participantId]['TreatmentMaster']['start_date_accuracy'] = $newProstatectomy['TreatmentMaster']['start_date_accuracy'];
            }
        }
        
        // Analyze participants psa
        $eventModel = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
        $eventControlId = $eventControls['laboratory']['id'];
        $allParticipantsPsa = $eventModel->find('all', array(
            'conditions' => array(
                'EventMaster.participant_id' => $participantIds,
                'EventMaster.event_control_id' => $eventControlId,
                'EventMaster.event_date IS NOT NULL'
            ),
            'order' => array(
                'EventMaster.event_date ASC'
            )
        ));
        $systemBcrEventMasterIds = array();
        foreach ($allParticipantsPsa as $newPsa) {
            $participantId = $newPsa['EventMaster']['participant_id'];
            $prostatectomyDate = $data[$participantId]['TreatmentMaster']['start_date'];
            $prostatectomyDateAccuracy = $data[$participantId]['TreatmentMaster']['start_date_accuracy'];
            if ($prostatectomyDate && $newPsa['EventMaster']['event_date'] > $prostatectomyDate) {
                // Check ATiM BCR
                if ($newPsa['EventDetail']['biochemical_relapse'] == 'y' && ! strlen($data[$participantId]['0']['procure_atim_bcr_psa'])) {
                    $data[$participantId]['0']['procure_atim_bcr_psa'] = $newPsa['EventDetail']['psa_total_ngml'];
                    $data[$participantId]['0']['procure_atim_bcr_psa_date'] = $this->procureFormatDate($newPsa['EventMaster']['event_date'], $newPsa['EventMaster']['event_date_accuracy']);
                    $data[$participantId]['0']['procure_atim_bcr_psa_date_accuracy'] = $newPsa['EventMaster']['event_date_accuracy'];
                    $this->procureSetBcrDetectionCcl($data[$participantId]['0']);
                }
                // Work on BCR detection
                if ($prostatectomyDateAccuracy != 'c' || $newPsa['EventMaster']['event_date_accuracy'] != 'c') {
                    $inaccurateDate = true;
                    $data[$participantId][0]['procure_inaccurate_date_use'] = 'y';
                }
                array_unshift($data[$participantId]['tmp_all_psa'], array(
                    $newPsa['EventDetail']['psa_total_ngml'],
                    $this->procureFormatDate($newPsa['EventMaster']['event_date'], $newPsa['EventMaster']['event_date_accuracy']),
                    $newPsa['EventMaster']['event_date_accuracy'],
                    $newPsa['EventMaster']['id']
                ));
                switch ($procureNbrOfSuccesivePsa) {
                    case '1':
                        if (! strlen($data[$participantId]['0']['procure_detected_bcr_psa'])) {
                            if ($data[$participantId]['tmp_all_psa']['0']['0'] >= $procurePsaLevel) {
                                // BCR
                                list ($data[$participantId]['0']['procure_detected_bcr_psa'], $data[$participantId]['0']['procure_detected_bcr_psa_date'], $data[$participantId]['0']['procure_detected_bcr_psa_date_accuracy'], $tmpEventMasterId) = $data[$participantId]['tmp_all_psa']['0'];
                                $this->procureSetBcrDetectionCcl($data[$participantId]['0']);
                                $systemBcrEventMasterIds[] = $tmpEventMasterId;
                                // Pre BCR
                                if (isset($data[$participantId]['tmp_all_psa']['1']))
                                    list ($data[$participantId]['0']['procure_detected_pre_bcr_psa'], $data[$participantId]['0']['procure_detected_pre_bcr_psa_date'], $data[$participantId]['0']['procure_detected_pre_bcr_psa_date_accuracy'], $tmpEventMasterId) = $data[$participantId]['tmp_all_psa']['1'];
                            }
                        } else {
                            if (! strlen($data[$participantId]['0']['procure_detected_post_bcr_psa'])) {
                                // Post BCR
                                list ($data[$participantId]['0']['procure_detected_post_bcr_psa'], $data[$participantId]['0']['procure_detected_post_bcr_psa_date'], $data[$participantId]['0']['procure_detected_post_bcr_psa_date_accuracy'], $tmpEventMasterId) = $data[$participantId]['tmp_all_psa']['0'];
                            }
                        }
                        break;
                    case '2':
                        if (sizeof($data[$participantId]['tmp_all_psa']) > 1) {
                            if (! strlen($data[$participantId]['0']['procure_detected_bcr_psa'])) {
                                if ($data[$participantId]['tmp_all_psa']['0']['0'] >= $procurePsaLevel && $data[$participantId]['tmp_all_psa']['1']['0'] >= $procurePsaLevel) {
                                    // Pre BCR
                                    if (sizeof($data[$participantId]['tmp_all_psa']) > 2)
                                        list ($data[$participantId]['0']['procure_detected_pre_bcr_psa'], $data[$participantId]['0']['procure_detected_pre_bcr_psa_date'], $data[$participantId]['0']['procure_detected_pre_bcr_psa_date_accuracy'], $tmpEventMasterId) = $data[$participantId]['tmp_all_psa']['2'];
                                        // BCR
                                    list ($data[$participantId]['0']['procure_detected_bcr_psa'], $data[$participantId]['0']['procure_detected_bcr_psa_date'], $data[$participantId]['0']['procure_detected_bcr_psa_date_accuracy'], $tmpEventMasterId) = $data[$participantId]['tmp_all_psa']['1'];
                                    $this->procureSetBcrDetectionCcl($data[$participantId]['0']);
                                    $systemBcrEventMasterIds[] = $tmpEventMasterId;
                                    // Post BCR
                                    list ($data[$participantId]['0']['procure_detected_post_bcr_psa'], $data[$participantId]['0']['procure_detected_post_bcr_psa_date'], $data[$participantId]['0']['procure_detected_post_bcr_psa_date_accuracy'], $tmpEventMasterId) = $data[$participantId]['tmp_all_psa']['0'];
                                }
                            }
                        }
                        break;
                    default:
                        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            } elseif ($newPsa['EventDetail']['biochemical_relapse'] == 'y' && ! strlen($data[$participantId]['0']['procure_atim_bcr_psa'])) {
                // No prostatectomy or BCR flagged before prostatectomy date
                $data[$participantId]['0']['procure_atim_bcr_psa'] = $newPsa['EventDetail']['psa_total_ngml'];
                $data[$participantId]['0']['procure_atim_bcr_psa_date'] = $this->procureFormatDate($newPsa['EventMaster']['event_date'], $newPsa['EventMaster']['event_date_accuracy']);
                $data[$participantId]['0']['procure_atim_bcr_psa_date_accuracy'] = $newPsa['EventMaster']['event_date_accuracy'];
                $this->procureSetBcrDetectionCcl($data[$participantId]['0']);
            }
        }
        
        if ($parameters['0']['update_system_biochemical_relapse']['0'] == '1') {
            // Update field procure_ed_laboratories.system_biochemical_relapse
            // (to limit the number of records into revs tables (event_masters and particiants), update is done directly into table to bypass the record into revs)
            $updateQuery = "UPDATE event_masters EventMaster, procure_ed_laboratories EventDetail
                SET EventDetail.system_biochemical_relapse = ''
                WHERE EventMaster.participant_id IN ('" . implode("','", $participantIds) . "')
                AND EventMaster.id = EventDetail.event_master_id;";
            $treatmentModel->tryCatchQuery($updateQuery);
            if ($systemBcrEventMasterIds) {
                $updateQuery = "UPDATE event_masters EventMaster, procure_ed_laboratories EventDetail
                    SET EventDetail.system_biochemical_relapse = 'y'
                    WHERE EventMaster.id IN ('" . implode("','", $systemBcrEventMasterIds) . "')
                    AND EventMaster.id = EventDetail.event_master_id;";
                $treatmentModel->tryCatchQuery($updateQuery);
            }
            AppController::addWarningMsg(__('updated field procure_ed_laboratories.system_biochemical_relapse of the listed participants'));
        }
        
        if ($inaccurateDate)
            AppController::addWarningMsg(__('at least one participant summary is based on inaccurate date'));
        
        if ($displayExactSearchWarning)
            AppController::addWarningMsg(__('all searches are considered as exact searches'));
        
        return array(
            'header' => $header,
            'data' => $data,
            'columns_names' => null,
            'error_msg' => null
        );
    }

    public function procureSetBcrDetectionCcl(&$bcrParticipantData)
    {
        if (! strlen($bcrParticipantData['procure_detected_bcr_psa'] . $bcrParticipantData['procure_atim_bcr_psa'])) {
            $bcrParticipantData['procure_detected_bcr_conclusion'] = 'n/a';
        } elseif ($bcrParticipantData['procure_detected_bcr_psa'] == $bcrParticipantData['procure_atim_bcr_psa'] && $bcrParticipantData['procure_detected_bcr_psa_date'] == $bcrParticipantData['procure_atim_bcr_psa_date'] && $bcrParticipantData['procure_detected_bcr_psa_date_accuracy'] == $bcrParticipantData['procure_atim_bcr_psa_date_accuracy']) {
            $bcrParticipantData['procure_detected_bcr_conclusion'] = 'identical';
        } else {
            $bcrParticipantData['procure_detected_bcr_conclusion'] = 'different';
        }
    }

    public function procureNextFollowupReport($parameters)
    {
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/TreatmentMasters/listall')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/EventMasters/listall')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        $displayExactSearchWarning = false;
        $header = null;
        $conditions = array(
            'TRUE'
        );
        if (isset($parameters['Participant']['id']) && ! empty($parameters['Participant']['id'])) {
            // From databrowser
            $participantIds = array_filter($parameters['Participant']['id']);
            if ($participantIds)
                $conditions[] = "Participant.id IN ('" . implode("','", $participantIds) . "')";
        } elseif (isset($parameters['Participant']['participant_identifier_start'])) {
            $participantIdentifierStart = (! empty($parameters['Participant']['participant_identifier_start'])) ? $parameters['Participant']['participant_identifier_start'] : null;
            $participantIdentifierEnd = (! empty($parameters['Participant']['participant_identifier_end'])) ? $parameters['Participant']['participant_identifier_end'] : null;
            if ($participantIdentifierStart)
                $conditions[] = "Participant.participant_identifier >= '$participantIdentifierStart'";
            if ($participantIdentifierEnd)
                $conditions[] = "Participant.participant_identifier <= '$participantIdentifierEnd'";
        } elseif (isset($parameters['Participant']['participant_identifier'])) {
            $displayExactSearchWarning = true;
            $participantIdentifiers = array_filter($parameters['Participant']['participant_identifier']);
            if ($participantIdentifiers)
                $conditions[] = "Participant.participant_identifier IN ('" . implode("','", $participantIdentifiers) . "')";
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
// *** PROCURE CHUM *****************************************************
        if (isset($parameters['MiscIdentifier']['identifier_value'])) {
            $noLabos = array_filter($parameters['MiscIdentifier']['identifier_value']);
            if ($noLabos)
                $conditions[] = "MiscIdentifier.identifier_value IN ('" . implode("','", $noLabos) . "')";
        } elseif (isset($parameters['MiscIdentifier']['identifier_value_start'])) {
            $identifierValueStart = (! empty($parameters['MiscIdentifier']['identifier_value_start'])) ? $parameters['MiscIdentifier']['identifier_value_start'] : null;
            $identifierValueEnd = (! empty($parameters['MiscIdentifier']['identifier_value_end'])) ? $parameters['MiscIdentifier']['identifier_value_end'] : null;
            if ($identifierValueStart)
                $conditions[] = "MiscIdentifier.identifier_value >= '$identifierValueStart'";
            if ($identifierValueEnd)
                $conditions[] = "MiscIdentifier.identifier_value <= '$identifierValueEnd'";
        }
//*** END PROCURE CHUM *****************************************************
        
        $lastRecordNbr = 3;
        
        $participantModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        $miscIdentifierModel = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
        $treatmentModel = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
        $eventModel = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
        $drugModel = AppModel::getInstance("Drug", "Drug", true);
        $flagShowConfidential = $this->Session->read('flag_show_confidential');
        $StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
        
        App::uses('StructureValueDomain', 'Model');
        $this->StructureValueDomain = new StructureValueDomain();
        $procureOtherTumorSites = $this->StructureValueDomain->find('first', array(
            'conditions' => array(
                'StructureValueDomain.domain_name' => 'procure_other_tumor_sites'
            ),
            'recursive' => 2
        ));
        $procureOtherTumorSitesValues = array();
        if ($procureOtherTumorSites) {
            foreach ($procureOtherTumorSites['StructurePermissibleValue'] as $newValue) {
                $procureOtherTumorSitesValues[$newValue['value']] = __($newValue['language_alias']);
            }
        }
        $procureOtherTumorSitesValues[''] = '';
        
        $procureFollowupClinicalMethods = $this->StructureValueDomain->find('first', array(
            'conditions' => array(
                'StructureValueDomain.domain_name' => 'procure_followup_clinical_methods'
            ),
            'recursive' => 2
        ));
        $procureFollowupClinicalMethodsValues = array();
        if ($procureFollowupClinicalMethods) {
            foreach ($procureFollowupClinicalMethods['StructurePermissibleValue'] as $newValue) {
                $procureFollowupClinicalMethodsValues[$newValue['value']] = __($newValue['language_alias']);
            }
        }
        $procureFollowupClinicalMethodsValues[''] = '';
        
        $query = "SELECT id,event_type, detail_tablename FROM event_controls WHERE flag_active = 1;";
        $eventControls = array();
        foreach ($participantModel->query($query) as $res)
            $eventControls[$res['event_controls']['event_type']] = array(
                'id' => $res['event_controls']['id'],
                'detail_tablename' => $res['event_controls']['detail_tablename']
            );
        $query = "SELECT id,tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1;";
        $txControls = array();
        foreach ($participantModel->query($query) as $res) {
            $txControls[$res['treatment_controls']['tx_method']] = array(
                'id' => $res['treatment_controls']['id'],
                'detail_tablename' => $res['treatment_controls']['detail_tablename']
            );
        }

// *** PROCURE CHUM *****************************************************
        $query = "SELECT id, misc_identifier_name FROM misc_identifier_controls WHERE flag_active = 1 AND misc_identifier_name IN ('ramq nbr', 'prostate bank no lab');";
        $miscIdentifierControlIds = null;
        foreach ($participantModel->query($query) as $res)
            $miscIdentifierControlIds[$res['misc_identifier_controls']['misc_identifier_name']] = $res['misc_identifier_controls']['id'];
//*** END PROCURE CHUM *****************************************************
        
        // Get participants data
        
        $participantsWithRefusalOrWithrawal = array();
        
        $recordTemplate = array(
            '0' => array(
                'procure_next_followup_data' => '',
                'procure_next_followup_data_precision' => '',
                'procure_next_followup_value' => '',
                'procure_next_followup_date' => '',
                'procure_next_followup_finish_date' => '',
                'procure_next_followup_data_notes' => ''
            )
        );
        
        $query = "SELECT
			Participant.id,
			Participant.participant_identifier,
-- *** PROCURE CHUM *****************************************************
			MiscIdentifier.identifier_value,
-- *** END PROCURE CHUM *****************************************************
			Participant.first_name,
			Participant.last_name,
			Participant.date_of_birth,
			Participant.date_of_birth_accuracy,
		    Participant.notes,
		    procure_patient_withdrawn,
		    procure_next_collections_refusal,
		    procure_next_visits_refusal,
		    procure_refusal_to_be_contacted,
		    procure_clinical_file_update_refusal	    
			FROM participants Participant
-- *** PROCURE CHUM *****************************************************
			LEFT JOIN misc_identifiers MiscIdentifier ON MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1 AND MiscIdentifier.misc_identifier_control_id = $miscIdentifierControlId
-- *** END PROCURE CHUM *****************************************************
            WHERE Participant.deleted <> 1 AND " . implode(' AND ', $conditions);
        $participantData = $participantModel->query($query);
        if (sizeof($participantData) > 10) {
            return array(
                'header' => null,
                'data' => null,
                'columns_names' => null,
                'error_msg' => 'the report contains too many results - please redefine search criteria'
            );
        }
        
        $data = array();
        $isFirstParticipant = true;
        foreach ($participantData as $newParticipant) {
            if (! $isFirstParticipant) {
                // *** Separate participants ***
                for ($tmp = 1; $tmp < 4; $tmp ++) {
                    $data[] = $recordTemplate;
                }
            }
            $isFirstParticipant = false;
            
            $newParticipantId = $newParticipant['Participant']['id'];
            
            // *** Patient Profile ***
            
            $newData = $recordTemplate;
            $newData['0']['procure_next_followup_data'] = '# PROCURE';
            $newData['0']['procure_next_followup_value'] = $newParticipant['Participant']['participant_identifier'];
            $newData['0']['procure_next_followup_date'] = '';
            $newData['0']['procure_next_followup_finish_date'] = '';
            $newData['0']['procure_next_followup_data_notes'] = $newParticipant['Participant']['notes'];
            
            if ($newParticipant['Participant']['procure_patient_withdrawn']) {
                $participantsWithRefusalOrWithrawal[] = $newParticipant['Participant']['participant_identifier'];
                $newData['0']['procure_next_followup_value'] .= ' -- ' . __('warning') . ' : ' . __('patient withdrawn');
            } else {
                $refusalDetails = array();
                if ($newParticipant['Participant']['procure_next_collections_refusal'])
                    $refusalDetails[] = __('refusal to participate to next collections');
                if ($newParticipant['Participant']['procure_next_visits_refusal'])
                    $refusalDetails[] = __('refusal to participate to next visits');
                if ($newParticipant['Participant']['procure_refusal_to_be_contacted'])
                    $refusalDetails[] = __('refusal to be contacted');
                if ($newParticipant['Participant']['procure_clinical_file_update_refusal'])
                    $refusalDetails[] = __('clinical file update refusal');
                if ($refusalDetails) {
                    $participantsWithRefusalOrWithrawal[] = $newParticipant['Participant']['participant_identifier'];
                    $newData['0']['procure_next_followup_value'] .= ' -- ' . __('warning') . ' : ' . implode(' & ', $refusalDetails) . '.';
                }
            }
            
            $data[] = $newData;
            
            if ($flagShowConfidential) {
                $newData = $recordTemplate;
                $newData['0']['procure_next_followup_data'] = __('name');
                $newData['0']['procure_next_followup_value'] = $newParticipant['Participant']['first_name'] . ' ' . $newParticipant['Participant']['last_name'];
                $data[] = $newData;
                $newData = $recordTemplate;
                $newData['0']['procure_next_followup_data'] = __('date of birth');
                $newData['0']['procure_next_followup_value'] = $this->procureFormatDate($newParticipant['Participant']['date_of_birth'], $newParticipant['Participant']['date_of_birth_accuracy']);
                $data[] = $newData;
            }
            
            // *** Patient Identifiers ***
            
            foreach ($miscIdentifierModel->find('all', array(
                'conditions' => array(
                    'MiscIdentifier.participant_id' => $newParticipantId,
                    'MiscIdentifierControl.misc_identifier_name' => array(
                        'hospital number',
//*** PROCURE CHUM *****************************************************                      
                        'prostate bank no lab',
//*** PROCURE CHUM *****************************************************
                        'ramq'
                    )
                )
            )) as $newIdentifier) {
                $newData = $recordTemplate;
                $newData['0']['procure_next_followup_data'] = __($newIdentifier['MiscIdentifierControl']['misc_identifier_name']);
                $newData['0']['procure_next_followup_value'] = (! $flagShowConfidential && $newIdentifier['MiscIdentifierControl']['flag_confidential']) ? CONFIDENTIAL_MARKER : $newIdentifier['MiscIdentifier']['identifier_value'];
                $data[] = $newData;
            }
            
            // *** Last visit ***
            
            $newData = $recordTemplate;
            $newData['0']['procure_next_followup_data'] = __('last visit');
            $lastData = $eventModel->find('first', array(
                'conditions' => array(
                    'EventMaster.participant_id' => $newParticipantId,
                    'EventControl.event_type' => 'visit/contact'
                ),
                'order' => 'EventMaster.event_date DESC'
            ));
            if (! $lastData) {
                $newData['0']['procure_next_followup_value'] = __('none');
            } else {
                $lastVisitDate = $this->procureFormatDate($lastData['EventMaster']['event_date'], $lastData['EventMaster']['event_date_accuracy']);
                $lastVisitDate = $lastVisitDate ? $lastVisitDate : __('unknown');
                $lastVisitMethod = $lastData['EventDetail']['method'] ? ' (' . $procureFollowupClinicalMethodsValues[$lastData['EventDetail']['method']] . ')' : '';
                $newData['0']['procure_next_followup_value'] = $lastVisitDate . $lastVisitMethod;
            }
            $data[] = $newData;
            
            // *** Collection data for new visit ***
            
            $dataForNewVisit = array(
                array(
                    'procure_next_followup_data' => __('visit date'),
                    'procure_next_followup_value' => ' ______ / ___ / ___'
                ),
                array(
                    'procure_next_followup_data' => __('blood collection'),
                    'procure_next_followup_value' => __('time') . ' ___ : ___'
                ),
                array(
                    'procure_next_followup_data' => '',
                    'procure_next_followup_value' => __('collected by') . ' _____________________'
                ),
                array(
                    'procure_next_followup_value' => __('serum') . ' (' . __('yellow') . ') ___ --- ' . __('EDTA') . ' (' . __('purple') . ') ___  --- ' . __('paxgene') . ' (' . __('brown') . ') ___'
                ),
                array(
                    'procure_next_followup_data' => __('urine collection'),
                    'procure_next_followup_value' => __('time') . ' ___ : ___'
                ),
                array(
                    'procure_next_followup_data' => '',
                    'procure_next_followup_value' => __('collected volume') . ' (ml) ___'
                ),
                array(
                    'procure_next_followup_value' => __('aspect at reception') . ' : ' . __('clear') . ' [ _ ] --- ' . __('turbidity') . ' [ _ ] --- ' . __('other') . ' [ _ ] ' . __('precision') . ' _____________________'
                ),
                array(
                    'procure_next_followup_value' => __('hematuria') . ' : ' . __('yes') . ' [ _ ] / ' . __('no') . ' [ _ ]'
                ),
                array(
                    'procure_next_followup_value' => __('urine was collected via a urinary catheter') . ' : ' . __('yes') . ' [ _ ] / ' . __('no') . ' [ _ ]'
                )
            );
            foreach ($dataForNewVisit as $tmpNewLineData) {
                $data[]['0'] = array_merge($recordTemplate['0'], $tmpNewLineData);
            }
            
            // *** Line Separator ***
            
            // *** Prostatectomy ***
            
            $txJoin = array(
                'table' => $txControls['treatment']['detail_tablename'],
                'alias' => 'TreatmentDetail',
                'type' => 'INNER',
                'conditions' => array(
                    'TreatmentDetail.treatment_master_id = TreatmentMaster.id'
                )
            );
            $prostatectomyData = $treatmentModel->find('first', array(
                'conditions' => array(
                    'TreatmentMaster.participant_id' => $newParticipantId,
                    'TreatmentControl.tx_method' => 'treatment',
                    'TreatmentDetail.surgery_type' => array(
                        'prostatectomy',
                        'prostatectomy aborted'
                    )
                ),
                'order' => 'TreatmentMaster.start_date ASC',
                'joins' => array(
                    $txJoin
                )
            ));
            $newData = $recordTemplate;
            $newData['0']['procure_next_followup_data'] = __('prostatectomy');
            if ($prostatectomyData) {
                if ($prostatectomyData['TreatmentDetail']['surgery_type'] == 'prostatectomy aborted')
                    $newData['0']['procure_next_followup_data'] .= ' (' . __('aborted') . ')';
                if (empty($prostatectomyData['TreatmentMaster']['start_date'])) {
                    $newData['0']['procure_next_followup_value'] = __('date') . ' : ' . __('unknown');
                } else {
                    $newData['0']['procure_next_followup_date'] = $this->procureFormatDate($prostatectomyData['TreatmentMaster']['start_date'], $prostatectomyData['TreatmentMaster']['start_date_accuracy']);
                    $datetime1 = new DateTime($prostatectomyData['TreatmentMaster']['start_date']);
                    $datetime2 = new DateTime(date("Y-m-d"));
                    $interval = $datetime1->diff($datetime2);
                    if (! $interval->invert) {
                        $newData['0']['procure_next_followup_value'] = __('time past (months)') . ' : ' . (($interval->format('%y') * 12) + $interval->format('%m'));
                        if ($prostatectomyData['TreatmentMaster']['start_date_accuracy'] != 'c')
                            $newData['0']['procure_next_followup_value'] .= ' (' . __('inaccurate date use') . ')';
                    }
                }
                $newData['0']['procure_next_followup_data_notes'] = $prostatectomyData['TreatmentMaster']['notes'];
            } else {
                $newData['0']['procure_next_followup_value'] = __('none');
            }
            $data[] = $newData;
            
            // *** CRPC***
            
            $newData = $recordTemplate;
            $newData['0']['procure_next_followup_data'] = __('CRPC');
            $evJoin = array(
                'table' => $eventControls['clinical note']['detail_tablename'],
                'alias' => 'EventDetail',
                'type' => 'INNER',
                'conditions' => array(
                    'EventDetail.event_master_id = EventMaster.id'
                )
            );
            $lastData = $eventModel->find('first', array(
                'conditions' => array(
                    'EventMaster.participant_id' => $newParticipantId,
                    'EventControl.event_type' => 'clinical note',
                    'EventDetail.type' => 'CRPC'
                ),
                'joins' => array(
                    $evJoin
                )
            ));
            $newData['0']['procure_next_followup_value'] = (! $lastData) ? __('no') : __('yes');
            $data[] = $newData;
            
            // *** Clinical Relapse ***
            
            $evJoin = array(
                'table' => $eventControls['clinical exam']['detail_tablename'],
                'alias' => 'EventDetail',
                'type' => 'INNER',
                'conditions' => array(
                    'EventDetail.event_master_id = EventMaster.id'
                )
            );
            $allAtimData = $eventModel->find('all', array(
                'conditions' => array(
                    'EventMaster.participant_id' => $newParticipantId,
                    'EventControl.event_type' => 'clinical exam',
                    "EventDetail.clinical_relapse = 'y'"
                ),
                'joins' => array(
                    $evJoin
                )
            ));
            $newData = $recordTemplate;
            $newData['0']['procure_next_followup_data'] = __('clinical relapse');
            if (! $allAtimData) {
                $newData['0']['procure_next_followup_value'] = __('none');
                $data[] = $newData;
            } else {
                $allClinicalRelapses = array();
                foreach ($allAtimData as $atimData) {
                    $progressionComorbidity = $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Progressions & Comorbidities (PROCURE values only)', $atimData['EventDetail']['progression_comorbidity']);
                    $eventDate = $this->procureFormatDate($atimData['EventMaster']['event_date'], $atimData['EventMaster']['event_date_accuracy']);
                    if ($progressionComorbidity || $eventDate) {
                        $allClinicalRelapses[$eventDate . '-' . $progressionComorbidity] = array(
                            ($progressionComorbidity ? $progressionComorbidity : __('undefined')),
                            $eventDate
                        );
                    }
                }
                if (empty($allClinicalRelapses)) {
                    $newData['0']['procure_next_followup_value'] = __('yes') . ' - ' . __('undefined');
                    $data[] = $newData;
                } else {
                    krsort($allClinicalRelapses);
                    foreach ($allClinicalRelapses as $clinicalRelapse) {
                        list ($newData['0']['procure_next_followup_value'], $newData['0']['procure_next_followup_date']) = $clinicalRelapse;
                        $data[] = $newData;
                        $newData['0']['procure_next_followup_data'] = '';
                    }
                }
            }
            
            // *** Biochemical Relapse ***
            
            $evJoin = array(
                'table' => $eventControls['laboratory']['detail_tablename'],
                'alias' => 'EventDetail',
                'type' => 'INNER',
                'conditions' => array(
                    'EventDetail.event_master_id = EventMaster.id'
                )
            );
            $allAtimData = $eventModel->find('all', array(
                'conditions' => array(
                    'EventMaster.participant_id' => $newParticipantId,
                    'EventControl.event_type' => 'laboratory',
                    "EventDetail.biochemical_relapse = 'y'"
                ),
                'joins' => array(
                    $evJoin
                )
            ));
            $newData = $recordTemplate;
            $newData['0']['procure_next_followup_data'] = __('biochemical relapse');
            if (! $allAtimData) {
                $newData['0']['procure_next_followup_value'] = __('none');
                $data[] = $newData;
            } else {
                $allBiochemicalRelapses = array();
                foreach ($allAtimData as $atimData) {
                    $psa = strlen($atimData['EventDetail']['psa_total_ngml']) ? $atimData['EventDetail']['psa_total_ngml'] . ' (ng/ml)' : '';
                    $eventDate = $this->procureFormatDate($atimData['EventMaster']['event_date'], $atimData['EventMaster']['event_date_accuracy']);
                    if ($eventDate || strlen($psa)) {
                        $allBiochemicalRelapses[$eventDate . '-' . $psa] = array(
                            (strlen($psa) ? $psa : __('undefined')),
                            $eventDate
                        );
                    }
                }
                if (empty($allBiochemicalRelapses)) {
                    $newData['0']['procure_next_followup_value'] = __('yes') . ' - ' . __('undefined');
                    $data[] = $newData;
                } else {
                    ksort($allBiochemicalRelapses);
                    foreach ($allBiochemicalRelapses as $biochemicalRelapse) {
                        list ($newData['0']['procure_next_followup_value'], $newData['0']['procure_next_followup_date']) = $biochemicalRelapse;
                        $data[] = $newData;
                        $newData['0']['procure_next_followup_data'] = '';
                    }
                }
            }
            
            // *** Other Tumors ***
            
            $allAtimData = $eventModel->find('all', array(
                'conditions' => array(
                    'EventMaster.participant_id' => $newParticipantId,
                    'EventControl.event_type' => 'other tumor diagnosis'
                )
            ));
            $newData = $recordTemplate;
            $newData['0']['procure_next_followup_data'] = __('other tumor diagnosis');
            if (! $allAtimData) {
                $newData['0']['procure_next_followup_value'] = __('none');
                $data[] = $newData;
            } else {
                $allTumorSites = array();
                foreach ($allAtimData as $atimData) {
                    $tumorSite = $procureOtherTumorSitesValues[$atimData['EventDetail']['tumor_site']];
                    $eventDate = $this->procureFormatDate($atimData['EventMaster']['event_date'], $atimData['EventMaster']['event_date_accuracy']);
                    if ($tumorSite || $eventDate) {
                        $allTumorSites[$eventDate . '-' . $tumorSite] = array(
                            ($tumorSite ? $tumorSite : __('undefined')),
                            $eventDate
                        );
                    }
                }
                if (empty($allTumorSites)) {
                    $newData['0']['procure_next_followup_value'] = __('yes') . ' - ' . __('undefined');
                    $data[] = $newData;
                } else {
                    krsort($allTumorSites);
                    foreach ($allTumorSites as $tumorSite) {
                        list ($newData['0']['procure_next_followup_value'], $newData['0']['procure_next_followup_date']) = $tumorSite;
                        $data[] = $newData;
                        $newData['0']['procure_next_followup_data'] = '';
                    }
                }
            }
            
            // *** Last PSA ***
            
            $evJoin = array(
                'table' => $eventControls['laboratory']['detail_tablename'],
                'alias' => 'EventDetail',
                'type' => 'INNER',
                'conditions' => array(
                    'EventDetail.event_master_id = EventMaster.id'
                )
            );
            $allAtimData = $eventModel->find('all', array(
                'conditions' => array(
                    'EventMaster.participant_id' => $newParticipantId,
                    'EventControl.event_type' => 'laboratory',
                    'OR' => array(
                        array(
                            'EventDetail.psa_total_ngml IS NOT NULL',
                            "EventDetail.psa_total_ngml NOT LIKE ''"
                        ),
                        'EventDetail.biochemical_relapse' => 'y'
                    )
                ),
                'joins' => array(
                    $evJoin
                ),
                'order' => 'EventMaster.event_date DESC',
                'limit' => $lastRecordNbr
            ));
            if (! $allAtimData) {
                $newData = $recordTemplate;
                $newData['0']['procure_next_followup_data'] = __('last psa') . ' - ' . __('total ng/ml');
                $newData['0']['procure_next_followup_value'] = __('none');
                $data[] = $newData;
            } else {
                $isFirstRecord = true;
                foreach ($allAtimData as $atimData) {
                    $newData = $recordTemplate;
                    $newData['0']['procure_next_followup_data'] = $isFirstRecord ? __('last psa') . ' - ' . __('total ng/ml') : '';
                    $newData['0']['procure_next_followup_value'] = (strlen($atimData['EventDetail']['psa_total_ngml']) ? $atimData['EventDetail']['psa_total_ngml'] : '?') . (($atimData['EventDetail']['biochemical_relapse'] == 'y') ? ' (BCR)' : '');
                    $newData['0']['procure_next_followup_date'] = $this->procureFormatDate($atimData['EventMaster']['event_date'], $atimData['EventMaster']['event_date_accuracy']);
                    $data[] = $newData;
                    $isFirstRecord = false;
                }
            }
            
            // *** Last Testosterone ***
            
            $evJoin = array(
                'table' => $eventControls['laboratory']['detail_tablename'],
                'alias' => 'EventDetail',
                'type' => 'INNER',
                'conditions' => array(
                    'EventDetail.event_master_id = EventMaster.id'
                )
            );
            $allAtimData = $eventModel->find('all', array(
                'conditions' => array(
                    'EventMaster.participant_id' => $newParticipantId,
                    'EventControl.event_type' => 'laboratory',
                    'EventDetail.testosterone_nmoll IS NOT NULL',
                    "EventDetail.testosterone_nmoll NOT LIKE ''"
                ),
                'joins' => array(
                    $evJoin
                ),
                'order' => 'EventMaster.event_date DESC',
                'limit' => $lastRecordNbr
            ));
            if (! $allAtimData) {
                $newData = $recordTemplate;
                $newData['0']['procure_next_followup_data'] = __('last testosterone - nmol/l');
                $newData['0']['procure_next_followup_value'] = __('none');
                $data[] = $newData;
            } else {
                $isFirstRecord = true;
                foreach ($allAtimData as $atimData) {
                    $newData = $recordTemplate;
                    $newData['0']['procure_next_followup_data'] = $isFirstRecord ? __('last testosterone - nmol/l') : '';
                    $newData['0']['procure_next_followup_value'] = (strlen($atimData['EventDetail']['testosterone_nmoll']) ? $atimData['EventDetail']['testosterone_nmoll'] : '?') . (($atimData['EventDetail']['biochemical_relapse'] == 'y') ? ' (BCR)' : '');
                    $newData['0']['procure_next_followup_date'] = $this->procureFormatDate($atimData['EventMaster']['event_date'], $atimData['EventMaster']['event_date_accuracy']);
                    $data[] = $newData;
                    $isFirstRecord = false;
                }
            }
            
            // *** Last clinical event ***
            
            $subDataSpace = ' . . . . . . . . : ';
            
            $allAtimData = $eventModel->find('all', array(
                'conditions' => array(
                    'EventMaster.participant_id' => $newParticipantId,
                    'EventControl.event_type' => 'clinical exam'
                ),
                'order' => 'EventMaster.event_date DESC',
                'limit' => $lastRecordNbr
            ));
            $newData = $recordTemplate;
            $newData['0']['procure_next_followup_data'] = __('last clinical event');
            if (! $allAtimData) {
                $newData['0']['procure_next_followup_value'] = __('none');
                $data[] = $newData;
            } else {
                $data[] = $newData;
                foreach ($allAtimData as $atimData) {
                    $newData = $recordTemplate;
                    $newData['0']['procure_next_followup_data'] = $subDataSpace . $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Clinical Exam - Types (PROCURE values only)', $atimData['EventDetail']['type']);
                    $newData['0']['procure_next_followup_value'] = implode(' - ', array_filter(array(
                        $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Clinical Exam - Sites (PROCURE values only)', $atimData['EventDetail']['site_precision']),
                        $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Clinical Exam - Results (PROCURE values only)', $atimData['EventDetail']['results']),
                        $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Progressions & Comorbidities (PROCURE values only)', $atimData['EventDetail']['progression_comorbidity']),
                        (($atimData['EventDetail']['clinical_relapse'] == 'y') ? __('clinical relapse') : '')
                    )));
                    $newData['0']['procure_next_followup_date'] = $this->procureFormatDate($atimData['EventMaster']['event_date'], $atimData['EventMaster']['event_date_accuracy']);
                    $newData['0']['procure_next_followup_data_notes'] = $atimData['EventMaster']['event_summary'];
                    $data[] = $newData;
                }
            }
            
            // *** Last completed treatment ***
            
            $allAtimData = $treatmentModel->find('all', array(
                'conditions' => array(
                    'TreatmentMaster.participant_id' => $newParticipantId,
                    'TreatmentControl.tx_method' => 'treatment',
                    'TreatmentMaster.finish_date IS NOT NULL'
                ),
                'order' => 'TreatmentMaster.finish_date DESC',
                'limit' => $lastRecordNbr
            ));
            $newData = $recordTemplate;
            $newData['0']['procure_next_followup_data'] = __('last completed treatment');
            if (! $allAtimData) {
                $newData['0']['procure_next_followup_value'] = __('none');
                $data[] = $newData;
            } else {
                $data[] = $newData;
                foreach ($allAtimData as $atimData) {
                    $newData = $recordTemplate;
                    $newData['0']['procure_next_followup_data'] = $subDataSpace . $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Treatment Types (PROCURE values only)', $atimData['TreatmentDetail']['treatment_type']);
                    $newData['0']['procure_next_followup_value'] = implode(' - ', array_filter(array(
                        $atimData['Drug']['generic_name'],
                        (strlen($atimData['TreatmentDetail']['dosage']) ? __('dose') . ': ' . $atimData['TreatmentDetail']['dosage'] : ''),
                        (strlen($atimData['TreatmentDetail']['duration']) ? __('frequency') . ': ' . $atimData['TreatmentDetail']['duration'] : ''),
                        $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Treatment Sites (PROCURE values only)', $atimData['TreatmentDetail']['treatment_site']),
                        $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Treatment Precisions (PROCURE values only)', $atimData['TreatmentDetail']['treatment_precision']),
                        $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Surgery Types (PROCURE values only)', $atimData['TreatmentDetail']['surgery_type'])
                    )));
                    $newData['0']['procure_next_followup_date'] = $this->procureFormatDate($atimData['TreatmentMaster']['start_date'], $atimData['TreatmentMaster']['start_date_accuracy']);
                    $newData['0']['procure_next_followup_finish_date'] = $this->procureFormatDate($atimData['TreatmentMaster']['finish_date'], $atimData['TreatmentMaster']['finish_date_accuracy']);
                    $newData['0']['procure_next_followup_data_notes'] = $atimData['TreatmentMaster']['notes'];
                    $data[] = $newData;
                }
            }
            
            // *** Ongoing treatment : tx ***
            
            $allAtimData = $treatmentModel->find('all', array(
                'conditions' => array(
                    'TreatmentMaster.participant_id' => $newParticipantId,
                    'TreatmentControl.tx_method' => 'treatment',
                    'TreatmentMaster.finish_date IS NULL'
                ),
                'order' => 'TreatmentMaster.start_date DESC'
            ));
            $newData = $recordTemplate;
            $newData['0']['procure_next_followup_data'] = __('ongoing treatment');
            if ($allAtimData) {
                $data[] = $newData;
                foreach ($allAtimData as $atimData) {
                    $newData = $recordTemplate;
                    $newData['0']['procure_next_followup_data'] = $subDataSpace . $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Treatment Types (PROCURE values only)', $atimData['TreatmentDetail']['treatment_type']);
                    $newData['0']['procure_next_followup_value'] = implode(' - ', array_filter(array(
                        $atimData['Drug']['generic_name'],
                        (strlen($atimData['TreatmentDetail']['dosage']) ? __('dose') . ': ' . $atimData['TreatmentDetail']['dosage'] : ''),
                        (strlen($atimData['TreatmentDetail']['duration']) ? __('frequency') . ': ' . $atimData['TreatmentDetail']['duration'] : ''),
                        $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Treatment Sites (PROCURE values only)', $atimData['TreatmentDetail']['treatment_site']),
                        $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Treatment Precisions (PROCURE values only)', $atimData['TreatmentDetail']['treatment_precision']),
                        $StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('Surgery Types (PROCURE values only)', $atimData['TreatmentDetail']['surgery_type'])
                    )));
                    $procureNextFollowupDate = $this->procureFormatDate($atimData['TreatmentMaster']['start_date'], $atimData['TreatmentMaster']['start_date_accuracy']);
                    $newData['0']['procure_next_followup_date'] = strlen($procureNextFollowupDate) ? $procureNextFollowupDate : '______ / ___ / ___';
                    $newData['0']['procure_next_followup_finish_date'] = '______ / ___ / ___';
                    $newData['0']['procure_next_followup_data_notes'] = $atimData['TreatmentMaster']['notes'];
                    $data[] = $newData;
                }
            } else {
                $newData['0']['procure_next_followup_value'] = __('none');
                $data[] = $newData;
            }
        }
        
        if ($participantsWithRefusalOrWithrawal) {
            AppController::addWarningMsg(__('participants with refusal or withdrawal') . ' : ' . implode('& ', $participantsWithRefusalOrWithrawal) . '!');
        }
        
        if ($displayExactSearchWarning)
            AppController::addWarningMsg(__('all searches are considered as exact searches'));
        
        return array(
            'header' => $header,
            'data' => $data,
            'columns_names' => null,
            'error_msg' => null
        );
    }

    public function procureFormatDate($date, $accuracy)
    {
        $lengh = strlen($date);
        switch ($accuracy) {
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

    public function procureGetListOfBarcodeErrors($parameters)
    {
        // NL Comment (2018-01-11):Can return too many erros beacause any aliquot could have its own specific format
        // since we decided that all Processing site, activites will be migrated to each bank.
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        
        // if(!AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')){
        // $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        // }
        // if(!AppController::checkLinkPermission('/InventoryManagement/Collections/detail')){
        // $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        // }
        
        // AppController::addWarningMsg(__('search is only done on banks aliquots'));
        
        // $displayExactSearchWarning = false;
        // $header = null;
        // $conditions = array('TRUE');
        // if(isset($parameters['ViewAliquot']['participant_identifier_start'])) {
        // $participantIdentifierStart = (!empty($parameters['ViewAliquot']['participant_identifier_start']))? $parameters['ViewAliquot']['participant_identifier_start']: null;
        // $participantIdentifierEnd = (!empty($parameters['ViewAliquot']['participant_identifier_end']))? $parameters['ViewAliquot']['participant_identifier_end']: null;
        // if($participantIdentifierStart) $conditions[] = "ViewAliquot.participant_identifier >= '$participantIdentifierStart'";
        // if($participantIdentifierEnd) $conditions[] = "ViewAliquot.participant_identifier <= '$participantIdentifierEnd'";
        // } elseif(isset($parameters['ViewAliquot']['participant_identifier'])) {
        // $displayExactSearchWarning = true;
        // $participantIdentifiers = array_filter($parameters['ViewAliquot']['participant_identifier']);
        // if($participantIdentifiers) $conditions[] = "ViewAliquot.participant_identifier IN ('".implode("','",$participantIdentifiers)."')";
        // } else {
        // $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
        // }
        // if(isset($parameters['ViewAliquot']['procure_created_by_bank'])) {
        // $procureCreatedByBank = array_filter($parameters['ViewAliquot']['procure_created_by_bank']);
        // $conditions[] = "ViewAliquot.procure_created_by_bank IN ('".implode("','",$procureCreatedByBank)."')";
        // if(in_array('p', $procureCreatedByBank) || in_array('s', $procureCreatedByBank)) {
        // $checkProcureCreatedByBank = implode('',$procureCreatedByBank);
        // if(in_array($checkProcureCreatedByBank, array('p','s','ps','sp'))) $conditions = array("ViewAliquot.procure_created_by_bank = '-1'");
        // }
        // }
        
        // $data = array();
        
        // //Get Controls Data
        // $ViewAliquotModel = AppModel::getInstance("ClinicalAnnotation", "ViewAliquot", true);
        
        // //Look for duplicated barcodes
        
        // $query = "SELECT ViewAliquot.*
        // FROM (
        // SELECT barcode, count(*) as nbr_of_aliquots
        // FROM view_aliquots AS ViewAliquot
        // WHERE ". implode(' AND ', $conditions) ." AND ViewAliquot.procure_created_by_bank NOT IN ('p','s') GROUP BY barcode
        // ) TmpRes, view_aliquots AS ViewAliquot
        // WHERE TmpRes.nbr_of_aliquots > 1
        // AND TmpRes.barcode = ViewAliquot.barcode
        // ORDER BY ViewAliquot.barcode;";
        // foreach($ViewAliquotModel->query($query) as $res) {
        // $data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']] = array_merge(array('0'=> array(__('duplicated'))), $res);
        // }
        
        // //Look for barcodes that don't match format (limited to bank aliquots)
        
        // $wrongFormatAliquotMasterIds = array('-1');
        // $query = "SELECT ViewAliquot.*
        // FROM view_aliquots AS ViewAliquot
        // WHERE ". implode(' AND ', $conditions) ."
        // AND ViewAliquot.barcode NOT REGEXP '^PS[0-9]P[0-9]{4}\ V[0-9]{2}(\.[0-9]+){0,1}\ \-[A-Z]{3}';";
        // foreach($ViewAliquotModel->query($query) as $res) {
        // $error = __('wrong format');
        // if(!isset($data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']])) {
        // $data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']] = array_merge(array('0'=> array($error)), $res);
        // } else {
        // $data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']]['0'][] = $error;
        // }
        // $wrongFormatAliquotMasterIds[] = $res['ViewAliquot']['aliquot_master_id'];
        // }
        
        // //Look for barcodes that don't match the participant identifier of the collection participant (limited to bank aliquots)
        
        // $query = "SELECT ViewAliquot.*
        // FROM view_aliquots AS ViewAliquot
        // WHERE ". implode(' AND ', $conditions) ."
        // AND ViewAliquot.barcode NOT REGEXP CONCAT('^',ViewAliquot.participant_identifier,'\ V[0-9]{2}(\.[0-9]+){0,1}\ \-[A-Z]{3}')
        // AND ViewAliquot.procure_created_by_bank != 'p'
        // AND ViewAliquot.aliquot_master_id NOT IN (".implode(',',$wrongFormatAliquotMasterIds).");";
        // foreach($ViewAliquotModel->query($query) as $res) {
        // $error = __('wrong participant identifier');
        // if(!isset($data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']])) {
        // $data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']] = array_merge(array('0'=> array($error)), $res);
        // } else {
        // $data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']]['0'][] = $error;
        // }
        // }
        
        // //Look for barcodes that don't match the visit of the collection (limited to bank aliquots)
        
        // $query = "SELECT ViewAliquot.*
        // FROM view_aliquots AS ViewAliquot
        // WHERE ". implode(' AND ', $conditions) ."
        // AND ViewAliquot.barcode NOT REGEXP CONCAT('^PS[0-9]P[0-9]{4}\ ',ViewAliquot.procure_visit,'\ \-[A-Z]{3}')
        // AND ViewAliquot.procure_created_by_bank != 'p'
        // AND ViewAliquot.aliquot_master_id NOT IN (".implode(',',$wrongFormatAliquotMasterIds).");";
        // foreach($ViewAliquotModel->query($query) as $res) {
        // $error = __('wrong visit');
        // if(!isset($data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']])) {
        // $data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']] = array_merge(array('0'=> array($error)), $res);
        // } else {
        // $data[$res['ViewAliquot']['barcode']][$res['ViewAliquot']['aliquot_master_id']]['0'][] = $error;
        // }
        // }
        
        // $finalData = array();
        // foreach($data as $newAliquots) {
        // foreach($newAliquots as $newAliquot) {
        // $newAliquot['0']['procure_barcode_error'] = implode(' & ', $newAliquot['0']);
        // $finalData[] = $newAliquot;
        // }
        // }
        
        // if(sizeof($finalData) > Configure::read('databrowser_and_report_results_display_limit')) {
        // return array(
        // 'header' => null,
        // 'data' => null,
        // 'columns_names' => null,
        // 'error_msg' => 'the report contains too many results - please redefine search criteria');
        // }
        
        // if($displayExactSearchWarning) AppController::addWarningMsg(__('all searches are considered as exact searches'));
        
        // return array(
        // 'header' => $header,
        // 'data' => $finalData,
        // 'columns_names' => null,
        // 'error_msg' => null);
    }

    public function procureBankActivityReport($parameters)
    {
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        if (! AppController::checkLinkPermission('/InventoryManagement/Collections/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
        
        $displayExactSearchWarning = false;
        $inaccurateDate = false;
        
        // Get Criteria
        
        $conditions = array(
            'TRUE'
        );
        $procurePsNbrsDescription = '';
        
        if (isset($parameters['Participant']['participant_identifier_start'])) {
            $participantIdentifierStart = (! empty($parameters['Participant']['participant_identifier_start'])) ? $parameters['Participant']['participant_identifier_start'] : null;
            $participantIdentifierEnd = (! empty($parameters['Participant']['participant_identifier_end'])) ? $parameters['Participant']['participant_identifier_end'] : null;
            if ($participantIdentifierStart)
                $conditions[] = "Participant.participant_identifier >= '$participantIdentifierStart'";
            if ($participantIdentifierEnd)
                $conditions[] = "Participant.participant_identifier <= '$participantIdentifierEnd'";
        } elseif (isset($parameters['Participant']['participant_identifier'])) {
            $displayExactSearchWarning = true;
            $participantIdentifiers = array_filter($parameters['Participant']['participant_identifier']);
            if ($participantIdentifiers)
                $conditions[] = "Participant.participant_identifier IN ('" . implode("','", $participantIdentifiers) . "')";
        } else {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (isset($parameters['0']['procure_participant_identifier_prefix'])) {
            $tmpConditions = array();
            $procurePsNbrs = array();
            foreach ($parameters['0']['procure_participant_identifier_prefix'] as $tmpNewPrefix) {
                if (in_array($tmpNewPrefix, array(
                    '1',
                    '2',
                    '3',
                    '4'
                ))) {
                    $tmpConditions[] = "Participant.participant_identifier LIKE 'PS$tmpNewPrefix%'";
                    $procurePsNbrs[] = "PS$tmpNewPrefix";
                } elseif (strlen($tmpNewPrefix)) {
                    $tmpConditions[] = "Participant.participant_identifier LIKE '-1'";
                }
            }
            if ($tmpConditions) {
                $conditions[] = "(" . implode(' OR ', $tmpConditions) . ")";
            }
            if ($procurePsNbrs) {
                $procurePsNbrsDescription = ' || ' . __('participant identifier prefix') . ' ' . implode(", ", $procurePsNbrs);
            }
        }
        
        // Get Data
        
        $data = array(
            'procure_nbr_of_participants_with_collection_and_visit' => array(),
            'procure_nbr_of_participants_with_collection' => array(),
            'procure_nbr_of_participants_with_visit_only' => array(),
            'procure_nbr_of_participants_with_collection_post_bcr' => array(),
            'procure_nbr_of_participants_with_collection_pre_bcr' => array(),
            'procure_nbr_of_participants_with_pbmc_extraction' => array(),
            'procure_nbr_of_participants_with_rna_extraction' => array(),
            'procure_nbr_of_participants_with_clinical_data_update' => array(),
            'procure_nbr_of_psa_created_modified' => array(),
            'procure_nbr_of_treatment_created_modified' => array(),
            'procure_nbr_of_clinical_exams_created_modified' => array()
        );
        $dateKeyList = array();
        
        $participantModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        
        $query = "SELECT id,event_type, detail_tablename FROM event_controls WHERE flag_active = 1;";
        $eventControls = array();
        foreach ($participantModel->query($query) as $res)
            $eventControls[$res['event_controls']['event_type']] = array(
                'id' => $res['event_controls']['id'],
                'detail_tablename' => $res['event_controls']['detail_tablename']
            );
        $query = "SELECT id,tx_method, detail_tablename FROM treatment_controls WHERE flag_active = 1;";
        $txControls = array();
        foreach ($participantModel->query($query) as $res) {
            $txControls[$res['treatment_controls']['tx_method']] = array(
                'id' => $res['treatment_controls']['id'],
                'detail_tablename' => $res['treatment_controls']['detail_tablename']
            );
        }
        $query = "SELECT id,sample_type, detail_tablename FROM sample_controls;";
        $sampleControls = array();
        foreach ($participantModel->query($query) as $res)
            $sampleControls[$res['sample_controls']['sample_type']] = array(
                'id' => $res['sample_controls']['id'],
                'detail_tablename' => $res['sample_controls']['detail_tablename']
            );
        
        $endDateYear = date("Y");
        $endDate = date("Y-m");
        $startDate = str_replace($endDateYear, ($endDateYear - 1), $endDate);
        $endDate .= '-31';
        $startDate .= '-01';
        
        // Get participants ids
        $query = "SELECT DISTINCT
			Participant.id
			FROM participants Participant
			WHERE Participant.deleted <> 1
		    AND " . implode(' AND ', $conditions);
        $participantIds = array();
        foreach ($participantModel->query($query) as $newParticipantId) {
            $participantIds[] = $newParticipantId['Participant']['id'];
        }
        $participantIdsStrg = empty($participantIds) ? '-1' : implode(',', $participantIds);
        
        $header = array(
            'title' => __('report parameters'),
            'description' => __('from') . " $startDate " . __('to') . " $endDate || " . sizeof($participantIds) . ' ' . __('participants') . $procurePsNbrsDescription
        );
        
        // Get number of participants with visit and/or collection
        
        $query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
                SELECT DISTINCT res1.participant_id, res1.record_year, res1.record_month FROM (
                    SELECT DISTINCT Collection.participant_id, 
                    YEAR(Collection.collection_datetime) AS record_year, 
                    IF(Collection.collection_datetime_accuracy <> 'm', LPAD(MONTH(Collection.collection_datetime), 2, '0'), '?') AS record_month
                    FROM aliquot_masters AS AliquotMaster
                    INNER JOIN collections AS Collection ON Collection.id = AliquotMaster.collection_id
                    WHERE Collection.participant_id IN ($participantIdsStrg)
                    AND Collection.deleted <> 1
                    AND AliquotMaster.deleted <> 1
                    AND Collection.collection_datetime > '$startDate 23:59:59' 
                    AND Collection.collection_datetime <= '$endDate 23:59:59'
                    AND Collection.collection_datetime_accuracy <> 'y'
                    UNION ALL
                    SELECT DISTINCT EventMaster.participant_id, 
                    YEAR(EventMaster.event_date) AS event_year, 
                    IF(EventMaster.event_date_accuracy <> 'm', LPAD(MONTH(EventMaster.event_date), 2, '0'), '?') AS event_month
                    FROM event_masters AS EventMaster
                    WHERE EventMaster.participant_id IN ($participantIdsStrg)
                    AND EventMaster.deleted <> 1
                    AND EventMaster.event_control_id = " . $eventControls['visit/contact']['id'] . "
                    AND EventMaster.event_date > '$startDate' 
                    AND EventMaster.event_date <= '$endDate'
                    AND EventMaster.event_date_accuracy <> 'y'
                ) AS res1
    		) AS res
    		 GROUP BY res.record_year, res.record_month;";
        foreach ($participantModel->query($query) as $newParticipantsCount) {
            $data['procure_nbr_of_participants_with_collection_and_visit'][$newParticipantsCount[0]['y_m']] = $newParticipantsCount[0]['nbr_of_records'];
            $dateKeyList[$newParticipantsCount[0]['y_m']] = $newParticipantsCount[0]['y_m'];
        }
        
        // Get number of participants with collection
        
        $query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
        		SELECT DISTINCT Collection.participant_id,
        		YEAR(Collection.collection_datetime) AS record_year,
        		IF(Collection.collection_datetime_accuracy <> 'm', LPAD(MONTH(Collection.collection_datetime), 2, '0'), '?') AS record_month
        		FROM aliquot_masters AS AliquotMaster
        		INNER JOIN collections AS Collection ON Collection.id = AliquotMaster.collection_id
        		WHERE Collection.participant_id IN ($participantIdsStrg)
        		AND Collection.deleted <> 1
        		AND AliquotMaster.deleted <> 1
        		AND Collection.collection_datetime > '$startDate 23:59:59'
        		AND Collection.collection_datetime <= '$endDate 23:59:59'
        		AND Collection.collection_datetime_accuracy <> 'y'
    		) AS res
    		GROUP BY res.record_year, res.record_month;";
        foreach ($participantModel->query($query) as $newParticipantsCount) {
            $data['procure_nbr_of_participants_with_collection'][$newParticipantsCount[0]['y_m']] = $newParticipantsCount[0]['nbr_of_records'];
            $dateKeyList[$newParticipantsCount[0]['y_m']] = $newParticipantsCount[0]['y_m'];
        }
        
        // Get number of participants with visit only
        
        foreach ($data['procure_nbr_of_participants_with_collection_and_visit'] as $keyYearMonth => $recordNbrs) {
            if (! array_key_exists($keyYearMonth, $data['procure_nbr_of_participants_with_collection'])) {
                $data['procure_nbr_of_participants_with_visit_only'][$keyYearMonth] = $recordNbrs;
            } else {
                $data['procure_nbr_of_participants_with_visit_only'][$keyYearMonth] = $recordNbrs - $data['procure_nbr_of_participants_with_collection'][$keyYearMonth];
            }
        }
        
        // Get number of participants with collections after BCR
        
        $query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
        		SELECT DISTINCT Collection.participant_id,
        		YEAR(Collection.collection_datetime) AS record_year,
        		IF(Collection.collection_datetime_accuracy <> 'm', LPAD(MONTH(Collection.collection_datetime), 2, '0'), '?') AS record_month
        		FROM aliquot_masters AS AliquotMaster
        		INNER JOIN collections AS Collection ON Collection.id = AliquotMaster.collection_id
        		INNER JOIN event_masters AS EventMaster ON EventMaster.participant_id = Collection.participant_id
        		INNER JOIN " . $eventControls['laboratory']['detail_tablename'] . " AS EventDetail ON EventDetail.event_master_id = EventMaster.id
        		WHERE Collection.participant_id IN ($participantIdsStrg)
        		AND Collection.deleted <> 1
        		AND AliquotMaster.deleted <> 1
        		AND EventMaster.deleted <> 1
        		AND EventMaster.event_control_id = " . $eventControls['laboratory']['id'] . "
    		    AND EventMaster.event_date <= Collection.collection_datetime
    		    AND EventDetail.biochemical_relapse = 'y'
        		AND Collection.collection_datetime > '$startDate 23:59:59'
        		AND Collection.collection_datetime <= '$endDate 23:59:59'
        		AND Collection.collection_datetime_accuracy <> 'y'
    		) AS res
    		GROUP BY res.record_year, res.record_month;";
        foreach ($participantModel->query($query) as $newParticipantsCount) {
            $data['procure_nbr_of_participants_with_collection_post_bcr'][$newParticipantsCount[0]['y_m']] = $newParticipantsCount[0]['nbr_of_records'];
            $dateKeyList[$newParticipantsCount[0]['y_m']] = $newParticipantsCount[0]['y_m'];
        }
        
        // Get number of participants with visit collection pre bcr
        
        foreach ($data['procure_nbr_of_participants_with_collection_and_visit'] as $keyYearMonth => $recordNbrs) {
            if (! array_key_exists($keyYearMonth, $data['procure_nbr_of_participants_with_collection_post_bcr'])) {
                $data['procure_nbr_of_participants_with_collection_pre_bcr'][$keyYearMonth] = $recordNbrs;
            } else {
                $data['procure_nbr_of_participants_with_collection_pre_bcr'][$keyYearMonth] = $recordNbrs - $data['procure_nbr_of_participants_with_collection_post_bcr'][$keyYearMonth];
            }
        }
        
        // Get number of participants with pbmc extraction
        
        $query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
        		SELECT DISTINCT Collection.participant_id,
        		YEAR(DerivativeDetail.creation_datetime) AS record_year,
        		IF(DerivativeDetail.creation_datetime_accuracy <> 'm', LPAD(MONTH(DerivativeDetail.creation_datetime), 2, '0'), '?') AS record_month
        		FROM sample_masters AS SampleMaster
        		INNER JOIN derivative_details DerivativeDetail ON DerivativeDetail.sample_master_id = SampleMaster.id
        		INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id
        		WHERE Collection.participant_id IN ($participantIdsStrg)
        		AND Collection.deleted <> 1
        		AND SampleMaster.deleted <> 1
        		AND DerivativeDetail.creation_datetime > '$startDate 23:59:59'
        		AND DerivativeDetail.creation_datetime <= '$endDate 23:59:59'
        		AND DerivativeDetail.creation_datetime_accuracy <> 'y'
        		AND SampleMaster.sample_control_id = " . $sampleControls['pbmc']['id'] . "
    		) AS res
    		GROUP BY res.record_year, res.record_month;";
        foreach ($participantModel->query($query) as $newParticipantsCount) {
            $data['procure_nbr_of_participants_with_pbmc_extraction'][$newParticipantsCount[0]['y_m']] = $newParticipantsCount[0]['nbr_of_records'];
            $dateKeyList[$newParticipantsCount[0]['y_m']] = $newParticipantsCount[0]['y_m'];
        }
        
        // Get number of participants with rna extraction
        
        $query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
        		SELECT DISTINCT Collection.participant_id,
        		YEAR(DerivativeDetail.creation_datetime) AS record_year,
        		IF(DerivativeDetail.creation_datetime_accuracy <> 'm', LPAD(MONTH(DerivativeDetail.creation_datetime), 2, '0'), '?') AS record_month
        		FROM sample_masters AS SampleMaster
        		INNER JOIN derivative_details DerivativeDetail ON DerivativeDetail.sample_master_id = SampleMaster.id
        		INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id
        		WHERE Collection.participant_id IN ($participantIdsStrg)
        		AND Collection.deleted <> 1
        		AND SampleMaster.deleted <> 1
        		AND DerivativeDetail.creation_datetime > '$startDate 23:59:59'
        		AND DerivativeDetail.creation_datetime <= '$endDate 23:59:59'
        		AND DerivativeDetail.creation_datetime_accuracy <> 'y'
        		AND SampleMaster.sample_control_id = " . $sampleControls['rna']['id'] . "
    		) AS res
    		GROUP BY res.record_year, res.record_month;";
        foreach ($participantModel->query($query) as $newParticipantsCount) {
            $data['procure_nbr_of_participants_with_rna_extraction'][$newParticipantsCount[0]['y_m']] = $newParticipantsCount[0]['nbr_of_records'];
            $dateKeyList[$newParticipantsCount[0]['y_m']] = $newParticipantsCount[0]['y_m'];
        }
        
        // Get number of participants with clinical data updated
        
        $query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
                SELECT DISTINCT res1.participant_id, res1.record_year, res1.record_month FROM (
                    SELECT DISTINCT id as participant_id, 
            		YEAR(date_of_death) AS record_year,
                    LPAD(MONTH(date_of_death), 2, '0') AS record_month
            		FROM participants
            		WHERE deleted <> 1 
            		AND date_of_death > '$startDate' 
                    AND date_of_death <= '$endDate'
                    AND id IN ($participantIdsStrg)
            		UNION All
            		SELECT DISTINCT participant_id, 
            		YEAR(event_date) AS event_year,
                    LPAD(MONTH(event_date), 2, '0') AS event_month
            		FROM event_masters
            		WHERE deleted <> 1 
            		AND event_date > '$startDate'
                    AND event_date <= '$endDate'   
                    AND participant_id IN ($participantIdsStrg)
            		UNION All
            		SELECT DISTINCT participant_id, 
            		YEAR(start_date) AS event_year,
                    LPAD(MONTH(start_date), 2, '0') AS event_month
            		FROM treatment_masters
            		WHERE deleted <> 1 
            		AND start_date > '$startDate'
                    AND start_date <= '$endDate'
                    AND participant_id IN ($participantIdsStrg)
            		UNION All
            		SELECT DISTINCT participant_id, 
            		YEAR(finish_date) AS event_year,
                    LPAD(MONTH(finish_date), 2, '0') AS event_month
            		FROM treatment_masters
            		WHERE deleted <> 1 
            		AND finish_date > '$startDate'
                    AND finish_date <= '$endDate'
                    AND participant_id IN ($participantIdsStrg)
                ) AS res1
    		) AS res
    		 GROUP BY res.record_year, res.record_month;";
        foreach ($participantModel->query($query) as $newParticipantsCount) {
            $data['procure_nbr_of_participants_with_clinical_data_update'][$newParticipantsCount[0]['y_m']] = $newParticipantsCount[0]['nbr_of_records'];
            $dateKeyList[$newParticipantsCount[0]['y_m']] = $newParticipantsCount[0]['y_m'];
        }
        
        // Get number of psa(s), treatments, clinical exams created/updated
        
        $query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
        		SELECT DISTINCT event_masters.id,
        		YEAR(created) AS record_year,
        		LPAD(MONTH(created), 2, '0') AS record_month
        		FROM event_masters
        		WHERE deleted <> 1 
        		AND event_control_id = " . $eventControls['laboratory']['id'] . "
                AND created > '$startDate'
        		AND created <= '$endDate'
        		AND participant_id IN ($participantIdsStrg)
    		) AS res
    		GROUP BY res.record_year, res.record_month;";
        foreach ($participantModel->query($query) as $newPsasCount) {
            $data['procure_nbr_of_psa_created_modified'][$newPsasCount[0]['y_m']]['created'] = $newPsasCount[0]['nbr_of_records'];
            $dateKeyList[$newPsasCount[0]['y_m']] = $newPsasCount[0]['y_m'];
        }
        $query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
        		SELECT DISTINCT event_masters.id,
        		YEAR(modified) AS record_year,
        		LPAD(MONTH(modified), 2, '0') AS record_month
        		FROM event_masters
        		WHERE deleted <> 1
        		AND event_control_id = " . $eventControls['laboratory']['id'] . "
        		AND modified > '$startDate'
        		AND modified <= '$endDate'
        		AND modified != created
        		AND participant_id IN ($participantIdsStrg)
    		) AS res
    		GROUP BY res.record_year, res.record_month;";
        foreach ($participantModel->query($query) as $newPsasCount) {
            $data['procure_nbr_of_psa_created_modified'][$newPsasCount[0]['y_m']]['modified'] = $newPsasCount[0]['nbr_of_records'];
            $dateKeyList[$newPsasCount[0]['y_m']] = $newPsasCount[0]['y_m'];
        }
        
        $query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
        		SELECT DISTINCT event_masters.id,
        		YEAR(created) AS record_year,
        		LPAD(MONTH(created), 2, '0') AS record_month
        		FROM event_masters
        		WHERE deleted <> 1
        		AND event_control_id = " . $eventControls['clinical exam']['id'] . "
        		AND created > '$startDate'
        		AND created <= '$endDate'
        		AND participant_id IN ($participantIdsStrg)
    		) AS res
    		GROUP BY res.record_year, res.record_month;";
        foreach ($participantModel->query($query) as $newPsasCount) {
            $data['procure_nbr_of_clinical_exams_created_modified'][$newPsasCount[0]['y_m']]['created'] = $newPsasCount[0]['nbr_of_records'];
            $dateKeyList[$newPsasCount[0]['y_m']] = $newPsasCount[0]['y_m'];
        }
        $query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
        		SELECT DISTINCT event_masters.id,
        		YEAR(modified) AS record_year,
        		LPAD(MONTH(modified), 2, '0') AS record_month
        		FROM event_masters
        		WHERE deleted <> 1
        		AND event_control_id = " . $eventControls['clinical exam']['id'] . "
        		AND modified > '$startDate'
        		AND modified <= '$endDate'
        		AND modified != created
        		AND participant_id IN ($participantIdsStrg)
    		) AS res
    		GROUP BY res.record_year, res.record_month;";
        foreach ($participantModel->query($query) as $newPsasCount) {
            $data['procure_nbr_of_clinical_exams_created_modified'][$newPsasCount[0]['y_m']]['modified'] = $newPsasCount[0]['nbr_of_records'];
            $dateKeyList[$newPsasCount[0]['y_m']] = $newPsasCount[0]['y_m'];
        }
        
        $query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
        		SELECT DISTINCT treatment_masters.id,
        		YEAR(created) AS record_year,
        		LPAD(MONTH(created), 2, '0') AS record_month
        		FROM treatment_masters
        		WHERE deleted <> 1
        		AND created > '$startDate'
        		AND created <= '$endDate'
        		AND participant_id IN ($participantIdsStrg)
    		) AS res
    		GROUP BY res.record_year, res.record_month;";
        foreach ($participantModel->query($query) as $newPsasCount) {
            $data['procure_nbr_of_treatment_created_modified'][$newPsasCount[0]['y_m']]['created'] = $newPsasCount[0]['nbr_of_records'];
            $dateKeyList[$newPsasCount[0]['y_m']] = $newPsasCount[0]['y_m'];
        }
        $query = "SELECT COUNT(*) as 'nbr_of_records', CONCAT(res.record_year,'-', res.record_month) as y_m  FROM (
        		SELECT DISTINCT treatment_masters.id,
        		YEAR(modified) AS record_year,
        		LPAD(MONTH(modified), 2, '0') AS record_month
        		FROM treatment_masters
        		WHERE deleted <> 1
        		AND modified > '$startDate'
        		AND modified <= '$endDate'
        		AND modified != created
        		AND participant_id IN ($participantIdsStrg)
    		) AS res
    		GROUP BY res.record_year, res.record_month;";
        foreach ($participantModel->query($query) as $newPsasCount) {
            $data['procure_nbr_of_treatment_created_modified'][$newPsasCount[0]['y_m']]['modified'] = $newPsasCount[0]['nbr_of_records'];
            $dateKeyList[$newPsasCount[0]['y_m']] = $newPsasCount[0]['y_m'];
        }
        
        foreach (array(
            'procure_nbr_of_psa_created_modified',
            'procure_nbr_of_clinical_exams_created_modified',
            'procure_nbr_of_treatment_created_modified'
        ) as $tmpCreatedModifiedField) {
            foreach ($data[$tmpCreatedModifiedField] as $tmpCreatedModifiedDate => $tmpCreatedModifiedValues) {
                $created = isset($tmpCreatedModifiedValues['created']) ? $tmpCreatedModifiedValues['created'] : '0';
                $modified = isset($tmpCreatedModifiedValues['modified']) ? $tmpCreatedModifiedValues['modified'] : '0';
                $data[$tmpCreatedModifiedField][$tmpCreatedModifiedDate] = "$created + $modified";
            }
        }
        
        // Set empty value
        if ($inaccurateDate)
            AppController::addWarningMsg(__('at least one participant summary is based on inaccurate date'));
        
        if ($displayExactSearchWarning)
            AppController::addWarningMsg(__('all searches are considered as exact searches'));
        
        foreach ($data as $fieldKey => $fieldVals) {
            foreach ($dateKeyList as $expectedFieldKey) {
                if (! array_key_exists($expectedFieldKey, $fieldVals)) {
                    $data[$fieldKey][$expectedFieldKey] = '0';
                }
            }
        }
        
        if (empty($dateKeyList)) {
            $dateKeyList = array(
                __('no data')
            );
            foreach ($data as $key => $valArr)
                $data[$key] = array(
                    __('no data') => __('n/a')
                );
        }
        
        sort($dateKeyList);
        $arrayToReturn = array(
            'header' => $header,
            'data' => array(
                $data
            ),
            'columns_names' => $dateKeyList,
            'error_msg' => null
        );
        
        return $arrayToReturn;
    }
}