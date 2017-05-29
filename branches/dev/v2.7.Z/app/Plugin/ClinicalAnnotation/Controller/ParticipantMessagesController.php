<?php

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

    function listall($participant_id)
    {
        // MANAGE DATA
        $participant_data = $this->Participant->getOrRedirect($participant_id);
        
        $this->request->data = $this->paginate($this->ParticipantMessage, array(
            'ParticipantMessage.participant_id' => $participant_id
        ));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atim_menu_variables', array(
            'Participant.id' => $participant_id
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
    }

    function detail($participant_id, $participant_message_id)
    {
        // MANAGE DATA
        $participant_messsage_data = $this->ParticipantMessage->find('first', array(
            'conditions' => array(
                'ParticipantMessage.id' => $participant_message_id,
                'ParticipantMessage.participant_id' => $participant_id
            ),
            'recursive' => '-1'
        ));
        if (empty($participant_messsage_data)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $participant_messsage_data;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atim_menu_variables', array(
            'Participant.id' => $participant_id,
            'ParticipantMessage.id' => $participant_message_id
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
    }

    function add($participant_id = null)
    {
        // GET DATA
        $initial_display = false;
        $participant_ids = array();
        
        $this->setUrlToCancel();
        $url_to_cancel = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        if ($participant_id) {
            // User is working on a participant
            $participant_ids = array(
                $participant_id
            );
            if (empty($this->request->data))
                $initial_display = true;
        } else 
            if (isset($this->request->data['Participant']['id'])) {
                // User launched an action from the DataBrowser or a Report Form
                if ($this->request->data['Participant']['id'] == 'all' && isset($this->request->data['node'])) {
                    // The displayed elements number was higher than the databrowser_and_report_results_display_limit
                    $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                    $browsing_result = $this->BrowsingResult->find('first', array(
                        'conditions' => array(
                            'BrowsingResult.id' => $this->request->data['node']['id']
                        )
                    ));
                    $this->request->data['Participant']['id'] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
                }
                $participant_ids = array_filter($this->request->data['Participant']['id']);
                $initial_display = true;
            } else 
                if (isset($this->request->data['participant_ids'])) {
                    $participant_ids = explode(',', $this->request->data['participant_ids']);
                    unset($this->request->data['participant_ids']);
                } else {
                    $this->flash((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $url_to_cancel, 5);
                    return;
                }
        
        // Get participants data
        
        $participants = $this->Participant->find('all', array(
            'conditions' => array(
                'Participant.id' => $participant_ids
            ),
            'recursive' => '0'
        ));
        if (! $participants)
            $this->flash((__('at least one participant should be selected')), $url_to_cancel, 5);
        $display_limit = Configure::read('ParticipantMessageCreation_processed_participants_limit');
        if (sizeof($participants) > $display_limit)
            $this->flash(__("batch init - number of submitted records too big") . " (>$display_limit)", $url_to_cancel, 5);
        $this->set('participant_ids', implode(',', $participant_ids));
        
        if ($participant_id)
            $url_to_cancel = '/ClinicalAnnotation/ParticipantMessages/listall/' . $participant_id;
        
        $this->set('url_to_cancel', $url_to_cancel);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atim_menu_variables', array(
            'Participant.id' => $participant_id
        ));
        if (! $participant_id) {
            $this->set('atim_menu', $this->Menus->get('/InventoryManagement/'));
        }
        
        // MANAGE DATA
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if ($initial_display) {
            
            $this->request->data = array();
            
            $hook_link = $this->hook('initial_display');
            if ($hook_link) {
                require ($hook_link);
            }
        } else {
            
            $submitted_data_validates = true;
            
            // Validation
            
            $this->ParticipantMessage->id = null;
            $this->ParticipantMessage->data = null;
            $this->ParticipantMessage->set($this->request->data);
            if (! $this->ParticipantMessage->validates())
                $submitted_data_validates = false;
            $this->request->data = $this->ParticipantMessage->data;
            
            $hook_link = $this->hook('presave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            if ($submitted_data_validates) {
                
                // saving
                
                $this->ParticipantMessage->addWritableField(array(
                    'participant_id'
                ));
                $this->ParticipantMessage->writable_fields_mode = 'add';
                foreach ($participant_ids as $message_participant_id) {
                    $this->ParticipantMessage->id = null;
                    $this->ParticipantMessage->data = null;
                    $this->request->data['ParticipantMessage']['participant_id'] = $message_participant_id;
                    if (! $this->ParticipantMessage->save($this->request->data, false))
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                $hook_link = $this->hook('postsave_process');
                if ($hook_link) {
                    require ($hook_link);
                }
                
                if ($participant_id) {
                    $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/ParticipantMessages/detail/' . $participant_id . '/' . $this->ParticipantMessage->id);
                } else {
                    // batch
                    $batch_ids = $participant_ids;
                    $datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                    
                    $batch_set_data = array(
                        'BatchSet' => array(
                            'datamart_structure_id' => $datamart_structure->getIdByModelName('Participant'),
                            'flag_tmp' => true
                        )
                    );
                    
                    $batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
                    $batch_set_model->saveWithIds($batch_set_data, $batch_ids);
                    
                    $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batch_set_model->getLastInsertId());
                }
            }
        }
    }

    function edit($participant_id, $participant_message_id)
    {
        if (! $participant_id && ! $participant_message_id) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, NULL, TRUE);
        }
        
        // MANAGE DATA
        $participant_message_data = $this->ParticipantMessage->find('first', array(
            'conditions' => array(
                'ParticipantMessage.id' => $participant_message_id,
                'ParticipantMessage.participant_id' => $participant_id
            ),
            'recursive' => '-1'
        ));
        if (empty($participant_message_data)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atim_menu_variables', array(
            'Participant.id' => $participant_id,
            'ParticipantMessage.id' => $participant_message_id
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $participant_message_data;
        } else {
            $submitted_data_validates = true;
            // ... special validations
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hook_link = $this->hook('presave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            if ($submitted_data_validates) {
                $this->ParticipantMessage->id = $participant_message_id;
                if ($this->ParticipantMessage->save($this->request->data)) {
                    $hook_link = $this->hook('postsave_process');
                    if ($hook_link) {
                        require ($hook_link);
                    }
                    $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/ParticipantMessages/detail/' . $participant_id . '/' . $participant_message_id);
                }
            }
        }
    }

    function delete($participant_id, $participant_message_id)
    {
        // MANAGE DATA
        $participant_message_data = $this->ParticipantMessage->find('first', array(
            'conditions' => array(
                'ParticipantMessage.id' => $participant_message_id,
                'ParticipantMessage.participant_id' => $participant_id
            ),
            'recursive' => '-1'
        ));
        if (empty($participant_message_data)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $arr_allow_deletion = $this->ParticipantMessage->allowDeletion($participant_message_id);
        
        if ($arr_allow_deletion['allow_deletion']) {
            
            if ($this->ParticipantMessage->atimDelete($participant_message_id)) {
                $hook_link = $this->hook('postsave_process');
                if ($hook_link) {
                    require ($hook_link);
                }
                $this->atimFlash(__('your data has been deleted'), '/ClinicalAnnotation/ParticipantMessages/listall/' . $participant_id);
            } else {
                $this->flash(__('error deleting data - contact administrator'), '/ClinicalAnnotation/ParticipantMessages/listall/' . $participant_id);
            }
        } else {
            $this->flash(__($arr_allow_deletion['msg']), '/ClinicalAnnotation/ParticipantMessages/detail/' . $participant_id . '/' . $participant_message_id);
        }
    }

    function search($search_id = 0)
    {
        $this->set('atim_menu', $this->Menus->get('/ClinicalAnnotation/Participants/search'));
        $this->searchHandler($search_id, $this->ParticipantMessage, 'participantmessages', '/ClinicalAnnotation/ParticipantMessages/search');
        $this->Structures->set('participantmessages');
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if (empty($search_id)) {
            // index
            $this->render('index');
        }
    }
}
