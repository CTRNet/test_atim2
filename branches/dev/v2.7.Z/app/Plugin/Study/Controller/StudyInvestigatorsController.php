<?php

class StudyInvestigatorsController extends StudyAppController
{

    public $uses = array(
        'Study.StudyInvestigator',
        'Study.StudySummary'
    );

    public $paginate = array(
        'StudyInvestigator' => array(
            'limit' => 5,
            'order' => 'StudyInvestigator.last_name'
        )
    );

    function add($study_summary_id)
    {
        $study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/detail/'));
        $this->set('atim_menu_variables', array(
            'StudySummary.id' => $study_summary_id
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = array(
                array()
            );
            
            $hook_link = $this->hook('initial_display');
            if ($hook_link) {
                require ($hook_link);
            }
        } else {
            
            $this->request->data['StudyInvestigator']['study_summary_id'] = $study_summary_id;
            $this->StudyInvestigator->addWritableField(array(
                'study_summary_id'
            ));
            
            $submitted_data_validates = true;
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hook_link = $this->hook('presave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            if ($submitted_data_validates) {
                if ($this->StudyInvestigator->save($this->request->data)) {
                    $hook_link = $this->hook('postsave_process');
                    if ($hook_link) {
                        require ($hook_link);
                    }
                    $this->atimFlash(__('your data has been saved'), '/Study/StudySummaries/detail/' . $study_summary_id . '/');
                }
            }
        }
    }

    function listall($study_summary_id)
    {
        // MANAGE DATA
        $study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);
        
        $this->request->data = $this->paginate($this->StudyInvestigator, array(
            'StudyInvestigator.study_summary_id' => $study_summary_id
        ));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/detail/'));
        $this->set('atim_menu_variables', array(
            'StudySummary.id' => $study_summary_id
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
    }

    function detail($study_summary_id, $study_investigator_id)
    {
        // MANAGE DATA
        $study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);
        $this->request->data = $this->StudyInvestigator->getOrRedirect($study_investigator_id);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/detail/'));
        $this->set('atim_menu_variables', array(
            'StudySummary.id' => $study_summary_id
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
    }

    function edit($study_summary_id, $study_investigator_id)
    {
        // MANAGE DATA
        $study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);
        $study_investigator_data = $this->StudyInvestigator->getOrRedirect($study_investigator_id);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atim_menu', $this->Menus->get('/Study/StudySummaries/detail/'));
        $this->set('atim_menu_variables', array(
            'StudySummary.id' => $study_summary_id
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $study_investigator_data;
            
            $hook_link = $this->hook('initial_display');
            if ($hook_link) {
                require ($hook_link);
            }
        } else {
            
            $submitted_data_validates = true;
            
            $hook_link = $this->hook('presave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            if ($submitted_data_validates) {
                
                $this->StudyInvestigator->id = $study_investigator_id;
                if ($this->StudyInvestigator->save($this->request->data)) {
                    $hook_link = $this->hook('postsave_process');
                    if ($hook_link) {
                        require ($hook_link);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Study/StudySummaries/detail/' . $study_summary_id . '/');
                }
            }
        }
    }

    function delete($study_summary_id, $study_investigator_id)
    {
        // MANAGE DATA
        $study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);
        $study_investigator_data = $this->StudyInvestigator->getOrRedirect($study_investigator_id);
        
        $arr_allow_deletion = $this->StudyInvestigator->allowDeletion($study_investigator_id);
        
        // CUSTOM CODE
        $hook_link = $this->hook('delete');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if ($arr_allow_deletion['allow_deletion']) {
            $this->StudyInvestigator->data = null;
            if ($this->StudyInvestigator->atimDelete($study_investigator_id)) {
                $this->atimFlash(__('your data has been deleted'), '/Study/StudySummaries/detail/' . $study_summary_id . '/');
            } else {
                $this->flash(__('error deleting data - contact administrator.'), '/Study/StudySummaries/detail/' . $study_summary_id . '/');
            }
        } else {
            $this->flash(__($arr_allow_deletion['msg']), '/Study/StudyInvestigators/detail/' . $study_summary_id . '/' . $study_investigator_id);
        }
    }
}