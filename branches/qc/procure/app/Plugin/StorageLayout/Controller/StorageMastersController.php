<?php

/**
 * Class StorageMastersController
 */
class StorageMastersController extends StorageLayoutAppController
{

    public $components = array();

    public $uses = array(
        'StorageLayout.StorageMaster',
        'StorageLayout.ViewStorageMaster',
        'StorageLayout.StorageTreeView',
        'StorageLayout.StorageControl',
        'StorageLayout.StorageCoordinate',
        'StorageLayout.TmaBlock',
        'StorageLayout.TmaSlide',
        'StorageLayout.StorageCoordinate',
        
        'InventoryManagement.AliquotMaster'
    );

    public $paginate = array(
        'StorageMaster' => array(
            'order' => 'StorageMaster.selection_label ASC'
        ),
        'ViewStorageMaster' => array(
            'order' => 'ViewStorageMaster.selection_label ASC'
        )
    );

    /**
     *
     * @param int $searchId
     * @param bool $fromLayoutPage
     */
    public function search($searchId = 0, $fromLayoutPage = false)
    {
        $modelToUse = $this->ViewStorageMaster;
        $structureAlias = 'view_storage_masters';
        $structureIndex = '/StorageLayout/StorageMasters/search';
        if ($fromLayoutPage) {
            $topRowStorageId = $this->request->data['current_storage_id'];
            unset($this->request->data['current_storage_id']);
            
            $hookLink = $this->hook('pre_search_handler');
            if ($hookLink) {
                require ($hookLink);
            }
            
            $this->searchHandler($searchId, $modelToUse, $structureAlias, $structureIndex, false, 21);
            if (count($this->request->data) > 20) {
                $this->request->data = array();
                $this->Structures->set('empty', 'emptyStructure');
                $this->set('overflow', true);
            } else {
                $warn = false;
                foreach ($this->request->data as $key => $data) {
                    if ($data['StorageControl']['coord_x_type'] == null) {
                        unset($this->request->data[$key]);
                        $warn = true;
                    } elseif ($data['StorageControl']['coord_x_type'] == 'list' && ! $this->StorageCoordinate->find('count', array(
                        'conditions' => array(
                            'StorageCoordinate.storage_master_id' => $data['StorageMaster']['id']
                        ),
                        'recursive' => - 1
                    ))) {
                        unset($this->request->data[$key]);
                        $warn = true;
                    } elseif ($data['StorageMaster']['id'] == $topRowStorageId) {
                        unset($this->request->data[$key]);
                        AppController::addInfoMsg(__('the storage you are already working on has been removed from the results'));
                    }
                }
                if ($warn) {
                    AppController::addInfoMsg(__('storages without layout have been removed from the results'));
                }
            }
        } else {
            
            $hookLink = $this->hook('pre_search_handler_2');
            if ($hookLink) {
                require ($hookLink);
            }
            
            $this->searchHandler($searchId, $modelToUse, $structureAlias, $structureIndex);
        }
        $this->set('fromLayoutPage', $fromLayoutPage);
        $this->Structures->set($structureAlias);
        
        // Get data for the add to selected button
        $this->set('addLinks', $this->StorageControl->getAddStorageStructureLinks());
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($searchId)) {
            if ($this->request->is('ajax')) {
                $this->set('isAjax', true);
            }
            // index
            $this->render('index');
        }
    }

    /**
     *
     * @param $storageMasterId
     * @param int $isFromTreeViewOrLayout
     * @param null $storageCategory
     */
    public function detail($storageMasterId, $isFromTreeViewOrLayout = 0, $storageCategory = null)
    {
        // $isFromTreeViewOrLayout : 0-Normal, 1-Tree view, 2-Stoarge layout
        
        // Note: The $storageCategory variable is not really used.
        // Just added to parameters list to be consistent with use_link set into menu table
        // for TMA.
        
        // MANAGE DATA
        
        // Get the storage data
        $data = $this->StorageMaster->getOrRedirect($storageMasterId);
        
        $data['StorageMaster']['layout_description'] = $this->StorageControl->getStorageLayoutDescription(array(
            'StorageControl' => $data['StorageControl']
        ));
        
        // Get parent storage information
        $parentStorageId = $data['StorageMaster']['parent_id'];
        $parentStorageData = $this->StorageMaster->find('first', array(
            'conditions' => array(
                'StorageMaster.id' => $parentStorageId
            )
        ));
        if (! empty($parentStorageId) && empty($parentStorageData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('parentStorageId', $parentStorageId);
        $data['Generated']['path'] = $this->StorageMaster->getStoragePath($parentStorageId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object. Needed to disable menu options based on storage type
        
        $atimMenu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
        $displayLayout = true;
        if (! $this->StorageControl->allowCustomCoordinates($data['StorageControl']['id'], array(
            'StorageControl' => $data['StorageControl']
        ))) {
            // Check storage supports custom coordinates and disable access to coordinates menu option if required
            $atimMenu = $this->inactivateStorageCoordinateMenu($atimMenu);
        } else {
            if (! $this->StorageCoordinate->find('count', array(
                'conditions' => array(
                    'StorageCoordinate.storage_master_id' => $storageMasterId
                ),
                'recursive' => - 1
            ))) {
                if (! $isFromTreeViewOrLayout)
                    AppController::addWarningMsg(__('no layout exists - add coordinates first'));
                $displayLayout = false;
            }
        }
        if (empty($data['StorageControl']['coord_x_type'])) {
            // Check storage supports coordinates and disable access to storage layout menu option if required
            $atimMenu = $this->inactivateStorageLayoutMenu($atimMenu);
            $displayLayout = false;
        }
        if (! $isFromTreeViewOrLayout && $displayLayout) {
            if (empty($data['StorageControl']['coord_y_type'])) {
                if ($this->StorageMaster->find('count', array(
                    'conditions' => array(
                        'StorageMaster.parent_id' => $storageMasterId,
                        'OR' => array(
                            'StorageMaster.parent_storage_coord_x' => '',
                            'StorageMaster.parent_storage_coord_x IS NULL'
                        )
                    )
                )) || $this->AliquotMaster->find('count', array(
                    'conditions' => array(
                        'AliquotMaster.storage_master_id' => $storageMasterId,
                        'OR' => array(
                            'AliquotMaster.storage_coord_x' => '',
                            'AliquotMaster.storage_coord_x IS NULL'
                        )
                    )
                )) || $this->TmaSlide->find('count', array(
                    'conditions' => array(
                        'TmaSlide.storage_master_id' => $storageMasterId,
                        'OR' => array(
                            'TmaSlide.storage_coord_x' => '',
                            'TmaSlide.storage_coord_x IS NULL'
                        )
                    )
                ))) {
                    AppController::addWarningMsg(__('at least one stored element is not displayed in layout'));
                }
            } else {
                if ($this->StorageMaster->find('count', array(
                    'conditions' => array(
                        'StorageMaster.parent_id' => $storageMasterId,
                        'OR' => array(
                            'StorageMaster.parent_storage_coord_x' => '',
                            'StorageMaster.parent_storage_coord_x IS NULL',
                            'StorageMaster.parent_storage_coord_y' => '',
                            'StorageMaster.parent_storage_coord_y IS NULL'
                        )
                    )
                )) || $this->AliquotMaster->find('count', array(
                    'conditions' => array(
                        'AliquotMaster.storage_master_id' => $storageMasterId,
                        'OR' => array(
                            'AliquotMaster.storage_coord_x' => '',
                            'AliquotMaster.storage_coord_x IS NULL',
                            'AliquotMaster.storage_coord_y' => '',
                            'AliquotMaster.storage_coord_y IS NULL'
                        )
                    )
                )) || $this->TmaSlide->find('count', array(
                    'conditions' => array(
                        'TmaSlide.storage_master_id' => $storageMasterId,
                        'OR' => array(
                            'TmaSlide.storage_coord_x' => '',
                            'TmaSlide.storage_coord_x IS NULL',
                            'TmaSlide.storage_coord_y' => '',
                            'TmaSlide.storage_coord_y IS NULL'
                        )
                    )
                ))) {
                    AppController::addWarningMsg(__('at least one stored element is not displayed in layout'));
                }
            }
        }
        $this->set('displayLayout', $displayLayout);
        
        $this->set('atimMenu', $atimMenu);
        $this->set('atimMenuVariables', array(
            'StorageMaster.id' => $storageMasterId
        ));
        
        // Set structure
        $this->Structures->set($data['StorageControl']['form_alias']);
        
        // Set boolean
        $this->set('isTma', $data['StorageControl']['is_tma_block'] ? true : false);
        
        // Define if this detail form is displayed into the children storage tree view, storage layout, etc
        $this->set('isFromTreeViewOrLayout', $isFromTreeViewOrLayout);
        
        // Get data for the add to selected button
        $this->set('addLinks', $this->StorageControl->getAddStorageStructureLinks($storageMasterId));
        
        $this->request->data = $data;
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $storageControlId
     * @param null $predefinedParentStorageId
     */
    public function add($storageControlId, $predefinedParentStorageId = null)
    {
        // MANAGE DATA
        $storageControlData = $this->StorageControl->getOrRedirect($storageControlId);
        if (! $storageControlData['StorageControl']['flag_active'])
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $this->set('storageControlId', $storageControlData['StorageControl']['id']);
        $this->set('layoutDescription', $this->StorageControl->getStorageLayoutDescription($storageControlData));
        
        $urlToCancel = '/StorageLayout/StorageMasters/search/';
        if (isset($this->request->data['url_to_cancel']))
            $urlToCancel = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        // Set predefined parent storage
        if (! is_null($predefinedParentStorageId)) {
            $predefinedParentStorageData = $this->StorageMaster->find('first', array(
                'conditions' => array(
                    'StorageMaster.id' => $predefinedParentStorageId,
                    'StorageControl.is_tma_block' => '0'
                )
            ));
            if (empty($predefinedParentStorageData)) {
                $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            $this->set('predefinedParentStorageSelectionLabel', $this->StorageMaster->getStorageLabelAndCodeForDisplay($predefinedParentStorageData));
            $urlToCancel = '/StorageLayout/StorageMasters/detail/' . $predefinedParentStorageId;
        }
        
        $this->set('urlToCancel', $urlToCancel);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Set menu
        $atimMenu = $this->Menus->get('/StorageLayout/StorageMasters/search/');
        $this->set('atimMenu', $atimMenu);
        $this->set('atimMenuVariables', array(
            'StorageControl.id' => $storageControlId
        ));
        
        // set structure alias based on VALUE from CONTROL table
        $this->Structures->set($storageControlData['StorageControl']['form_alias'] . ($storageControlData['StorageControl']['set_temperature'] ? ',storage_temperature' : ''));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! empty($this->request->data)) {
            
            // Set control ID en type
            $this->request->data['StorageMaster']['storage_control_id'] = $storageControlData['StorageControl']['id'];
            
            // Validates and set additional data
            $submittedDataValidates = true;
            
            $this->StorageMaster->set($this->request->data);
            if (! $this->StorageMaster->validates()) {
                $submittedDataValidates = false;
            }
            
            // Reste data to get position data
            $this->request->data = $this->StorageMaster->data;
            
            if ($submittedDataValidates) {
                // Set selection label
                $this->request->data['StorageMaster']['selection_label'] = $this->StorageMaster->getSelectionLabel($this->request->data);
                
                // Set storage temperature information
                $this->StorageMaster->manageTemperature($this->request->data, $storageControlData);
            }
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                // Save storage data
                $boolSaveDone = true;
                
                $storageMasterId = null;
                $this->StorageMaster->addWritableField(array(
                    'storage_control_id',
                    'parent_id',
                    'selection_label',
                    'temperature',
                    'temp_unit'
                ));
                
                if ($this->StorageMaster->save($this->request->data, false)) {
                    $storageMasterId = $this->StorageMaster->getLastInsertId();
                } else {
                    $boolSaveDone = false;
                }
                
                // Create storage code
                if ($boolSaveDone) {
                    $this->StorageMaster->tryCatchQuery("UPDATE storage_masters SET storage_masters.code = storage_masters.id WHERE storage_masters.id = $storageMasterId;");
                    $this->StorageMaster->tryCatchQuery("UPDATE storage_masters_revs SET storage_masters_revs.code = storage_masters_revs.id WHERE storage_masters_revs.id = $storageMasterId;");
                    $viewStorageMasterModel = AppModel::getInstance('StorageLayout', 'ViewStorageMaster');
                    $viewStorageMasterModel->manageViewUpdate('view_storage_masters', 'StorageMaster.id', array(
                        $storageMasterId
                    ), $viewStorageMasterModel::$tableQuery);
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                if ($boolSaveDone) {
                    $this->atimFlash(__('your data has been saved'), '/StorageLayout/StorageMasters/detail/' . $storageMasterId);
                }
            }
        }
    }

    /**
     *
     * @param $storageMasterId
     */
    public function edit($storageMasterId)
    {
        // MANAGE DATA
        // Get the storage data
        $storageData = $this->StorageMaster->getOrRedirect($storageMasterId);
        $storageData['StorageMaster']['layout_description'] = $this->StorageControl->getStorageLayoutDescription(array(
            'StorageControl' => $storageData['StorageControl']
        ));
        
        // Set predefined parent storage
        if (! empty($storageData['StorageMaster']['parent_id'])) {
            $predefinedParentStorageData = $this->StorageMaster->find('first', array(
                'conditions' => array(
                    'StorageMaster.id' => $storageData['StorageMaster']['parent_id'],
                    'StorageControl.is_tma_block' => '0'
                )
            ));
            if (empty($predefinedParentStorageData)) {
                $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            $this->set('predefinedParentStorageSelectionLabel', $this->StorageMaster->getStorageLabelAndCodeForDisplay($predefinedParentStorageData));
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object. Needed to disable menu options based on storage type
        $atimMenu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
        
        if (! $this->StorageControl->allowCustomCoordinates($storageData['StorageControl']['id'], array(
            'StorageControl' => $storageData['StorageControl']
        ))) {
            // Check storage supports custom coordinates and disable access to coordinates menu option if required
            $atimMenu = $this->inactivateStorageCoordinateMenu($atimMenu);
        }
        
        if (empty($storageData['StorageControl']['coord_x_type'])) {
            // Check storage supports coordinates and disable access to storage layout menu option if required
            $atimMenu = $this->inactivateStorageLayoutMenu($atimMenu);
        }
        
        $this->set('atimMenu', $atimMenu);
        $this->set('atimMenuVariables', array(
            'StorageMaster.id' => $storageMasterId
        ));
        
        // Set structure
        $this->Structures->set($storageData['StorageControl']['form_alias'] . ($storageData['StorageControl']['set_temperature'] ? ',storage_temperature' : ''));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $storageData;
        } else {
            // Validates and set additional data
            $submittedDataValidates = true;
            
            $this->request->data['StorageMaster']['id'] = $storageMasterId;
            $this->StorageMaster->data = array();
            $this->StorageMaster->set($this->request->data);
            if (! $this->StorageMaster->validates()) {
                $submittedDataValidates = false;
            }
            
            // Reste data to get position data
            $this->request->data = $this->StorageMaster->data;
            
            if ($submittedDataValidates) {
                // Set selection label
                $this->request->data['StorageMaster']['selection_label'] = $this->StorageMaster->getSelectionLabel($this->request->data);
                
                // Set storage temperature information
                $this->StorageMaster->manageTemperature($this->request->data, array(
                    'StorageControl' => $storageData['StorageControl']
                ));
            }
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->StorageMaster->addWritableField(array(
                    'storage_control_id',
                    'parent_id',
                    'selection_label',
                    'temperature',
                    'temp_unit'
                ));
                
                AppModel::acquireBatchViewsUpdateLock();
                
                // Save storage data
                $this->StorageMaster->id = $storageMasterId;
                if ($this->StorageMaster->save($this->request->data, false)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    
                    // Manage children temperature
                    $storageTemperature = (array_key_exists('temperature', $this->request->data['StorageMaster'])) ? $this->request->data['StorageMaster']['temperature'] : $storageData['StorageMaster']['temperature'];
                    $storageTempUnit = (array_key_exists('temp_unit', $this->request->data['StorageMaster'])) ? $this->request->data['StorageMaster']['temp_unit'] : $storageData['StorageMaster']['temp_unit'];
                    $this->StorageMaster->updateChildrenSurroundingTemperature($storageMasterId, $storageTemperature, $storageTempUnit);
                    
                    // Manage children selection label
                    if (strcmp($this->request->data['StorageMaster']['selection_label'], $storageData['StorageMaster']['selection_label']) != 0) {
                        $this->StorageMaster->updateChildrenStorageSelectionLabel($storageMasterId, $this->request->data);
                    }
                    
                    AppModel::releaseBatchViewsUpdateLock();
                    
                    $this->atimFlash(__('your data has been updated'), '/StorageLayout/StorageMasters/detail/' . $storageMasterId);
                }
            }
        }
    }

    /**
     *
     * @param $storageMasterId
     */
    public function delete($storageMasterId)
    {
        // Get the storage data
        $storageData = $this->StorageMaster->getOrRedirect($storageMasterId);
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->StorageMaster->allowDeletion($storageMasterId);
        
        // CUSTOM CODE
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            // First remove storage from tree
            $this->StorageMaster->id = $storageMasterId;
            $this->StorageMaster->data = array();
            $cleanedStorageData = array(
                'StorageMaster' => array(
                    'parent_id' => ''
                )
            );
            $this->StorageMaster->addWritableField(array(
                'parent_id'
            ));
            if (! $this->StorageMaster->save($cleanedStorageData, false)) {
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            // Create has many relation to delete the storage coordinate
            $this->StorageMaster->bindModel(array(
                'hasMany' => array(
                    'StorageCoordinate' => array(
                        'className' => 'StorageCoordinate',
                        'foreignKey' => 'storage_master_id',
                        'dependent' => true
                    )
                )
            ), false);
            
            // Delete storage
            $message = '';
            $atimFlash = null;
            if ($this->StorageMaster->atimDelete($storageMasterId, true)) {
                $atimFlash = true;
            } else {
                $atimFlash = false;
            }
            
            $hookLink = $this->hook('postsave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            $this->StorageMaster->bindModel(array(
                'hasMany' => array(
                    'StorageCoordinate'
                )
            ), false);
            if ($atimFlash) {
                $this->atimFlash(__('your data has been deleted'), '/StorageLayout/StorageMasters/search/');
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/StorageLayout/StorageMasters/search/');
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/StorageLayout/StorageMasters/detail/' . $storageMasterId);
        }
    }

    /**
     * Display into a tree view the studied storage and all its children storages (recursive call)
     * plus both aliquots and TMA slides stored into those storages starting from a specific parent storage.
     *
     * @param int|Storage $storageMasterId Storage
     *        master id of the studied storage that will be used as tree root.
     * @param bool|int $isAjax
     *
     * @author N. Luc
     * @since 2007-05-22
     *        @updated A. Suggitt
     */
    public function contentTreeView($storageMasterId = 0, $isAjax = false)
    {
        if ($isAjax) {
            $this->layout = 'ajax';
            Configure::write('debug', 0);
        }
        $this->set("isAjax", $isAjax);
        
        $storagesNbrLimit = 100;
        $aliquotsNbrLimit = 400;
        $tmaSlidesNbrLimit = 100;
        
        $fieldsToSortOn = array(
            'StorageMaster' => array(
                'StorageMaster.short_label'
            ),
            'InitialStorageMaster' => array(
                'StorageControl.storage_type',
                'StorageMaster.short_label'
            ),
            'TmaBlock' => array(
                'TmaBlock.short_label'
            ),
            'AliquotMaster' => array(
                'AliquotMaster.barcode'
            ),
            'TmaSlide' => array(
                'TmaSlide.barcode'
            )
        );
        
        $hookLink = $this->hook('pre_format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // MANAGE STORAGE DATA
        // Get the storage data
        $storageData = null;
        $atimMenu = array();
        if ($storageMasterId) {
            $storageData = $this->StorageMaster->getOrRedirect($storageMasterId);
            $treeData = $this->StorageMaster->find('all', array(
                'conditions' => array(
                    'StorageMaster.parent_id' => $storageMasterId,
                    'StorageControl.is_tma_block' => '0'
                ),
                'recursive' => 0
            ));
            $treeData = $this->StorageMaster->contentNatCaseSort($fieldsToSortOn['StorageMaster'], $treeData);
            if (sizeof($treeData) > $storagesNbrLimit)
                $treeData = array(
                    array(
                        'Generated' => array(
                            'storage_tree_view_item_summary' => __('storage contains too many children storages for display') . ' (' . sizeof($treeData) . ')'
                        )
                    )
                );
                // Aliquot
            $aliquots = $this->AliquotMaster->find('all', array(
                'conditions' => array(
                    'AliquotMaster.storage_master_id' => $storageMasterId
                ),
                'recursive' => 0
            ));
            $aliquots = $this->StorageMaster->contentNatCaseSort($fieldsToSortOn['AliquotMaster'], $aliquots);
            if (sizeof($aliquots) > $aliquotsNbrLimit)
                $aliquots = array(
                    array(
                        'Generated' => array(
                            'storage_tree_view_item_summary' => __('storage contains too many aliquots for display') . ' (' . sizeof($aliquots) . ')'
                        )
                    )
                );
            $treeData = array_merge($treeData, $aliquots);
            // TMA blocks
            $tmaBlocks = $this->TmaBlock->find('all', array(
                'conditions' => array(
                    'TmaBlock.parent_id' => $storageMasterId
                ),
                'recursive' => 0
            ));
            $tmaBlocks = $this->StorageMaster->contentNatCaseSort($fieldsToSortOn['TmaBlock'], $tmaBlocks);
            if (sizeof($tmaBlocks) > $storagesNbrLimit)
                $tmaBlocks = array(
                    array(
                        'Generated' => array(
                            'storage_tree_view_item_summary' => __('storage contains too many tma blocks for display') . ' (' . sizeof($tmaBlocks) . ')'
                        )
                    )
                );
            $treeData = array_merge($treeData, $tmaBlocks);
            // TMA slide
            $tmaSlides = $this->TmaSlide->find('all', array(
                'conditions' => array(
                    'TmaSlide.storage_master_id' => $storageMasterId
                ),
                'recursive' => 0
            ));
            $tmaSlides = $this->StorageMaster->contentNatCaseSort($fieldsToSortOn['TmaSlide'], $tmaSlides);
            if (sizeof($tmaSlides) > $tmaSlidesNbrLimit)
                $tmaSlides = array(
                    array(
                        'Generated' => array(
                            'storage_tree_view_item_summary' => __('storage contains too many tma slides for display') . ' (' . sizeof($tmaSlides) . ')'
                        )
                    )
                );
            $treeData = array_merge($treeData, $tmaSlides);
            $atimMenu = $this->Menus->get('/StorageLayout/StorageMasters/contentTreeView/%%StorageMaster.id%%');
            if (! $isAjax && ! $storageData['StorageControl']['is_tma_block']) {
                // Get data for the add to selected button
                $this->set('addLinks', $this->StorageControl->getAddStorageStructureLinks($storageMasterId));
            }
        } else {
            $treeData = $this->StorageMaster->find('all', array(
                'conditions' => array(
                    'StorageMaster.parent_id IS NULL',
                    'StorageControl.is_tma_block' => '0'
                ),
                'order' => 'CAST(StorageMaster.parent_storage_coord_x AS signed), CAST(StorageMaster.parent_storage_coord_y AS signed)',
                'recursive' => 0
            ));
            $treeData = $this->StorageMaster->contentNatCaseSort($fieldsToSortOn['InitialStorageMaster'], $treeData);
            if (sizeof($treeData) > $storagesNbrLimit) {
                $this->atimFlashWarning(__('there are too many main storages for display'), '/StorageLayout/StorageMasters/search/');
                return;
            }
            // TMA blocks
            $tmaBlocks = $this->TmaBlock->find('all', array(
                'conditions' => array(
                    'TmaBlock.parent_id IS NULL'
                ),
                'recursive' => 0
            ));
            $tmaBlocks = $this->StorageMaster->contentNatCaseSort($fieldsToSortOn['TmaBlock'], $tmaBlocks);
            if (sizeof($tmaBlocks) > $storagesNbrLimit)
                $tmaBlocks = array(
                    array(
                        'Generated' => array(
                            'storage_tree_view_item_summary' => __('storage contains too many tma blocks for display') . ' (' . sizeof($tmaBlocks) . ')'
                        )
                    )
                );
            $treeData = array_merge($treeData, $tmaBlocks);
            $atimMenu = $this->Menus->get('/StorageLayout/StorageMasters/search');
            $this->set("search", true);
            // Get data for the add to selected button
            $this->set('addLinks', $this->StorageControl->getAddStorageStructureLinks());
        }
        $ids = array();
        
        foreach ($treeData as $dataUnit) {
            if (isset($dataUnit['StorageMaster'])) {
                $ids[] = $dataUnit['StorageMaster']['id'];
            } elseif (isset($dataUnit['TmaBlock'])) {
                $ids[] = $dataUnit['TmaBlock']['id'];
            }
        }
        $ids = array_flip($this->StorageMaster->hasChild($ids)); // array_key_exists is faster than in_array
        foreach ($treeData as &$dataUnit) {
            if (isset($dataUnit['StorageMaster']) && ! isset($dataUnit['TmaBlock']) && ! isset($dataUnit['TmaSlide']) && ! isset($dataUnit['AliquotMaster'])) {
                $dataUnit['children'] = array_key_exists($dataUnit['StorageMaster']['id'], $ids);
            } elseif (isset($dataUnit['TmaBlock']) && ! isset($dataUnit['StorageMaster']) && ! isset($dataUnit['TmaSlide']) && ! isset($dataUnit['AliquotMaster'])) {
                $dataUnit['children'] = array_key_exists($dataUnit['TmaBlock']['id'], $ids);
            }
        }
        
        $this->request->data = $treeData;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object. Needed to disable menu options based on storage type
        if (! empty($storageData)) {
            if (! $this->StorageControl->allowCustomCoordinates($storageData['StorageControl']['id'], array(
                'StorageControl' => $storageData['StorageControl']
            ))) {
                // Check storage supports custom coordinates and disable access to coordinates menu option if required
                $atimMenu = $this->inactivateStorageCoordinateMenu($atimMenu);
            }
            
            if (empty($storageData['StorageControl']['coord_x_type'])) {
                // Check storage supports coordinates and disable access to storage layout menu option if required
                $atimMenu = $this->inactivateStorageLayoutMenu($atimMenu);
            }
        }
        
        $this->set('atimMenu', $atimMenu);
        $this->set('atimMenuVariables', array(
            'StorageMaster.id' => $storageMasterId
        ));
        
        // Set structure
        $atimStructure = array();
        $atimStructure['StorageMaster'] = $this->Structures->get('form', 'storage_masters_for_storage_tree_view');
        $atimStructure['AliquotMaster'] = $this->Structures->get('form', 'aliquot_masters_for_storage_tree_view');
        $atimStructure['TmaBlock'] = $this->Structures->get('form', 'tma_blocks_for_storage_tree_view');
        $atimStructure['TmaSlide'] = $this->Structures->get('form', 'tma_slides_for_storage_tree_view');
        $atimStructure['Generated'] = $this->Structures->get('form', 'message_for_storage_tree_view');
        $this->set('atimStructure', $atimStructure);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     * Display the content of a storage into a layout.
     *
     * @param $storageMasterId Id of the studied storage.
     * @param bool $isAjax : Tells
     *        wheter the request has to be treated as ajax
     *        query (required to counter issues in Chrome 15 back/forward button on the
     *        page and Opera 11.51 first ajax query that is not recognized as such)
     *       
     * @param bool $csvCreation
     * @author N. Luc
     * @since 2007-05-22
     */
    public function storageLayout($storageMasterId, $isAjax = false, $csvCreation = false)
    {
        if (! AppController::checkLinkPermission('/InventoryManagement/AliquotMasters/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), 'javascript:history.back()');
        }
        
        // MANAGE STORAGE DATA
        
        // Get the storage data
        $storageData = $this->StorageMaster->getOrRedirect($storageMasterId);
        
        $parentCoordinateList = array();
        if ($storageData['StorageControl']['coord_x_type'] == "list") {
            $coordinateTmp = $this->StorageCoordinate->find('all', array(
                'conditions' => array(
                    'StorageCoordinate.storage_master_id' => $storageMasterId
                ),
                'recursive' => - 1,
                'order' => 'StorageCoordinate.order ASC'
            ));
            foreach ($coordinateTmp as $key => $value) {
                $parentCoordinateList[$value['StorageCoordinate']['id']]['StorageCoordinate'] = $value['StorageCoordinate'];
            }
            if (empty($parentCoordinateList)) {
                if ($isAjax) {
                    echo json_encode(array(
                        'valid' => 0
                    ));
                    exit();
                } else {
                    $this->atimFlashWarning(__('no layout exists - add coordinates first'), '/StorageLayout/StorageMasters/detail/' . $storageMasterId);
                    return;
                }
            }
        }
        
        // Storage layout not allowed for this type of storage
        if (empty($storageData['StorageControl']['coord_x_type'])) {
            if ($isAjax) {
                echo json_encode(array(
                    'valid' => 0
                ));
                exit();
            } else {
                $this->atimFlashWarning(__('no storage layout is defined for this storage type'), '/StorageLayout/StorageMasters/detail/' . $storageMasterId);
                return;
            }
        }
        
        if (! empty($this->request->data)) {
            if ($csvCreation) {
                if (isset($this->request->data['Config']))
                    $this->configureCsv($this->request->data['Config']);
            } else {
                
                $data = array();
                $unclassified = array();
                
                $json = (json_decode($this->request->data));
                $secondStorageId = null;
                foreach ($json as $element) {
                    if ((int) $element->s && $element->s != $storageMasterId) {
                        if ($secondStorageId == null) {
                            $secondStorageId = $element->s;
                        } elseif ($secondStorageId != $element->s) {
                            // more than 2 storages
                            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    }
                }
                
                $storageData = array(
                    $storageData
                );
                if ($secondStorageId) {
                    $storageData[] = $this->StorageMaster->getOrRedirect($secondStorageId);
                }
                $storageData = AppController::defineArrayKey($storageData, 'StorageMaster', 'id', true);
                
                $childrenCoordinateList = array();
                if (isset($storageData[$secondStorageId]) && $storageData[$secondStorageId]['StorageControl']['coord_x_type'] == "list") {
                    $coordinateTmp = $this->StorageCoordinate->find('all', array(
                        'conditions' => array(
                            'StorageCoordinate.storage_master_id' => $secondStorageId
                        ),
                        'recursive' => - 1,
                        'order' => 'StorageCoordinate.order ASC'
                    ));
                    foreach ($coordinateTmp as $key => $value) {
                        $childrenCoordinateList[$value['StorageCoordinate']['id']]['StorageCoordinate'] = $value['StorageCoordinate'];
                    }
                    if (empty($childrenCoordinateList)) {
                        // The 'Pick a storage to drag and drop to' action should limit selection to storage with layout
                        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
                
                // have cells with id as key
                for ($i = sizeof($json) - 1; $i >= 0; -- $i) {
                    // builds a $cell[type][id] array
                    $data[$json[$i]->{'type'}][$json[$i]->{'id'}] = (array) $json[$i];
                }
                
                $allCoordinateList = $parentCoordinateList + $childrenCoordinateList;
                foreach ($storageData as $storageId => $storageDataUnit) {
                    if ($storageDataUnit['StorageControl']['coord_x_type'] == "list") {
                        foreach ($data as &$dataModel) {
                            foreach ($dataModel as &$value) {
                                if (is_numeric($value['x']) && $value['s'] == $storageId) {
                                    $value['x'] = $allCoordinateList[$value['x']]['StorageCoordinate']['coordinate_value'];
                                }
                            }
                        }
                    }
                }
                
                $storagesInitialData = isset($data['StorageMaster']) ? $this->StorageMaster->find('all', array(
                    'conditions' => array(
                        'StorageMaster.id' => array_keys($data['StorageMaster'])
                    )
                )) : array();
                $aliquotsInitialData = isset($data['AliquotMaster']) ? $this->AliquotMaster->find('all', array(
                    'conditions' => array(
                        'AliquotMaster.id' => array_keys($data['AliquotMaster'])
                    )
                )) : array();
                $tmasInitialData = isset($data['TmaSlide']) ? $this->TmaSlide->find('all', array(
                    'conditions' => array(
                        'TmaSlide.id' => array_keys($data['TmaSlide'])
                    )
                )) : array();
                
                // manual validate/alteration of positions based on position conflict checks
                $storageConfig = array();
                $errorsOrWarningsFound = $this->StorageMaster->checkBatchLayoutConflicts($data, 'StorageMaster', 'selection_label', $storageConfig);
                $errorsOrWarningsFound = $this->StorageMaster->checkBatchLayoutConflicts($data, 'AliquotMaster', 'barcode', $storageConfig) || $errorsOrWarningsFound;
                $errorsOrWarningsFound = $this->StorageMaster->checkBatchLayoutConflicts($data, 'TmaSlide', 'barcode', $storageConfig) || $errorsOrWarningsFound;
                
                AppModel::acquireBatchViewsUpdateLock();
                
                $updatedRecordCounter = 0;
                
                // update StorageMaster
                $this->StorageMaster->checkWritableFields = false;
                $errorsOrWarningsFound = $this->StorageMaster->updateAndSaveDataArray($storagesInitialData, "StorageMaster", "parent_storage_coord_x", "parent_storage_coord_y", "parent_id", $data, $this->StorageMaster, $storageData, $updatedRecordCounter) || $errorsOrWarningsFound;
                
                // Update AliquotMaster
                $this->AliquotMaster->checkWritableFields = false;
                $errorsOrWarningsFound = $this->StorageMaster->updateAndSaveDataArray($aliquotsInitialData, "AliquotMaster", "storage_coord_x", "storage_coord_y", "storage_master_id", $data, $this->AliquotMaster, $storageData, $updatedRecordCounter) || $errorsOrWarningsFound;
                
                // Update TmaSlide
                $this->TmaSlide->checkWritableFields = false;
                $errorsOrWarningsFound = $this->StorageMaster->updateAndSaveDataArray($tmasInitialData, "TmaSlide", "storage_coord_x", "storage_coord_y", "storage_master_id", $data, $this->TmaSlide, $storageData, $updatedRecordCounter) || $errorsOrWarningsFound;
                
                AppModel::releaseBatchViewsUpdateLock();
                
                $summaryMessage = $updatedRecordCounter ? __("the storage data of %s element(s) have been updated", $updatedRecordCounter) : __("no storage data has been updated");
                if ($errorsOrWarningsFound) {
                    AppController::addWarningMsg(__($summaryMessage));
                    $storageData = $storageData[$storageMasterId];
                } else {
                    $this->atimFlash(__($summaryMessage), '/StorageLayout/StorageMasters/storageLayout/' . $storageMasterId);
                    return;
                }
            }
        }
        $this->request->data = array();
        
        $fieldsToSortOn = array(
            'StorageMaster' => array(
                'StorageMaster.short_label'
            ),
            'AliquotMaster' => array(
                'AliquotMaster.barcode'
            ),
            'TmaSlide' => array(
                'TmaSlide.barcode'
            )
        );
        
        $hookLink = $this->hook('pre_format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $storageMasterC = $this->StorageMaster->find('all', array(
            'conditions' => array(
                'StorageMaster.parent_id' => $storageMasterId
            )
        ));
        $storageMasterC = $this->StorageMaster->contentNatCaseSort($fieldsToSortOn['StorageMaster'], $storageMasterC, true);
        $aliquotMasterC = $this->AliquotMaster->find('all', array(
            'conditions' => array(
                'AliquotMaster.storage_master_id' => $storageMasterId
            ),
            'recursive' => - 1
        ));
        $aliquotMasterC = $this->StorageMaster->contentNatCaseSort($fieldsToSortOn['AliquotMaster'], $aliquotMasterC, true);
        $tmaSlideC = $this->TmaSlide->find('all', array(
            'conditions' => array(
                'TmaSlide.storage_master_id' => $storageMasterId
            ),
            'recursive' => - 1
        ));
        $tmaSlideC = $this->StorageMaster->contentNatCaseSort($fieldsToSortOn['TmaSlide'], $tmaSlideC, true);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object. Needed to disable menu options based on storage type
        $atimMenu = $this->Menus->get('/StorageLayout/StorageMasters/storageLayout/%%StorageMaster.id%%');
        
        if (! $this->StorageControl->allowCustomCoordinates($storageData['StorageControl']['id'], array(
            'StorageControl' => $storageData['StorageControl']
        ))) {
            // Check storage supports custom coordinates and disable access to coordinates menu option if required
            $atimMenu = $this->inactivateStorageCoordinateMenu($atimMenu);
        }
        
        // Get all storage control types to build the add to selected button
        if (! $storageData['StorageControl']['is_tma_block']) {
            // Get data for the add to selected button
            $this->set('addLinks', $this->StorageControl->getAddStorageStructureLinks($storageMasterId));
        }
        
        // Add translated storage type to main storage and chidlren storage
        $storageTypesFromId = $this->StorageControl->getStorageTypePermissibleValues();
        $storageControlId = $storageData['StorageControl']['id'];
        $storageData['StorageControl']['translated_storage_type'] = isset($storageTypesFromId[$storageControlId]) ? $storageTypesFromId[$storageControlId] : $storageData['StorageControl']['storage_type'];
        foreach ($storageMasterC as &$newChildrenStorage) {
            $childrenStorageControlId = $newChildrenStorage['StorageControl']['id'];
            $newChildrenStorage['StorageControl']['translated_storage_type'] = isset($storageTypesFromId[$childrenStorageControlId]) ? $storageTypesFromId[$childrenStorageControlId] : $newChildrenStorage['StorageControl']['storage_type'];
        }
        
        $this->set('atimMenu', $atimMenu);
        $this->set('atimMenuVariables', array(
            'StorageMaster.id' => $storageMasterId
        ));
        
        // Set structure
        $this->Structures->set('storagemasters');
        
        $data['parent'] = $storageData;
        if (isset($parentCoordinateList)) {
            $data['parent']['list'] = $parentCoordinateList;
            $rkeyCoordinateList = array();
            foreach ($parentCoordinateList as $values) {
                $rkeyCoordinateList[$values['StorageCoordinate']['coordinate_value']] = $values;
            }
        } else {
            $rkeyCoordinateList = null;
        }
        $data['children'] = $storageMasterC;
        $data['children'] = array_merge($data['children'], $aliquotMasterC);
        $data['children'] = array_merge($data['children'], $tmaSlideC);
        
        foreach ($data['children'] as &$childrenArray) {
            if (isset($childrenArray['StorageMaster'])) {
                $link = $this->request->webroot . "StorageLayout/StorageMasters/detail/" . $childrenArray["StorageMaster"]['id'] . "/2";
                $this->StorageMaster->buildChildrenArray($childrenArray, "StorageMaster", "parent_storage_coord_x", "parent_storage_coord_y", "selection_label", $rkeyCoordinateList, $link, $childrenArray['StorageControl']['is_tma_block'] ? 'tma block' : 'storage');
            } elseif (isset($childrenArray['AliquotMaster'])) {
                $link = $this->request->webroot . "InventoryManagement/AliquotMasters/detail/" . $childrenArray["AliquotMaster"]["collection_id"] . "/" . $childrenArray["AliquotMaster"]["sample_master_id"] . "/" . $childrenArray["AliquotMaster"]["id"] . "/2";
                $this->StorageMaster->buildChildrenArray($childrenArray, "AliquotMaster", "storage_coord_x", "storage_coord_y", "barcode", $rkeyCoordinateList, $link, "aliquot");
            } elseif (isset($childrenArray['TmaSlide'])) {
                $link = $this->request->webroot . "StorageLayout/TmaSlides/detail/" . $childrenArray["TmaSlide"]['tma_block_storage_master_id'] . "/" . $childrenArray["TmaSlide"]['id'] . "/2";
                $this->StorageMaster->buildChildrenArray($childrenArray, "TmaSlide", "storage_coord_x", "storage_coord_y", "barcode", $rkeyCoordinateList, $link, "slide");
            }
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->set('data', $data);
        $this->Structures->set('empty', 'emptyStructure');
        
        if ($csvCreation) {
            $this->render('storage_layout_csv');
            Configure::write('debug', 0);
        } elseif ($isAjax) {
            $this->render('storage_layout_html');
        }
    }

    public function autocompleteLabel()
    {
        
        // -- NOTE ----------------------------------------------------------
        //
        // This function is linked to functions of the StorageMaster model
        // called getStorageDataFromStorageLabelAndCode() and
        // getStorageLabelAndCodeForDisplay().
        //
        // When you override the autocompleteLabel() function, check
        // if you need to override these functions.
        //
        // ------------------------------------------------------------------
        
        // layout = ajax to avoid printing layout
        $this->layout = 'ajax';
        // debug = 0 to avoid printing debug queries that would break the javascript array
        Configure::write('debug', 0);
        // query the database
        $term = trim(str_replace(array(
            "\\",
            '%',
            '_'
        ), array(
            "\\\\",
            '\%',
            '\_'
        ), $_GET['term']));
        $conditions = array(
            'StorageMaster.Selection_label LIKE' => '%' . $term . '%'
        );
        $rpos = strripos($term, "[");
        if ($rpos) {
            $term2a = substr($term, 0, $rpos - 1);
            $term2b = substr($term, $rpos + 1);
            if ($term2b[strlen($term2b) - 1] == "]") {
                $term2b = substr($term2b, - 1);
            }
            $tmpCondition = $conditions;
            $conditions = array();
            $conditions['or'][] = $tmpCondition;
            $conditions['or'][] = array(
                'StorageMaster.Selection_label LIKE' => $term2a,
                'StorageMaster.code LIKE' => $term2b . '%'
            );
        }
        
        $storageMasters = $this->StorageMaster->find('all', array(
            'conditions' => $conditions,
            'fields' => array(
                'StorageMaster.selection_label',
                'StorageMaster.code',
                'StorageControl.storage_type',
                'StorageControl.id'
            ),
            'order' => array(
                'StorageMaster.selection_label ASC, StorageMaster.code ASC'
            ),
            'recursive' => 0,
            'limit' => 10
        ));
        
        $storageTypesFromId = $this->StorageControl->getStorageTypePermissibleValues();
        
        // build javascript textual array
        $result = "";
        $count = 0;
        foreach ($storageMasters as $storageMaster) {
            $storageControlId = $storageMaster['StorageControl']['id'];
            $result .= '"' . str_replace(array(
                '\\',
                '"'
            ), array(
                '\\\\',
                '\"'
            ), $storageMaster['StorageMaster']['selection_label'] . ' [' . $storageMaster['StorageMaster']['code'] . '] / ' . (isset($storageTypesFromId[$storageControlId]) ? $storageTypesFromId[$storageControlId] : $storageMaster['StorageControl']['storage_type'])) . '", ';
            ++ $count;
            if ($count > 9) {
                break;
            }
        }
        if (sizeof($result) > 0) {
            $result = substr($result, 0, - 2);
        }
        $this->set('result', "[" . $result . "]");
    }

    /**
     *
     * @param $storageMasterId
     * @param null $model
     */
    public function contentListView($storageMasterId, $model = null)
    {
        $storageMasterData = $this->StorageMaster->getOrRedirect($storageMasterId);
        
        $atimMenu = $this->Menus->get('/StorageLayout/StorageMasters/contentListView/%%StorageMaster.id%%');
        if (! $this->StorageControl->allowCustomCoordinates($storageMasterData['StorageControl']['id'], array(
            'StorageControl' => $storageMasterData['StorageControl']
        ))) {
            // Check storage supports custom coordinates and disable access to coordinates menu option if required
            $atimMenu = $this->inactivateStorageCoordinateMenu($atimMenu);
        }
        if (empty($storageMasterData['StorageControl']['coord_x_type'])) {
            // Check storage supports coordinates and disable access to storage layout menu option if required
            $atimMenu = $this->inactivateStorageLayoutMenu($atimMenu);
        }
        $this->set('atimMenu', $atimMenu);
        $this->set('atimMenuVariables', array(
            'StorageMaster.id' => $storageMasterId
        ));
        
        if (! $model) {
            $this->Structures->set('empty', 'emptyStructure');
            if ($storageMasterData['StorageControl']['is_tma_block']) {
                $this->set('modelsToDispay', array(
                    'AliquotMaster' => 'cores'
                ));
            } else {
                $modelsToDispay = array(
                    'StorageMaster' => 'storages',
                    'AliquotMaster' => 'aliquots'
                );
                if ($this->StorageControl->find('count', array(
                    'conditions' => array(
                        'StorageControl.is_tma_block' => '1',
                        'StorageControl.flag_active' => '1'
                    )
                ))) {
                    $modelsToDispay = array_merge($modelsToDispay, array(
                        'TmaBlock' => 'tma blocks',
                        'TmaSlide' => 'tma slides'
                    ));
                }
                $this->set('modelsToDispay', $modelsToDispay);
            }
            if (! $storageMasterData['StorageControl']['is_tma_block']) {
                // Get data for the add to selected button
                $this->set('addLinks', $this->StorageControl->getAddStorageStructureLinks($storageMasterId));
            }
            $this->set('isMainForm', true);
        } else {
            switch ($model) {
                case 'StorageMaster':
                    $this->request->data = $this->paginate($this->StorageMaster, array(
                        'StorageMaster.parent_id' => $storageMasterId,
                        'StorageControl.is_tma_block' => '0'
                    ));
                    $this->Structures->set('storage_masters_for_storage_list_view');
                    $this->set('detailUrl', '/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%/');
                    $this->set('icon', 'storage');
                    break;
                case 'AliquotMaster':
                    $this->request->data = $this->paginate($this->AliquotMaster, array(
                        'AliquotMaster.storage_master_id' => $storageMasterId
                    ));
                    $this->Structures->set('aliquot_masters_for_storage_list_view');
                    $this->set('detailUrl', '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/');
                    $this->set('icon', 'aliquot');
                    break;
                case 'TmaBlock':
                    $this->request->data = $this->paginate($this->TmaBlock, array(
                        'TmaBlock.parent_id' => $storageMasterId
                    ));
                    $this->Structures->set('tma_blocks_for_storage_tree_view');
                    $this->set('detailUrl', '/StorageLayout/StorageMasters/detail/%%TmaBlock.id%%/');
                    $this->set('icon', 'tma block');
                    break;
                case 'TmaSlide':
                    $this->request->data = $this->paginate($this->TmaSlide, array(
                        'TmaSlide.storage_master_id' => $storageMasterId
                    ));
                    $this->Structures->set('tma_slides_for_storage_list_view');
                    $this->set('detailUrl', '/StorageLayout/TmaSlides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%/');
                    $this->set('icon', 'tma slide');
                    break;
                default:
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            $this->set('isMainForm', false);
        }
        
        // CUTOM CODE
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     * Get the aliquot detail and send it to view.
     *
     * @param int $storageId
     * @param string $barcode
     */
    public function getAliquotDetail($storageId, $barcode)
    {
        if (! AppController::checkLinkPermission('/InventoryManagement/AliquotMasters/add') || ! AppController::checkLinkPermission('/InventoryManagement/AliquotMasters/edit')) {
            $this->atimFlashError(__('you need privileges to access this page'), 'javascript:history.back()');
        }
        $result = $this->AliquotMaster->getAliquotByBarcode($storageId, $barcode);
        $this->set('result', $result['aliquots']);
        $this->set('isTma', $result['isTma']);
        $this->set('barcodeSearch', $barcode);
    }

    /**
     * Load a CSV file and add the barcodes into the form.
     *
     * @param int $storageId
     */
    public function getCsvFile($storageId)
    {
        if (! AppController::checkLinkPermission('/InventoryManagement/AliquotMasters/add') || ! AppController::checkLinkPermission('/InventoryManagement/AliquotMasters/edit')) {
            $this->atimFlashError(__('you need privileges to access this page'), 'javascript:history.back()');
        }
        $csvSeparator = ! empty($this->request->data['csvSeparator']) ? $this->request->data['csvSeparator'] : CSV_SEPARATOR;
        unset($this->request->data['csvSeparator']);
        $dataFile = $_FILES['media'];
        $response = $this->AliquotMaster->readCsvAndConvertToArray($dataFile, $storageId, $csvSeparator);
        $this->set("csvArrayData", $response);
        $this->Structures->set('empty', 'emptyStructure');
    }
}