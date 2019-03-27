<?php

/**
 * Class ProtocolExtendMastersController
 */
class ProtocolExtendMastersController extends ProtocolAppController
{

    public $uses = array(
        'Protocol.ProtocolExtendMaster',
        'Protocol.ProtocolExtendControl',
        
        'Protocol.ProtocolMaster',
        'Protocol.ProtocolControl',
        
        'Drug.Drug'
    );

    public $paginate = array();

    /**
     *
     * @param $protocolMasterId
     */
    public function listall($protocolMasterId)
    {
        $protocolMasterData = $this->ProtocolMaster->getOrRedirect($protocolMasterId);
        if (! $protocolMasterData['ProtocolControl']['protocol_extend_control_id']) {
            $this->atimFlashWarning(__('no additional data has to be defined for this type of protocol'), '/Protocol/ProtocolMasters/detail/' . $protocolMasterId);
            return;
        }
        
        $protocolExtendControlData = $this->ProtocolExtendControl->getOrRedirect($protocolMasterData['ProtocolControl']['protocol_extend_control_id']);
        $this->request->data = $this->paginate($this->ProtocolExtendMaster, array(
            'ProtocolExtendMaster.protocol_master_id' => $protocolMasterId,
            'ProtocolExtendMaster.protocol_extend_control_id' => $protocolMasterData['ProtocolControl']['protocol_extend_control_id']
        ));
        
        $this->Structures->set($protocolExtendControlData['ProtocolExtendControl']['form_alias']);
        $this->set('atimMenuVariables', array(
            'ProtocolMaster.id' => $protocolMasterId
        ));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $protocolMasterId
     * @param $protocolExtendMasterId
     */
    public function detail($protocolMasterId, $protocolExtendMasterId)
    {
        // Get treatment master row for extended data
        $protocolMasterData = $this->ProtocolMaster->getOrRedirect($protocolMasterId);
        if (! $protocolMasterData['ProtocolControl']['protocol_extend_control_id']) {
            $this->atimFlashWarning(__('no additional data has to be defined for this type of protocol'), '/Protocol/ProtocolMasters/detail/' . $protocolMasterId);
            return;
        }
        
        $condtions = array(
            'ProtocolExtendMaster.id' => $protocolExtendMasterId,
            'ProtocolExtendMaster.protocol_master_id' => $protocolMasterId
        );
        $this->request->data = $this->ProtocolExtendMaster->find('first', array(
            'conditions' => $condtions
        ));
        if (empty($this->request->data))
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        
        $this->Structures->set($this->request->data['ProtocolExtendControl']['form_alias']);
        $this->set('atimMenuVariables', array(
            'ProtocolMaster.id' => $protocolMasterId,
            'ProtocolExtendMaster.id' => $protocolExtendMasterId
        ));
        $this->set('atimMenu', $this->Menus->get('/Protocol/ProtocolMasters/detail/%%ProtocolMaster.id%%'));
        
        $isUsed = $this->ProtocolMaster->isLinkedToTreatment($protocolMasterId);
        if ($isUsed['is_used']) {
            AppController::addWarningMsg(__('warning') . ": " . __($isUsed['msg']));
        }
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $protocolMasterId
     */
    public function add($protocolMasterId)
    {
        if (! $protocolMasterId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get treatment master row for extended data
        $protocolMasterData = $this->ProtocolMaster->getOrRedirect($protocolMasterId);
        if (! $protocolMasterData['ProtocolControl']['protocol_extend_control_id']) {
            $this->atimFlashWarning(__('no additional data has to be defined for this type of protocol'), '/Protocol/ProtocolMasters/detail/' . $protocolMasterId);
            return;
        }
        
        // Set tablename to use
        $protocolExtendControlData = $this->ProtocolExtendControl->getOrRedirect($protocolMasterData['ProtocolControl']['protocol_extend_control_id']);
        
        $this->Structures->set($protocolExtendControlData['ProtocolExtendControl']['form_alias']);
        $this->set('atimMenuVariables', array(
            'ProtocolMaster.id' => $protocolMasterId
        ));
        $this->set('atimMenu', $this->Menus->get('/Protocol/ProtocolMasters/detail/%%ProtocolMaster.id%%'));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            $this->request->data['ProtocolExtendMaster']['protocol_master_id'] = $protocolMasterId;
            $this->request->data['ProtocolExtendMaster']['protocol_extend_control_id'] = $protocolMasterData['ProtocolControl']['protocol_extend_control_id'];
            $this->ProtocolExtendMaster->addWritableField(array(
                'protocol_master_id',
                'protocol_extend_control_id'
            ));
            
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates && $this->ProtocolExtendMaster->save($this->request->data)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been saved'), '/Protocol/ProtocolMasters/detail/' . $protocolMasterId);
            }
        }
    }

    /**
     *
     * @param $protocolMasterId
     * @param $protocolExtendMasterId
     */
    public function edit($protocolMasterId, $protocolExtendMasterId)
    {
        if ((! $protocolMasterId) || (! $protocolExtendMasterId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get treatment master row for extended data
        $protocolMasterData = $this->ProtocolMaster->getOrRedirect($protocolMasterId);
        if (! $protocolMasterData['ProtocolControl']['protocol_extend_control_id']) {
            $this->atimFlashWarning(__('no additional data has to be defined for this type of protocol'), '/Protocol/ProtocolMasters/detail/' . $protocolMasterId);
            return;
        }
        
        $condtions = array(
            'ProtocolExtendMaster.id' => $protocolExtendMasterId,
            'ProtocolExtendMaster.protocol_master_id' => $protocolMasterId
        );
        $protExtendData = $this->ProtocolExtendMaster->find('first', array(
            'conditions' => $condtions
        ));
        if (empty($protExtendData))
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        
        $this->Structures->set($protExtendData['ProtocolExtendControl']['form_alias']);
        $this->set('atimMenuVariables', array(
            'ProtocolMaster.id' => $protocolMasterId,
            'ProtocolExtendMaster.id' => $protocolExtendMasterId
        ));
        $this->set('atimMenu', $this->Menus->get('/Protocol/ProtocolMasters/detail/%%ProtocolMaster.id%%'));
        
        $isUsed = $this->ProtocolMaster->isLinkedToTreatment($protocolMasterId);
        if ($isUsed['is_used']) {
            AppController::addWarningMsg(__('warning') . ": " . __($isUsed['msg']));
        }
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $protExtendData['FunctionManagement']['autocomplete_protocol_drug_id'] = $this->Drug->getDrugDataAndCodeForDisplay(array(
                'Drug' => array(
                    'id' => $protExtendData['ProtocolExtendMaster']['drug_id']
                )
            ));
            $this->request->data = $protExtendData;
            
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
            
            $this->ProtocolExtendMaster->id = $protocolExtendMasterId;
            if ($submittedDataValidates && $this->ProtocolExtendMaster->save($this->request->data)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been updated'), '/Protocol/ProtocolExtendMasters/detail/' . $protocolMasterId . '/' . $protocolExtendMasterId);
            }
        }
    }

    /**
     *
     * @param $protocolMasterId
     * @param $protocolExtendMasterId
     */
    public function delete($protocolMasterId, $protocolExtendMasterId)
    {
        if ((! $protocolMasterId) || (! $protocolExtendMasterId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get treatment master row for extended data
        $protocolMasterData = $this->ProtocolMaster->getOrRedirect($protocolMasterId);
        if (! $protocolMasterData['ProtocolControl']['protocol_extend_control_id']) {
            $this->atimFlashWarning(__('no additional data has to be defined for this type of protocol'), '/Protocol/ProtocolMasters/detail/' . $protocolMasterId);
            return;
        }
        
        // Set extend data
        $condtions = array(
            'ProtocolExtendMaster.id' => $protocolExtendMasterId,
            'ProtocolExtendMaster.protocol_master_id' => $protocolMasterId
        );
        $protExtendData = $this->ProtocolExtendMaster->find('first', array(
            'conditions' => $condtions
        ));
        if (empty($protExtendData))
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        
        $arrAllowDeletion = $this->ProtocolExtendMaster->allowDeletion($protocolExtendMasterId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->ProtocolExtendMaster->atimDelete($protocolExtendMasterId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/Protocol/ProtocolMasters/detail/' . $protocolMasterId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/Protocol/ProtocolMasters/detail/' . $protocolMasterId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Protocol/ProtocolExtendMaster/detail/' . $protocolMasterId . '/' . $protocolExtendMasterId);
        }
    }
}