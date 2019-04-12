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
 * Class ClinicalCollectionLinksController
 */
class ClinicalCollectionLinksController extends ClinicalAnnotationAppController
{

    public $components = array();

    public $uses = array(
        'ClinicalAnnotation.Participant',
        'ClinicalAnnotation.ConsentMaster',
        'ClinicalAnnotation.DiagnosisMaster',
        'ClinicalAnnotation.TreatmentMaster',
        'ClinicalAnnotation.EventMaster',
        'ClinicalAnnotation.ClinicalAnnotationAppModel',
        
        'InventoryManagement.Collection',
        
        'Tools.CollectionProtocol',
        
        'Codingicd.CodingIcd10Who',
        'Codingicd.CodingIcd10Ca',
        'Codingicd.CodingIcdo3Morpho',
        'Codingicd.CodingIcdo3Topo'
    );

    public function beforeFilter()
    {
        parent::beforeFilter();
        
        // permissions on collections, consent, dx, tx and event are required
        $error = array();
        $check = array(
            'collection' => '/InventoryManagement/Collections/detail/'
        );
        foreach ($check as $name => $link) {
            if (! AppController::checkLinkPermission($link)) {
                $error[] = __($name);
            }
        }
        if ($error) {
            if ($this->request->is('ajax')) {
                die(__('You are not authorized to access that location.'));
            }
            $this->atimFlashError(__('you need privileges on the following modules to manage participant inventory: %s', implode(', ', $error)), 'javascript:history.back()');
        }
    }
    
    // var $paginate = array('Collection' => array('order'=>'Collection.acquisition_label ASC'));
    
    /**
     *
     * @param $participantId
     */
    public function listall($participantId)
    {
        $participantData = $this->Participant->getOrRedirect($participantId);
        
        $conditions = array(
            'Collection.participant_id' => $participantId
        );
        if (isset($this->passedArgs['filterModel']) && isset($this->passedArgs['filterId'])) {
            $filterModel = $this->passedArgs['filterModel'];
            if (isset($this->$filterModel)) {
                $conditions[$this->$filterModel->name . '.id'] = $this->passedArgs['filterId'];
            }
        }
        
        $order = 'Collection.collection_datetime ASC';
        
        $joins = array(
            DiagnosisMaster::joinOnDiagnosisDup('Collection.diagnosis_master_id'),
            DiagnosisMaster::$joinDiagnosisControlOnDup,
            ConsentMaster::joinOnConsentDup('Collection.consent_master_id'),
            ConsentMaster::$joinConsentControlOnDup,
            array(
                'table' => 'treatment_masters',
                'alias' => 'treatment_masters_dup',
                'type' => 'LEFT',
                'conditions' => array(
                    'Collection.treatment_master_id = treatment_masters_dup.id'
                )
            ),
            array(
                'table' => 'treatment_controls',
                'alias' => 'TreatmentControl',
                'type' => 'LEFT',
                'conditions' => array(
                    'treatment_masters_dup.treatment_control_id = TreatmentControl.id'
                )
            ),
            array(
                'table' => 'event_masters',
                'alias' => 'event_masters_dup',
                'type' => 'LEFT',
                'conditions' => array(
                    'Collection.event_master_id = event_masters_dup.id'
                )
            ),
            array(
                'table' => 'event_controls',
                'alias' => 'EventControl',
                'type' => 'LEFT',
                'conditions' => array(
                    'event_masters_dup.event_control_id = EventControl.id'
                )
            )
        );
        
        $hookLink = $this->hook('before_find');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // MANAGE DATA
        $this->request->data = $this->Collection->find('all', array(
            'conditions' => $conditions,
            'order' => $order,
            'joins' => $joins,
            'fields' => array(
                '*'
            )
        ));
        
        // Check permission and data to display
        $arrayDataForPermissions = array(
            '/ClinicalAnnotation/ConsentMasters/detail/' => array(
                'ConsentControl',
                'consent_masters_dup',
                'ConsentMaster',
                'ConsentDetail'
            ),
            '/ClinicalAnnotation/DiagnosisMasters/detail/' => array(
                'DiagnosisControl',
                'diagnosis_masters_dup',
                'DiagnosisMaster',
                'DiagnosisDetail'
            ),
            '/ClinicalAnnotation/TreatmentMasters/detail/' => array(
                'TreatmentControl',
                'treatment_masters_dup',
                'TreatmentMaster',
                'TreatmentDetail'
            ),
            '/ClinicalAnnotation/EventMasters/detail/' => array(
                'EventControl',
                'event_masters_dup',
                'EventMaster',
                'EventDetail'
            )
        );
        foreach ($arrayDataForPermissions as $link => $modelNamesToHide) {
            if (! AppController::checkLinkPermission($link)) {
                foreach ($this->request->data as &$newRecord) {
                    foreach ($newRecord as $newRecordModel => &$newRecordModelData) {
                        if (in_array($newRecordModel, $modelNamesToHide)) {
                            foreach ($newRecordModelData as &$newRecordValue)
                                $newRecordValue = '';
                        }
                    }
                }
            }
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId
        ));
        
