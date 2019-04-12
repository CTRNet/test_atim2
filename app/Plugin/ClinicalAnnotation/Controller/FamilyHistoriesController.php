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
 * Class FamilyHistoriesController
 */
class FamilyHistoriesController extends ClinicalAnnotationAppController
{

    public $uses = array(
        'ClinicalAnnotation.FamilyHistory',
        'ClinicalAnnotation.Participant',
        'CodingIcd.CodingIcd10Who',
        'CodingIcd.CodingIcd10Ca'
    );

    public $paginate = array(
        'FamilyHistory' => array(
            'order' => 'FamilyHistory.relation'
        )
    );

    /*
     * --------------------------------------------------------------------------
     * DISPLAY FUNCTIONS
     * --------------------------------------------------------------------------
     */
    
    /*
     * ==> Note: Create just 5 basic error pages per plugin as following lines:
     * |-----------------------------|------------------------------|----------------------------------------------------------------|
     * | id | language_title | language_body |
     * |-----------------------------|------------------------------|----------------------------------------------------------------|
     * | err_..._deletion_err | data deletion error | the system is unable to delete correctly the data |
     * | err_..._funct_param_missing | parameter missing | a paramater used by the executed function has not been set |
     * | err_..._no_data | data not found | no data exists for the specified id |
     * | err_..._record_err | data creation - update error | an error occured during the creation or the update of the data |
     * | err_..._system_error | system error | a system error has been detetced |
     * |-----------------------------|------------------------------|----------------------------------------------------------------|
     * All errors that could occured should be managed by the code and generated an error page if required!
     */
    
    /* ==> Note: Reuse flash() messages as they are into this controller! */
    /**
     *
     * @param $participantId
     */
    public function listall($participantId)
    {
        
        // MANAGE DATA
        
        /* ==> Note: Always validate data linked to the created record exists */
        $participantData = $this->Participant->getOrRedirect($participantId);
        
        $this->request->data = $this->paginate($this->FamilyHistory, array(
            'FamilyHistory.participant_id' => $participantId
        ));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        /* ==> Note: Uncomment following lines to override default structure and menu */
        // $this->set('atimStructure', $this->Structures->get('form', 'familyhistories'));
        // $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/FamilyHistories/listall/%%Participant.id%%'));
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $participantId
     * @param $familyHistoryId
     */
    public function detail($participantId, $familyHistoryId)
    {
        // MANAGE DATA
        $familyHistoryData = $this->FamilyHistory->find('first', array(
            'conditions' => array(
                'FamilyHistory.id' => $familyHistoryId,
                'FamilyHistory.participant_id' => $participantId
            )
        ));
        /* ==> Note: Always validate data exists */
        if (empty($familyHistoryData)) {
            
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $familyHistoryData;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // $this->set('atimStructure', $this->Structures->get('form', 'familyhistories'));
        // $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/FamilyHistories/listall/%%Participant.id%%'));
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'FamilyHistory.id' => $familyHistoryId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param null $participantId
     */
    public function add($participantId)
    {
        // MANAGE DATA
        $participantData = $this->Participant->getOrRedirect($participantId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // $this->set('atimStructure', $this->Structures->get('form', 'familyhistories'));
        // $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/FamilyHistories/listall/%%Participant.id%%'));
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data[] = array();
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            // Save process
            
            $errors = array();
            $lineCounter = 0;
            foreach ($this->request->data as $key => &$newRow) {
                $this->FamilyHistory->patchIcd10NullValues($newRow);
                $lineCounter ++;
                $this->FamilyHistory->data = array(); // *** To guaranty no merge will be done with previous data ***
                $this->FamilyHistory->set($newRow);
                if (! $this->FamilyHistory->validates()) {
                    foreach ($this->FamilyHistory->validationErrors as $field => $msgs) {
                        $msgs = is_array($msgs) ? $msgs : array(
                            $msgs
                        );
                        foreach ($msgs as $msg)
                            $errors[$field][$msg][] = $lineCounter;
                    }
                }
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if (empty($errors)) {
                $this->FamilyHistory->addWritableField('participant_id');
                $this->FamilyHistory->writableFieldsMode = 'addgrid';
                foreach ($this->request->data as $newData) {
                    $newData['FamilyHistory']['participant_id'] = $participantId;
                    $this->FamilyHistory->id = null;
                    $this->FamilyHistory->data = array(); // *** To guaranty no merge will be done with previous data ***
                    if (! $this->FamilyHistory->save($newData, false))
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                $urlToFlash = '/ClinicalAnnotation/FamilyHistories/listall/' . $participantId;
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                $this->atimFlash(__('your data has been saved'), $urlToFlash);
            } else {
                $this->FamilyHistory->validationErrors = array();
                foreach ($errors as $field => $msgAndLines) {
                    foreach ($msgAndLines as $msg => $lines) {
                        $msg = __($msg);
                        $linesStrg = implode(",", array_unique($lines));
                        if (! empty($linesStrg)) {
                            $msg .= ' - ' . str_replace('%s', $linesStrg, __('see line %s'));
                        }
                        $this->FamilyHistory->validationErrors[$field][] = $msg;
                    }
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $familyHistoryId
     */
    public function edit($participantId, $familyHistoryId)
    {
        
        // MANAGE DATA
        $familyHistoryData = $this->FamilyHistory->find('first', array(
            'conditions' => array(
                'FamilyHistory.id' => $familyHistoryId,
                'FamilyHistory.participant_id' => $participantId
            )
        ));
        if (empty($familyHistoryData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // $this->set('atimStructure', $this->Structures->get('form', 'familyhistories'));
        // $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/FamilyHistories/listall/%%Participant.id%%'));
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'FamilyHistory.id' => $familyHistoryId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $familyHistoryData;
        } else {
            $this->FamilyHistory->patchIcd10NullValues($this->request->data);
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
                
                $this->FamilyHistory->id = $familyHistoryId;
                if ($this->FamilyHistory->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/FamilyHistories/detail/' . $participantId . '/' . $familyHistoryId);
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $familyHistoryId
     */
    public function delete($participantId, $familyHistoryId)
    {
        
        // MANAGE DATA
        $familyHistoryData = $this->FamilyHistory->find('first', array(
            'conditions' => array(
                'FamilyHistory.id' => $familyHistoryId,
                'FamilyHistory.participant_id' => $participantId
            )
        ));
        if (empty($familyHistoryData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $arrAllowDeletion = $this->FamilyHistory->allowDeletion($familyHistoryId);
        
        // CUSTOM CODE
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            
            // DELETE DATA
            
            $flashLink = '/ClinicalAnnotation/FamilyHistories/listall/' . $participantId;
            if ($this->FamilyHistory->atimDelete($familyHistoryId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), $flashLink);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), $flashLink);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/ClinicalAnnotation/FamilyHistories/detail/' . $participantId . '/' . $familyHistoryId);
        }
    }
}