<?php

/**
 * Class StudyReviewsController
 */
class StudyReviewsController extends StudyAppController
{

    public $uses = array(
        'Study.StudyReview',
        'Study.StudySummary'
    );

    public $paginate = array(
        'StudyReview' => array(
            'order' => 'StudyReview.last_name'
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
        // exit();
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyReviewsData = $this->StudySummary->find('first', array(
            'conditions' => array(
                'StudySummary.id' => $studySummaryId
            ),
            'recursive' => - 1
        ));
        if (empty($studyReviewsData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->request->data = $this->paginate($this->StudyReview, array(
            'StudyReview.study_summary_id' => $studySummaryId
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
     * @param $studyReviewsId
     */
    public function detail($studySummaryId, $studyReviewsId)
    {
        pr('Has to be reviewed before to be used in prod.');
        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        exit();
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! $studyReviewsId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyReviewsData = $this->StudyReview->find('first', array(
            'conditions' => array(
                'StudyReview.id' => $studyReviewsId,
                'StudyReview.study_summary_id' => $studySummaryId
            )
        ));
        if (empty($studyReviewsData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $studyReviewsData;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId,
            'StudyReview.id' => $studyReviewsId
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
        $studyReviewsData = $this->StudySummary->find('first', array(
            'conditions' => array(
                'StudySummary.id' => $studySummaryId
            ),
            'recursive' => - 1
        ));
        if (empty($studyReviewsData)) {
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
            
            $this->request->data['StudyReview']['study_summary_id'] = $studySummaryId;
            
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
                if ($this->StudyReview->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been saved'), '/Study/StudyReviews/detail/' . $studySummaryId . '/' . $this->StudyReview->id);
                }
            }
        }
    }

    /**
     *
     * @param $studySummaryId
     * @param $studyReviewsId
     */
    public function edit($studySummaryId, $studyReviewsId)
    {
        pr('Has to be reviewed before to be used in prod.');
        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        exit();
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! $studyReviewsId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyReviewsData = $this->StudyReview->find('first', array(
            'conditions' => array(
                'StudyReview.id' => $studyReviewsId,
                'StudyReview.study_summary_id' => $studySummaryId
            )
        ));
        if (empty($studyReviewsData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId,
            'StudyReview.id' => $studyReviewsId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $studyReviewsData;
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
                $this->StudyReview->id = $studyReviewsId;
                if ($this->StudyReview->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Study/StudyReviews/detail/' . $studySummaryId . '/' . $studyReviewsId);
                }
            }
        }
    }

    /**
     *
     * @param $studySummaryId
     * @param $studyReviewsId
     */
    public function delete($studySummaryId, $studyReviewsId)
    {
        pr('Has to be reviewed before to be used in prod.');
        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        exit();
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! $studyReviewsId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyReviewsData = $this->StudyReview->find('first', array(
            'conditions' => array(
                'StudyReview.id' => $studyReviewsId,
                'StudyReview.study_summary_id' => $studySummaryId
            )
        ));
        if (empty($studyReviewsData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $arrAllowDeletion = $this->StudyReview->allowDeletion($studyReviewsId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            
            // DELETE DATA
            
            if ($this->StudyReview->atimDelete($studyReviewsId)) {
                $this->atimFlash(__('your data has been deleted'), '/Study/StudyReviews/listall/' . $studySummaryId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator.'), '/Study/StudyReviews/listall/' . $studySummaryId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Study/StudyReviews/detail/' . $studySummaryId . '/' . $studyReviewsId);
        }
    }
}