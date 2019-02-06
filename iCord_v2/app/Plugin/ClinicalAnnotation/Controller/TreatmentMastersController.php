<?php

/**
 * Class TreatmentMastersController
 */
class TreatmentMastersController extends ClinicalAnnotationAppController
{

    public $uses = array(
        'ClinicalAnnotation.Participant',
        'ClinicalAnnotation.TreatmentMaster',
        'ClinicalAnnotation.TreatmentExtendMaster',
        'ClinicalAnnotation.TreatmentControl',
        'ClinicalAnnotation.TreatmentExtendControl',
        'ClinicalAnnotation.DiagnosisMaster',
        'Protocol.ProtocolMaster'
    );

    public $paginate = array(
        'TreatmentMaster' => array(
            'order' => 'TreatmentMaster.start_date ASC'
        )
    );

    /**
     *
     * @param $participantId
     * @param null $treatmentControlId
     */
    public function listall($participantId, $treatmentControlId = null)
    {
        // MANAGE DATA
        $participantData = $this->Participant->getOrRedirect($participantId);
        
        $searchCriteria = array();
        if (! $treatmentControlId) {
            // 1 - MANAGE DISPLAY
            $treatmentControls = $this->TreatmentControl->find('all', array(
                'conditions' => array(
                    'TreatmentControl.flag_active' => '1'
                )
            ));
            $participantTreatmentControls = $this->TreatmentMaster->find('all', array(
                'conditions' => array(
                    'TreatmentMaster.participant_id' => $participantId,
                    'TreatmentControl.flag_active' => '1'
                ),
                'fields' => array(
                    "GROUP_CONCAT(DISTINCT TreatmentControl.id SEPARATOR ',') as ids"
                )
            ));
            $participantTreatmentControlIds = explode(',', $participantTreatmentControls['0']['0']['ids']);
            $controlsForSubformDisplay = array();
            if ($participantTreatmentControlIds) {
                foreach ($treatmentControls as $newCtrl) {
                    if (in_array($newCtrl['TreatmentControl']['id'], $participantTreatmentControlIds)) {
                        if ($newCtrl['TreatmentControl']['use_detail_form_for_index']) {
                            // Controls that should be listed using detail form
                            $controlsForSubformDisplay[$newCtrl['TreatmentControl']['id']] = $newCtrl;
                            $controlsForSubformDisplay[$newCtrl['TreatmentControl']['id']]['TreatmentControl']['tx_header'] = __($newCtrl['TreatmentControl']['tx_method']) . (empty($treatmentControl['TreatmentControl']['disease_site']) ? '' : ' - ' . __($treatmentControl['TreatmentControl']['disease_site']));
                        } else {
                            $controlsForSubformDisplay['-1']['TreatmentControl'] = array(
                                'id' => '-1',
                                'tx_header' => null
                            );
                        }
                    }
                }
            } else {
                $controlsForSubformDisplay['-1']['TreatmentControl'] = array(
                    'id' => '-1',
                    'tx_header' => null
                );
            }
            ksort($controlsForSubformDisplay);
            $this->set('controlsForSubformDisplay', $controlsForSubformDisplay);
            // find all TXCONTROLS, for ADD form
            $this->set('addLinks', $this->TreatmentControl->getAddLinks($participantId));
            // Set structure
            $this->Structures->set('treatmentmasters');
        } elseif ($treatmentControlId == '-1') {
            // 2 - DISPLAY ALL TREATMENTS THAT SHOULD BE DISPLAYED IN MASTER VIEW
            // Set search criteria
            $searchCriteria['TreatmentMaster.participant_id'] = $participantId;
            $searchCriteria['TreatmentControl.use_detail_form_for_index'] = '0';
            // Set structure
            $this->set('addLinks', array());
            $this->Structures->set('treatmentmasters');
        } else {
            // 3 - DISPLAY ALL TREATMENTS THAT SHOULD BE DISPLAYED IN DETAILED VIEW
            // Set search criteria
            $searchCriteria['TreatmentMaster.participant_id'] = $participantId;
            $searchCriteria['TreatmentControl.id'] = $treatmentControlId;
            // Set structure
            $controlData = $this->TreatmentControl->getOrRedirect($treatmentControlId);
            $this->Structures->set($controlData['TreatmentControl']['form_alias']);
            $this->set('addLinks', array());
            self::buildDetailBinding($this->TreatmentMaster, $searchCriteria, $controlData['TreatmentControl']['form_alias']);
        }
        
        // MANAGE DATA
        $this->request->data = $treatmentControlId ? $this->paginate($this->TreatmentMaster, $searchCriteria) : array();
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $participantId
     * @param $txMasterId
     */
    public function detail($participantId, $txMasterId)
    {
        // MANAGE DATA
        $treatmentMasterData = $this->TreatmentMaster->find('first', array(
            'conditions' => array(
                'TreatmentMaster.id' => $txMasterId,
                'TreatmentMaster.participant_id' => $participantId
            )
        ));
        if (empty($treatmentMasterData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $treatmentMasterData;
        
        $this->set('diagnosisData', $this->DiagnosisMaster->getRelatedDiagnosisEvents($this->request->data['TreatmentMaster']['diagnosis_master_id']));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'TreatmentMaster.id' => $txMasterId
        ));
        
        // set structure alias based on control data
        $this->Structures->set($treatmentMasterData['TreatmentControl']['form_alias']);
        $this->Structures->set('view_diagnosis,diagnosis_event_relation_type', 'diagnosisStructure');
        $this->set('isAjax', $this->request->is('ajax'));
        
        if ($treatmentMasterData['TreatmentControl']['treatment_extend_control_id']) {
            $treatmentExtendControlData = $this->TreatmentExtendControl->getOrRedirect($treatmentMasterData['TreatmentControl']['treatment_extend_control_id']);
            $this->set('txExtendType', $treatmentExtendControlData['TreatmentExtendControl']['type']);
            $this->set('txExtendData', $this->TreatmentExtendMaster->find('all', array(
                'conditions' => array(
                    'TreatmentExtendMaster.treatment_master_id' => $txMasterId,
                    'TreatmentExtendMaster.treatment_extend_control_id' => $treatmentMasterData['TreatmentControl']['treatment_extend_control_id']
                )
            )));
            $this->Structures->set($treatmentExtendControlData['TreatmentExtendControl']['form_alias'], 'extend_form_alias');
            if (! empty($treatmentMasterData['TreatmentControl']['extended_data_import_process'])) {
                $this->set('extendedDataImportProcess', $treatmentMasterData['TreatmentControl']['extended_data_import_process']);
            }
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $participantId
     * @param $txMasterId
     */
    public function edit($participantId, $txMasterId)
    {
        // MANAGE DATA
        $treatmentMasterData = $this->TreatmentMaster->find('first', array(
            'conditions' => array(
                'TreatmentMaster.id' => $txMasterId,
                'TreatmentMaster.participant_id' => $participantId
            )
        ));
        if (empty($treatmentMasterData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        if (! empty($treatmentMasterData['TreatmentControl']['applied_protocol_control_id'])) {
            $availableProtocols = array();
            $this->ProtocolMaster;
            ProtocolMaster::$protocolDropdown = $this->ProtocolMaster->getProtocolPermissibleValuesFromId($treatmentMasterData['TreatmentControl']['applied_protocol_control_id']);
        }
        
        // Set diagnosis data for diagnosis selection (radio button)
        $dxData = $this->DiagnosisMaster->find('threaded', array(
            'conditions' => array(
                'DiagnosisMaster.participant_id' => $participantId
            ),
            'order' => array(
                'DiagnosisMaster.dx_date ASC'
            )
        ));
        $dxId = isset($this->request->data['TreatmentMaster']['diagnosis_master_id']) ? $this->request->data['TreatmentMaster']['diagnosis_master_id'] : $treatmentMasterData['TreatmentMaster']['diagnosis_master_id'];
        $this->DiagnosisMaster->arrangeThreadedDataForView($dxData, $dxId, 'TreatmentMaster');
        
        $this->set('radioChecked', $dxId > 0);
        $this->set('dataForChecklist', $dxData);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'TreatmentMaster.id' => $txMasterId
        ));
        
        // set FORM ALIAS based off VALUE from MASTER table
        $this->Structures->set($treatmentMasterData['TreatmentControl']['form_alias']);
        $this->Structures->Set('empty', 'emptyStructure');
        $this->Structures->set('view_diagnosis', 'diagnosisStructure');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $treatmentMasterData;
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            // LAUNCH SPECIAL VALIDATION PROCESS
            $submittedDataValidates = true;
            // ... special validations
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->TreatmentMaster->id = $txMasterId;
                $this->TreatmentMaster->addWritableField(array(
                    'diagnosis_master_id'
                ));
                if ($this->TreatmentMaster->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $txMasterId);
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $txControlId
     * @param null $diagnosisMasterId
     */
    public function add($participantId, $txControlId, $diagnosisMasterId = null)
    {
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/listall/')) {
            $this->atimFlashError(__('you need privileges to access this page'), 'javascript:history.back()');
        }
        
        // MANAGE DATA
        $participantData = $this->Participant->getOrRedirect($participantId);
        
        $txControlData = $this->TreatmentControl->getOrRedirect($txControlId);
        
        if (! empty($txControlData['TreatmentControl']['applied_protocol_control_id'])) {
            $availableProtocols = array();
            $this->ProtocolMaster; // lazy load
            ProtocolMaster::$protocolDropdown = $this->ProtocolMaster->getProtocolPermissibleValuesFromId($txControlData['TreatmentControl']['applied_protocol_control_id']);
        }
        
        // Set diagnosis data for diagnosis selection (radio button)
        $dxData = $this->DiagnosisMaster->find('threaded', array(
            'conditions' => array(
                'DiagnosisMaster.participant_id' => $participantId
            ),
            'order' => array(
                'DiagnosisMaster.dx_date ASC'
            )
        ));
        if (isset($this->request->data['TreatmentMaster']['diagnosis_master_id'])) {
            $this->DiagnosisMaster->arrangeThreadedDataForView($dxData, $this->request->data['TreatmentMaster']['diagnosis_master_id'], 'TreatmentMaster');
        } elseif ($diagnosisMasterId) {
            $this->DiagnosisMaster->arrangeThreadedDataForView($dxData, $diagnosisMasterId, 'TreatmentMaster');
        }
        
        $this->set('dataForChecklist', $dxData);
        
        $this->set('initialDisplay', (empty($this->request->data) ? true : false));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'TreatmentControl.id' => $txControlId
        ));
        
        // Override generated menu to prevent selection of Administration menu item on ADD action
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/listall/%%Participant.id%%'));
        
        // Set trt header
        $this->set('txHeader', __($txControlData['TreatmentControl']['tx_method']) . (empty($txControlData['TreatmentControl']['disease_site']) ? '' : ' - ' . __($txControlData['TreatmentControl']['disease_site'])));
        
        // set DIAGANOSES radio list form
        $this->Structures->set('view_diagnosis', 'diagnosisStructure');
        $this->Structures->set($txControlData['TreatmentControl']['form_alias'], 'atim_structure', array(
            'model_table_assoc' => array(
                'TreatmentDetail' => $txControlData['TreatmentControl']['detail_tablename']
            )
        ));
        $this->Structures->Set('empty', 'emptyStructure');
        $this->set('useAddgrid', $txControlData['TreatmentControl']['use_addgrid']);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            if ($txControlData['TreatmentControl']['use_addgrid'])
                $this->request->data = array(
                    array()
                );
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            if (! $txControlData['TreatmentControl']['use_addgrid']) {
                
                // 1 - ** Single data save **
                
                $this->request->data['TreatmentMaster']['participant_id'] = $participantId;
                $this->request->data['TreatmentMaster']['treatment_control_id'] = $txControlId;
                $this->TreatmentMaster->addWritableField(array(
                    'participant_id',
                    'treatment_control_id',
                    'diagnosis_master_id'
                ));
                $this->TreatmentMaster->addWritableField('treatment_master_id', $txControlData['TreatmentControl']['detail_tablename']);
                
                // LAUNCH SPECIAL VALIDATION PROCESS
                $submittedDataValidates = true;
                // ... special validations
                
                // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
                $hookLink = $this->hook('presave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                if ($submittedDataValidates) {
                    if ($this->TreatmentMaster->save($this->request->data)) {
                        $treatmentMasterId = $this->TreatmentMaster->getLastInsertId();
                        $urlToFlash = '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $treatmentMasterId;
                        if ($txControlData['TreatmentControl']['treatment_extend_control_id']) {
                            if ($txControlData['TreatmentControl']['extended_data_import_process'] && isset($this->request->data['TreatmentMaster']['protocol_master_id']) && $this->request->data['TreatmentMaster']['protocol_master_id']) {
                                if (AppController::checkLinkPermission('/ClinicalAnnotation/TreatmentExtendMasters/' . $txControlData['TreatmentControl']['extended_data_import_process']))
                                    $urlToFlash = '/ClinicalAnnotation/TreatmentExtendMasters/' . $txControlData['TreatmentControl']['extended_data_import_process'] . '/' . $participantId . '/' . $treatmentMasterId;
                            } else {
                                if (AppController::checkLinkPermission('/ClinicalAnnotation/TreatmentExtendMasters/add/'))
                                    $urlToFlash = '/ClinicalAnnotation/TreatmentExtendMasters/add/' . $participantId . '/' . $treatmentMasterId;
                            }
                        }
                        
                        $hookLink = $this->hook('postsave_process');
                        if ($hookLink) {
                            require ($hookLink);
                        }
                        
                        $this->atimFlash(__('your data has been saved'), $urlToFlash);
                    }
                }
            } else {
                
                // 2 - ** Multi lines save **
                
                $errorsTracking = array();
                
                // Launch Structure Fields Validation
                $diagnosisMasterId = (array_key_exists('TreatmentMaster', $this->request->data) && array_key_exists('diagnosis_master_id', $this->request->data['TreatmentMaster'])) ? $this->request->data['TreatmentMaster']['diagnosis_master_id'] : null;
                unset($this->request->data['TreatmentMaster']);
                
                $rowCounter = 0;
                foreach ($this->request->data as &$dataUnit) {
                    $rowCounter ++;
                    
                    $dataUnit['TreatmentMaster']['treatment_control_id'] = $txControlId;
                    $dataUnit['TreatmentMaster']['participant_id'] = $participantId;
                    $dataUnit['TreatmentMaster']['diagnosis_master_id'] = $diagnosisMasterId;
                    
                    $this->TreatmentMaster->id = null;
                    $this->TreatmentMaster->set($dataUnit);
                    if (! $this->TreatmentMaster->validates()) {
                        foreach ($this->TreatmentMaster->validationErrors as $field => $msgs) {
                            $msgs = is_array($msgs) ? $msgs : array(
                                $msgs
                            );
                            foreach ($msgs as $msg)
                                $errorsTracking[$field][$msg][] = $rowCounter;
                        }
                    }
                    $dataUnit = $this->TreatmentMaster->data;
                }
                unset($dataUnit);
                
                $hookLink = $this->hook('presave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                // Launch Save Process
                if (empty($this->request->data)) {
                    $this->TreatmentMaster->validationErrors[][] = 'at least one record has to be created';
                } elseif (empty($errorsTracking)) {
                    AppModel::acquireBatchViewsUpdateLock();
                    // save all
                    $this->TreatmentMaster->addWritableField(array(
                        'participant_id',
                        'treatment_control_id',
                        'diagnosis_master_id'
                    ));
                    $this->TreatmentMaster->addWritableField('treatment_master_id', $txControlData['TreatmentControl']['detail_tablename']);
                    foreach ($this->request->data as $newDataToSave) {
                        $this->TreatmentMaster->id = null;
                        $this->TreatmentMaster->data = array();
                        if (! $this->TreatmentMaster->save($newDataToSave, false))
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    $urlToFlash = '/ClinicalAnnotation/TreatmentMasters/listall/' . $participantId . '/';
                    $hookLink = $this->hook('postsave_process_batch');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    AppModel::releaseBatchViewsUpdateLock();
                    $this->atimFlash(__('your data has been updated'), $urlToFlash);
                } else {
                    $this->TreatmentMaster->validationErrors = array();
                    foreach ($errorsTracking as $field => $msgAndLines) {
                        foreach ($msgAndLines as $msg => $lines) {
                            $this->TreatmentMaster->validationErrors[$field][] = $msg . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
                        }
                    }
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $txMasterId
     */
    public function delete($participantId, $txMasterId)
    {
        
        // MANAGE DATA
        $treatmentMasterData = $this->TreatmentMaster->find('first', array(
            'conditions' => array(
                'TreatmentMaster.id' => $txMasterId,
                'TreatmentMaster.participant_id' => $participantId
            )
        ));
        if (empty($treatmentMasterData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->TreatmentMaster->set($treatmentMasterData);
        $arrAllowDeletion = $this->TreatmentMaster->allowDeletion($txMasterId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->TreatmentMaster->atimDelete($txMasterId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/ClinicalAnnotation/TreatmentMasters/listall/' . $participantId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/ClinicalAnnotation/TreatmentMasters/listall/' . $participantId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $txMasterId);
        }
    }
}