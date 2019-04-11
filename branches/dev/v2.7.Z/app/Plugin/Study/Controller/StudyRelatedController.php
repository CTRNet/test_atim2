<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

/**
 * Class StudyRelatedController
 */
class StudyRelatedController extends StudyAppController
{

    public $uses = array(
        'Study.StudyRelated',
        'Study.StudySummary'
    );

    public $paginate = array(
        'StudyRelated' => array(
            'order' => 'StudyRelated.title'
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
        $studyRelatedData = $this->StudySummary->find('first', array(
            'conditions' => array(
                'StudySummary.id' => $studySummaryId
            ),
            'recursive' => - 1
        ));
        if (empty($studyRelatedData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->request->data = $this->paginate($this->StudyRelated, array(
            'StudyRelated.study_summary_id' => $studySummaryId
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
     * @param $studyRelatedId
     */
    public function detail($studySummaryId, $studyRelatedId)
    {
        pr('Has to be reviewed before to be used in prod.');
        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        exit();
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! $studyRelatedId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyRelatedData = $this->StudyRelated->find('first', array(
            'conditions' => array(
                'StudyRelated.id' => $studyRelatedId,
                'StudyRelated.study_summary_id' => $studySummaryId
            )
        ));
        if (empty($studyRelatedData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $studyRelatedData;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId,
            'StudyRelated.id' => $studyRelatedId
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
        $studyRelatedData = $this->StudySummary->find('first', array(
            'conditions' => array(
                'StudySummary.id' => $studySummaryId
            ),
            'recursive' => - 1
        ));
        if (empty($studyRelatedData)) {
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
            
            $this->request->data['StudyRelated']['study_summary_id'] = $studySummaryId;
            
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
                if ($this->StudyRelated->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been saved'), '/Study/StudyRelated/detail/' . $studySummaryId . '/' . $this->StudyRelated->id);
                }
            }
        }
    }

    /**
     *
     * @param $studySummaryId
     * @param $studyRelatedId
     */
    public function edit($studySummaryId, $studyRelatedId)
    {
        pr('Has to be reviewed before to be used in prod.');
        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        exit();
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! $studyRelatedId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyRelatedData = $this->StudyRelated->find('first', array(
            'conditions' => array(
                'StudyRelated.id' => $studyRelatedId,
                'StudyRelated.study_summary_id' => $studySummaryId
            )
        ));
        if (empty($studyRelatedData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'StudySummary.id' => $studySummaryId,
            'StudyRelated.id' => $studyRelatedId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $studyRelatedData;
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
                $this->StudyRelated->id = $studyRelatedId;
                if ($this->StudyRelated->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Study/StudyRelated/detail/' . $studySummaryId . '/' . $studyRelatedId);
                }
            }
        }
    }

    /**
     *
     * @param $studySummaryId
     * @param $studyRelatedId
     */
    public function delete($studySummaryId, $studyRelatedId)
    {
        pr('Has to be reviewed before to be used in prod.');
        $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        exit();
        if (! $studySummaryId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (! $studyRelatedId) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $studyRelatedData = $this->StudyRelated->find('first', array(
            'conditions' => array(
                'StudyRelated.id' => $studyRelatedId,
                'StudyRelated.study_summary_id' => $studySummaryId
            )
        ));
        if (empty($studyRelatedData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $arrAllowDeletion = $this->StudyRelated->allowDeletion($studyRelatedId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            
            // DELETE DATA
            
            if ($this->StudyRelated->atimDelete($studyRelatedId)) {
                $this->atimFlash(__('your data has been deleted'), '/Study/StudyRelated/listall/' . $studySummaryId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator.'), '/Study/StudyRelated/listall/' . $studySummaryId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Study/StudyRelated/detail/' . $studySummaryId . '/' . $studyRelatedId);
        }
    }
}