        $this->set('collectionProtocols', $this->CollectionProtocol->getProtocolsList('use'));
        
        // BUILD COLLECTION CONTENT TREE VIEW
        
        $this->set('isAjax', $this->request->is('ajax'));
        
        if (! $this->request->is('ajax')) {
            $ids = array();
            foreach ($this->request->data as $unit) {
                $ids[] = $unit['Collection']['id'];
            }
            $ids = array_flip($this->Collection->hasChild($ids));
            foreach ($this->request->data as &$unit) {
                $unit['children'] = array_key_exists($unit['Collection']['id'], $ids);
            }
            $treeViewAtimStructure = array();
            $treeViewAtimStructure['Collection'] = $this->Structures->get('form', 'collections_for_collection_tree_view');
            $this->set('treeViewAtimStructure', $treeViewAtimStructure);
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $participantId
     * @param $collectionId
     */
    public function detail($participantId, $collectionId)
    {
        $collectionData = $this->Collection->getOrRedirect($collectionId);
        if ($collectionData['Collection']['participant_id'] != $participantId) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if ($collectionData['Collection']['consent_master_id']) {
            $tmpData = $this->ConsentMaster->getOrRedirect($collectionData['Collection']['consent_master_id']);
            $collectionData['ConsentControl'] = $tmpData['ConsentControl'];
        }
        if ($collectionData['Collection']['treatment_master_id']) {
            $tmpData = $this->TreatmentMaster->getOrRedirect($collectionData['Collection']['treatment_master_id']);
            $collectionData['TreatmentControl'] = $tmpData['TreatmentControl'];
        }
        if ($collectionData['Collection']['event_master_id']) {
            $tmpData = $this->EventMaster->getOrRedirect($collectionData['Collection']['event_master_id']);
            $collectionData['EventControl'] = $tmpData['EventControl'];
        }
        if ($collectionData['Collection']['diagnosis_master_id']) {
            $tmpData = $this->DiagnosisMaster->getOrRedirect($collectionData['Collection']['diagnosis_master_id']);
            $collectionData['DiagnosisControl'] = $tmpData['DiagnosisControl'];
        }
        
        $this->set('collectionData', $collectionData);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/ClinicalCollectionLinks/detail/'));
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'Collection.id' => $collectionId
        ));
        
        $this->Structures->set('collections', 'atim_structure_collection_detail');
        $this->Structures->set('consent_masters', 'atim_structure_consent_detail');
        $this->Structures->set('view_diagnosis,diagnosis_event_relation_type', 'atim_structure_diagnosis_detail');
        $this->Structures->set('treatmentmasters', 'atim_structure_tx');
        $this->Structures->set('eventmasters', 'atim_structure_event');
        $this->Structures->set('empty', 'emptyStructure');
        
