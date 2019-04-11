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
 * Class DiagnosisMastersController
 */
class DiagnosisMastersController extends ClinicalAnnotationAppController
{

    public $uses = array(
        'ClinicalAnnotation.DiagnosisMaster',
        'ClinicalAnnotation.DiagnosisDetail',
        'ClinicalAnnotation.DiagnosisControl',
        'ClinicalAnnotation.Participant',
        'ClinicalAnnotation.TreatmentMaster',
        'ClinicalAnnotation.TreatmentControl',
        'ClinicalAnnotation.EventMaster',
        'ClinicalAnnotation.EventControl',
        'CodingIcd.CodingIcd10Who',
        'CodingIcd.CodingIcd10Ca',
        'CodingIcd.CodingIcdo3Topo', // required by model
        'CodingIcd.CodingIcdo3Morpho'
    );
    
    // required by model
    public $paginate = array(
        'DiagnosisMaster' => array(
            'order' => 'DiagnosisMaster.dx_date'
        )
    );

    /**
     *
     * @param $participantId
     * @param null $parentDxId
     * @param int $isAjax
     */
    public function listall($participantId, $parentDxId = null, $isAjax = 0)
    {
        // MANAGE DATA
        $participantData = $this->Participant->getOrRedirect($participantId);
        
        if ($isAjax) {
            $this->layout = 'ajax';
            Configure::write('debug', 0);
        }
        
        $txModel = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
        $eventMasterModel = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
        $dxData = $this->DiagnosisMaster->find('all', array(
            'conditions' => array(
                'DiagnosisMaster.participant_id' => $participantId,
                'DiagnosisMaster.parent_id' => $parentDxId
            ),
            'order' => array(
                'DiagnosisMaster.dx_date'
            )
        ));
        $txData = $txModel->find('all', array(
            'conditions' => array(
                'TreatmentMaster.participant_id' => $participantId,
                'TreatmentMaster.diagnosis_master_id' => $parentDxId == null ? - 1 : $parentDxId
            ),
            'order' => array(
                'TreatmentMaster.start_date'
            )
        ));
        $eventData = $eventMasterModel->find('all', array(
            'conditions' => array(
                'EventMaster.participant_id' => $participantId,
                'EventMaster.diagnosis_master_id' => $parentDxId == null ? - 1 : $parentDxId
            ),
            'order' => array(
                'EventMaster.event_date'
            )
        ));
        $tmpData = array();
        foreach ($dxData as &$unit) {
            $tmpData[$unit['DiagnosisMaster']['dx_date']][] = $unit;
        }
        foreach ($txData as &$unit) {
            $tmpData[$unit['TreatmentMaster']['start_date']][] = $unit;
        }
        foreach ($eventData as &$unit) {
            $tmpData[$unit['EventMaster']['event_date']][] = $unit;
        }
        ksort($tmpData);
        $currData = array();
        foreach ($tmpData as &$dateDataArr) {
            foreach ($dateDataArr as &$unit) {
                $currData[] = $unit;
            }
        }
        
        $ids = array(); // ids already having child
        $canHaveChild = $this->DiagnosisMaster->find('all', array(
            'fields' => array(
                'DiagnosisMaster.id'
            ),
            'conditions' => array(
                'DiagnosisControl.category' => array(
                    'primary',
                    'secondary - distant'
                ),
                'DiagnosisMaster.participant_id' => $participantId
            ),
            'recursive' => 0
        ));
        $canHaveChild = AppController::defineArrayKey($canHaveChild, 'DiagnosisMaster', 'id', true);
        $canHaveChild = array_keys($canHaveChild);
        foreach ($currData as $data) {
            if (array_key_exists('DiagnosisMaster', $data)) {
                $ids[] = $data['DiagnosisMaster']['id'];
            }
        }
        
        $idsHavingChild = $this->DiagnosisMaster->hasChild($ids);
        $idsHavingChild = array_fill_keys($idsHavingChild, null);
        foreach ($currData as &$data) {
            if (array_key_exists('DiagnosisMaster', $data)) {
                $data['children'] = array_key_exists($data['DiagnosisMaster']['id'], $idsHavingChild);
            }
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId
        ));
        $this->set('diagnosisControlsList', $this->DiagnosisControl->find('all', array(
            'conditions' => array(
                'DiagnosisControl.flag_active' => 1
            )
        )));
        $this->set('treatmentControlsList', $this->TreatmentControl->find('all', array(
            'conditions' => array(
                'TreatmentControl.flag_active' => 1
            )
        )));
        $this->set('eventControlsList', $this->EventControl->find('all', array(
            'conditions' => array(
                'EventControl.flag_active' => 1
            )
        )));
        $this->set('isAjax', $isAjax);
        $atimStructure['DiagnosisMaster'] = $this->Structures->get('form', 'view_diagnosis');
        $atimStructure['TreatmentMaster'] = $this->Structures->get('form', 'treatmentmasters');
        $atimStructure['EventMaster'] = $this->Structures->get('form', 'eventmasters');
        $this->set('atimStructure', $atimStructure);
        $this->set('canHaveChild', $canHaveChild);
        
