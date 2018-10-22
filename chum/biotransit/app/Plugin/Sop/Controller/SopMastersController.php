<?php

/**
 * Class SopMastersController
 */
class SopMastersController extends SopAppController
{

    public $uses = array(
        'Sop.SopControl',
        'Sop.SopMaster'
    );

    public $paginate = array(
        'SopMaster' => array(
            'order' => 'SopMaster.title DESC'
        )
    );

    public function listall()
    {
        $this->request->data = $this->paginate($this->SopMaster, array());
        
        // find all EVENTCONTROLS, for ADD form
        $this->set('sopControls', $this->SopControl->find('all', array(
            'conditions' => array(
                'SopControl.flag_active' => '1'
            )
        )));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $sopControlId
     */
    public function add($sopControlId)
    {
        $this->set('atimMenuVariables', array(
            'SopControl.id' => $sopControlId
        ));
        $thisData = $this->SopControl->find('first', array(
            'conditions' => array(
                'SopControl.id' => $sopControlId,
                'SopControl.flag_active' => '1'
            )
        ));
        if (empty($thisData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->set('sopControlData', $thisData['SopControl']);
        
        // set FORM ALIAS based off VALUE from CONTROL table
        $this->Structures->set($thisData['SopControl']['form_alias']);
        
        $atimMenu = $this->Menus->get('/Sop/SopMasters/listall/');
        $this->set('atimMenu', $atimMenu);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            
            $this->request->data['SopMaster']['sop_control_id'] = $sopControlId;
            $this->SopMaster->addWritableField('sop_control_id');
            
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                if ($this->SopMaster->save($this->request->data)) {
                    
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    
                    $this->atimFlash(__('your data has been updated'), '/Sop/SopMasters/detail/' . $this->SopMaster->getLastInsertId());
                }
            }
        }
    }

    /**
     *
     * @param $sopMasterId
     */
    public function detail($sopMasterId)
    {
        if (! $sopMasterId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('atimMenuVariables', array(
            'SopMaster.id' => $sopMasterId
        ));
        
        $this->request->data = $this->SopMaster->getOrRedirect($sopMasterId);
        
        // set FORM ALIAS based off VALUE from MASTER table
        $this->Structures->set($this->request->data['SopControl']['form_alias']);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $sopMasterId
     */
    public function edit($sopMasterId)
    {
        $this->set('atimMenuVariables', array(
            'SopMaster.id' => $sopMasterId
        ));
        $thisData = $this->SopMaster->getOrRedirect($sopMasterId);
        
        // set FORM ALIAS based off VALUE from MASTER table
        $this->Structures->set($thisData['SopControl']['form_alias']);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'SopMaster.id' => $sopMasterId
        ));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $thisData;
        } else {
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            $this->SopMaster->id = $sopMasterId;
            if ($submittedDataValidates) {
                if ($this->SopMaster->save($this->request->data)) {
                    
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    
                    $this->atimFlash(__('your data has been updated'), '/Sop/SopMasters/detail/' . $sopMasterId . '/');
                }
            }
        }
    }

    /**
     *
     * @param $sopMasterId
     */
    public function delete($sopMasterId)
    {
        if (! $sopMasterId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $thisData = $this->SopMaster->find('first', array(
            'conditions' => array(
                'SopMaster.id' => $sopMasterId
            )
        ));
        if (empty($thisData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->SopMaster->allowDeletion($sopMasterId);
        
        // CUSTOM CODE
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->SopMaster->atimDelete($sopMasterId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/Sop/SopMasters/listall/');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/Sop/SopMasters/listall/');
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Sop/SopMasters/detail/' . $sopMasterId);
        }
    }
}