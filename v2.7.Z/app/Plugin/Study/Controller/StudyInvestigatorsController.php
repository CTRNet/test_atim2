<?php

/**
 * Class StudyInvestigatorsController
 */
class StudyInvestigatorsController extends StudyAppController
{

    public $uses = array(
        'Study.StudyInvestigator',
        'Study.StudySummary'
    );

    public $paginate = array(
        'StudyInvestigator' => array(
            'order' => 'StudyInvestigator.last_name'
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
            
            $this->request->data['StudyInvestigator']['study_summary_id'] = $studySummaryId;
            $this->StudyInvestigator->addWritableField(array(
                'study_summary_id'
            ));
            
            $submittedDataValidates = true;
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                if ($this->StudyInvestigator->save($this->request->data)) {
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
        
        $this->request->data = $this->paginate($this->StudyInvestigator, array(
            'StudyInvestigator.study_summary_id' => $studySummaryId
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
     * @param $studyInvestigatorId
     */
    public function detail($studySummaryId, $studyInvestigatorId)
    {
        // MANAGE DATA
        $studySummaryData = $this->StudySummary->getOrRedirect($studySummaryId);
        $this->request->data = $this->StudyInvestigator->getOrRedirect($studyInvestigatorId);
        
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
     * @param $studyInvestigatorId
     */
    public function edit($studySummaryId, $studyInvestigatorId)
    {
        // MANAGE DATA
        $studySummaryData = $this->StudySummary->getOrRedirect($studySummaryId);
        $studyInvestigatorData = $this->StudyInvestigator->getOrRedirect($studyInvestigatorId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/Study/StudySummaries/detail/'));
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId,
            'StudyInvestigator.id' => $studyInvestigatorId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $studyInvestigatorData;
            
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
                
                $this->StudyInvestigator->id = $studyInvestigatorId;
                if ($this->StudyInvestigator->save($this->request->data)) {
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
     * @param $studyInvestigatorId
     */
    public function delete($studySummaryId, $studyInvestigatorId)
    {
        // MANAGE DATA
        $studySummaryData = $this->StudySummary->getOrRedirect($studySummaryId);
        $studyInvestigatorData = $this->StudyInvestigator->getOrRedirect($studyInvestigatorId);
        
        $arrAllowDeletion = $this->StudyInvestigator->allowDeletion($studyInvestigatorId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            $this->StudyInvestigator->data = null;
            if ($this->StudyInvestigator->atimDelete($studyInvestigatorId)) {
                $this->atimFlash(__('your data has been deleted'), '/Study/StudySummaries/detail/' . $studySummaryId . '/');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator.'), '/Study/StudySummaries/detail/' . $studySummaryId . '/');
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Study/StudyInvestigators/detail/' . $studySummaryId . '/' . $studyInvestigatorId);
        }
    }
}