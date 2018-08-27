<?php

/**
 * Class ParticipantsController
 */
class ParticipantsController extends ClinicalAnnotationAppController
{

    public $components = array();

    public $uses = array(
        'ClinicalAnnotation.Participant',
        'ClinicalAnnotation.ConsentMaster',
        'ClinicalAnnotation.ParticipantContact',
        'ClinicalAnnotation.ParticipantMessage',
        'ClinicalAnnotation.EventMaster',
        'ClinicalAnnotation.DiagnosisMaster',
        'ClinicalAnnotation.FamilyHistory',
        'ClinicalAnnotation.MiscIdentifier',
        'ClinicalAnnotation.ReproductiveHistory',
        'ClinicalAnnotation.TreatmentMaster',
        'ClinicalAnnotation.MiscIdentifierControl',
        'Codingicd.CodingIcd10Who',
        'Codingicd.CodingIcd10Ca',
        
        'Tools.CollectionProtocol'
    );

    public $paginate = array(
        'Participant' => array(
            'order' => 'Participant.last_name ASC, Participant.first_name ASC'
        ),
        'MiscIdentifier' => array(
            'order' => 'MiscIdentifier.study_summary_id ASC,MiscIdentifierControl.misc_identifier_name ASC'
        )
    );

    /**
     *
     * @param string $searchId
     */
    public function search($searchId = '')
    {
        // CUSTOM CODE: Hook for search_handler
        $hookLink = $this->hook('pre_search_handler');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->searchHandler($searchId, $this->Participant, 'participants', '/ClinicalAnnotation/Participants/search');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($searchId)) {
            // index
            $this->request->data = $this->Participant->find('all', array(
                'conditions' => array(
                    'Participant.created_by' => $this->Session->read('Auth.User.id')
                ),
                'order' => array(
                    'Participant.created DESC'
                ),
                'limit' => 5
            ));
            $this->render('index');
        }
    }

    /**
     *
     * @param $participantId
     */
    public function profile($participantId)
    {
        // MANAGE DATA
        $this->request->data = $this->Participant->getOrRedirect($participantId);
        
        // Set data for identifier list
        $participantIdentifiersData = $this->paginate($this->MiscIdentifier, array(
            'MiscIdentifier.participant_id' => $participantId
        ));
        $this->set('participantIdentifiersData', $participantIdentifiersData);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId
        ));
        
        // Set form for identifier list
        $this->Structures->set('miscidentifiers', 'atimStructureForMiscIdentifiers');
        
        $mi = $this->MiscIdentifier->find('all', array(
            'fields' => array(
                'MiscIdentifierControl.id'
            ),
            'conditions' => array(
                'MiscIdentifier.deleted' => 1,
                'MiscIdentifier.tmp_deleted' => 1
            ),
            'group' => array(
                'MiscIdentifierControl.id'
            )
        ));
        $reusable = array();
        foreach ($mi as $miUnit) {
            $reusable[$miUnit['MiscIdentifierControl']['id']] = null;
        }
        $conditions = array(
            'flag_active' => '1'
        );
        if (! $this->Session->read('flag_show_confidential')) {
            $conditions["flag_confidential"] = 0;
        }
        $identifierControlsList = $this->MiscIdentifierControl->find('all', array(
            'conditions' => $conditions
        ));
        foreach ($identifierControlsList as &$unit) {
            if (! empty($unit['MiscIdentifierControl']['autoincrement_name']) && array_key_exists($unit['MiscIdentifierControl']['id'], $reusable)) {
                $unit['reusable'] = true;
            }
        }
        $this->set('identifierControlsList', $identifierControlsList);
        $this->Structures->set('empty', 'emptyStructure');
        
        $this->set('collectionProtocols', $this->CollectionProtocol->getProtocolsList('use'));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->set('isAjax', $this->request->is('ajax'));
    }

    public function add()
    {
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/Participants/search'));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            $this->Participant->patchIcd10NullValues($this->request->data);
            $submittedDataValidates = true;
            // ... special validations
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                if ($this->Participant->save($this->request->data)) {
                    
                    $urlToFlash = '/ClinicalAnnotation/Participants/profile/' . $this->Participant->getLastInsertID();
                    
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    
                    $this->atimFlash(__('your data has been saved'), $urlToFlash);
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     */
    public function edit($participantId)
    {
        // MANAGE DATA
        $participantData = $this->Participant->getOrRedirect($participantId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        if (empty($this->request->data)) {
            $this->request->data = $participantData;
        } else {
            $this->Participant->patchIcd10NullValues($this->request->data);
            $submittedDataValidates = true;
            // ... special validations
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->Participant->id = $participantId;
                $this->Participant->data = array();
                if ($this->Participant->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/Participants/profile/' . $participantId);
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     */
    public function delete($participantId)
    {
        
        // MANAGE DATA
        $this->request->data = $this->Participant->getOrRedirect($participantId);
        
        $arrAllowDeletion = $this->Participant->allowDeletion($participantId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->Participant->atimDelete($participantId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/ClinicalAnnotation/Participants/search/');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/ClinicalAnnotation/Participants/search/');
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/ClinicalAnnotation/Participants/profile/' . $participantId . '/');
        }
    }

    /**
     *
     * @param $participantId
     */
    public function chronology($participantId)
    {
        $tmpArray = array();
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId
        ));
        $this->Structures->set('chronology', 'chronology');
        
        // *** Load model being used to populate chronology_details (for values of fields linked to drop down list)
        
        $this->StructurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true); // Use of $structurePermissibleValuesCustom->getTranslatedCustomDropdownValue()
        
        App::uses('StructureValueDomain', 'Model');
        $this->StructureValueDomain = new StructureValueDomain();
        
        $this->TreatmentExtendMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentExtendMaster", true);
        
        $Drug = AppModel::getInstance("Drug", "Drug", true);
        $allDrugs = $Drug->getDrugPermissibleValues();
        
        $addDrugToDetail = true;
        
        $hookLink = $this->hook('start');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // accuracy_sort
        $aS = array(
            '±' => 0,
            'y' => 1,
            'm' => 2,
            'd' => 3,
            'h' => 4,
            'i' => 5,
            'c' => 6,
            '' => 7
        );
        
        $addToTmpArray = function (array $in) use($aS, &$tmpArray) {
            if ($in['date']) {
                $tmpArray[$in['date'] . $aS[$in['date_accuracy']]][] = $in;
            } else {
                $tmpArray[' '][] = $in;
            }
        };
        
        // *** load every wanted information into the tmpArray ***
        
        // 1-Participant
        
        if (AppController::checkLinkPermission('/ClinicalAnnotation/Participants/profile/')) {
            $participant = $this->Participant->find('first', array(
                'conditions' => array(
                    'Participant.id' => $participantId
                )
            ));
            $chronolgyDataParticipantBirth = ($this->Session->read('flag_show_confidential')) ? array(
                'date' => $participant['Participant']['date_of_birth'],
                'date_accuracy' => $participant['Participant']['date_of_birth_accuracy'],
                'event' => __('date of birth'),
                'chronology_details' => '',
                'link' => '/ClinicalAnnotation/Participants/profile/' . $participantId . '/'
            ) : null;
            $chronolgyDataParticipantDeath = false;
            if (strlen($participant['Participant']['date_of_death']) > 0) {
                $chronolgyDataParticipantDeath = array(
                    'date' => $participant['Participant']['date_of_death'],
                    'date_accuracy' => $participant['Participant']['date_of_death_accuracy'],
                    'event' => __('date of death'),
                    'chronology_details' => '',
                    'link' => '/ClinicalAnnotation/Participants/profile/' . $participantId . '/'
                );
            }
            $hookLink = $this->hook('participant');
            if ($hookLink) {
                require ($hookLink);
            }
            if ($chronolgyDataParticipantBirth)
                $addToTmpArray($chronolgyDataParticipantBirth);
            if ($chronolgyDataParticipantDeath)
                $addToTmpArray($chronolgyDataParticipantDeath);
        }
        
        // 2-Consent
        
        if (AppController::checkLinkPermission('/ClinicalAnnotation/ConsentMasters/detail/')) {
            $consentStatus = $this->StructureValueDomain->find('first', array(
                'conditions' => array(
                    'StructureValueDomain.domain_name' => 'consent_status'
                ),
                'recursive' => 2
            ));
            $consentStatusValues = array();
            if ($consentStatus) {
                foreach ($consentStatus['StructurePermissibleValue'] as $newValue) {
                    $consentStatusValues[$newValue['value']] = __($newValue['language_alias']);
                }
            }
            $consents = $this->ConsentMaster->find('all', array(
                'conditions' => array(
                    'ConsentMaster.participant_id' => $participantId
                )
            ));
            foreach ($consents as $consent) {
                $chronolgyDataConsent = array(
                    'date' => $consent['ConsentMaster']['consent_signed_date'],
                    'date_accuracy' => isset($consent['ConsentMaster']['consent_signed_date_accuracy']) ? $consent['ConsentMaster']['consent_signed_date_accuracy'] : 'c',
                    'event' => __('consent') . ', ' . __($consent['ConsentControl']['controls_type']),
                    'chronology_details' => isset($consentStatusValues[$consent['ConsentMaster']['consent_status']]) ? $consentStatusValues[$consent['ConsentMaster']['consent_status']] : $consent['ConsentMaster']['consent_status'],
                    'link' => '/ClinicalAnnotation/ConsentMasters/detail/' . $participantId . '/' . $consent['ConsentMaster']['id']
                );
                $hookLink = $this->hook('consent');
                if ($hookLink) {
                    require ($hookLink);
                }
                if ($chronolgyDataConsent)
                    $addToTmpArray($chronolgyDataConsent);
            }
        }
        
        // 2-Diagnosis
        
        if (AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/detail/')) {
            $dxs = $this->DiagnosisMaster->find('all', array(
                'conditions' => array(
                    'DiagnosisMaster.participant_id' => $participantId
                )
            ));
            foreach ($dxs as $dx) {
                $chronolgyDataDiagnosis = array(
                    'date' => $dx['DiagnosisMaster']['dx_date'],
                    'date_accuracy' => $dx['DiagnosisMaster']['dx_date_accuracy'],
                    'event' => __('diagnosis') . ', ' . __($dx['DiagnosisControl']['category']) . ' - ' . __($dx['DiagnosisControl']['controls_type']),
                    'chronology_details' => '',
                    'link' => '/ClinicalAnnotation/DiagnosisMasters/detail/' . $participantId . '/' . $dx['DiagnosisMaster']['id']
                );
                $hookLink = $this->hook('diagnosis');
                if ($hookLink) {
                    require ($hookLink);
                }
                if ($chronolgyDataDiagnosis)
                    $addToTmpArray($chronolgyDataDiagnosis);
            }
        }
        
        // 3-Event
        
        if (AppController::checkLinkPermission('/ClinicalAnnotation/EventMasters/detail/')) {
            $annotations = $this->EventMaster->find('all', array(
                'conditions' => array(
                    'EventMaster.participant_id' => $participantId
                )
            ));
            foreach ($annotations as $annotation) {
                $chronolgyDataAnnotation = array(
                    'date' => $annotation['EventMaster']['event_date'],
                    'date_accuracy' => isset($annotation['EventMaster']['event_date_accuracy']) ? $annotation['EventMaster']['event_date_accuracy'] : 'c',
                    'event' => __($annotation['EventControl']['event_group']) . ', ' . __($annotation['EventControl']['event_type']),
                    'chronology_details' => '',
                    'link' => '/ClinicalAnnotation/EventMasters/detail/' . $participantId . '/' . $annotation['EventMaster']['id']
                );
                $hookLink = $this->hook('annotation');
                if ($hookLink) {
                    require ($hookLink);
                }
                if ($chronolgyDataAnnotation)
                    $addToTmpArray($chronolgyDataAnnotation);
            }
        }
        
        // 4-Treatment
        
        if (AppController::checkLinkPermission('/ClinicalAnnotation/TreatmentMasters/detail/')) {
            $txs = $this->TreatmentMaster->find('all', array(
                'conditions' => array(
                    'TreatmentMaster.participant_id' => $participantId
                )
            ));
            foreach ($txs as $tx) {
                $startSuffixMsg = '';
                $finishSuffixMsg = '';
                if ($tx['TreatmentMaster']['start_date'] || $tx['TreatmentMaster']['finish_date']) {
                    $startSuffixMsg = " (" . __("start") . ")";
                    $finishSuffixMsg = empty($tx['TreatmentMaster']['finish_date']) ? '' : " (" . __("end") . ")";
                    if ($tx['TreatmentMaster']['start_date'] == $tx['TreatmentMaster']['finish_date'] && $tx['TreatmentMaster']['start_date_accuracy'] == $tx['TreatmentMaster']['finish_date_accuracy']) {
                        $startSuffixMsg = " (" . __("start") . " & " . __("end") . ")";
                        $finishSuffixMsg = '';
                    }
                }
                $txChronologyDetails = '';
                if ($addDrugToDetail) {
                    $drugs = array();
                    $treatmentExtendConditions = array(
                        'TreatmentExtendMaster.treatment_master_id' => $tx['TreatmentMaster']['id']
                    );
                    foreach ($this->TreatmentExtendMaster->find('all', array(
                        'conditions' => $treatmentExtendConditions,
                        'recursive' => - 1
                    )) as $newDrug) {
                        if (isset($newDrug['TreatmentExtendMaster']['drug_id']) && isset($allDrugs[$newDrug['TreatmentExtendMaster']['drug_id']])) {
                            $drugs[$allDrugs[$newDrug['TreatmentExtendMaster']['drug_id']]] = $allDrugs[$newDrug['TreatmentExtendMaster']['drug_id']];
                        }
                    }
                    ksort($drugs);
                    $txChronologyDetails = implode(', ', $drugs);
                }
                $chronolgyDataTreatmentStart = array(
                    'date' => $tx['TreatmentMaster']['start_date'],
                    'date_accuracy' => $tx['TreatmentMaster']['start_date_accuracy'],
                    'event' => __('treatment') . ", " . __($tx['TreatmentControl']['tx_method']) . $startSuffixMsg,
                    'chronology_details' => $txChronologyDetails,
                    'link' => '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $tx['TreatmentMaster']['id']
                );
                $chronolgyDataTreatmentFinish = false;
                if ($finishSuffixMsg) {
                    $chronolgyDataTreatmentFinish = array(
                        'date' => $tx['TreatmentMaster']['finish_date'],
                        'date_accuracy' => $tx['TreatmentMaster']['finish_date_accuracy'],
                        'event' => __('treatment') . ", " . __($tx['TreatmentControl']['tx_method']) . $finishSuffixMsg,
                        'chronology_details' => $txChronologyDetails,
                        'link' => '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $tx['TreatmentMaster']['id']
                    );
                }
                $hookLink = $this->hook('treatment');
                if ($hookLink) {
                    require ($hookLink);
                }
                if ($chronolgyDataTreatmentStart)
                    $addToTmpArray($chronolgyDataTreatmentStart);
                if ($chronolgyDataTreatmentFinish)
                    $addToTmpArray($chronolgyDataTreatmentFinish);
            }
        }
        
        // 4-Collection
        
        if (AppController::checkLinkPermission('/InventoryManagement/Collections/detail/')) {
            $collectionModel = AppModel::getInstance('InventoryManagement', 'Collection', true);
            $collections = $collectionModel->find('all', array(
                'conditions' => array(
                    'Collection.participant_id' => $participantId
                ),
                'recursive' => - 1
            ));
            foreach ($collections as $collection) {
                $chronolgyDataCollection = array(
                    'date' => $collection['Collection']['collection_datetime'],
                    'date_accuracy' => $collection['Collection']['collection_datetime_accuracy'],
                    'event' => __('collection'),
                    'chronology_details' => $collection['Collection']['acquisition_label'],
                    'link' => '/InventoryManagement/Collections/detail/' . $collection['Collection']['id']
                );
                $hookLink = $this->hook('collection');
                if ($hookLink) {
                    require ($hookLink);
                }
                if ($chronolgyDataCollection)
                    $addToTmpArray($chronolgyDataCollection);
            }
        }
        
        $hookLink = $this->hook('end');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // *** Sort data ***
        
        // sort the tmpArray by key (key = date)
        ksort($tmpArray);
        $tmpArray2 = array();
        foreach ($tmpArray as $dateWAccu => $elements) {
            $date = substr($dateWAccu, 0, - 1);
            if ($date == 0) {
                $date = '';
            }
            if (isset($tmpArray2[$date])) {
                $tmpArray2[$date] = array_merge($tmpArray2[$date], $elements);
            } else {
                $tmpArray2[$date] = $elements;
            }
        }
        $tmpArray = $tmpArray2;
        
        // transfer the tmpArray into $this->request->data
        $this->request->data = array();
        foreach ($tmpArray as $key => $values) {
            foreach ($values as $value) {
                $date = $key;
                $time = null;
                if (strpos($date, " ") > 0) {
                    list ($date, $time) = explode(" ", $date);
                }
                $this->request->data[] = array(
                    'custom' => array(
                        'date' => $date,
                        'date_accuracy' => $value['date_accuracy'],
                        'time' => $time,
                        'event' => $value['event'],
                        'chronology_details' => $value['chronology_details'],
                        'link' => isset($value['link']) ? $value['link'] : null
                    )
                );
            }
        }
    }

    public function batchEdit()
    {
        // TODO not supported anymore
        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/Participants/search'));
        if (empty($this->request->data)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (isset($this->request->data['Participant']['id']) && (is_array($this->request->data['Participant']['id']) || $this->request->data['Participant']['id'] == 'all')) {
            // display
            if (isset($this->request->data['node']) && $this->request->data['Participant']['id'] == 'all') {
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $this->request->data['Participant']['id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
            $ids = array_filter($this->request->data['Participant']['id']);
            $this->request->data[0]['ids'] = implode(",", $ids);
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } elseif (isset($this->request->data[0]['ids']) && strlen($this->request->data[0]['ids'])) {
            // save
            $participants = $this->Participant->find('all', array(
                'conditions' => array(
                    'Participant.id' => explode(",", $this->request->data[0]['ids'])
                )
            ));
            $this->Structures->set('participants');
            // fake participant to validate
            AppController::removeEmptyValues($this->request->data['Participant']);
            $this->Participant->set($this->request->data);
            $submittedDataValidates = $this->Participant->validates();
            $this->request->data = $this->Participant->data;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $ids = explode(",", $this->request->data[0]['ids']);
                foreach ($ids as $id) {
                    $this->Participant->id = $id;
                    $this->Participant->save($this->request->data['Participant'], array(
                        'validate' => false,
                        'fieldList' => array_keys($this->request->data['Participant'])
                    ));
                }
                
                $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                $batchSetData = array(
                    'BatchSet' => array(
                        'datamart_structure_id' => $datamartStructure->getIdByModelName('Participant'),
                        'flag_tmp' => true
                    )
                );
                $batchSetModel->checkWritableFields = false;
                $batchSetModel->saveWithIds($batchSetData, $ids);
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId());
            }
        } else {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
    }
}