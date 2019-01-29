<?php

/**
 * Class ReproductiveHistoriesController
 */
class ReproductiveHistoriesController extends ClinicalAnnotationAppController
{

    public $uses = array(
        'ClinicalAnnotation.ReproductiveHistory',
        'ClinicalAnnotation.Participant'
    );

    public $paginate = array(
        'ReproductiveHistory' => array(
            'order' => 'ReproductiveHistory.date_captured'
        )
    );

    /**
     *
     * @param $participantId
     */
    public function listall($participantId)
    {
        // MANAGE DATA
        $participantData = $this->Participant->getOrRedirect($participantId);
        
        $this->request->data = $this->paginate($this->ReproductiveHistory, array(
            'ReproductiveHistory.participant_id' => $participantId
        ));
        
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
     * @param $reproductiveHistoryId
     */
    public function detail($participantId, $reproductiveHistoryId)
    {
        if (! $participantId && ! $reproductiveHistoryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $reproductiveData = $this->ReproductiveHistory->find('first', array(
            'conditions' => array(
                'ReproductiveHistory.id' => $reproductiveHistoryId,
                'ReproductiveHistory.participant_id' => $participantId
            ),
            'recursive' => - 1
        ));
        if (empty($reproductiveData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $reproductiveData;
        
        $this->request->data = $this->ReproductiveHistory->find('first', array(
            'conditions' => array(
                'ReproductiveHistory.id' => $reproductiveHistoryId
            )
        ));
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'ReproductiveHistory.id' => $reproductiveHistoryId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param null $participantId
     */
    public function add($participantId = null)
    {
        if (! $participantId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
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
        
        if (! empty($this->request->data)) {
            $this->request->data['ReproductiveHistory']['participant_id'] = $participantId;
            $this->ReproductiveHistory->addWritableField('participant_id');
            
            $submittedDataValidates = true;
            // ... special validations
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                if ($this->ReproductiveHistory->save($this->request->data)) {
                    $urlToFlash = '/ClinicalAnnotation/ReproductiveHistories/detail/' . $participantId . '/' . $this->ReproductiveHistory->id;
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
     * @param $reproductiveHistoryId
     */
    public function edit($participantId, $reproductiveHistoryId)
    {
        if ((! $participantId) && (! $reproductiveHistoryId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $reproductiveHistoryData = $this->ReproductiveHistory->find('first', array(
            'conditions' => array(
                'ReproductiveHistory.id' => $reproductiveHistoryId,
                'ReproductiveHistory.participant_id' => $participantId
            )
        ));
        if (empty($reproductiveHistoryData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'ReproductiveHistory.id' => $reproductiveHistoryId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $reproductiveHistoryData;
        } else {
            $submittedDataValidates = true;
            // ... special validations
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->ReproductiveHistory->id = $reproductiveHistoryId;
                if ($this->ReproductiveHistory->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/ReproductiveHistories/detail/' . $participantId . '/' . $reproductiveHistoryId);
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $reproductiveHistoryId
     */
    public function delete($participantId, $reproductiveHistoryId)
    {
        if ((! $participantId) && (! $reproductiveHistoryId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $reproductiveHistoryData = $this->ReproductiveHistory->find('first', array(
            'conditions' => array(
                'ReproductiveHistory.id' => $reproductiveHistoryId,
                'ReproductiveHistory.participant_id' => $participantId
            )
        ));
        if (empty($reproductiveHistoryData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $arrAllowDeletion = $this->ReproductiveHistory->allowDeletion($reproductiveHistoryId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            // DELETE DATA
            $flashLink = '/ClinicalAnnotation/ReproductiveHistories/listall/' . $participantId;
            if ($this->ReproductiveHistory->atimDelete($reproductiveHistoryId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), $flashLink);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), $flashLink);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/ClinicalAnnotation/ReproductiveHistories/detail/' . $participantId . '/' . $reproductiveHistoryId);
        }
    }
}