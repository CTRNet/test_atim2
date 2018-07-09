<?php

/**
 * Class StudyFundingsController
 */
class StudyFundingsController extends StudyAppController
{

    public $uses = array(
        'Study.StudyFunding',
        'Study.StudySummary'
    );

    public $paginate = array(
        'StudyFunding' => array(
            'order' => 'StudyFunding.study_sponsor'
        )
    );

    /**
     *
     * @param $studySummaryId
     */
    public function add($studySummaryId)
    {
        $studySummaryData = $this->StudySummary->getOrRedirect($studySummaryId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/Study/StudySummaries/detail/'));
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = array(
                array()
            );
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            $this->request->data['StudyFunding']['study_summary_id'] = $studySummaryId;
            $this->StudyFunding->addWritableField(array(
                'study_summary_id'
            ));
            
            $submittedDataValidates = true;
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                if ($this->StudyFunding->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been saved'), '/Study/StudySummaries/detail/' . $studySummaryId . '/');
                }
            }
        }
    }

    /**
     *
     * @param $studySummaryId
     */
    public function listall($studySummaryId)
    {
        // MANAGE DATA
        $studySummaryData = $this->StudySummary->getOrRedirect($studySummaryId);
        
        $this->request->data = $this->paginate($this->StudyFunding, array(
            'StudyFunding.study_summary_id' => $studySummaryId
        ));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/Study/StudySummaries/detail/'));
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
     * @param $studyFundingId
     */
    public function detail($studySummaryId, $studyFundingId)
    {
        // MANAGE DATA
        $studySummaryData = $this->StudySummary->getOrRedirect($studySummaryId);
        $this->request->data = $this->StudyFunding->getOrRedirect($studyFundingId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/Study/StudySummaries/detail/'));
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
     * @param $studyFundingId
     */
    public function edit($studySummaryId, $studyFundingId)
    {
        // MANAGE DATA
        $studySummaryData = $this->StudySummary->getOrRedirect($studySummaryId);
        $studyFundingData = $this->StudyFunding->getOrRedirect($studyFundingId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/Study/StudySummaries/detail/'));
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId,
            'StudyFunding.id' => $studyFundingId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $studyFundingData;
            
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
            
            if ($submittedDataValidates) {
                
                $this->StudyFunding->id = $studyFundingId;
                if ($this->StudyFunding->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Study/StudySummaries/detail/' . $studySummaryId . '/');
                }
            }
        }
    }

    /**
     *
     * @param $studySummaryId
     * @param $studyFundingId
     */
    public function delete($studySummaryId, $studyFundingId)
    {
        // MANAGE DATA
        $studySummaryData = $this->StudySummary->getOrRedirect($studySummaryId);
        $studyFundingData = $this->StudyFunding->getOrRedirect($studyFundingId);
        
        $arrAllowDeletion = $this->StudyFunding->allowDeletion($studyFundingId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            $this->StudyFunding->data = null;
            if ($this->StudyFunding->atimDelete($studyFundingId)) {
                $this->atimFlash(__('your data has been deleted'), '/Study/StudySummaries/detail/' . $studySummaryId . '/');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator.'), '/Study/StudySummaries/detail/' . $studySummaryId . '/');
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Study/StudyFundings/detail/' . $studySummaryId . '/' . $studyFundingId);
        }
    }
}