        $this->set('cclsList', $this->ClinicalAnnotationAppModel->getCCLsList());
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $participantId
     */
    public function add($participantId, $collectionProtocolId = null)
    {
        $participantData = $this->Participant->getOrRedirect($participantId);
        
        // Set collections list
        $this->set('collectionId', isset($this->request->data['Collection']['id']) ? $this->request->data['Collection']['id'] : null);
        // Set collection protocol
        if ($collectionProtocolId) {
            $collectionProtocolLists = $this->CollectionProtocol->getProtocolsList('use');
            if (! array_key_exists($collectionProtocolId, $collectionProtocolLists)) {
                AppController::addWarningMsg(__("you don't have permission to use the protocol"));
                $collectionProtocolId = null;
            } else {
                $this->set('collectionProtocolId', $collectionProtocolId);
                $this->set('collectionProtocolName', $collectionProtocolLists[$collectionProtocolId]);
            }
        }
        
        // Set consents list
        $consentData = $this->ConsentMaster->find('all', array(
            'conditions' => array(
                'ConsentMaster.participant_id' => $participantId
            )
        ));
        $consentFound = false;
        if (isset($this->request->data['Collection']['consent_master_id'])) {
            $consentFound = $this->setForRadiolist($consentData, 'ConsentMaster', 'id', $this->request->data, 'Collection', 'consent_master_id');
        }
        $this->set('consentFound', $consentFound);
        $this->set('consentData', $consentData);
        
        // Set diagnoses list
        $diagnosisData = $this->DiagnosisMaster->find('threaded', array(
            'conditions' => array(
                'DiagnosisMaster.participant_id' => $participantId
            )
        ));
        $foundDx = false;
        if (isset($this->request->data['Collection']['diagnosis_master_id'])) {
            $foundDx = $this->DiagnosisMaster->arrangeThreadedDataForView($diagnosisData, $this->request->data['Collection']['diagnosis_master_id'], 'Collection');
        }
        $this->set('diagnosisData', $diagnosisData);
        $this->set('foundDx', $foundDx);
        
        // set tx list
        $txData = $this->TreatmentMaster->find('all', array(
            'conditions' => array(
                'TreatmentMaster.participant_id' => $participantId,
                'TreatmentControl.flag_use_for_ccl' => true
            )
        ));
        $foundTx = false;
        if (isset($this->request->data['Collection']['treatment_master_id'])) {
            $foundTx = $this->setForRadiolist($txData, 'TreatmentMaster', 'id', $this->request->data, 'Collection', 'treatment_master_id');
        }
        $this->set('txData', $txData);
        $this->set('foundTx', $foundTx);
        
        // set event list
        $eventData = $this->EventMaster->find('all', array(
            'conditions' => array(
                'EventMaster.participant_id' => $participantId,
                'EventControl.flag_use_for_ccl' => true
            )
        ));
        $foundEvent = false;
        if (isset($this->request->data['Collection']['event_master_id'])) {
            $foundEvent = $this->setForRadiolist($eventData, 'EventMaster', 'id', $this->request->data, 'Collection', 'event_master_id');
        }
        $this->set('eventData', $eventData);
        $this->set('foundEvent', $foundEvent);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/ClinicalCollectionLinks/listall/'));
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId
        ));
        
        $this->Structures->set('collections', 'atim_structure_collection_detail');
        $this->Structures->set('consent_masters', 'atim_structure_consent_detail');
        $this->Structures->set('view_diagnosis', 'atim_structure_diagnosis_detail');
        $this->Structures->set('treatmentmasters', 'atim_structure_tx');
        $this->Structures->set('eventmasters', 'atim_structure_event');
        $this->Structures->set('empty', 'emptyStructure');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            // Initial Display: Hook call to set default values
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            // Launch Save Process
            $fields = array(
                'participant_id',
                'diagnosis_master_id',
                'consent_master_id',
                'treatment_master_id',
                'event_master_id'
            );

            if (isset($this->request->data['Collection']['id']) && $this->request->data['Collection']['id']) {

                // test if the collection exists and is available
                $collectionData = $this->Collection->find('first', array(
                    'conditions' => array(
                        'Collection.participant_id IS NULL',
                        'Collection.collection_property' => 'participant collection',
                        'Collection.id' => $this->request->data['Collection']['id']
                    )
                ));
                if (empty($collectionData)) {
                    $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            } else {
                $this->request->data['Collection']['deleted'] = 1;
                $fields[] = 'deleted';
                $fields[] = 'created_by';
                $fields[] = 'modified_by';
                if ($collectionProtocolId) {
                    $this->request->data['Collection']['collection_protocol_id'] = $collectionProtocolId;
                    $fields[] = 'collection_protocol_id';
                }
            }

            $models = array("ConsentMaster", "DiagnosisMaster", "TreatmentMaster", "EventMaster");
            foreach ($models as $model) {
                $idField = Inflector::underscore($model)."_id";
                if (!empty($this->request->data['Collection'][$idField])){
                    $id = $this->request->data['Collection'][$idField];
                    $modelInstance = AppModel::getInstance("ClinicalAnnotation", $model);

                    $p = $modelInstance->find('first', array(
                        'conditions' => array($model.'.id' => $id)
                    ));

                    if (!isset($p[$model]['participant_id']) || $p[$model]['participant_id']!=$participantId){
                        $this->atimFlashError(__('the %s is not related to the participant', __(strtolower(str_replace("Master", "", $model)))), 'javascript:history.back();');
                    }
                }

            }

            if (!empty($this->request->data['Collection']['event_master_id'])){
                $this->EventMaster->id = $this->request->data['Collection']['event_master_id'];
                $result = $this->EventMaster->read();
                if (!$result || !$result['EventControl']['flag_use_for_ccl']){
                    $this->atimFlashError(__('the annotation #%s is not for clinical collection link', $this->request->data['Collection']['event_master_id']), 'javascript:history.back();');
                }
            }
            
            $this->request->data['Collection']['participant_id'] = $participantId;
            $this->Collection->id = (isset($this->request->data['Collection']['id']) && $this->request->data['Collection']['id']) ? $this->request->data['Collection']['id'] : null;
            unset($this->request->data['Collection']['id']);
            
            $this->Collection->addWritableField($fields);
            
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates && $this->Collection->save($this->request->data, true, $fields)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                if (isset($this->request->data['Collection']['deleted'])) {
                    $this->redirect('/InventoryManagement/Collections/add/' . $this->Collection->getLastInsertId());
                } else {
                    $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/ClinicalCollectionLinks/detail/' . $participantId . '/' . $this->Collection->id);
                }
                return;
            }
        }
        $this->set('cclsList', $this->ClinicalAnnotationAppModel->getCCLsList());
    }

    /**
     *
     * @param $participantId
     * @param $collectionId
     */
    public function edit($participantId, $collectionId)
    {
        $collectionData = $this->Collection->getOrRedirect($collectionId);
        if ($collectionData['Collection']['participant_id'] != $participantId) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('collectionData', $collectionData);
        
        if ($collectionData['Collection']['treatment_master_id']) {
            $collectionData['Collection']['tx_or_event_id'] = 'tx_' . $collectionData['Collection']['treatment_master_id'];
        } elseif ($collectionData['Collection']['event_master_id']) {
            $collectionData['Collection']['tx_or_event_id'] = 'ev_' . $collectionData['Collection']['event_master_id'];
        }
        $dataForForm = $this->request->data ? $this->request->data : $collectionData;
        foreach (array(
            'diagnosis_master_id',
            'consent_master_id',
            'treatment_master_id',
            'event_master_id'
        ) as $foreignKey) {
            // Used to remove warning generated by setForRadiolist() call when custom code hide either treatment or annotation (etc) section.
            if (! array_key_exists($foreignKey, $dataForForm['Collection']))
                $dataForForm['Collection'][$foreignKey] = null;
        }
        
        // Set consents list
        $consentData = $this->ConsentMaster->find('all', array(
            'conditions' => array(
                'ConsentMaster.deleted' => '0',
                'ConsentMaster.participant_id' => $participantId
            )
        ));
        // because consent has a one to many relation with participant, we need to format it
        $consentFound = $this->setForRadiolist($consentData, 'ConsentMaster', 'id', $dataForForm, 'Collection', 'consent_master_id');
        $this->set('consentData', $consentData);
        $this->set('consentFound', $consentFound);
        
        // Set diagnoses list
        $diagnosisData = $this->DiagnosisMaster->find('threaded', array(
            'conditions' => array(
                'DiagnosisMaster.deleted' => '0',
                'DiagnosisMaster.participant_id' => $participantId
            )
        ));
        // because diagnosis has a one to many relation with participant, we need to format it
        $foundDx = $this->DiagnosisMaster->arrangeThreadedDataForView($diagnosisData, (isset($dataForForm['Collection']['diagnosis_master_id']) ? $dataForForm['Collection']['diagnosis_master_id'] : null), 'Collection');
        
        $this->set('diagnosisData', $diagnosisData);
        $this->set('foundDx', $foundDx);
        
        // set tx list
        $txData = $this->TreatmentMaster->find('all', array(
            'conditions' => array(
                'TreatmentMaster.participant_id' => $participantId,
                'TreatmentControl.flag_use_for_ccl' => true
            )
        ));
        $foundTx = $this->setForRadiolist($txData, 'TreatmentMaster', 'id', $dataForForm, 'Collection', 'treatment_master_id');
        $this->set('txData', $txData);
        $this->set('foundTx', $foundTx);
        
        // set event list
        $eventData = $this->EventMaster->find('all', array(
            'conditions' => array(
                'EventMaster.participant_id' => $participantId,
                'EventControl.flag_use_for_ccl' => true
            )
        ));
        $foundEvent = $this->setForRadiolist($eventData, 'EventMaster', 'id', $dataForForm, 'Collection', 'event_master_id');
        $this->set('eventData', $eventData);
        $this->set('foundEvent', $foundEvent);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/ClinicalAnnotation/ClinicalCollectionLinks/detail/'));
        $this->set('atimMenuVariables', array(
            'Participant.id' => $participantId,
            'Collection.id' => $collectionId
        ));
        
        $this->Structures->set('collections', 'atim_structure_collection_detail');
        $this->Structures->set('consent_masters', 'atim_structure_consent_detail');
        $this->Structures->set('view_diagnosis', 'atim_structure_diagnosis_detail');
        $this->Structures->set('treatmentmasters', 'atim_structure_tx');
        $this->Structures->set('eventmasters', 'atim_structure_event');
        $this->Structures->set('empty', 'emptyStructure');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // MANAGE DATA RECORD
        
        if (! empty($this->request->data)) {
            // Launch Save Process
            
            $submittedDataValidates = true;
            $fields = array(
                'consent_master_id',
                'diagnosis_master_id',
                'treatment_master_id',
                'event_master_id'
            );
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            $this->Collection->id = $collectionId;
            $this->Collection->addWritableField($fields);
            
            $models = array("ConsentMaster", "DiagnosisMaster", "TreatmentMaster", "EventMaster");
            foreach ($models as $model) {
                $idField = Inflector::underscore($model)."_id";
                if (!empty($this->request->data['Collection'][$idField])){
                    $id = $this->request->data['Collection'][$idField];
                    $modelInstance = AppModel::getInstance("ClinicalAnnotation", $model);

                    $p = $modelInstance->find('first', array(
                        'conditions' => array($model.'.id' => $id)
                    ));

                    if (!isset($p[$model]['participant_id']) || $p[$model]['participant_id']!=$participantId){
                        $this->atimFlashError(__('the %s is not related to the participant', __(strtolower(str_replace("Master", "", $model)))), 'javascript:history.back();');
                    }
                }

            }

            if (!empty($this->request->data['Collection']['event_master_id'])){
                $this->EventMaster->id = $this->request->data['Collection']['event_master_id'];
                $result = $this->EventMaster->read();
                if (!$result || !$result['EventControl']['flag_use_for_ccl']){
                    $this->atimFlashError(__('the annotation #%s is not for clinical collection link', $this->request->data['Collection']['event_master_id']), 'javascript:history.back();');
                }
            }

            if ($submittedDataValidates && $this->Collection->save($this->request->data, true, $fields)) {
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                $this->atimFlash(__('your data has been updated'), '/ClinicalAnnotation/ClinicalCollectionLinks/detail/' . $participantId . '/' . $collectionId);
                return;
            }
        } else {
            // Launch Initial Display Process
            $this->request->data = $collectionData;
        }
        $this->set('cclsList', $this->ClinicalAnnotationAppModel->getCCLsList());
    }

    /**
     *
     * @param $participantId
     * @param $collectionId
     */
    public function delete($participantId, $collectionId)
    {
        $collectionData = $this->Collection->getOrRedirect($collectionId);
        if ($collectionData['Collection']['participant_id'] != $participantId) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $arrAllowDeletion = $this->Collection->allowLinkDeletion($collectionId);
        
        // CUSTOM CODE
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            $collectionDataToUpdate = array(
                'Collection' => array(
                    'participant_id' => null,
                    'diagnosis_master_id' => null,
                    'consent_master_id' => null,
                    'treatment_master_id' => null,
                    'event_master_id' => null
                )
            );
            
            $this->Collection->data = array();
            $this->Collection->id = $collectionId;
            $this->Collection->addWritableField(array(
                'participant_id',
                'diagnosis_master_id',
                'consent_master_id',
                'treatment_master_id',
                'event_master_id'
            ));
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($this->Collection->save($collectionDataToUpdate, false)) {
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                $this->atimFlash(__('your data has been deleted') . ' ' . __('use inventory management module to delete the entire collection'), '/ClinicalAnnotation/ClinicalCollectionLinks/listall/' . $participantId . '/');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/ClinicalAnnotation/ClinicalCollectionLinks/detail/' . $participantId . '/' . $collectionId . '/');
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/ClinicalAnnotation/ClinicalCollectionLinks/detail/' . $participantId . '/' . $collectionId);
        }
    }
}