        $externalLinkModel = AppModel::getInstance('', 'ExternalLink', true);
        $helpUrl = $externalLinkModel->find('first', array(
            'conditions' => array(
                'name' => 'diagnosis_module_wiki'
            )
        ));
        $this->set('helpUrl', $helpUrl['ExternalLink']['link']);
        
        $this->request->data = $currData;
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $participantId
     * @param $diagnosisMasterId
     */
    public function detail($participantId, $diagnosisMasterId)
    {
        // MANAGE DATA
        $dxMasterData = $this->DiagnosisMaster->find('first', array(
            'conditions' => array(
                'DiagnosisMaster.id' => $diagnosisMasterId,
                'DiagnosisMaster.participant_id' => $participantId
            )
        ));
        if (empty($dxMasterData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $dxMasterData;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->setDiagnosisMenu($dxMasterData);
        if (($dxMasterData['DiagnosisControl']['category'] == 'primary') && ($dxMasterData['DiagnosisControl']['controls_type'] == 'primary diagnosis unknown')) {
            $this->set('primaryCtrlToRedefineUnknown', $this->DiagnosisControl->find('all', array(
                'conditions' => array(
                    'NOT' => array(
                        'DiagnosisControl.id' => $dxMasterData['DiagnosisControl']['id'],
                        'DiagnosisControl.controls_type' => 'primary diagnosis unknown'
                    ),
                    'DiagnosisControl.category' => 'primary',
                    'DiagnosisControl.flag_active' => 1
                )
            )));
        }
        
        $dxControlData = $this->DiagnosisControl->find('first', array(
            'conditions' => array(
                'DiagnosisControl.id' => $dxMasterData['DiagnosisMaster']['diagnosis_control_id']
            )
        ));
        $this->Structures->set($dxControlData['DiagnosisControl']['form_alias']);
        
        // check for dates warning
        if (is_numeric($dxMasterData['DiagnosisMaster']['parent_id']) && ! empty($dxMasterData['DiagnosisMaster']['dx_date']) && $dxMasterData['DiagnosisMaster']['dx_date_accuracy'] == 'c') {
            $parentDx = $this->DiagnosisMaster->findById($dxMasterData['DiagnosisMaster']['parent_id']);
            if (! empty($parentDx['DiagnosisMaster']['dx_date']) && $parentDx['DiagnosisMaster']['dx_date_accuracy'] == 'c' && (strtotime($dxMasterData['DiagnosisMaster']['dx_date']) - strtotime($parentDx['DiagnosisMaster']['dx_date']) < 0)) {
                AppController::addWarningMsg(__('the current diagnosis date is before the parent diagnosis date'));
            }
        }
        
        // available child ctrl_id for creation
        $conditionNotCategory = array();
        $dxCtrls = array();
        switch ($dxMasterData['DiagnosisControl']['category']) {
            case 'secondary - distant':
                $conditionNotCategory[] = 'secondary - distant';
            case 'primary':
                $conditionNotCategory[] = 'primary';
                $dxCtrls = $this->DiagnosisControl->find('all', array(
                    'conditions' => array(
                        'NOT' => array(
                            "DiagnosisControl.category" => $conditionNotCategory
                        ),
                        'DiagnosisControl.flag_active' => 1
                    ),
                    'order' => 'DiagnosisControl.display_order'
                ));
                break;
            
            default:
        }
        $links = array();
        foreach ($dxCtrls as $dxCtrl) {
            $links[] = array(
                'order' => $dxCtrl['DiagnosisControl']['display_order'],
                'label' => __($dxCtrl['DiagnosisControl']['category']) . ' - ' . __($dxCtrl['DiagnosisControl']['controls_type']),
                'link' => '/ClinicalAnnotation/DiagnosisMasters/add/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/' . $dxCtrl['DiagnosisControl']['id']
            );
        }
        AppController::buildBottomMenuOptions($links);
        $this->set('childControlsList', $links);
        
        $canHaveChild = $this->DiagnosisMaster->find('all', array(
            'fields' => array(
                'DiagnosisMaster.id'
            ),
            'conditions' => array(
                'DiagnosisControl.category' => array(
                    'primary',
                    'secondary - distant'
                ),
                'DiagnosisMaster.participant_id' => $participantId
            ),
            'recursive' => 0
        ));
        $canHaveChild = AppController::defineArrayKey($canHaveChild, 'DiagnosisMaster', 'id', true);
        $canHaveChild = array_keys($canHaveChild);
        $this->set('canHaveChild', $canHaveChild);
        $this->set('diagnosisControlsList', $this->DiagnosisControl->find('all', array(
            'conditions' => array(
                'DiagnosisControl.flag_active' => 1
            )
        )));
        $this->set('treatmentControlsList', $this->TreatmentControl->find('all', array(
            'conditions' => array(
                'TreatmentControl.flag_active' => 1
            )
        )));
        $this->set('eventControlsList', $this->EventControl->find('all', array(
            'conditions' => array(
                'EventControl.flag_active' => 1
            )
        )));
        $this->set('isAjax', $this->request->is('ajax'));
        $this->set('diagnosisMasterId', $diagnosisMasterId);
        $this->set('isSecondary', is_numeric($dxMasterData['DiagnosisMaster']['parent_id']));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $eventsData = $this->EventMaster->find('all', array(
            'conditions' => array(
                'EventMaster.participant_id' => $participantId,
                'EventMaster.diagnosis_master_id' => $diagnosisMasterId
            )
        ));
        if ($this->request->data['DiagnosisControl']['flag_compare_with_cap']) {
            foreach ($eventsData as $eventData) {
                EventMaster::generateDxCompatWarnings($this->request->data, $eventData);
            }
        }
        
        $this->Structures->set('empty', 'emptyStructure');
    }

    /**
     *
     * @param $participantId
     * @param $dxControlId
     * @param $parentId
     */
    public function add($participantId, $dxControlId, $parentId)
    {
        // MANAGE DATA
        $participantData = $this->Participant->getOrRedirect($participantId);
        $dxCtrl = $this->DiagnosisControl->getOrRedirect($dxControlId);
        
        $parentDx = null;
        if ($parentId == 0) {
            if ($dxCtrl['DiagnosisControl']['category'] != 'primary') {
                // is not a primary but has no parent
                $this->atimFlashError(__('invalid control id'), 'javascript:history.back();');
                return;
            }
        } else {
            $parentDx = $this->DiagnosisMaster->find('first', array(
                'conditions' => array(
                    'DiagnosisMaster.id' => $parentId,
                    'DiagnosisMaster.participant_id' => $participantId
                )
            ));
            if (empty($parentDx)) {
                $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            if ($dxCtrl['DiagnosisControl']['category'] == 'primary' || ! in_array($parentDx['DiagnosisControl']['category'], array(
                'primary',
                'secondary - distant'
            )) || ($dxCtrl['DiagnosisControl']['category'] == 'secondary - distant' && $parentDx['DiagnosisControl']['category'] != 'primary')) {
                $this->atimFlashError(__('invalid control id'), 'javascript:history.back();');
                return;
            }
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $atimMenuVariables = array(
            'Participant.id' => $participantId,
            "tableId" => $dxControlId,
            'DiagnosisMaster.parent_id' => $parentId
        );
        if (! empty($parentDx)) {
            $this->setDiagnosisMenu($parentDx, $atimMenuVariables);
        } else {
            $this->set('atimMenuVariables', $atimMenuVariables);
            $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/DiagnosisMasters/listall/'));
        }
        $this->set('origin', $parentId == 0 ? 'primary' : 'secondary - distant');
        $dxControlData = $this->DiagnosisControl->find('first', array(
            'conditions' => array(
                'DiagnosisControl.id' => $dxControlId
            )
        ));
        $this->Structures->set($dxControlData['DiagnosisControl']['form_alias'] . "," . ($parentId == 0 ? "dx_origin_primary" : "dx_origin_wo_primary"), 'atim_structure', array(
            'model_table_assoc' => array(
                'DiagnosisDetail' => $dxControlData['DiagnosisControl']['detail_tablename']
            )
        ));
        $this->Structures->set('empty', 'emptyStructure');
        
        $this->set('dxCtrl', $dxCtrl);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            $this->DiagnosisMaster->patchIcd10NullValues($this->request->data);
            $this->request->data['DiagnosisMaster']['participant_id'] = $participantId;
            $this->request->data['DiagnosisMaster']['diagnosis_control_id'] = $dxControlId;
            
            $this->request->data['DiagnosisMaster']['parent_id'] = $parentId == 0 ? null : $parentId;
            $this->request->data['DiagnosisMaster']['primary_id'] = $parentId == 0 ? null : (empty($parentDx['DiagnosisMaster']['primary_id']) ? $parentDx['DiagnosisMaster']['id'] : $parentDx['DiagnosisMaster']['primary_id']);
            
            $this->DiagnosisMaster->addWritableField(array(
                'participant_id',
                'diagnosis_control_id',
                'parent_id',
                'primary_id'
            ));
            $this->DiagnosisMaster->addWritableField('diagnosis_master_id', $dxControlData['DiagnosisControl']['detail_tablename']);
            
            $submittedDataValidates = true;
            // ... special validations
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                if ($this->DiagnosisMaster->save($this->request->data)) {
                    $diagnosisMasterId = $this->DiagnosisMaster->getLastInsertId();
                    
                    if ($parentId == 0) {
                        // Set primary_id of a Primary
                        $queryToUpdate = "UPDATE diagnosis_masters SET diagnosis_masters.primary_id = diagnosis_masters.id WHERE diagnosis_masters.id = $diagnosisMasterId;";
                        $this->DiagnosisMaster->tryCatchQuery($queryToUpdate);
                        $this->DiagnosisMaster->tryCatchQuery(str_replace("diagnosis_masters", "diagnosis_masters_revs", $queryToUpdate));
                    }
                    
                    $urlToFlash = '/ClinicalAnnotation/DiagnosisMasters/detail/' . $participantId . '/' . $diagnosisMasterId . '/';
                    
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
     * @param $diagnosisMasterId
     * @param null $redefinedPrimaryControlId
     */
    public function edit($participantId, $diagnosisMasterId, $redefinedPrimaryControlId = null)
    {
        
        // MANAGE DATA
        $dxMasterData = $this->DiagnosisMaster->find('first', array(
            'conditions' => array(
                'DiagnosisMaster.id' => $diagnosisMasterId,
                'DiagnosisMaster.participant_id' => $participantId
            )
        ));
        if (empty($dxMasterData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // CUSTOM CODE: MANAGE REDEFINE PRIMARY
        $hookLink = $this->hook('before_redefine_primary');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! is_null($redefinedPrimaryControlId)) {
            
            // UNKNOWN PRIMARY REDEFINITION
            // User expected to change an unknown primary to a specific diagnosis
            
            $newPrimaryCtrl = $this->DiagnosisControl->find('first', array(
                'conditions' => array(
                    'DiagnosisControl.id' => $redefinedPrimaryControlId
                )
            ));
            if (empty($newPrimaryCtrl) || ($dxMasterData['DiagnosisControl']['category'] != 'primary') || ($dxMasterData['DiagnosisControl']['controls_type'] != 'primary diagnosis unknown') || ($newPrimaryCtrl['DiagnosisControl']['category'] != 'primary') || ($newPrimaryCtrl['DiagnosisControl']['controls_type'] == 'primary diagnosis unknown'))
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            
            if ($dxMasterData['DiagnosisControl']['detail_tablename'] != $newPrimaryCtrl['DiagnosisControl']['detail_tablename']) {
                $this->DiagnosisMaster->tryCatchQuery("INSERT INTO " . $newPrimaryCtrl['DiagnosisControl']['detail_tablename'] . " (`diagnosis_master_id`) VALUES ($diagnosisMasterId);");
            }
            $this->DiagnosisMaster->tryCatchQuery("UPDATE diagnosis_masters SET diagnosis_control_id = $redefinedPrimaryControlId, deleted = 0 WHERE id = $diagnosisMasterId;");
            // Save empty data to add row in revs table
            $this->DiagnosisMaster->data = array();
            $this->DiagnosisMaster->id = $diagnosisMasterId;
            if (! $this->DiagnosisMaster->save(array()))
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            ;
            
            $dxMasterData = $this->DiagnosisMaster->find('first', array(
                'conditions' => array(
                    'DiagnosisMaster.id' => $diagnosisMasterId,
                    'DiagnosisMaster.participant_id' => $participantId
                )
            ));
            if (empty($dxMasterData)) {
                $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $this->addWarningMsg(__('unknown primary has been redefined. complete primary data.'));
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->setDiagnosisMenu($dxMasterData);
        
        $this->Structures->set($dxMasterData['DiagnosisControl']['form_alias']);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $dxMasterData;
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            $this->DiagnosisMaster->patchIcd10NullValues($this->request->data);
            $submittedDataValidates = true;
            // ... special validations
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->DiagnosisMaster->id = $diagnosisMasterId;
                if ($this->DiagnosisMaster->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/DiagnosisMasters/detail/' . $participantId . '/' . $diagnosisMasterId);
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $diagnosisMasterId
     */
    public function delete($participantId, $diagnosisMasterId)
    {
        // MANAGE DATA
        $diagnosisMasterData = $this->DiagnosisMaster->find('first', array(
            'conditions' => array(
                'DiagnosisMaster.id' => $diagnosisMasterId,
                'DiagnosisMaster.participant_id' => $participantId
            )
        ));
        if (empty($diagnosisMasterData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $arrAllowDeletion = $this->DiagnosisMaster->allowDeletion($diagnosisMasterId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->DiagnosisMaster->atimDelete($diagnosisMasterId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/ClinicalAnnotation/DiagnosisMasters/listall/' . $participantId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/ClinicalAnnotation/DiagnosisMasters/listall/' . $participantId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/ClinicalAnnotation/DiagnosisMasters/detail/' . $participantId . '/' . $diagnosisMasterId);
        }
    }

    /**
     *
     * @param $dxMasterData
     * @param array $additionalMenuVariables
     */
    public function setDiagnosisMenu($dxMasterData, $additionalMenuVariables = array())
    {
        if (! isset($dxMasterData['DiagnosisMaster']['id'])) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $primaryId = null;
        $progression1Id = null;
        $progression2Id = null;
        if ($dxMasterData['DiagnosisMaster']['primary_id'] == $dxMasterData['DiagnosisMaster']['id']) {
            // Primary Display
            $primaryId = $dxMasterData['DiagnosisMaster']['id'];
            $menuLink = '/ClinicalAnnotation/DiagnosisMasters/detail/%%Participant.id%%/%%DiagnosisMaster.primary_id%%';
        } elseif ($dxMasterData['DiagnosisMaster']['primary_id'] == $dxMasterData['DiagnosisMaster']['parent_id']) {
            // Secondary or primary progression display
            $primaryId = $dxMasterData['DiagnosisMaster']['primary_id'];
            $progression1Id = $dxMasterData['DiagnosisMaster']['id'];
            $menuLink = '/ClinicalAnnotation/DiagnosisMasters/detail/%%Participant.id%%/%%DiagnosisMaster.progression_1_id%%';
        } else {
            // Secondary progression display
            $primaryId = $dxMasterData['DiagnosisMaster']['primary_id'];
            $progression1Id = $dxMasterData['DiagnosisMaster']['parent_id'];
            $progression2Id = $dxMasterData['DiagnosisMaster']['id'];
            $menuLink = '/ClinicalAnnotation/DiagnosisMasters/detail/%%Participant.id%%/%%DiagnosisMaster.progression_2_id%%';
        }
        
        $this->set('atimMenu', $this->Menus->get($menuLink));
        $this->set('atimMenuVariables', array_merge(array(
            'Participant.id' => $dxMasterData['DiagnosisMaster']['participant_id'],
            'DiagnosisMaster.id' => $dxMasterData['DiagnosisMaster']['id'],
            
            'DiagnosisMaster.primary_id' => $primaryId,
            'DiagnosisMaster.progression_1_id' => $progression1Id,
            'DiagnosisMaster.progression_2_id' => $progression2Id
        ), $additionalMenuVariables));
    }
}