<?php

/**
 * Class QualityCtrlsController
 */
class QualityCtrlsController extends InventoryManagementAppController
{

    public $components = array();

    public $uses = array(
        'InventoryManagement.Collection',
        'InventoryManagement.SampleMaster',
        'InventoryManagement.AliquotMaster',
        'InventoryManagement.QualityCtrl'
    );

    public $paginate = array(
        'QualityCtrl' => array(
            'order' => 'QualityCtrl.date ASC'
        )
    );

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     */
    public function listAll($collectionId, $sampleMasterId)
    {
        // MANAGE DATA
        $sampleData = $this->SampleMaster->find('first', array(
            'conditions' => array(
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.id' => $sampleMasterId
            ),
            'recursive' => 0
        ));
        if (empty($sampleData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->request->data = $this->paginate($this->QualityCtrl, array(
            'QualityCtrl.sample_master_id' => $sampleMasterId
        ));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $sampleIdParameter = ($sampleData['SampleControl']['sample_category'] == 'specimen') ? '%%SampleMaster.initial_specimen_sample_id%%' : '%%SampleMaster.id%%';
        $this->set('atimMenu', $this->Menus->get('/InventoryManagement/QualityCtrls/listAll/%%Collection.id%%/' . $sampleIdParameter));
        
        $this->set('atimMenuVariables', array(
            'Collection.id' => $sampleData['SampleMaster']['collection_id'],
            'SampleMaster.id' => $sampleMasterId,
            'SampleMaster.initial_specimen_sample_id' => $sampleData['SampleMaster']['initial_specimen_sample_id']
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     */
    public function addInit($collectionId, $sampleMasterId)
    {
        $this->setBatchMenu(array(
            'SampleMaster' => $sampleMasterId
        ));
        $this->set('aliquotDataNoVol', $this->AliquotMaster->find('all', array(
            'conditions' => array(
                'AliquotMaster.sample_master_id' => $sampleMasterId,
                AliquotMaster::$volumeCondition
            )
        )));
        $this->set('aliquotDataVol', $this->AliquotMaster->find('all', array(
            'conditions' => array(
                'AliquotMaster.sample_master_id' => $sampleMasterId,
                'NOT' => AliquotMaster::$volumeCondition
            )
        )));
        $this->Structures->set('aliquot_masters,aliquotmasters_volume', 'aliquot_structure_vol');
        $this->Structures->set('aliquot_masters', 'aliquot_structure_no_vol');
        $this->Structures->set('empty', 'emptyStructure');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param null $sampleMasterId
     */
    public function add($sampleMasterId = null)
    {
        $this->Structures->set('view_sample_joined_to_collection', "samples_structure");
        $this->Structures->set('used_aliq_in_stock_details', "aliquots_structure");
        $this->Structures->set('used_aliq_in_stock_details,used_aliq_in_stock_detail_volume', 'aliquots_volume_structure');
        $this->Structures->set('qualityctrls', 'qc_structure');
        $this->Structures->set('qualityctrls,qualityctrls_volume', 'qc_volume_structure');
        $this->set('sampleMasterIdParameter', $sampleMasterId);
        
        $menuData = null;
        $this->setUrlToCancel();
        $cancelButton = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        $usedAliquotDataToApplyToAll = array();
        if (isset($this->request->data['FunctionManagement'])) {
            $usedAliquotDataToApplyToAll['FunctionManagement'] = $this->request->data['FunctionManagement'];
            $usedAliquotDataToApplyToAll['AliquotMaster'] = $this->request->data['AliquotMaster'];
            unset($this->request->data['FunctionManagement']);
            unset($this->request->data['AliquotMaster']);
        }
        
        if ($sampleMasterId != null) {
            // User click on add QC from collection
            $menuData = $this->SampleMaster->find('first', array(
                'conditions' => array(
                    'SampleMaster.id' => $sampleMasterId
                )
            ));
            $menuData = $menuData['SampleMaster'];
            $cancelButton = '/InventoryManagement/QualityCtrls/listAll/' . $menuData['collection_id'] . '/' . $sampleMasterId;
        } elseif (array_key_exists('ViewAliquot', $this->request->data)) {
            if (isset($this->request->data['node']) && $this->request->data['ViewAliquot']['aliquot_master_id'] == 'all') {
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $this->request->data['ViewAliquot']['aliquot_master_id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
            $aliquotSampleIds = $this->AliquotMaster->find('all', array(
                'conditions' => array(
                    'AliquotMaster.id' => $this->request->data['ViewAliquot']['aliquot_master_id']
                ),
                'fields' => array(
                    'AliquotMaster.sample_master_id'
                ),
                'recursive' => - 1
            ));
            $menuData = array();
            foreach ($aliquotSampleIds as $aliquotSampleId) {
                $menuData[] = $aliquotSampleId['AliquotMaster']['sample_master_id'];
            }
        } elseif (array_key_exists('ViewSample', $this->request->data)) {
            if (isset($this->request->data['node']) && $this->request->data['ViewSample']['sample_master_id'] == 'all') {
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $this->request->data['ViewSample']['sample_master_id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
            $menuData = $this->request->data['ViewSample']['sample_master_id'];
        } elseif (! empty($this->request->data)) {
            // submitted data
            $tmpData = current($this->request->data);
            $model = array_key_exists('AliquotMaster', $tmpData) ? 'AliquotMaster' : 'SampleMaster';
            $menuData = array_keys($this->request->data);
            if ($model == 'AliquotMaster') {
                $aliquotSampleIds = $this->AliquotMaster->find('all', array(
                    'conditions' => array(
                        'AliquotMaster.id' => $menuData
                    ),
                    'fields' => array(
                        'AliquotMaster.sample_master_id'
                    ),
                    'recursive' => - 1
                ));
                $menuData = array();
                foreach ($aliquotSampleIds as $aliquotSampleId) {
                    $menuData[] = $aliquotSampleId['AliquotMaster']['sample_master_id'];
                }
            }
        } else {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $cancelButton);
            return;
        }
        $this->setBatchMenu(array(
            'SampleMaster' => $menuData
        ));
        $this->set('cancelButton', $cancelButton);
        
        $joins = array(
            array(
                'table' => 'view_samples',
                'alias' => 'ViewSample',
                'type' => 'INNER',
                'conditions' => array(
                    'AliquotMaster.sample_master_id = ViewSample.sample_master_id'
                )
            )
        );
        
        $displayBatchProcessAliqStorageAndInStockDetails = false;
        if (isset($this->request->data['ViewAliquot']) || isset($this->request->data['ViewSample'])) {
            if (empty($this->request->data['ViewAliquot']['aliquot_master_id']) && $sampleMasterId != null) {
                $this->request->data['ViewSample']['sample_master_id'] = array(
                    $sampleMasterId
                );
                unset($this->request->data['ViewAliquot']);
            }
            // initial access
            $data = null;
            if (isset($this->request->data['ViewAliquot'])) {
                if (! is_array($this->request->data['ViewAliquot']['aliquot_master_id'])) {
                    $this->request->data['ViewAliquot']['aliquot_master_id'] = array(
                        $this->request->data['ViewAliquot']['aliquot_master_id']
                    );
                }
                $aliquotIds = array_filter($this->request->data['ViewAliquot']['aliquot_master_id']);
                $this->AliquotMaster->unbindModel(array(
                    'belongsTo' => array(
                        'SampleMaster'
                    )
                ));
                $data = $this->AliquotMaster->find('all', array(
                    'fields' => array(
                        '*'
                    ),
                    'conditions' => array(
                        'AliquotMaster.id' => $aliquotIds
                    ),
                    'recursive' => 0,
                    'joins' => $joins
                ));
                $this->AliquotMaster->sortForDisplay($data, $aliquotIds);
                
                $displayBatchProcessAliqStorageAndInStockDetails = sizeof($data) > 1;
            } else {
                if (! is_array($this->request->data['ViewSample']['sample_master_id'])) {
                    $this->request->data['ViewSample']['sample_master_id'] = array(
                        $this->request->data['ViewSample']['sample_master_id']
                    );
                }
                $sampleIds = array_filter($this->request->data['ViewSample']['sample_master_id']);
                $viewSampleModel = AppModel::getInstance("InventoryManagement", "ViewSample", true);
                $data = $viewSampleModel->find('all', array(
                    'conditions' => array(
                        'ViewSample.sample_master_id' => $sampleIds
                    ),
                    'recursive' => - 1
                ));
                $viewSampleModel->sortForDisplay($data, $sampleIds);
            }
            
            $displayLimit = Configure::read('QualityCtrlsCreation_processed_items_limit');
            if (sizeof($data) > $displayLimit) {
                $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", $cancelButton);
                return;
            }
            
            $this->request->data = array();
            foreach ($data as $dataUnit) {
                $this->request->data[] = array(
                    'parent' => $dataUnit,
                    'children' => array()
                );
            }
            
            $hookLink = $this->hook('format');
            if ($hookLink) {
                require ($hookLink);
            }
        } elseif (! empty($this->request->data)) {
            // Parse First Section To Apply To All
            list ($usedAliquotDataToApplyToAll, $errorsOnFirstSectionToApplyToAll) = $this->AliquotMaster->getAliquotDataStorageAndStockToApplyToAll($usedAliquotDataToApplyToAll);
            
            // post
            $displayData = array();
            $sampleData = null;
            $aliquotData = null;
            $removeFromStorage = null;
            $recordCounter = 0;
            $errors = $errorsOnFirstSectionToApplyToAll;
            $aliquotDataToSave = array();
            $qcDataToSave = array();
            
            foreach ($this->request->data as $key => $dataUnit) {
                $recordCounter ++;
                
                // validate
                $studiedSampleMasterId = null;
                $sampleData = $dataUnit['ViewSample'];
                unset($dataUnit['ViewSample']);
                
                $aliquotMasterId = null;
                if (isset($dataUnit['AliquotMaster'])) {
                    if ($usedAliquotDataToApplyToAll)
                        $dataUnit = array_replace_recursive($dataUnit, $usedAliquotDataToApplyToAll);
                    
                    $studiedSampleMasterId = $dataUnit['AliquotMaster']['sample_master_id'];
                    
                    $aliquotMaster = $this->AliquotMaster->getOrRedirect($key);
                    if ($aliquotMaster['AliquotMaster']['sample_master_id'] != $studiedSampleMasterId) {
                        // HACK attempt
                        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    $aliquotMasterId = $key;
                    
                    $aliquotData = array();
                    $aliquotData['AliquotMaster'] = $dataUnit['AliquotMaster'];
                    $aliquotData['AliquotMaster']['id'] = $aliquotMasterId;
                    
                    $aliquotData['AliquotControl'] = $dataUnit['AliquotControl'];
                    $aliquotData['StorageMaster'] = $dataUnit['StorageMaster'];
                    $aliquotData['FunctionManagement'] = $dataUnit['FunctionManagement'];
                    
                    unset($dataUnit['AliquotControl']);
                    unset($dataUnit['StorageMaster']);
                    unset($dataUnit['FunctionManagement']);
                    
                    $this->AliquotMaster->data = null;
                    unset($aliquotData['AliquotMaster']['storage_coord_x']);
                    unset($aliquotData['AliquotMaster']['storage_coord_y']);
                    $this->AliquotMaster->set($aliquotData);
                    if (! $this->AliquotMaster->validates()) {
                        foreach ($this->AliquotMaster->validationErrors as $field => $msgs) {
                            $msgs = is_array($msgs) ? $msgs : array(
                                $msgs
                            );
                            foreach ($msgs as $msg)
                                $errors[$field][$msg][] = $recordCounter;
                        }
                    }
                    $aliquotData = $this->AliquotMaster->data;
                    
                    $aliquotData['AliquotMaster']['storage_coord_x'] = $dataUnit['AliquotMaster']['storage_coord_x'];
                    $aliquotData['AliquotMaster']['storage_coord_y'] = $dataUnit['AliquotMaster']['storage_coord_y'];
                    
                    unset($dataUnit['AliquotMaster']);
                    
                    $displayData[] = array(
                        'parent' => array_merge($aliquotData, array(
                            'ViewSample' => $sampleData
                        )),
                        'children' => $dataUnit
                    );
                    
                    if ($aliquotData['FunctionManagement']['remove_from_storage'] || ($aliquotData['AliquotMaster']['in_stock'] == 'no')) {
                        $aliquotData['AliquotMaster']['storage_master_id'] = null;
                        $aliquotData['AliquotMaster']['storage_coord_x'] = null;
                        $aliquotData['AliquotMaster']['storage_coord_y'] = null;
                        $this->AliquotMaster->addWritableField(array(
                            'storage_coord_x',
                            'storage_coord_y',
                            'storage_master_id'
                        ));
                    }
                    
                    $aliquotDataToSave[] = $aliquotData['AliquotMaster'];
                } else {
                    $studiedSampleMasterId = $key;
                    $sampleData['sample_master_id'] = $key;
                    $displayData[] = array(
                        'parent' => array(
                            'ViewSample' => $sampleData
                        ),
                        'children' => $dataUnit
                    );
                }
                
                if (empty($dataUnit)) {
                    $errors['']['at least one quality control has to be created for each item'][] = $recordCounter;
                } else {
                    foreach ($dataUnit as $qualityControl) {
                        $this->QualityCtrl->data = null;
                        $this->QualityCtrl->set($qualityControl);
                        if (! $this->QualityCtrl->validates()) {
                            foreach ($this->QualityCtrl->validationErrors as $field => $msgs) {
                                $msgs = is_array($msgs) ? $msgs : array(
                                    $msgs
                                );
                                foreach ($msgs as $msg)
                                    $errors[$field][$msg][] = $recordCounter;
                            }
                        }
                        $qualityControl = $this->QualityCtrl->data;
                        $qualityControl['QualityCtrl']['aliquot_master_id'] = $aliquotMasterId;
                        $qualityControl['QualityCtrl']['sample_master_id'] = $studiedSampleMasterId;
                        $qcDataToSave[] = $qualityControl;
                    }
                }
            }
            
            $isBatchProcess = ($recordCounter > 1) ? true : false;
            
            $displayBatchProcessAliqStorageAndInStockDetails = sizeof($aliquotDataToSave) > 1;
            if ($usedAliquotDataToApplyToAll) {
                AppController::addWarningMsg(__('fields values of the first section have been applied to all other sections'));
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            // save
            if (empty($errors) && ! empty($qcDataToSave)) {
                
                AppModel::acquireBatchViewsUpdateLock();
                
                $this->QualityCtrl->addWritableField(array(
                    'sample_master_id',
                    'aliquot_master_id'
                ));
                $this->QualityCtrl->writableFieldsMode = 'addgrid';
                $this->QualityCtrl->saveAll($qcDataToSave, array(
                    'validate' => false
                ));
                $lastQcId = $this->QualityCtrl->getLastInsertId();
                
                $this->QualityCtrl->generateQcCode();
                
                if (! empty($aliquotDataToSave)) {
                    $this->AliquotMaster->pkeySafeguard = false;
                    $this->AliquotMaster->saveAll($aliquotDataToSave, array(
                        'validate' => false
                    ));
                    $this->AliquotMaster->pkeySafeguard = true;
                    foreach ($aliquotDataToSave as $aliquotData) {
                        $this->AliquotMaster->updateAliquotVolume($aliquotData['id']);
                    }
                }
                
                $target = null;
                if ($sampleMasterId != null) {
                    $target = $cancelButton;
                } else {
                    // different samples, show the result into a tmp batchset
                    $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                    $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                    $batchSetData = array(
                        'BatchSet' => array(
                            'datamart_structure_id' => $datamartStructure->getIdByModelName('QualityCtrl'),
                            'flag_tmp' => true
                        )
                    );
                    $batchSetModel->saveWithIds($batchSetData, range($lastQcId - count($qcDataToSave) + 1, $lastQcId));
                    $target = '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId();
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                $this->atimFlash(__('your data has been saved'), $target);
                return;
            } else {
                $this->AliquotMaster->validationErrors = array();
                $this->QualityCtrl->validationErrors = array();
                if (! empty($errors)) {
                    foreach ($errors as $field => $msgAndLines) {
                        foreach ($msgAndLines as $msg => $lines) {
                            $msg = __($msg);
                            $linesStrg = implode(",", array_unique($lines));
                            if (! empty($linesStrg) && $isBatchProcess) {
                                $msg .= ' - ' . str_replace('%s', $linesStrg, __('see # %s'));
                            }
                            $this->QualityCtrl->validationErrors[$field][] = $msg;
                        }
                    }
                }
                
                $this->request->data = $displayData;
            }
        } else {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), "javascript:history.back();");
            return;
        }
        
        $this->set('displayBatchProcessAliqStorageAndInStockDetails', $displayBatchProcessAliqStorageAndInStockDetails);
        $this->Structures->set('batch_process_aliq_storage_and_in_stock_details', 'batch_process_aliq_storage_and_in_stock_details');
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     * @param $qualityCtrlId
     * @param bool $isFromTreeView
     */
    public function detail($collectionId, $sampleMasterId, $qualityCtrlId, $isFromTreeView = false)
    {
        if ((! $collectionId) || (! $sampleMasterId) || (! $qualityCtrlId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        
        // Get Quality Control Data
        $this->SampleMaster; // lazy load
        $qualityCtrlData = $this->QualityCtrl->find('first', array(
            'fields' => array(
                '*'
            ),
            'conditions' => array(
                'QualityCtrl.id' => $qualityCtrlId,
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.id' => $sampleMasterId
            ),
            'joins' => array(
                AliquotMaster::joinOnAliquotDup('QualityCtrl.aliquot_master_id'),
                AliquotMaster::$joinAliquotControlOnDup,
                SampleMaster::joinOnSampleDup('QualityCtrl.sample_master_id'),
                SampleMaster::$joinSampleControlOnDup
            )
        ));
        if (empty($qualityCtrlData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $structureToLoad = 'qualityctrls';
        if (! empty($qualityCtrlData['AliquotControl']['volume_unit'])) {
            $structureToLoad .= ",qualityctrls_volume_for_detail";
        }
        $this->Structures->set($structureToLoad);
        
        // Set aliquot data
        $this->set('qualityCtrlData', $qualityCtrlData);
        $this->request->data = array();
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $sampleIdParameter = ($qualityCtrlData['SampleControl']['sample_category'] == 'specimen') ? '%%SampleMaster.initial_specimen_sample_id%%' : '%%SampleMaster.id%%';
        $this->set('atimMenu', $this->Menus->get('/InventoryManagement/QualityCtrls/detail/%%Collection.id%%/' . $sampleIdParameter . '/%%QualityCtrl.id%%'));
        
        $this->set('atimMenuVariables', array(
            'Collection.id' => $qualityCtrlData['SampleMaster']['collection_id'],
            'SampleMaster.id' => $qualityCtrlData['QualityCtrl']['sample_master_id'],
            'SampleMaster.initial_specimen_sample_id' => $qualityCtrlData['SampleMaster']['initial_specimen_sample_id'],
            'QualityCtrl.id' => $qualityCtrlId
        ));
        
        $this->set('isFromTreeView', $isFromTreeView);
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     * @param $qualityCtrlId
     */
    public function edit($collectionId, $sampleMasterId, $qualityCtrlId)
    {
        if ((! $collectionId) || (! $sampleMasterId) || (! $qualityCtrlId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE DATA
        $this->SampleMaster; // lazy load
        $qcData = $this->QualityCtrl->find('first', array(
            'fields' => array(
                '*'
            ),
            'conditions' => array(
                'QualityCtrl.id' => $qualityCtrlId,
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.id' => $sampleMasterId
            ),
            'joins' => array(
                SampleMaster::joinOnSampleDup('QualityCtrl.sample_master_id'),
                SampleMaster::$joinSampleControlOnDup
            )
        ));
        
        if (empty($qcData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $sampleIdParameter = ($qcData['SampleControl']['sample_category'] == 'specimen') ? '%%SampleMaster.initial_specimen_sample_id%%' : '%%SampleMaster.id%%';
        $this->set('atimMenu', $this->Menus->get('/InventoryManagement/QualityCtrls/detail/%%Collection.id%%/' . $sampleIdParameter . '/%%QualityCtrl.id%%'));
        
        $this->set('atimMenuVariables', array(
            'Collection.id' => $qcData['SampleMaster']['collection_id'],
            'SampleMaster.id' => $qcData['QualityCtrl']['sample_master_id'],
            'SampleMaster.initial_specimen_sample_id' => $qcData['SampleMaster']['initial_specimen_sample_id'],
            'QualityCtrl.id' => $qualityCtrlId
        ));
        
        $this->Structures->set('aliquot_masters,aliquotmasters_volume', 'aliquot_structure');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // MANAGE DATA RECORD
        
        if (empty($this->request->data)) {
            $this->request->data = $qcData;
        } else {
            // Launch save process
            
            // Launch validation
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            $updateNewAliquotId = null;
            $updateOldAliquotId = null;
            if (is_numeric($this->request->data['QualityCtrl']['aliquot_master_id'])) {
                $updateNewAliquotId = $this->request->data['QualityCtrl']['aliquot_master_id'];
                $aliquotData = $this->AliquotMaster->findById($this->request->data['QualityCtrl']['aliquot_master_id']);
                if ((empty($aliquotData) || empty($aliquotData['AliquotControl']['volume_unit'])) && ! empty($this->request->data['QualityCtrl']['used_volume'])) {
                    $this->request->data['QualityCtrl']['used_volume'] = null;
                    AppController::addWarningMsg(__('this aliquot has no recorded volume') . ". " . __('the inputed volume was automatically removed') . ".");
                }
            } else {
                $this->request->data['QualityCtrl']['aliquot_master_id'] = null;
            }
            
            if (! empty($qcData['QualityCtrl']['aliquot_master_id']) && $qcData['QualityCtrl']['aliquot_master_id'] != $this->request->data['QualityCtrl']['aliquot_master_id']) {
                // the aliquot changed, update the old one afterwards
                $updateOldAliquotId = $qcData['QualityCtrl']['aliquot_master_id'];
            }
            
            if (! array_key_exists('used_volume', $this->request->data['QualityCtrl'])) {
                $this->request->data['QualityCtrl']['used_volume'] = null;
            }
            
            // Save data
            $this->QualityCtrl->id = $qualityCtrlId;
            $this->QualityCtrl->addWritableField(array(
                'aliquot_master_id'
            ));
            if ($submittedDataValidates && $this->QualityCtrl->save($this->request->data)) {
                if ($updateNewAliquotId != null) {
                    $this->AliquotMaster->updateAliquotVolume($updateNewAliquotId);
                }
                if ($updateOldAliquotId != null) {
                    $this->AliquotMaster->updateAliquotVolume($updateOldAliquotId);
                }
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been saved'), '/InventoryManagement/QualityCtrls/detail/' . $collectionId . '/' . $sampleMasterId . '/' . $qualityCtrlId . '/');
            }
        }
        
        $this->set('aliquotDataNoVol', $this->AliquotMaster->find('all', array(
            'conditions' => array(
                'AliquotMaster.sample_master_id' => $sampleMasterId,
                AliquotMaster::$volumeCondition
            )
        )));
        $this->set('aliquotDataVol', $this->AliquotMaster->find('all', array(
            'conditions' => array(
                'AliquotMaster.sample_master_id' => $sampleMasterId,
                'NOT' => AliquotMaster::$volumeCondition
            )
        )));
    }

    /**
     *
     * @param $collectionId
     * @param $sampleMasterId
     * @param $qualityCtrlId
     */
    public function delete($collectionId, $sampleMasterId, $qualityCtrlId)
    {
        if ((! $collectionId) || (! $sampleMasterId) || (! $qualityCtrlId)) {
            $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $qcData = $this->QualityCtrl->find('first', array(
            'conditions' => array(
                'QualityCtrl.id' => $qualityCtrlId,
                'SampleMaster.collection_id' => $collectionId,
                'SampleMaster.id' => $sampleMasterId
            )
        ));
        if (empty($qcData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->QualityCtrl->allowDeletion($qualityCtrlId);
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            if ($this->QualityCtrl->atimDelete($qualityCtrlId)) {
                if ($qcData['QualityCtrl']['aliquot_master_id'] != null) {
                    $this->AliquotMaster->updateAliquotVolume($qcData['QualityCtrl']['aliquot_master_id']);
                }
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/InventoryManagement/QualityCtrls/listAll/' . $qcData['SampleMaster']['collection_id'] . '/' . $qcData['QualityCtrl']['sample_master_id'] . '/');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/InventoryManagement/QualityCtrls/listAll/' . $collectionId . '/' . $sampleMasterId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/InventoryManagement/QualityCtrls/detail/' . $collectionId . '/' . $sampleMasterId . '/' . $qualityCtrlId);
        }
    }
}