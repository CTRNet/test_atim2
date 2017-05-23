<?php

class StudyFundingsController extends StudyAppController
{

    var $uses = array(
        'Study.StudyFunding',
        'Study.StudySummary'
    );

    var $paginate = array(
        'StudyFunding' => array(
            'limit' => 5,
            'order' => 'StudyFunding.study_sponsor'
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
            
            $this->request->data['StudyFunding']['study_summary_id'] = $study_summary_id;
            $this->StudyFunding->addWritableField(array(
                'study_summary_id'
            ));
            
            $submitted_data_validates = true;
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hook_link = $this->hook('presave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            if ($submitted_data_validates) {
                if ($this->StudyFunding->save($this->request->data)) {
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
        
        $this->request->data = $this->paginate($this->StudyFunding, array(
            'StudyFunding.study_summary_id' => $study_summary_id
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

    function detail($study_summary_id, $study_funding_id)
    {
        // MANAGE DATA
        $study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);
        $this->request->data = $this->StudyFunding->getOrRedirect($study_funding_id);
        
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

    function edit($study_summary_id, $study_funding_id)
    {
        // MANAGE DATA
        $study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);
        $study_funding_data = $this->StudyFunding->getOrRedirect($study_funding_id);
        
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
            $this->request->data = $study_funding_data;
            
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
                
                $this->StudyFunding->id = $study_funding_id;
                if ($this->StudyFunding->save($this->request->data)) {
                    $hook_link = $this->hook('postsave_process');
                    if ($hook_link) {
                        require ($hook_link);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Study/StudySummaries/detail/' . $study_summary_id . '/');
                }
            }
        }
    }

    function delete($study_summary_id, $study_funding_id)
    {
        // MANAGE DATA
        $study_summary_data = $this->StudySummary->getOrRedirect($study_summary_id);
        $study_funding_data = $this->StudyFunding->getOrRedirect($study_funding_id);
        
        $arr_allow_deletion = $this->StudyFunding->allowDeletion($study_funding_id);
        
        // CUSTOM CODE
        $hook_link = $this->hook('delete');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if ($arr_allow_deletion['allow_deletion']) {
            $this->StudyFunding->data = null;
            if ($this->StudyFunding->atimDelete($study_funding_id)) {
                $this->atimFlash(__('your data has been deleted'), '/Study/StudySummaries/detail/' . $study_summary_id . '/');
            } else {
                $this->flash(__('error deleting data - contact administrator.'), '/Study/StudySummaries/detail/' . $study_summary_id . '/');
            }
        } else {
            $this->flash(__($arr_allow_deletion['msg']), '/Study/StudyFundings/detail/' . $study_summary_id . '/' . $study_funding_id);
        }
    }
}

?>