<?php

/**
 * Class StudyResultsController
 */
class StudyResultsController extends StudyAppController
{

    public $uses = array(
        'Study.StudyResult',
        'Study.StudySummary'
    );

    public $paginate = array(
        'StudyResult' => array(
            'order' => 'StudyResult.abstract'
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
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyResultsData = $this->StudySummary->find('first', array(
            'conditions' => array(
                'StudySummary.id' => $studySummaryId
            ),
            'recursive' => - 1
        ));
        if (empty($studyResultsData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->request->data = $this->paginate($this->StudyResult, array(
            'StudyResult.study_summary_id' => $studySummaryId
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
     * @param $studyResultsId
     */
    public function detail($studySummaryId, $studyResultsId)
    {
        pr('Has to be reviewed before to be used in prod.');
        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        exit();
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! $studyResultsId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyResultsData = $this->StudyResult->find('first', array(
            'conditions' => array(
                'StudyResult.id' => $studyResultsId,
                'StudyResult.study_summary_id' => $studySummaryId
            )
        ));
        if (empty($studyResultsData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $studyResultsData;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId,
            'StudyResult.id' => $studyResultsId
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
        $studyResultsData = $this->StudySummary->find('first', array(
            'conditions' => array(
                'StudySummary.id' => $studySummaryId
            ),
            'recursive' => - 1
        ));
        if (empty($studyResultsData)) {
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
            
            $this->request->data['StudyResult']['study_summary_id'] = $studySummaryId;
            
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
                if ($this->StudyResult->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been saved'), '/Study/StudyResults/detail/' . $studySummaryId . '/' . $this->StudyResult->id);
                }
            }
        }
    }

    /**
     *
     * @param $studySummaryId
     * @param $studyResultsId
     */
    public function edit($studySummaryId, $studyResultsId)
    {
        pr('Has to be reviewed before to be used in prod.');
        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        exit();
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! $studyResultsId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyResultsData = $this->StudyResult->find('first', array(
            'conditions' => array(
                'StudyResult.id' => $studyResultsId,
                'StudyResult.study_summary_id' => $studySummaryId
            )
        ));
        if (empty($studyResultsData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId,
            'StudyResult.id' => $studyResultsId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $studyResultsData;
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
                $this->StudyResult->id = $studyResultsId;
                if ($this->StudyResult->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Study/StudyResults/detail/' . $studySummaryId . '/' . $studyResultsId);
                }
            }
        }
    }

    /**
     *
     * @param $studySummaryId
     * @param $studyResultsId
     */
    public function delete($studySummaryId, $studyResultsId)
    {
        pr('Has to be reviewed before to be used in prod.');
        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        exit();
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! $studyResultsId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyResultsData = $this->StudyResult->find('first', array(
            'conditions' => array(
                'StudyResult.id' => $studyResultsId,
                'StudyResult.study_summary_id' => $studySummaryId
            )
        ));
        if (empty($studyResultsData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $arrAllowDeletion = $this->allowDeletion($studyResultsId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            
            // DELETE DATA
            
            if ($this->StudyResult->atimDelete($studyResultsId)) {
                $this->atimFlash(__('your data has been deleted'), '/Study/StudyResults/listall/' . $studySummaryId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator.'), '/Study/StudyResults/listall/' . $studySummaryId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Study/StudyResults/detail/' . $studySummaryId . '/' . $studyResultsId);
        }
    }
}