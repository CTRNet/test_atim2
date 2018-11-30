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
 * Class CollectionProtocolController
 */
class CollectionProtocolController extends ToolsAppController
{

    public $uses = array(
        'Tools.Template',
        'Tools.TemplateNode',
        'Tools.CollectionProtocol',
        'Tools.CollectionProtocolVisit',
        'Group'
    );

    public function beforeFilter()
    {
        parent::beforeFilter();
        $this->Auth->actionPath = 'controllers/';
    }

    /**
     * List user Collection Protocols.
     */
    public function index()
    {
        $this->set('atimMenu', $this->Menus->get('/Tools/Template/listProtocolsAndTemplates'));
        $this->Structures->set('collection_protocol');
        
        $protocols = $this->CollectionProtocol->getTools('list all');
        $protocolIds = array();
        foreach ($protocols as $newTemplate) {
            $protocolIds[] = $newTemplate['CollectionProtocol']['id'];
        }
        $conditions = array(
            'CollectionProtocol.id' => $protocolIds
        );
        $this->request->data = $this->paginate($this->CollectionProtocol, $conditions);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     * Create a new Collection Protocol
     */
    public function add()
    {
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        $this->set('atimMenu', $this->Menus->get('/Tools/Template/listProtocolsAndTemplates'));
        
        $this->Structures->set('collection_protocol', 'collection_protocol_structure');
        $this->set('collectionProtocolVisitStructure', $this->CollectionProtocolVisit->getCollectionProtocolVisitStructures());
        $this->Structures->set('empty', 'emptyStructure');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = null;
            $this->set('collectionProtocolData', array());
            $this->set('collectionProtocolVisitData', array());
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            // reset array
            $collectionProtocolData = array(
                'CollectionProtocol' => $this->request->data['CollectionProtocol']
            );
            unset($this->request->data['CollectionProtocol']);
            $collectionProtocolVisitData = $this->request->data;
            $this->request->data = null;
            
            $this->set('collectionProtocolData', $collectionProtocolData);
            $this->set('collectionProtocolVisitData', $collectionProtocolVisitData);
            
            // LAUNCH SPECIAL VALIDATION PROCESS
            
            $submittedDataValidates = true;
            
            // Validate collection protocol
            $this->CollectionProtocol->set($collectionProtocolData);
            $submittedDataValidates = ($this->CollectionProtocol->validates()) ? $submittedDataValidates : false;
            $collectionProtocolData = $this->CollectionProtocol->data;
            
            // Validate collection protocol visit
            $allCollectionProtocolVisitErrors = array();
            $nbrOfFirstVisit = 0;
            foreach ($collectionProtocolVisitData as &$newCollectionProtocolVisist) {
                unset($newCollectionProtocolVisist['CollectionProtocolVisit']['id']);
                if ($newCollectionProtocolVisist['CollectionProtocolVisit']['first_visit']) {
                    $nbrOfFirstVisit ++;
                }
                $this->CollectionProtocolVisit->set($newCollectionProtocolVisist);
                $submittedDataValidates = ($this->CollectionProtocolVisit->validates()) ? $submittedDataValidates : false;
                $allCollectionProtocolVisitErrors = array_merge($allCollectionProtocolVisitErrors, $this->CollectionProtocolVisit->validationErrors);
                $newCollectionProtocolVisist = $this->CollectionProtocolVisit->data;
            }
            if (! $nbrOfFirstVisit || $nbrOfFirstVisit > 1) {
                $allCollectionProtocolVisitErrors['first_visit'][] = 'one visit and only one should be flagged as first one';
                $submittedDataValidates = false;
            }
            if (! empty($allCollectionProtocolVisitErrors)) {
                $this->CollectionProtocolVisit->validationErrors = array();
                foreach ($allCollectionProtocolVisitErrors as $field => $msgs) {
                    $msgs = is_array($msgs) ? $msgs : array(
                        $msgs
                    );
                    foreach ($msgs as $errorMessage)
                        $this->CollectionProtocolVisit->validationErrors[$field][] = $errorMessage;
                }
            }
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // LAUNCH SAVE PROCESS
            
            if ($submittedDataValidates) {
                
                // Set additional protocol data and save
                $this->CollectionProtocol->setOwner($collectionProtocolData);
                $collectionProtocolData['CollectionProtocol']['user_id'] = AppController::getInstance()->Session->read('Auth.User.id');
                $collectionProtocolData['CollectionProtocol']['group_id'] = AppController::getInstance()->Session->read('Auth.User.group_id');
                $this->CollectionProtocol->addWritableField(array(
                    'user_id',
                    'group_id'
                ));
                if ($collectionProtocolData['CollectionProtocol']['flag_active']) {
                    $collectionProtocolData['CollectionProtocol']['last_activation_date'] = date('Y-m-d');
                    $this->CollectionProtocol->addWritableField(array(
                        'last_activation_date'
                    ));
                }
                if (! $this->CollectionProtocol->save($collectionProtocolData, false)) {
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $collectionProtocolId = $this->CollectionProtocol->id;
                
                $this->CollectionProtocolVisit->writableFieldsMode = 'addgrid';
                $this->CollectionProtocolVisit->addWritableField(array(
                    'collection_protocol_id',
                    'default_values'
                ));
                foreach ($collectionProtocolVisitData as $newCollectionProtocolVisistToSave) {
                    // Format data
                    $newCollectionProtocolVisistToSave['CollectionProtocolVisit']['collection_protocol_id'] = $collectionProtocolId;
                    if ($newCollectionProtocolVisistToSave['CollectionProtocolVisit']['first_visit']) {
                        $newCollectionProtocolVisistToSave['CollectionProtocolVisit']['time_from_first_visit'] = '0';
                        $newCollectionProtocolVisistToSave['CollectionProtocolVisit']['time_from_first_visit_unit'] = 'day';
                    }
                    foreach ($newCollectionProtocolVisistToSave['Collection'] as &$newCollectionField) {
                        if (is_array($newCollectionField)) {
                            $tmpNewCollectionField = $newCollectionField;
                            $tmpNewCollectionField = array_filter($tmpNewCollectionField, function ($var) {
                                return (! ($var == '' || is_null($var)));
                            });
                            $newCollectionField = empty($tmpNewCollectionField) ? '' : $newCollectionField;
                        }
                    }
                    $collectionData = array_filter($newCollectionProtocolVisistToSave['Collection'], function ($var) {
                        return (! ($var == '' || is_null($var)));
                    });
                    $newCollectionProtocolVisistToSave['CollectionProtocolVisit']['default_values'] = json_encode(array(
                        'Collection' => $collectionData
                    ));
                    $newCollectionProtocolVisistToSave = array(
                        'CollectionProtocolVisit' => $newCollectionProtocolVisistToSave['CollectionProtocolVisit']
                    );
                    // Save protocol visit
                    $this->CollectionProtocolVisit->id = null;
                    $this->CollectionProtocolVisit->data = array(); // *** To guaranty no merge will be done with previous data ***
                    if (! $this->CollectionProtocolVisit->save($newCollectionProtocolVisistToSave, false)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                $this->atimFlash(__('your data has been saved'), '/Tools/CollectionProtocol/detail/' . $collectionProtocolId);
            } else {
                
                $this->request->data = null;
            }
        }
    }

    /**
     * Display a Collection Protocol
     *
     * @param $collectionProtocolId Id of the collection protocol
     */
    public function detail($collectionProtocolId)
    {
        $collectionProtocolDataCheck = $this->CollectionProtocol->getTools('edition', $collectionProtocolId);
        if (! $collectionProtocolDataCheck['CollectionProtocol']['allow_properties_edition']) {
            AppController::addWarningMsg(__('you do not own that protocol'));
        }
        
        // MANAGE DATA
        $collectionProtocolData = $this->CollectionProtocol->getOrRedirect($collectionProtocolId);
        
        $this->set('collectionProtocolData', $collectionProtocolData);
        $collectionProtocolVisitData = $this->CollectionProtocolVisit->find('all', array(
            'conditions' => array(
                'CollectionProtocolVisit.collection_protocol_id' => $collectionProtocolId
            )
        ));
        foreach ($collectionProtocolVisitData as &$newVisitData) {
            $newVisitData['CollectionProtocolVisit']['default_values'] = $this->CollectionProtocolVisit->formatDefaultValuesForDisplay($this->Structures->get('form', 'linked_collections'), json_decode($newVisitData['CollectionProtocolVisit']['default_values'], true));
        }
        $this->set('collectionProtocolVisitData', $collectionProtocolVisitData);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenu', $this->Menus->get('/Tools/Template/listProtocolsAndTemplates'));
        
        $this->Structures->set('collection_protocol', 'collection_protocol_structure');
        $this->Structures->set('collection_protocol_visit', 'collection_protocol_visit_structure');
        $this->Structures->set('empty', 'emptyStructure');
        
        $this->set('atimMenuVariables', array(
            'CollectionProtocol.id' => $collectionProtocolId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     * Modify a Collection Protocol
     *
     * @param $collectionProtocolId Id of the collection protocol
     */
    public function edit($collectionProtocolId)
    {
        
        // MANAGE DATA
        $collectionProtocolData = $this->CollectionProtocol->getOrRedirect($collectionProtocolId);
        
        $collectionProtocolDataCheck = $this->CollectionProtocol->getTools('edition', $collectionProtocolId);
        if (! $collectionProtocolDataCheck['CollectionProtocol']['allow_properties_edition']) {
            $this->atimFlashWarning(__('data can not be changed'), '/Tools/CollectionProtocol/detail/' . $collectionProtocolId);
        }
        $this->set('collectionProtocolData', $collectionProtocolData);
        $initialCollectionProtocolData = $collectionProtocolData;
        
        $collectionProtocolVisitData = $this->CollectionProtocolVisit->find('all', array(
            'conditions' => array(
                'CollectionProtocolVisit.collection_protocol_id' => $collectionProtocolId
            )
        ));
        $activeTemplateIds = $this->Template->getTemplatesList('use');
        $activeTemplateIds = array_keys($activeTemplateIds);
        $activeTemplateAll = $this->Template->getTemplatesList('all');
        $displayTemplateWarning = false;
        foreach ($collectionProtocolVisitData as &$tmpProtocolVisitData) {
            if (strlen($tmpProtocolVisitData['CollectionProtocolVisit']['default_values'])) {
                $tmpProtocolVisitData = array_merge(json_decode($tmpProtocolVisitData['CollectionProtocolVisit']['default_values'], true), $tmpProtocolVisitData);
            }
            if ($tmpProtocolVisitData['CollectionProtocolVisit']['template_id'] && ! in_array($tmpProtocolVisitData['CollectionProtocolVisit']['template_id'], $activeTemplateIds)) {
                $displayTemplateWarning = true;
                $tmpProtocolVisitData['CollectionProtocolVisit']['template_id'] = __('unusable template') . ' : ' . $activeTemplateAll[$tmpProtocolVisitData['CollectionProtocolVisit']['template_id']];
            }
        }
        if ($displayTemplateWarning) {
            AppController::addWarningMsg(__('unusable_collection_protocol_template'));
        }
        $this->set('collectionProtocolVisitData', $collectionProtocolVisitData);
        $initialCollectionProtocolVisitData = $collectionProtocolVisitData;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('atimMenu', $this->Menus->get('/Tools/Template/listProtocolsAndTemplates'));
        
        $this->Structures->set('collection_protocol', 'collection_protocol_structure');
        $this->set('collectionProtocolVisitStructure', $this->CollectionProtocolVisit->getCollectionProtocolVisitStructures());
        $this->Structures->set('empty', 'emptyStructure');
        
        $this->set('atimMenuVariables', array(
            'CollectionProtocol.id' => $collectionProtocolId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = null;
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            // reset array
            $collectionProtocolData = array(
                'CollectionProtocol' => $this->request->data['CollectionProtocol']
            );
            unset($this->request->data['CollectionProtocol']);
            $collectionProtocolVisitData = array_values($this->request->data); // compact the array as some key might be missing
            $this->request->data = null;
            
            $this->set('collectionProtocolData', $collectionProtocolData);
            $this->set('collectionProtocolVisitData', $collectionProtocolVisitData);
            
            // LAUNCH SPECIAL VALIDATION PROCESS
            
            $submittedDataValidates = true;
            
            // Validate collection protocol
            $this->CollectionProtocol->set($collectionProtocolData);
            $submittedDataValidates = ($this->CollectionProtocol->validates()) ? $submittedDataValidates : false;
            $collectionProtocolData = $this->CollectionProtocol->data;
            
            // Validate collection protocol visit
            
            $allCollectionProtocolVisitErrors = array();
            $nbrOfFirstVisit = 0;
            foreach ($collectionProtocolVisitData as $key => &$submittedCollectionProtocolVisistToValidate) {
                if (! preg_match('/^[0-9]+$/', $submittedCollectionProtocolVisistToValidate['CollectionProtocolVisit']['template_id'], $matches)) {
                    unset($submittedCollectionProtocolVisistToValidate['CollectionProtocolVisit']['template_id']);
                }
                if ($submittedCollectionProtocolVisistToValidate['CollectionProtocolVisit']['id']) {
                    $tmp = $this->CollectionProtocolVisit->getOrRedirect($submittedCollectionProtocolVisistToValidate['CollectionProtocolVisit']['id']);
                    if (! $tmp || $tmp['CollectionProtocolVisit']['collection_protocol_id'] != $collectionProtocolId) {
                        // hack attempt or deleted prior to save
                        unset($collectionProtocolVisitData[$key]);
                    }
                } else {
                    $submittedCollectionProtocolVisistToValidate['CollectionProtocolVisit']['collection_protocol_id'] = $collectionProtocolId;
                }
                if ($submittedCollectionProtocolVisistToValidate['CollectionProtocolVisit']['first_visit']) {
                    $nbrOfFirstVisit ++;
                }
                $this->CollectionProtocolVisit->data = array();
                $this->CollectionProtocolVisit->set($submittedCollectionProtocolVisistToValidate);
                $submittedDataValidates = $this->CollectionProtocolVisit->validates() && $submittedDataValidates;
                $submittedCollectionProtocolVisistToValidate = $this->CollectionProtocolVisit->data;
                $allCollectionProtocolVisitErrors = array_merge($allCollectionProtocolVisitErrors, $this->CollectionProtocolVisit->validationErrors);
            }
            if (! $nbrOfFirstVisit || $nbrOfFirstVisit > 1) {
                $allCollectionProtocolVisitErrors['first_visit'][] = 'one visit and only one should be flagged as first one';
                $submittedDataValidates = false;
            }
            if (! empty($allCollectionProtocolVisitErrors)) {
                $this->CollectionProtocolVisit->validationErrors = array();
                foreach ($allCollectionProtocolVisitErrors as $field => $msgs) {
                    $msgs = is_array($msgs) ? $msgs : array(
                        $msgs
                    );
                    foreach ($msgs as $errorMessage)
                        $this->CollectionProtocolVisit->validationErrors[$field][] = $errorMessage;
                }
            }
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // LAUNCH SAVE PROCESS
            if ($submittedDataValidates) {
                
                // Set additional protocol data and save
                
                $this->CollectionProtocol->setOwner($collectionProtocolData);
                
                if (! $initialCollectionProtocolData['CollectionProtocol']['flag_active'] && $collectionProtocolData['CollectionProtocol']['flag_active']) {
                    $collectionProtocolData['CollectionProtocol']['last_activation_date'] = date('Y-m-d');
                    $this->CollectionProtocol->addWritableField(array(
                        'last_activation_date'
                    ));
                }
                $this->CollectionProtocol->id = $collectionProtocolId;
                if (! $this->CollectionProtocol->save($collectionProtocolData, false)) {
                    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                // Build visit array with id = key
                $initialCollectionProtocolVisitIds = array();
                foreach ($initialCollectionProtocolVisitData as $initialCollectionProtocolVisit) {
                    $collectionProtocolVisitId = $initialCollectionProtocolVisit['CollectionProtocolVisit']['id'];
                    $initialCollectionProtocolVisitIds[$collectionProtocolVisitId] = $collectionProtocolVisitId;
                }
                
                // Launch process to update/create/delete visit
                $this->CollectionProtocolVisit->writableFieldsMode = 'editgrid';
                $this->CollectionProtocolVisit->addWritableField(array(
                    'collection_protocol_id',
                    'default_values'
                ));
                foreach ($collectionProtocolVisitData as $submittedCollectionProtocolVisistToUpdate) {
                    
                    if ($submittedCollectionProtocolVisistToUpdate['CollectionProtocolVisit']['first_visit']) {
                        $submittedCollectionProtocolVisistToUpdate['CollectionProtocolVisit']['time_from_first_visit'] = '0';
                        $submittedCollectionProtocolVisistToUpdate['CollectionProtocolVisit']['time_from_first_visit_unit'] = 'day';
                    }
                    foreach ($submittedCollectionProtocolVisistToUpdate['Collection'] as &$newCollectionField) {
                        if (is_array($newCollectionField)) {
                            $tmpNewCollectionField = $newCollectionField;
                            $tmpNewCollectionField = array_filter($tmpNewCollectionField, function ($var) {
                                return (! ($var == '' || is_null($var)));
                            });
                            $newCollectionField = empty($tmpNewCollectionField) ? '' : $newCollectionField;
                        }
                    }
                    $collectionData = array_filter($submittedCollectionProtocolVisistToUpdate['Collection'], function ($var) {
                        return (! ($var == '' || is_null($var)));
                    });
                    $submittedCollectionProtocolVisistToUpdate['CollectionProtocolVisit']['default_values'] = json_encode(array(
                        'Collection' => $collectionData
                    ));
                    $submittedCollectionProtocolVisistToUpdate = array(
                        'CollectionProtocolVisit' => $submittedCollectionProtocolVisistToUpdate['CollectionProtocolVisit']
                    );
                    
                    if (isset($initialCollectionProtocolVisitIds[$submittedCollectionProtocolVisistToUpdate['CollectionProtocolVisit']['id']])) {
                        
                        // ---------------------------------------------------------------------------
                        // 1- Existing visit to update
                        // ---------------------------------------------------------------------------
                        
                        $collectionProtocolVisitId = $submittedCollectionProtocolVisistToUpdate['CollectionProtocolVisit']['id'];
                        unset($submittedCollectionProtocolVisistToUpdate['CollectionProtocolVisit']['id']);
                        unset($initialCollectionProtocolVisitIds[$collectionProtocolVisitId]);
                        
                        $this->CollectionProtocolVisit->data = array();
                        $this->CollectionProtocolVisit->id = $collectionProtocolVisitId;
                        if (! $this->CollectionProtocolVisit->save($submittedCollectionProtocolVisistToUpdate, false)) {
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    } else {
                        
                        // ---------------------------------------------------------------------------
                        // 2- New visit to create
                        // ---------------------------------------------------------------------------
                        $this->CollectionProtocolVisit->data = array();
                        $this->CollectionProtocolVisit->id = null;
                        unset($submittedCollectionProtocolVisistToUpdate['CollectionProtocolVisit']['id']);
                        if (! $this->CollectionProtocolVisit->save($submittedCollectionProtocolVisistToUpdate, false)) {
                            $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    }
                }
                
                // ---------------------------------------------------------------------------
                // 3- Old visit to delete
                // ---------------------------------------------------------------------------
                
                foreach ($initialCollectionProtocolVisitIds as $initialCollectionProtocolVisitIdToDelete) {
                    $collectionProtocolVisitIdToDelete = $initialCollectionProtocolVisitIdToDelete;
                    $this->CollectionProtocolVisit->delete($collectionProtocolVisitIdToDelete);
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                $this->atimFlash(__('your data has been saved'), '/Tools/CollectionProtocol/detail/' . $collectionProtocolId);
            }
        }
    }

    /**
     * Delete a Collection Protocol
     *
     * @param $collectionProtocolId Id of the collection protocol
     */
    public function delete($collectionProtocolId)
    {
        // MANAGE DATA
        $collectionProtocolData = $this->CollectionProtocol->getOrRedirect($collectionProtocolId);
        
        $collectionProtocolDataCheck = $this->CollectionProtocol->getTools('edition', $collectionProtocolId);
        if (! $collectionProtocolDataCheck['CollectionProtocol']['allow_properties_edition']) {
            $this->atimFlashWarning(__('data can not be changed'), '/Tools/CollectionProtocol/detail/' . $collectionProtocolId);
        }
        
        $visitsToDelete = $this->CollectionProtocolVisit->find('list', array(
            'fields' => array(
                'CollectionProtocolVisit.id'
            ),
            'conditions' => array(
                'CollectionProtocolVisit.collection_protocol_id' => $collectionProtocolId
            )
        ));
        $visitsToDelete = array_reverse($visitsToDelete);
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->CollectionProtocol->allowDeletion($collectionProtocolId);
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            
            foreach ($visitsToDelete as $visitToDelete) {
                $this->CollectionProtocolVisit->delete($visitToDelete);
            }
            $this->CollectionProtocol->delete($collectionProtocolId);
            
            $hookLink = $this->hook('postsave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            $this->atimFlash(__('your data has been deleted'), '/Tools/Template/listProtocolsAndTemplates/');
        } else {
            
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Tools/CollectionProtocol/detail/' . $collectionProtocolId);
        }
    }
}