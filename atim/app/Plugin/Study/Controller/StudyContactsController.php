<?php

/**
 * Class StudyContactsController
 */
class StudyContactsController extends StudyAppController
{

    public $uses = array(
        'Study.StudyContact',
        'Study.StudySummary'
    );

    public $paginate = array(
        'StudyContact' => array(
            'order' => 'StudyContact.last_name'
        )
    );

    /**
     *
     * @param $studySummaryId
     */
    public function listall($studySummaryId)
    {
        pr('Has to be reviewed before to be used in prod.');
        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        exit();
        // Missing or empty function variable, send to ERROR page
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyContactData = $this->StudySummary->find('first', array(
            'conditions' => array(
                'StudySummary.id' => $studySummaryId
            ),
            'recursive' => - 1
        ));
        if (empty($studyContactData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->request->data = $this->paginate($this->StudyContact, array(
            'StudyContact.study_summary_id' => $studySummaryId
        ));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $studySummaryId
     * @param $studyContactId
     */
    public function detail($studySummaryId, $studyContactId)
    {
        pr('Has to be reviewed before to be used in prod.');
        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        exit();
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! $studyContactId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyContactData = $this->StudyContact->find('first', array(
            'conditions' => array(
                'StudyContact.id' => $studyContactId,
                'StudyContact.study_summary_id' => $studySummaryId
            )
        ));
        if (empty($studyContactData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $studyContactData;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId,
            'StudyContact.id' => $studyContactId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $studySummaryId
     */
    public function add($studySummaryId)
    {
        pr('Has to be reviewed before to be used in prod.');
        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        exit();
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyContactData = $this->StudySummary->find('first', array(
            'conditions' => array(
                'StudySummary.id' => $studySummaryId
            ),
            'recursive' => - 1
        ));
        if (empty($studyContactData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // $this->set('atimStructure', $this->Structures->get('form', 'familyhistories'));
        // $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/FamilyHistories/listall/%%Participant.id%%'));
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            
            // LAUNCH SAVE PROCESS
            // 1- SET ADDITIONAL DATA
            
            $this->request->data['StudyContact']['study_summary_id'] = $studySummaryId;
            
            // 2- LAUNCH SPECIAL VALIDATION PROCESS
            $submittedDataValidates = true;
            
            // ... special validations
            
            // 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                // 4- SAVE
                if ($this->StudyContact->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been saved'), '/Study/StudyContacts/detail/' . $studySummaryId . '/' . $this->StudyContact->id);
                }
            }
        }
    }

    /**
     *
     * @param $studySummaryId
     * @param $studyContactId
     */
    public function edit($studySummaryId, $studyContactId)
    {
        pr('Has to be reviewed before to be used in prod.');
        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        exit();
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! $studyContactId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyContactData = $this->StudyContact->find('first', array(
            'conditions' => array(
                'StudyContact.id' => $studyContactId,
                'StudyContact.study_summary_id' => $studySummaryId
            )
        ));
        if (empty($studyContactData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId,
            'StudyContact.id' => $studyContactId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $studyContactData;
        } else {
            // 1- SET ADDITIONAL DATA
            
            // ....
            
            // 2- LAUNCH SPECIAL VALIDATION PROCESS
            
            $submittedDataValidates = true;
            
            // ... special validations
            
            // 3- CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                
                // 4- SAVE
                $this->StudyContact->id = $studyContactId;
                if ($this->StudyContact->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Study/StudyContacts/detail/' . $studySummaryId . '/' . $studyContactId);
                }
            }
        }
    }

    /**
     *
     * @param $studySummaryId
     * @param $studyContactId
     */
    public function delete($studySummaryId, $studyContactId)
    {
        pr('Has to be reviewed before to be used in prod.');
        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        exit();
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! $studyContactId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyContactData = $this->StudyContact->find('first', array(
            'conditions' => array(
                'StudyContact.id' => $studyContactId,
                'StudyContact.study_summary_id' => $studySummaryId
            )
        ));
        if (empty($studyContactData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $arrAllowDeletion = $this->StudyContact->allowDeletion($studyContactId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            
            // DELETE DATA
            
            if ($this->StudyContact->atimDelete($studyContactId)) {
                $this->atimFlash(__('your data has been deleted'), '/Study/StudyContacts/listall/' . $studySummaryId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator.'), '/Study/StudyContacts/listall/' . $studySummaryId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Study/StudyContacts/detail/' . $studySummaryId . '/' . $studyContactId);
        }
    }
}