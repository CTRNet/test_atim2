<?php

/**
 * Class TreatmentExtendMastersController
 */
class TreatmentExtendMastersController extends ClinicalAnnotationAppController
{

    public $uses = array(
        'ClinicalAnnotation.TreatmentExtendMaster',
        'ClinicalAnnotation.TreatmentExtendControl',
        'ClinicalAnnotation.TreatmentMaster',
        'ClinicalAnnotation.TreatmentControl',
        
        'Protocol.ProtocolMaster',
        'Protocol.ProtocolControl',
        'Protocol.ProtocolExtendMaster',
        
        'Drug.Drug'
    );

    public $paginate = array();

    /**
     *
     * @param $participantId
     * @param $txMasterId
     */
    public function add($participantId, $txMasterId)
    {
        // Get treatment data
        $txMasterData = $this->TreatmentMaster->getOrRedirect($txMasterId);
        if ($txMasterData['TreatmentMaster']['participant_id'] != $participantId)
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        if (! $txMasterData['TreatmentControl']['treatment_extend_control_id']) {
            $this->atimFlashWarning(__('no additional data has to be defined for this type of treatment'), '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $txMasterId);
            return;
        }
        
        $txExtendControlData = $this->TreatmentExtendControl->getOrRedirect($txMasterData['TreatmentControl']['treatment_extend_control_id']);
        
        $this->set('txExtendType', $txExtendControlData['TreatmentExtendControl']['type']);
        
        // Set form alias and menu
        $this->Structures->set($txExtendControlData['TreatmentExtendControl']['form_alias']);
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'TreatmentMaster.id' => $txMasterId
        ));
        
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/detail/%%Participant.id%%/%%TreatmentMaster.id%%'));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data[] = array();
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            $errors = array();
            $lineCounter = 0;
            foreach ($this->request->data as &$newRow) {
                $lineCounter ++;
                $newRow['TreatmentExtendMaster']['treatment_extend_control_id'] = $txMasterData['TreatmentControl']['treatment_extend_control_id'];
                $newRow['TreatmentExtendMaster']['treatment_master_id'] = $txMasterId;
                $this->TreatmentExtendMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                $this->TreatmentExtendMaster->set($newRow);
                if (! $this->TreatmentExtendMaster->validates()) {
                    foreach ($this->TreatmentExtendMaster->validationErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $msg)
                            $errors[$field][$msg][] = $lineCounter;
                        $submittedDataValidates = false;
                    }
                }
                $newRow = $this->TreatmentExtendMaster->data;
            }
            
            echo $this->TreatmentExtendMaster->addWritableField(array(
                'treatment_master_id',
                'treatment_extend_control_id'
            ));
            $this->TreatmentExtendMaster->writableFieldsMode = 'addgrid';
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if (empty($errors)) {
                AppModel::acquireBatchViewsUpdateLock();
                
                foreach ($this->request->data as $newData) {
                    $this->TreatmentExtendMaster->id = null;
                    $this->TreatmentExtendMaster->data = array(); // *** To guaranty no merge will be done with previous data ***
                    if (! $this->TreatmentExtendMaster->save($newData, false))
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                $urlToFlash = '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $txMasterId;
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                $this->atimFlash(__('your data has been saved'), $urlToFlash);
            } else {
                $this->TreatmentExtendMaster->validationErrors = array();
                if (isset($this->TreatmentExtendDetail->validationErrors))
                    $this->TreatmentExtendDetail->validationErrors = array();
                foreach ($errors as $field => $msgAndLines) {
                    foreach ($msgAndLines as $msg => $lines) {
                        $msg = __($msg);
                        $linesStrg = implode(",", array_unique($lines));
                        if (! empty($linesStrg)) {
                            $msg .= ' - ' . str_replace('%s', $linesStrg, __('see line %s'));
                        }
                        $this->TreatmentExtendMaster->validationErrors[$field][] = $msg;
                    }
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $txMasterId
     * @param $txExtendId
     */
    public function edit($participantId, $txMasterId, $txExtendId)
    {
        // Get treatment extend data
        $txExtendData = $this->TreatmentExtendMaster->getOrRedirect($txExtendId);
        if ($txExtendData['TreatmentMaster']['id'] != $txMasterId)
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        
        $this->set('txExtendType', $txExtendData['TreatmentExtendControl']['type']);
        
        // Set form alias and menu data
        $this->Structures->set($txExtendData['TreatmentExtendControl']['form_alias']);
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'TreatmentMaster.id' => $txMasterId,
            'TreatmentExtendMaster.id' => $txExtendId
        ));
        
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/TreatmentMasters/detail/%%Participant.id%%/%%TreatmentMaster.id%%'));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $txExtendData['FunctionManagement']['autocomplete_treatment_drug_id'] = $this->Drug->getDrugDataAndCodeForDisplay(array(
                'Drug' => array(
                    'id' => $txExtendData['TreatmentExtendMaster']['drug_id']
                )
            ));
            $this->request->data = $txExtendData;
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // To allow particiant Last Modification update
            $this->request->data['TreatmentExtendMaster']['treatment_master_id'] = $txMasterId;
            $this->TreatmentExtendMaster->addWritableField('treatment_master_id');
            $this->TreatmentExtendMaster->writableFieldsMode = 'addgrid';
            
            $this->TreatmentExtendMaster->id = $txExtendId;
            if ($submittedDataValidates && $this->TreatmentExtendMaster->save($this->request->data)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $txMasterId);
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $txMasterId
     * @param $txExtendId
     */
    public function delete($participantId, $txMasterId, $txExtendId)
    {
        // Get treatment extend data
        $txExtendData = $this->TreatmentExtendMaster->getOrRedirect($txExtendId);
        if ($txExtendData['TreatmentMaster']['id'] != $txMasterId)
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        
        $arrAllowDeletion = $this->TreatmentExtendMaster->allowDeletion($txExtendId);
        
        // CUSTOM CODE
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->TreatmentExtendMaster->atimDelete($txExtendId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $txMasterId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $txMasterId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $txMasterId);
        }
    }

    /**
     *
     * @param $participantId
     * @param $txMasterId
     */
    public function importDrugFromChemoProtocol($participantId, $txMasterId)
    {
        $txMasterData = $this->TreatmentMaster->getOrRedirect($txMasterId);
        if ($txMasterData['TreatmentMaster']['participant_id'] != $participantId)
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        
        if (is_numeric($txMasterData['TreatmentMaster']['protocol_master_id'])) {
            $protcolData = $this->ProtocolMaster->getOrRedirect($txMasterData['TreatmentMaster']['protocol_master_id']);
            $protExtendData = $this->ProtocolExtendMaster->find('all', array(
                'conditions' => array(
                    'ProtocolExtendMaster.protocol_master_id' => $txMasterData['TreatmentMaster']['protocol_master_id']
                )
            ));
            $data = array();
            if (empty($protExtendData)) {
                $this->atimFlashWarning(__('there is no drug defined in the associated protocol'), '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $txMasterId);
            } else {
                foreach ($protExtendData as $protExtend) {
                    $data[] = array(
                        'TreatmentExtendMaster' => array(
                            'treatment_master_id' => $txMasterId,
                            'treatment_extend_control_id' => $txMasterData['TreatmentControl']['treatment_extend_control_id'],
                            'drug_id' => $protExtend['ProtocolExtendMaster']['drug_id']
                        ),
                        'TreatmentExtendDetail' => array(
                            'method' => $protExtend['ProtocolExtendDetail']['method'],
                            'dose' => $protExtend['ProtocolExtendDetail']['dose']
                        )
                    );
                }
                $this->TreatmentExtendMaster->checkWritableFields = false;
                if ($this->TreatmentExtendMaster->saveAll($data)) {
                    $this->atimFlash(__('drugs from the associated protocol were imported'), '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $txMasterId);
                } else {
                    $this->atimFlashError(__('unknown error'), '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $txMasterId);
                }
            }
        } else {
            $this->atimFlashWarning(__('there is no protocol associated with this treatment'), '/ClinicalAnnotation/TreatmentMasters/detail/' . $participantId . '/' . $txMasterId);
        }
    }
}