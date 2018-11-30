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
 * Class ConsentMastersController
 */
class ConsentMastersController extends ClinicalAnnotationAppController
{

    public $uses = array(
        'ClinicalAnnotation.ConsentMaster',
        'ClinicalAnnotation.ConsentDetail',
        'ClinicalAnnotation.ConsentControl',
        'ClinicalAnnotation.Participant',
        
        'Study.StudySummary'
    );

    public $paginate = array(
        'ConsentMaster' => array(
            'order' => 'ConsentMaster.date_first_contact ASC'
        )
    );

    /**
     *
     * @param $participantId
     */
    public function listall($participantId)
    {
        $participantData = $this->Participant->getOrRedirect($participantId);
        $this->request->data = $this->paginate($this->ConsentMaster, array(
            'ConsentMaster.participant_id' => $participantId
        ));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId
        ));
        $this->set('consentControlsList', $this->ConsentControl->find('all', array(
            'conditions' => array(
                'ConsentControl.flag_active' => '1'
            )
        )));
        $this->Structures->set('consent_masters');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $participantId
     * @param $consentMasterId
     */
    public function detail($participantId, $consentMasterId)
    {
        
        // MANAGE DATA
        $consentMasterData = $this->ConsentMaster->find('first', array(
            'conditions' => array(
                'ConsentMaster.id' => $consentMasterId,
                'ConsentMaster.participant_id' => $participantId
            )
        ));
        if (empty($consentMasterData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $consentMasterData;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'ConsentMaster.id' => $consentMasterId
        ));
        $consentControlData = $this->ConsentControl->find('first', array(
            'conditions' => array(
                'ConsentControl.id' => $this->request->data['ConsentMaster']['consent_control_id']
            )
        ));
        $this->Structures->set($consentControlData['ConsentControl']['form_alias']);
        
        $this->set('consentType', $consentControlData['ConsentControl']['controls_type']);
        $this->set('isAjax', $this->request->is('ajax'));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $participantId
     * @param $consentControlId
     */
    public function add($participantId, $consentControlId)
    {
        
        // MANAGE DATA
        $participantData = $this->Participant->getOrRedirect($participantId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'ConsentControl.id' => $consentControlId
        ));
        $consentControlData = $this->ConsentControl->find('first', array(
            'conditions' => array(
                'ConsentControl.id' => $consentControlId
            )
        ));
        $this->Structures->set($consentControlData['ConsentControl']['form_alias']);
        $this->Structures->set('empty', 'emptyStructure');
        
        $this->set('consentType', $consentControlData['ConsentControl']['controls_type']);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            $this->request->data['ConsentMaster']['participant_id'] = $participantId;
            $this->request->data['ConsentMaster']['consent_control_id'] = $consentControlId;
            
            $submittedDataValidates = true;
            // ... special validations
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->ConsentMaster->addWritableField(array(
                    'participant_id',
                    'consent_control_id'
                ));
                if ($this->ConsentMaster->save($this->request->data)) {
                    $urlToFlash = '/ClinicalAnnotation/ConsentMasters/detail/' . $participantId . '/' . $this->ConsentMaster->id;
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been saved'), $urlToFlash);
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $consentMasterId
     */
    public function edit($participantId, $consentMasterId)
    {
        
        // MANAGE DATA
        $consentMasterData = $this->ConsentMaster->find('first', array(
            'conditions' => array(
                'ConsentMaster.id' => $consentMasterId,
                'ConsentMaster.participant_id' => $participantId
            )
        ));
        if (empty($consentMasterData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'ConsentMaster.id' => $consentMasterId
        ));
        $consentControlData = $this->ConsentControl->find('first', array(
            'conditions' => array(
                'ConsentControl.id' => $consentMasterData['ConsentMaster']['consent_control_id']
            )
        ));
        $this->Structures->set($consentControlData['ConsentControl']['form_alias']);
        
        $this->set('consentType', $consentControlData['ConsentControl']['controls_type']);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $consentMasterData['FunctionManagement']['autocomplete_consent_study_summary_id'] = $this->StudySummary->getStudyDataAndCodeForDisplay(array(
                'StudySummary' => array(
                    'id' => $consentMasterData['ConsentMaster']['study_summary_id']
                )
            ));
            $this->request->data = $consentMasterData;
        } else {
            $submittedDataValidates = true;
            // ... special validations
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->ConsentMaster->id = $consentMasterId;
                if ($this->ConsentMaster->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/ConsentMasters/detail/' . $participantId . '/' . $consentMasterId);
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $consentMasterId
     */
    public function delete($participantId, $consentMasterId)
    {
        // MANAGE DATA
        $consentMasterData = $this->ConsentMaster->find('first', array(
            'conditions' => array(
                'ConsentMaster.id' => $consentMasterId,
                'ConsentMaster.participant_id' => $participantId
            )
        ));
        if (empty($consentMasterData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $arrAllowDeletion = $this->ConsentMaster->allowDeletion($consentMasterId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->ConsentMaster->atimDelete($consentMasterId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/ClinicalAnnotation/ConsentMasters/listall/' . $participantId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/ClinicalAnnotation/ConsentMasters/listall/' . $participantId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/ClinicalAnnotation/ConsentMasters/detail/' . $participantId . '/' . $consentMasterId);
        }
    }
}