<?php

/**
 * Class ParticipantMessagesController
 */
class ParticipantMessagesController extends ClinicalAnnotationAppController
{

    public $uses = array(
        'ClinicalAnnotation.ParticipantMessage',
        'ClinicalAnnotation.Participant'
    );

    public $paginate = array(
        'ParticipantMessage' => array(
            'order' => 'ParticipantMessage.date_requested'
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
        
        $this->request->data = $this->paginate($this->ParticipantMessage, array(
            'ParticipantMessage.participant_id' => $participantId
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
     * @param $participantMessageId
     */
    public function detail($participantId, $participantMessageId)
    {
        // MANAGE DATA
        $participantMesssageData = $this->ParticipantMessage->find('first', array(
            'conditions' => array(
                'ParticipantMessage.id' => $participantMessageId,
                'ParticipantMessage.participant_id' => $participantId
            ),
            'recursive' => - 1
        ));
        if (empty($participantMesssageData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $participantMesssageData;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'ParticipantMessage.id' => $participantMessageId
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
        // GET DATA
        $initialDisplay = false;
        $participantIds = array();
        
        $this->setUrlToCancel();
        $urlToCancel = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        if ($participantId) {
            // User is working on a participant
            $participantIds = array(
                $participantId
            );
            if (empty($this->request->data))
                $initialDisplay = true;
        } elseif (isset($this->request->data['Participant']['id'])) {
            // User launched an action from the DataBrowser or a Report Form
            if ($this->request->data['Participant']['id'] == 'all' && isset($this->request->data['node'])) {
                // The displayed elements number was higher than the databrowser_and_report_results_display_limit
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $this->request->data['Participant']['id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
            $participantIds = array_filter($this->request->data['Participant']['id']);
            $initialDisplay = true;
        } elseif (isset($this->request->data['participant_ids'])) {
            $participantIds = explode(',', $this->request->data['participant_ids']);
            unset($this->request->data['participant_ids']);
        } else {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel);
            return;
        }
        
        // Get participants data
        
        $participants = $this->Participant->find('all', array(
            'conditions' => array(
                'Participant.id' => $participantIds
            ),
            'recursive' => 0
        ));
        if (! $participants)
            $this->atimFlashWarning(__('at least one participant should be selected'), $urlToCancel);
        $displayLimit = Configure::read('ParticipantMessageCreation_processed_participants_limit');
        if (sizeof($participants) > $displayLimit)
            $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", $urlToCancel);
        $this->set('participantIds', implode(',', $participantIds));
        
        if ($participantId)
            $urlToCancel = '/ClinicalAnnotation/ParticipantMessages/listall/' . $participantId;
        
        $this->set('urlToCancel', $urlToCancel);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId
        ));
        if (! $participantId) {
            $this->set('atimMenu', $this->Menus->get('/InventoryManagement/'));
        }
        
        // MANAGE DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($initialDisplay) {
            
            $this->request->data = array();
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            $submittedDataValidates = true;
            
            // Validation
            
            $this->ParticipantMessage->id = null;
            $this->ParticipantMessage->data = null;
            $this->ParticipantMessage->set($this->request->data);
            if (! $this->ParticipantMessage->validates())
                $submittedDataValidates = false;
            $this->request->data = $this->ParticipantMessage->data;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                
                // saving
                
                $this->ParticipantMessage->addWritableField(array(
                    'participant_id'
                ));
                $this->ParticipantMessage->writableFieldsMode = 'add';
                foreach ($participantIds as $messageParticipantId) {
                    $this->ParticipantMessage->id = null;
                    $this->ParticipantMessage->data = null;
                    $this->request->data['ParticipantMessage']['participant_id'] = $messageParticipantId;
                    if (! $this->ParticipantMessage->save($this->request->data, false))
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                if ($participantId) {
                    $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/ParticipantMessages/detail/' . $participantId . '/' . $this->ParticipantMessage->id);
                } else {
                    // batch
                    $batchIds = $participantIds;
                    $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                    
                    $batchSetData = array(
                        'BatchSet' => array(
                            'datamart_structure_id' => $datamartStructure->getIdByModelName('Participant'),
                            'flag_tmp' => true
                        )
                    );
                    
                    $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                    $batchSetModel->saveWithIds($batchSetData, $batchIds);
                    
                    $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId());
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $participantMessageId
     */
    public function edit($participantId, $participantMessageId)
    {
        if (! $participantId && ! $participantMessageId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $participantMessageData = $this->ParticipantMessage->find('first', array(
            'conditions' => array(
                'ParticipantMessage.id' => $participantMessageId,
                'ParticipantMessage.participant_id' => $participantId
            ),
            'recursive' => - 1
        ));
        if (empty($participantMessageData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'ParticipantMessage.id' => $participantMessageId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $participantMessageData;
        } else {
            $submittedDataValidates = true;
            // ... special validations
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->ParticipantMessage->id = $participantMessageId;
                if ($this->ParticipantMessage->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/ParticipantMessages/detail/' . $participantId . '/' . $participantMessageId);
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $participantMessageId
     */
    public function delete($participantId, $participantMessageId)
    {
        // MANAGE DATA
        $participantMessageData = $this->ParticipantMessage->find('first', array(
            'conditions' => array(
                'ParticipantMessage.id' => $participantMessageId,
                'ParticipantMessage.participant_id' => $participantId
            ),
            'recursive' => - 1
        ));
        if (empty($participantMessageData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $arrAllowDeletion = $this->ParticipantMessage->allowDeletion($participantMessageId);
        
        if ($arrAllowDeletion['allow_deletion']) {
            
            if ($this->ParticipantMessage->atimDelete($participantMessageId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/ClinicalAnnotation/ParticipantMessages/listall/' . $participantId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/ClinicalAnnotation/ParticipantMessages/listall/' . $participantId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/ClinicalAnnotation/ParticipantMessages/detail/' . $participantId . '/' . $participantMessageId);
        }
    }

    /**
     *
     * @param int $searchId
     */
    public function search($searchId = 0)
    {
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/Participants/search'));
        
        $hookLink = $this->hook('pre_search_handler');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->searchHandler($searchId, $this->ParticipantMessage, 'participantmessages', '/ClinicalAnnotation/ParticipantMessages/search');
        $this->Structures->set('participantmessages');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($searchId)) {
            // index
            $this->render('index');
        }
    }
}