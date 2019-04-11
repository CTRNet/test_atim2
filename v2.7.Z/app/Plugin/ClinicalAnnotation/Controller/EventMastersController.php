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
 * Class EventMastersController
 */
class EventMastersController extends ClinicalAnnotationAppController
{

    public $uses = array(
        'ClinicalAnnotation.Participant',
        'ClinicalAnnotation.EventMaster',
        'ClinicalAnnotation.EventControl',
        'ClinicalAnnotation.DiagnosisMaster'
    );

    public $paginate = array(
        'EventMaster' => array(
            'order' => 'EventMaster.event_date ASC'
        )
    );

    public function beforeFilter()
    {
        parent::beforeFilter();
        $this->set('atimMenu', $this->Menus->get('/' . $this->params['plugin'] . '/' . $this->params['controller'] . '/' . $this->params['action'] . '/' . $this->params['pass'][0]));
    }

    /**
     *
     * @param $eventGroup
     * @param $participantId
     * @param null $eventControlId
     */
    public function listall($eventGroup, $participantId, $eventControlId = null)
    {
        $participantData = $this->Participant->getOrRedirect($participantId);
        
        $searchCriteria = array();
        if (! $eventControlId) {
            // 1 - MANAGE DISPLAY
            $eventControls = $this->EventControl->find('all', array(
                'conditions' => array(
                    'EventControl.event_group' => $eventGroup,
                    'EventControl.flag_active' => '1'
                ),
                'order' => array(
                    'EventControl.display_order ASC'
                )
            ));
            $participantEventControls = $this->EventMaster->find('all', array(
                'conditions' => array(
                    'EventMaster.participant_id' => $participantId,
                    'EventControl.event_group' => $eventGroup,
                    'EventControl.flag_active' => '1'
                ),
                'fields' => array(
                    "GROUP_CONCAT(DISTINCT EventControl.id SEPARATOR ',') as ids"
                )
            ));
            $participantEventControlIds = explode(',', $participantEventControls['0']['0']['ids']);
            $controlsForSubformDisplay = array();
            if ($participantEventControlIds) {
                foreach ($eventControls as $newCtrl) {
                    if (in_array($newCtrl['EventControl']['id'], $participantEventControlIds)) {
                        if ($newCtrl['EventControl']['use_detail_form_for_index']) {
                            // Controls that should be listed using detail form
                            $controlsForSubformDisplay[$newCtrl['EventControl']['id']] = $newCtrl;
                            $controlsForSubformDisplay[$newCtrl['EventControl']['id']]['EventControl']['ev_header'] = __($newCtrl['EventControl']['event_type']) . (empty($newCtrl['EventControl']['disease_site']) ? '' : ' - ' . __($newCtrl['EventControl']['disease_site']));
                        } else {
                            $controlsForSubformDisplay['-1']['EventControl'] = array(
                                'id' => '-1',
                                'ev_header' => null
                            );
                        }
                    }
                }
            } else {
                $controlsForSubformDisplay['-1']['EventControl'] = array(
                    'id' => '-1',
                    'ev_header' => null
                );
            }
            ksort($controlsForSubformDisplay);
            $this->set('controlsForSubformDisplay', $controlsForSubformDisplay);
            // find all EVENTCONTROLS, for ADD form
            $addLinks = $this->EventControl->buildAddLinks($eventControls, $participantId, $eventGroup);
            $this->set('addLinks', $addLinks);
            // Set structure
            $this->Structures->set('eventmasters');
        } elseif ($eventControlId == '-1') {
            // 2 - DISPLAY ALL EVENTS THAT SHOULD BE DISPLAYED IN MASTER VIEW
            // Set search criteria
            $searchCriteria['EventMaster.participant_id'] = $participantId;
            $searchCriteria['EventControl.event_group'] = $eventGroup;
            $searchCriteria['EventControl.use_detail_form_for_index'] = '0';
            // Set structure
            $this->Structures->set('eventmasters');
        } else {
            // 3 - DISPLAY ALL EVENTS THAT SHOULD BE DISPLAYED IN DETAILED VIEW
            // Set search criteria
            $searchCriteria['EventMaster.participant_id'] = $participantId;
            $searchCriteria['EventControl.id'] = $eventControlId;
            // Set structure
            $controlData = $this->EventControl->getOrRedirect($eventControlId);
            $this->Structures->set($controlData['EventControl']['form_alias']);
            self::buildDetailBinding($this->EventMaster, $searchCriteria, $controlData['EventControl']['form_alias']);
        }
        
        // MANAGE DATA
        $this->request->data = $eventControlId ? $this->paginate($this->EventMaster, $searchCriteria) : array();
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenuVariables', array(
            'EventMaster.event_group' => $eventGroup,
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
     * @param $eventMasterId
     * @param int $isAjax
     */
    public function detail($participantId, $eventMasterId, $isAjax = 0)
    {
        // MANAGE DATA
        $this->request->data = $this->EventMaster->find('first', array(
            'conditions' => array(
                'EventMaster.id' => $eventMasterId,
                'EventMaster.participant_id' => $participantId
            )
        ));
        if (empty($this->request->data)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->EventMaster->calculatedDetailfields($this->request->data);
        
        $eventGroup = $this->request->data['EventControl']['event_group'];
        $diagnosisData = $this->DiagnosisMaster->getRelatedDiagnosisEvents($this->request->data['EventMaster']['diagnosis_master_id']);
        $this->set('diagnosisData', $diagnosisData);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/' . $this->params['plugin'] . '/' . $this->params['controller'] . '/listall/' . $eventGroup));
        $this->set('atimMenuVariables', array(
            'EventMaster.event_group' => $eventGroup,
            'Participant.id' => $participantId,
            'EventMaster.id' => $eventMasterId,
            'EventControl.id' => $this->request->data['EventControl']['id']
        ));
        
        // set FORM ALIAS based off VALUE from MASTER table
        $this->Structures->set($this->request->data['EventControl']['form_alias']);
        $this->Structures->set('view_diagnosis,diagnosis_event_relation_type', 'diagnosisStructure');
        $this->set('isAjax', $isAjax);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (isset($diagnosisData[0]) && strpos($this->request->data['EventControl']['event_type'], 'cap report - ') !== false && $diagnosisData[0]['DiagnosisControl']['flag_compare_with_cap']) {
            // cap report, generate warnings if there are mismatches
            EventMaster::generateDxCompatWarnings($diagnosisData[0], $this->request->data);
        }
    }

    /**
     *
     * @param $participantId
     * @param $eventControlId
     * @param null $diagnosisMasterId
     */
    public function add($participantId, $eventControlId, $diagnosisMasterId = null)
    {
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/listall/')) {
            $this->atimFlashError(__('you need privileges to access this page'), 'javascript:history.back()');
        }
        
        // MANAGE DATA
        $participantData = $this->Participant->getOrRedirect($participantId);
        $eventControlData = $this->EventControl->getOrRedirect($eventControlId);
        $eventGroup = $eventControlData['EventControl']['event_group'];
        
        // Set diagnosis data for diagnosis selection (radio button)
        $dxData = $this->DiagnosisMaster->find('threaded', array(
            'conditions' => array(
                'DiagnosisMaster.participant_id' => $participantId
            ),
            'order' => array(
                'DiagnosisMaster.dx_date ASC'
            )
        ));
        if (! empty($this->request->data) && isset($this->request->data['EventMaster']['diagnosis_master_id'])) {
            $this->DiagnosisMaster->arrangeThreadedDataForView($dxData, $this->request->data['EventMaster']['diagnosis_master_id'], 'EventMaster');
        } elseif ($diagnosisMasterId) {
            $this->DiagnosisMaster->arrangeThreadedDataForView($dxData, $diagnosisMasterId, 'EventMaster');
        }
        $this->set('dataForChecklist', $dxData);
        
        $this->set('initialDisplay', (empty($this->request->data)));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/' . $this->params['plugin'] . '/' . $this->params['controller'] . '/listall/' . $eventGroup));
        $this->set('atimMenuVariables', array(
            'EventControl.event_group' => $eventGroup,
            'Participant.id' => $participantId,
            'EventControl.id' => $eventControlId
        ));
        $this->set('evHeader', __($eventControlData['EventControl']['event_type']) . (empty($eventControlData['EventControl']['disease_site']) ? '' : ' - ' . __($eventControlData['EventControl']['disease_site'])));
        
        // set FORM ALIAS based off VALUE from CONTROL table
        $this->Structures->set('empty', 'emptyStructure');
        $this->Structures->set($eventControlData['EventControl']['form_alias']);
        $this->Structures->set('view_diagnosis', 'diagnosisStructure');
        $this->set('useAddgrid', $eventControlData['EventControl']['use_addgrid']);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            if ($eventControlData['EventControl']['use_addgrid'])
                $this->request->data = array(
                    array()
                );
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            if (! $eventControlData['EventControl']['use_addgrid']) {
                
                // 1 - ** Single data save **
                
                $this->request->data['EventMaster']['participant_id'] = $participantId;
                $this->request->data['EventMaster']['event_control_id'] = $eventControlId;
                
                // LAUNCH SPECIAL VALIDATION PROCESS
                $submittedDataValidates = true;
                
                // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
                $hookLink = $this->hook('presave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                $this->EventMaster->addWritableField(array(
                    'participant_id',
                    'event_control_id',
                    'diagnosis_master_id'
                ));
                if ($submittedDataValidates && $this->EventMaster->save($this->request->data)) {
                    $urlToFlash = '/ClinicalAnnotation/EventMasters/detail/' . $participantId . '/' . $this->EventMaster->getLastInsertId();
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), $urlToFlash);
                }
            } else {
                if (!empty($this->request->data['EventMaster']['diagnosis_master_id'])){
                    $diagnosisMasterId = $this->request->data['EventMaster']['diagnosis_master_id'];
                    $diagnosisMasterModel = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster");

                    $p = $diagnosisMasterModel->find('first', array(
                        'conditions' => array('DiagnosisMaster.id' => $diagnosisMasterId)
                    ));

                    if (!isset($p['DiagnosisMaster']['participant_id']) || $p['DiagnosisMaster']['participant_id']!=$participantId){
                        $this->atimFlashError(__('the diagnosis is not related to the participant'), 'javascript:history.back();');
                    }
                }
                
                // 2 - ** Multi lines save **
                
                $errorsTracking = array();
                
                // Launch Structure Fields Validation
                $diagnosisMasterId = (array_key_exists('EventMaster', $this->request->data) && array_key_exists('diagnosis_master_id', $this->request->data['EventMaster'])) ? $this->request->data['EventMaster']['diagnosis_master_id'] : null;
                unset($this->request->data['EventMaster']);
                
                $rowCounter = 0;
                foreach ($this->request->data as &$dataUnit) {
                    $rowCounter ++;
                    
                    $dataUnit['EventMaster']['event_control_id'] = $eventControlId;
                    $dataUnit['EventMaster']['participant_id'] = $participantId;
                    $dataUnit['EventMaster']['diagnosis_master_id'] = $diagnosisMasterId;
                    
                    $this->EventMaster->id = null;
                    $this->EventMaster->set($dataUnit);
                    if (! $this->EventMaster->validates()) {
                        foreach ($this->EventMaster->validationErrors as $field => $msgs) {
                            $msgs = is_array($msgs) ? $msgs : array(
                                $msgs
                            );
                            foreach ($msgs as $msg){
                                $errorsTracking[$field][$msg][] = $rowCounter;
                            }
                        }
                    }
                    $dataUnit = $this->EventMaster->data;
                }
                unset($dataUnit);
                
                $hookLink = $this->hook('presave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                // Launch Save Process
                if (empty($this->request->data)) {
                    $this->EventMaster->validationErrors[][] = 'at least one record has to be created';
                } elseif (empty($errorsTracking)) {
                    AppModel::acquireBatchViewsUpdateLock();
                    // save all
                    $this->EventMaster->addWritableField(array(
                        'event_control_id',
                        'participant_id',
                        'diagnosis_master_id'
                    ));
                    $this->EventMaster->writableFieldsMode = 'addgrid';
                    foreach ($this->request->data as $newDataToSave) {
                        $this->EventMaster->id = null;
                        $this->EventMaster->data = array();
                        if (! $this->EventMaster->save($newDataToSave, false)){
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    }
                    $urlToFlash = '/ClinicalAnnotation/EventMasters/listall/' . $eventGroup . '/' . $participantId . '/';
                    $hookLink = $this->hook('postsave_process_batch');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    AppModel::releaseBatchViewsUpdateLock();
                    $this->atimFlash(__('your data has been updated'), $urlToFlash);
                } else {
                    $this->EventMaster->validationErrors = array();
                    foreach ($errorsTracking as $field => $msgAndLines) {
                        foreach ($msgAndLines as $msg => $lines) {
                            $this->EventMaster->validationErrors[$field][] = $msg . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
                        }
                    }
                }
            }
        }
    }

    /**
     *
     * @param $participantId
     * @param $eventMasterId
     */
    public function edit($participantId, $eventMasterId)
    {
        if (! AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/listall/')) {
            $this->atimFlashError(__('you need privileges to access this page'), 'javascript:history.back()');
        }
        
        // MANAGE DATA
        $eventMasterData = $this->EventMaster->find('first', array(
            'conditions' => array(
                'EventMaster.id' => $eventMasterId,
                'EventMaster.participant_id' => $participantId
            )
        ));
        if (empty($eventMasterData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $eventGroup = $eventMasterData['EventControl']['event_group'];
        
        // Set diagnosis data for diagnosis selection (radio button)
        $dxData = $this->DiagnosisMaster->find('threaded', array(
            'conditions' => array(
                'DiagnosisMaster.participant_id' => $participantId
            ),
            'order' => array(
                'DiagnosisMaster.dx_date ASC'
            )
        ));
        $dxId = isset($this->request->data['EventMaster']['diagnosis_master_id']) ? $this->request->data['EventMaster']['diagnosis_master_id'] : $eventMasterData['EventMaster']['diagnosis_master_id'];
        $this->DiagnosisMaster->arrangeThreadedDataForView($dxData, $dxId, 'EventMaster');
        $this->set('dataForChecklist', $dxData);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/' . $this->params['plugin'] . '/' . $this->params['controller'] . '/listall/' . $eventGroup));
        $this->set('atimMenuVariables', array(
            'EventMaster.event_group' => $eventGroup,
            'Participant.id' => $participantId,
            'EventMaster.id' => $eventMasterId,
            'EventControl.id' => $eventMasterData['EventControl']['id']
        ));
        
        // set FORM ALIAS based off VALUE from MASTER table
        $this->Structures->set('empty', 'emptyStructure');
        $this->Structures->set($eventMasterData['EventControl']['form_alias']);
        $this->Structures->set('view_diagnosis', 'diagnosisStructure');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            $this->EventMaster->id = $eventMasterId;
            
            // LAUNCH SPECIAL VALIDATION PROCESS
            $submittedDataValidates = true;
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            $this->EventMaster->addWritableField('diagnosis_master_id');
            
            if (!empty($this->request->data['EventMaster']['diagnosis_master_id'])){
                $diagnosisMasterId = $this->request->data['EventMaster']['diagnosis_master_id'];
                $diagnosisMasterModel = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster");

                $p = $diagnosisMasterModel->find('first', array(
                    'conditions' => array('DiagnosisMaster.id' => $diagnosisMasterId)
                ));

                if (!isset($p['DiagnosisMaster']['participant_id']) || $p['DiagnosisMaster']['participant_id']!=$participantId){
                    $this->atimFlashError(__('the diagnosis is not related to the participant'), 'javascript:history.back();');
                }
            }

            if ($submittedDataValidates && $this->EventMaster->save($this->request->data)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/EventMasters/detail/' . $participantId . '/' . $eventMasterId);
            }
        } else {
            $this->request->data = $eventMasterData;
        }
    }

    /**
     *
     * @param $participantId
     * @param $eventMasterId
     */
    public function delete($participantId, $eventMasterId)
    {
        $eventMasterData = $this->EventMaster->find('first', array(
            'conditions' => array(
                'EventMaster.id' => $eventMasterId,
                'EventMaster.participant_id' => $participantId
            )
        ));
        if (empty($eventMasterData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $eventGroup = $eventMasterData['EventControl']['event_group'];
        
        $arrAllowDeletion = $this->EventMaster->allowDeletion($eventMasterId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->EventMaster->atimDelete($eventMasterId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/ClinicalAnnotation/EventMasters/listall/' . $eventGroup . '/' . $participantId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/ClinicalAnnotation/EventMasters/listall/' . $eventGroup . '/' . $participantId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/ClinicalAnnotation/EventMasters/detail/' . $participantId . '/' . $eventMasterId);
        }
    }
}