<?php

/**
 * Class MiscIdentifiersController
 */
class MiscIdentifiersController extends ClinicalAnnotationAppController
{

    public $components = array();

    public $uses = array(
        'ClinicalAnnotation.MiscIdentifier',
        'ClinicalAnnotation.Participant',
        'ClinicalAnnotation.MiscIdentifierControl',
        
        'Study.StudySummary'
    );

    public $paginate = array(
        'MiscIdentifier' => array(
            'order' => 'MiscIdentifierControl.misc_identifier_name ASC, MiscIdentifier.identifier_value ASC'
        )
    );

    /**
     *
     * @param string $searchId
     */
    public function search($searchId = '')
    {
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/Participants/search'));
        
        $hookLink = $this->hook('pre_search_handler');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->searchHandler($searchId, $this->MiscIdentifier, 'miscidentifiers_for_participant_search', '/ClinicalAnnotation/MiscIdentifiers/search');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($searchId)) {
            // index
            $this->render('index');
        }
    }

    /**
     *
     * @param $participantId
     * @param $miscIdentifierControlId
     */
    public function add($participantId, $miscIdentifierControlId)
    {
        $this->Participant->getOrRedirect($participantId);
        $controls = $this->MiscIdentifierControl->getOrRedirect($miscIdentifierControlId);
        
        if ($controls['MiscIdentifierControl']['flag_confidential'] && ! $this->Session->read('flag_show_confidential')) {
            AppController::getInstance()->redirect("/Pages/err_confidential");
        }
        
        if ($controls['MiscIdentifierControl']['flag_once_per_participant']) {
            // Check identifier has not already been created
            $alreadyExist = $this->MiscIdentifier->find('count', array(
                'conditions' => array(
                    'misc_identifier_control_id' => $miscIdentifierControlId,
                    'participant_id' => $participantId
                )
            ));
            if ($alreadyExist) {
                $this->atimFlashWarning(__('this identifier has already been created for this participant'), '/ClinicalAnnotation/Participants/profile/' . $participantId . '/');
                return;
            }
        }
        
        $isIncrementedIdentifier = ! empty($controls['MiscIdentifierControl']['autoincrement_name']);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/Participants/profile'));
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'MiscIdentifierControl.id' => $miscIdentifierControlId
        ));
        
        $formAlias = ($isIncrementedIdentifier ? 'incrementedmiscidentifiers' : 'miscidentifiers') . ($controls['MiscIdentifierControl']['flag_link_to_study'] ? ',miscidentifiers_study' : '');
        $this->Structures->set($formAlias);
        
        // Following boolean created to allow hook to force the add form display when identifier is incremented
        $displayAddForm = true;
        if ($isIncrementedIdentifier ){
            $displayAddForm = false;
        }
            
            // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data) && $displayAddForm) {
            $this->request->data = $controls;
        } else {
            // Launch Save Process
            
            // Set additional data
            $this->request->data['MiscIdentifier']['participant_id'] = $participantId;
            $this->request->data['MiscIdentifier']['misc_identifier_control_id'] = $miscIdentifierControlId;
            if ($controls['MiscIdentifierControl']['flag_unique']) {
                $this->request->data['MiscIdentifier']['flag_unique'] = 1;
            }
            $this->MiscIdentifier->addWritableField(array(
                'participant_id',
                'misc_identifier_control_id',
                'flag_unique'
            ));
            
            // Launch validation
            $submittedDataValidates = true;
            
            if (! $isIncrementedIdentifier && isset($this->request->data['MiscIdentifier']['identifier_value'])) {
                $this->request->data['MiscIdentifier']['identifier_value'] = str_pad($this->request->data['MiscIdentifier']['identifier_value'], $controls['MiscIdentifierControl']['pad_to_length'], '0', STR_PAD_LEFT);
            }
            
            // ... special validations
            $saveState = $this->MiscIdentifier->saveValidateState($displayAddForm);
            
            $this->MiscIdentifier->set($this->request->data);
            $submittedDataValidates = $this->MiscIdentifier->validates() ? $submittedDataValidates : false;
            
            $this->MiscIdentifier->restoreValidateState($saveState);

            if ($controls['MiscIdentifierControl']['flag_unique'] && isset($this->request->data['MiscIdentifier']['identifier_value'])) {
                if ($this->MiscIdentifier->find('first', array(
                    'conditions' => array(
                        'misc_identifier_control_id' => $miscIdentifierControlId,
                        'identifier_value' => $this->request->data['MiscIdentifier']['identifier_value']
                    )
                ))) {
                    $submittedDataValidates = false;
                    $this->MiscIdentifier->validationErrors['identifier_value'][] = __('this field must be unique') . ' (' . __('value') . ')';
                }
            }
            $this->request->data = $this->MiscIdentifier->data;
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                // Set incremented identifier if required
                if ($isIncrementedIdentifier) {
                    $newIdentifierValue = $this->MiscIdentifierControl->getKeyIncrement($controls['MiscIdentifierControl']['autoincrement_name'], $controls['MiscIdentifierControl']['misc_identifier_format'], $controls['MiscIdentifierControl']['pad_to_length']);
                    if ($newIdentifierValue === false) {
                        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    $this->request->data['MiscIdentifier']['identifier_value'] = $newIdentifierValue;
                }
                
                // Save data
                if ($this->MiscIdentifier->save($this->request->data, false)) {
                    
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    
                    $this->atimFlash(__('your data has been saved'), '/ClinicalAnnotation/Participants/profile/' . $participantId . '/');
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $miscIdentifierId
     */
    public function edit($participantId, $miscIdentifierId)
    {
        $this->Participant->getOrRedirect($participantId);
        $this->MiscIdentifier->getOrRedirect($miscIdentifierId);
        
        // MANAGE DATA
        
        $miscIdentifierData = $this->MiscIdentifier->find('first', array(
            'conditions' => array(
                'MiscIdentifier.id' => $miscIdentifierId,
                'MiscIdentifier.participant_id' => $participantId
            ),
            'recursive' => 0
        ));
        if ($miscIdentifierData['MiscIdentifierControl']['flag_confidential'] && ! $this->Session->read('flag_show_confidential')) {
            AppController::getInstance()->redirect("/Pages/err_confidential");
        }
        
        if (empty($miscIdentifierData) || (! isset($miscIdentifierData['MiscIdentifierControl'])) || empty($miscIdentifierData['MiscIdentifierControl']['id'])) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $isIncrementedIdentifier = ! empty($miscIdentifierData['MiscIdentifierControl']['autoincrement_name']);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/Participants/profile'));
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'MiscIdentifier.id' => $miscIdentifierId
        ));
        
        $formAlias = ($isIncrementedIdentifier ? 'incrementedmiscidentifiers' : 'miscidentifiers') . ($miscIdentifierData['MiscIdentifierControl']['flag_link_to_study'] ? ',miscidentifiers_study' : '');
        $this->Structures->set($formAlias);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $miscIdentifierData['FunctionManagement']['autocomplete_misc_identifier_study_summary_id'] = $this->StudySummary->getStudyDataAndCodeForDisplay(array(
                'StudySummary' => array(
                    'id' => $miscIdentifierData['MiscIdentifier']['study_summary_id']
                )
            ));
            $this->request->data = $miscIdentifierData;
        } else {
            $submittedDataValidates = true;
            // ... special validations
            
            if (! $isIncrementedIdentifier && $miscIdentifierData['MiscIdentifierControl']['pad_to_length']) {
                $this->request->data['MiscIdentifier']['identifier_value'] = str_pad($this->request->data['MiscIdentifier']['identifier_value'], $miscIdentifierData['MiscIdentifierControl']['pad_to_length'], '0', STR_PAD_LEFT);
            }
            
            // ... special validations
            
            $this->MiscIdentifier->set($this->request->data);
            $submittedDataValidates = $this->MiscIdentifier->validates() ? $submittedDataValidates : false;
            if ($miscIdentifierData['MiscIdentifierControl']['flag_unique'] && isset($this->request->data['MiscIdentifier']['identifier_value']) && $this->request->data['MiscIdentifier']['identifier_value'] != $miscIdentifierData['MiscIdentifier']['identifier_value']) {
                if ($this->MiscIdentifier->find('first', array(
                    'conditions' => array(
                        'misc_identifier_control_id' => $miscIdentifierData['MiscIdentifierControl']['id'],
                        'identifier_value' => $this->request->data['MiscIdentifier']['identifier_value']
                    )
                ))) {
                    $submittedDataValidates = false;
                    $this->MiscIdentifier->validationErrors['identifier_value'][] = __('this field must be unique') . ' (' . __('value') . ')';
                }
            }
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->MiscIdentifier->id = $miscIdentifierId;
                $this->MiscIdentifier->data = null;
                if ($this->MiscIdentifier->save($this->request->data)) {
                    
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    
                    $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/Participants/profile/' . $participantId . '/');
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $miscIdentifierId
     */
    public function delete($participantId, $miscIdentifierId)
    {
        $miscIdentifierData = $this->MiscIdentifier->getOrRedirect($miscIdentifierId);
        
        // MANAGE DATA
        if ($miscIdentifierData['MiscIdentifier']['participant_id'] != $participantId) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $arrAllowDeletion = $this->MiscIdentifier->allowDeletion($miscIdentifierId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            $deletionWorked = false;
            if (empty($miscIdentifierData['MiscIdentifierControl']['autoincrement_name'])) {
                // real delete
                $this->MiscIdentifier->addWritableField(array(
                    'deleted',
                    'flag_unique'
                ));
                $this->MiscIdentifier->data = array();
                $deletionWorked = $this->MiscIdentifier->save(array(
                    'MiscIdentifier' => array(
                        'deleted' => 1,
                        'flag_unique' => null
                    )
                ));
            } else {
                // tmp delete to be able to reuse it
                // use update to avoid trigerring Participant last mod with a null participant_id.
                $deletionWorked = true;
                $this->MiscIdentifier->id = $miscIdentifierId;
                $this->MiscIdentifier->beforeDelete();
                $this->MiscIdentifier->updateAll(array(
                    'participant_id' => null,
                    'tmp_deleted' => 1,
                    'deleted' => 1
                ), array(
                    'MiscIdentifier.id' => $miscIdentifierId
                ));
                $this->MiscIdentifier->afterDelete();
                $this->Participant->id = $participantId;
                $this->Participant->data = array();
                $this->Participant->save(array(
                    'Participant.modified' => now()
                )); // trigger last modification
            }
            
            if ($deletionWorked) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/ClinicalAnnotation/Participants/profile/' . $participantId . '/');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/ClinicalAnnotation/Participants/profile/' . $participantId . '/');
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/ClinicalAnnotation/Participants/profile/' . $participantId . '/');
        }
    }

    /**
     *
     * @param $participantId
     * @param $miscIdentifierCtrlId
     * @param bool $submited
     */
    public function reuse($participantId, $miscIdentifierCtrlId, $submited = false)
    {
        $this->Participant->getOrRedirect($participantId);
        $this->MiscIdentifierControl->getOrRedirect($miscIdentifierCtrlId);
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/Participants/profile'));
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'MiscIdentifierControl.id' => $miscIdentifierCtrlId
        ));
        $this->Structures->set('misc_identifier_value');
        
        $miControl = $this->MiscIdentifierControl->findById($miscIdentifierCtrlId);
        if ($miControl['MiscIdentifierControl']['flag_confidential'] && ! $this->Session->read('flag_show_confidential')) {
            AppController::getInstance()->redirect("/Pages/err_confidential");
        }
        
        $this->set('title', $miControl['MiscIdentifierControl']['misc_identifier_name']);
        $dataToDisplay = $this->MiscIdentifier->find('all', array(
            'conditions' => array(
                'MiscIdentifier.participant_id' => null,
                'MiscIdentifier.deleted' => 1,
                'MiscIdentifier.tmp_deleted' => 1,
                'MiscIdentifierControl.id' => $miscIdentifierCtrlId
            ),
            'recursive' => 0
        ));
        
        if ($miControl['MiscIdentifierControl']['flag_once_per_participant']) {
            $count = $this->MiscIdentifier->find('count', array(
                'conditions' => array(
                    'MiscIdentifier.participant_id' => $participantId,
                    'MiscIdentifier.misc_identifier_control_id' => $miscIdentifierCtrlId
                ),
                'recursive' => - 1
            ));
            if ($count > 0) {
                $this->atimFlashWarning(__('this identifier has already been created for this participant'), '/ClinicalAnnotation/Participants/profile/' . $participantId . '/');
                return;
            }
        }
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($submited) {
            if (isset($this->request->data['MiscIdentifier']['selected_id']) && is_numeric($this->request->data['MiscIdentifier']['selected_id'])) {
                $submittedDataValidates = true;
                $hookLink = $this->hook('presave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                if ($submittedDataValidates) {
                    $conditions = array(
                        'MiscIdentifier.participant_id' => null,
                        'MiscIdentifier.deleted' => 1,
                        'MiscIdentifier.tmp_deleted' => 1,
                        'MiscIdentifier.misc_identifier_control_id' => $miscIdentifierCtrlId,
                        'MiscIdentifier.id' => $this->request->data['MiscIdentifier']['selected_id']
                    );
                    $mi = $this->MiscIdentifier->find('first', array(
                        'conditions' => $conditions,
                        'recursive' => - 1
                    ));
                    
                    if (! empty($mi)) {
                        $this->MiscIdentifier->updateAll(array(
                            'tmp_deleted' => 0,
                            'deleted' => 0,
                            'participant_id' => $participantId
                        ), $conditions); // will only update if conditions are still ok (hence if no one else took it)
                    }
                    
                    $mi = $this->MiscIdentifier->find('first', array(
                        'conditions' => array(
                            'MiscIdentifier.participant_id' => $participantId,
                            'MiscIdentifier.id' => $this->request->data['MiscIdentifier']['selected_id']
                        )
                    ));
                    if (empty($mi)) {
                        $this->MiscIdentifier->validationErrors[][] = 'by the time you submited your selection, the identifier was either used or removed from the system';
                    } else {
                        $this->MiscIdentifier->id = $this->request->data['MiscIdentifier']['selected_id'];
                        $this->MiscIdentifier->createRevision();
                        $this->Participant->id = $participantId;
                        $this->Participant->data = array();
                        $this->Participant->save(array(
                            'Participant.modified' => now()
                        )); // trigger last modification
                        $hookLink = $this->hook('postsave_process');
                        if ($hookLink) {
                            require ($hookLink);
                        }
                        $this->atimFlash(__('your data has been saved'), '/ClinicalAnnotation/Participants/profile/' . $participantId . '/');
                    }
                }
            } else {
                $this->MiscIdentifier->validationErrors[][] = 'you need to select an identifier value';
            }
        }
        $this->request->data = $dataToDisplay;
        
        if (empty($this->request->data)) {
            AppController::addWarningMsg(__('there are no unused identifiers left to reuse. hit cancel to return to the identifiers list.'));
        }
    }

    /**
     *
     * @param $participantId
     */
    public function listall($participantId)
    {
        // only for permissions
        // since identifiers are all loaded within participants to build the menu,
        // it's useless to have an ajax callback aftewards
    }
}