<?php

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

    function search($search_id = 0, $from_layout_page = false)
    {
        $model_to_use = $this->ViewStorageMaster;
        $structure_alias = 'view_storage_masters';
        $structure_index = '/StorageLayout/StorageMasters/search';
        if ($from_layout_page) {
            $top_row_storage_id = $this->request->data['current_storage_id'];
            unset($this->request->data['current_storage_id']);
            $this->searchHandler($search_id, $model_to_use, $structure_alias, $structure_index, false, 21);
            if (count($this->request->data) > 20) {
                $this->request->data = array();
                $this->Structures->set('empty', 'empty_structure');
                $this->set('overflow', true);
            } else {
                $warn = false;
                foreach ($this->request->data as $key => $data) {
                    if ($data['StorageControl']['coord_x_type'] == null) {
                        unset($this->request->data[$key]);
                        $warn = true;
                    } else 
                        if ($data['StorageControl']['coord_x_type'] == 'list' && ! $this->StorageCoordinate->find('count', array(
                            'conditions' => array(
                                'StorageCoordinate.storage_master_id' => $data['StorageMaster']['id']
                            ),
                            'recursive' => '-1'
                        ))) {
                            unset($this->request->data[$key]);
                            $warn = true;
                        } else 
                            if ($data['StorageMaster']['id'] == $top_row_storage_id) {
                                unset($this->request->data[$key]);
                                AppController::addInfoMsg(__('the storage you are already working on has been removed from the results'));
                            }
                }
                if ($warn) {
                    AppController::addInfoMsg(__('storages without layout have been removed from the results'));
                }
            }
        } else {
            $this->searchHandler($search_id, $model_to_use, $structure_alias, $structure_index);
        }
        $this->set('from_layout_page', $from_layout_page);
        $this->Structures->set($structure_alias);
        
        // Get data for the add to selected button
        $this->set('add_links', $this->StorageControl->getAddStorageStructureLinks());
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if (empty($search_id)) {
            if ($this->request->is('ajax')) {
                $this->set('is_ajax', true);
            }
            // index
            $this->render('index');
        }
    }

    function detail($storage_master_id, $is_from_tree_view_or_layout = 0, $storage_category = null)
    {
        // $is_from_tree_view_or_layout : 0-Normal, 1-Tree view, 2-Stoarge layout
        
        // Note: The $storage_category variable is not really used.
        // Just added to parameters list to be consistent with use_link set into menu table
        // for TMA.
        
        // MANAGE DATA
        
        // Get the storage data
        $data = $this->StorageMaster->getOrRedirect($storage_master_id);
        
        $data['StorageMaster']['layout_description'] = $this->StorageControl->getStorageLayoutDescription(array(
            'StorageControl' => $data['StorageControl']
        ));
        
        // Get parent storage information
        $parent_storage_id = $data['StorageMaster']['parent_id'];
        $parent_storage_data = $this->StorageMaster->find('first', array(
            'conditions' => array(
                'StorageMaster.id' => $parent_storage_id
            )
        ));
        if (! empty($parent_storage_id) && empty($parent_storage_data)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('parent_storage_id', $parent_storage_id);
        $data['Generated']['path'] = $this->StorageMaster->getStoragePath($parent_storage_id);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object. Needed to disable menu options based on storage type
        
        $atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
        $display_layout = true;
        if (! $this->StorageControl->allowCustomCoordinates($data['StorageControl']['id'], array(
            'StorageControl' => $data['StorageControl']
        ))) {
            // Check storage supports custom coordinates and disable access to coordinates menu option if required
            $atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
        } else {
            if (! $this->StorageCoordinate->find('count', array(
                'conditions' => array(
                    'StorageCoordinate.storage_master_id' => $storage_master_id
                ),
                'recursive' => '-1'
            ))) {
                if (! $is_from_tree_view_or_layout)
                    AppController::addWarningMsg(__('no layout exists - add coordinates first'));
                $display_layout = false;
            }
        }
        if (empty($data['StorageControl']['coord_x_type'])) {
            // Check storage supports coordinates and disable access to storage layout menu option if required
            $atim_menu = $this->inactivateStorageLayoutMenu($atim_menu);
            $display_layout = false;
        }
        if (! $is_from_tree_view_or_layout && $display_layout) {
            if (empty($data['StorageControl']['coord_y_type'])) {
                if ($this->StorageMaster->find('count', array(
                    'conditions' => array(
                        'StorageMaster.parent_id' => $storage_master_id,
                        'OR' => array(
                            'StorageMaster.parent_storage_coord_x' => '',
                            'StorageMaster.parent_storage_coord_x IS NULL'
                        )
                    )
                )) || $this->AliquotMaster->find('count', array(
                    'conditions' => array(
                        'AliquotMaster.storage_master_id' => $storage_master_id,
                        'OR' => array(
                            'AliquotMaster.storage_coord_x' => '',
                            'AliquotMaster.storage_coord_x IS NULL'
                        )
                    )
                )) || $this->TmaSlide->find('count', array(
                    'conditions' => array(
                        'TmaSlide.storage_master_id' => $storage_master_id,
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
                        'StorageMaster.parent_id' => $storage_master_id,
                        'OR' => array(
                            'StorageMaster.parent_storage_coord_x' => '',
                            'StorageMaster.parent_storage_coord_x IS NULL',
                            'StorageMaster.parent_storage_coord_y' => '',
                            'StorageMaster.parent_storage_coord_y IS NULL'
                        )
                    )
                )) || $this->AliquotMaster->find('count', array(
                    'conditions' => array(
                        'AliquotMaster.storage_master_id' => $storage_master_id,
                        'OR' => array(
                            'AliquotMaster.storage_coord_x' => '',
                            'AliquotMaster.storage_coord_x IS NULL',
                            'AliquotMaster.storage_coord_y' => '',
                            'AliquotMaster.storage_coord_y IS NULL'
                        )
                    )
                )) || $this->TmaSlide->find('count', array(
                    'conditions' => array(
                        'TmaSlide.storage_master_id' => $storage_master_id,
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
        $this->set('display_layout', $display_layout);
        
        $this->set('atim_menu', $atim_menu);
        $this->set('atim_menu_variables', array(
            'StorageMaster.id' => $storage_master_id
        ));
        
        // Set structure
        $this->Structures->set($data['StorageControl']['form_alias']);
        
        // Set boolean
        $this->set('is_tma', $data['StorageControl']['is_tma_block'] ? true : false);
        
        // Define if this detail form is displayed into the children storage tree view, storage layout, etc
        $this->set('is_from_tree_view_or_layout', $is_from_tree_view_or_layout);
        
        // Get data for the add to selected button
        $this->set('add_links', $this->StorageControl->getAddStorageStructureLinks($storage_master_id));
        
        $this->request->data = $data;
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
    }

    function add($storage_control_id, $predefined_parent_storage_id = null)
    {
        // MANAGE DATA
        $storage_control_data = $this->StorageControl->getOrRedirect($storage_control_id);
        if (! $storage_control_data['StorageControl']['flag_active'])
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $this->set('storage_control_id', $storage_control_data['StorageControl']['id']);
        $this->set('layout_description', $this->StorageControl->getStorageLayoutDescription($storage_control_data));
        
        $url_to_cancel = '/StorageLayout/StorageMasters/search/';
        if (isset($this->request->data['url_to_cancel']))
            $url_to_cancel = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        // Set predefined parent storage
        if (! is_null($predefined_parent_storage_id)) {
            $predefined_parent_storage_data = $this->StorageMaster->find('first', array(
                'conditions' => array(
                    'StorageMaster.id' => $predefined_parent_storage_id,
                    'StorageControl.is_tma_block' => '0'
                )
            ));
            if (empty($predefined_parent_storage_data)) {
                $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            $this->set('predefined_parent_storage_selection_label', $this->StorageMaster->getStorageLabelAndCodeForDisplay($predefined_parent_storage_data));
            $url_to_cancel = '/StorageLayout/StorageMasters/detail/' . $predefined_parent_storage_id;
        }
        
        $this->set('url_to_cancel', $url_to_cancel);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Set menu
        $atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/search/');
        $this->set('atim_menu', $atim_menu);
        $this->set('atim_menu_variables', array(
            'StorageControl.id' => $storage_control_id
        ));
        
        // set structure alias based on VALUE from CONTROL table
        $this->Structures->set($storage_control_data['StorageControl']['form_alias'] . ($storage_control_data['StorageControl']['set_temperature'] ? ',storage_temperature' : ''));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if (! empty($this->request->data)) {
            
            // Set control ID en type
            $this->request->data['StorageMaster']['storage_control_id'] = $storage_control_data['StorageControl']['id'];
            
            // Validates and set additional data
            $submitted_data_validates = true;
            
            $this->StorageMaster->set($this->request->data);
            if (! $this->StorageMaster->validates()) {
                $submitted_data_validates = false;
            }
            
            // Reste data to get position data
            $this->request->data = $this->StorageMaster->data;
            
            if ($submitted_data_validates) {
                // Set selection label
                $this->request->data['StorageMaster']['selection_label'] = $this->StorageMaster->getSelectionLabel($this->request->data);
                
                // Set storage temperature information
                $this->StorageMaster->manageTemperature($this->request->data, $storage_control_data);
            }
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            
            $hook_link = $this->hook('presave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            if ($submitted_data_validates) {
                // Save storage data
                $bool_save_done = true;
                
                $storage_master_id = null;
                $this->StorageMaster->addWritableField(array(
                    'storage_control_id',
                    'parent_id',
                    'selection_label',
                    'temperature',
                    'temp_unit'
                ));
                
                if ($this->StorageMaster->save($this->request->data, false)) {
                    $storage_master_id = $this->StorageMaster->getLastInsertId();
                } else {
                    $bool_save_done = false;
                }
                
                // Create storage code
                if ($bool_save_done) {
                    $this->StorageMaster->tryCatchQuery("UPDATE storage_masters SET storage_masters.code = storage_masters.id WHERE storage_masters.id = $storage_master_id;");
                    $this->StorageMaster->tryCatchQuery("UPDATE storage_masters_revs SET storage_masters_revs.code = storage_masters_revs.id WHERE storage_masters_revs.id = $storage_master_id;");
                    $view_storage_master_model = AppModel::getInstance('StorageLayout', 'ViewStorageMaster');
                    $view_storage_master_model->manageViewUpdate('view_storage_masters', 'StorageMaster.id', array(
                        $storage_master_id
                    ), $view_storage_master_model::$table_query);
                }
                
                $hook_link = $this->hook('postsave_process');
                if ($hook_link) {
                    require ($hook_link);
                }
                
                if ($bool_save_done) {
                    $this->atimFlash(__('your data has been saved'), '/StorageLayout/StorageMasters/detail/' . $storage_master_id);
                }
            }
        }
    }

    function edit($storage_master_id)
    {
        // MANAGE DATA
        // Get the storage data
        $storage_data = $this->StorageMaster->getOrRedirect($storage_master_id);
        $storage_data['StorageMaster']['layout_description'] = $this->StorageControl->getStorageLayoutDescription(array(
            'StorageControl' => $storage_data['StorageControl']
        ));
        
        // Set predefined parent storage
        if (! empty($storage_data['StorageMaster']['parent_id'])) {
            $predefined_parent_storage_data = $this->StorageMaster->find('first', array(
                'conditions' => array(
                    'StorageMaster.id' => $storage_data['StorageMaster']['parent_id'],
                    'StorageControl.is_tma_block' => '0'
                )
            ));
            if (empty($predefined_parent_storage_data)) {
                $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            $this->set('predefined_parent_storage_selection_label', $this->StorageMaster->getStorageLabelAndCodeForDisplay($predefined_parent_storage_data));
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object. Needed to disable menu options based on storage type
        $atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
        
        if (! $this->StorageControl->allowCustomCoordinates($storage_data['StorageControl']['id'], array(
            'StorageControl' => $storage_data['StorageControl']
        ))) {
            // Check storage supports custom coordinates and disable access to coordinates menu option if required
            $atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
        }
        
        if (empty($storage_data['StorageControl']['coord_x_type'])) {
            // Check storage supports coordinates and disable access to storage layout menu option if required
            $atim_menu = $this->inactivateStorageLayoutMenu($atim_menu);
        }
        
        $this->set('atim_menu', $atim_menu);
        $this->set('atim_menu_variables', array(
            'StorageMaster.id' => $storage_master_id
        ));
        
        // Set structure
        $this->Structures->set($storage_data['StorageControl']['form_alias'] . ($storage_data['StorageControl']['set_temperature'] ? ',storage_temperature' : ''));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if (empty($this->request->data)) {
            $this->request->data = $storage_data;
        } else {
            // Validates and set additional data
            $submitted_data_validates = true;
            
            $this->request->data['StorageMaster']['id'] = $storage_master_id;
            $this->StorageMaster->data = array();
            $this->StorageMaster->set($this->request->data);
            if (! $this->StorageMaster->validates()) {
                $submitted_data_validates = false;
            }
            
            // Reste data to get position data
            $this->request->data = $this->StorageMaster->data;
            
            if ($submitted_data_validates) {
                // Set selection label
                $this->request->data['StorageMaster']['selection_label'] = $this->StorageMaster->getSelectionLabel($this->request->data);
                
                // Set storage temperature information
                $this->StorageMaster->manageTemperature($this->request->data, array(
                    'StorageControl' => $storage_data['StorageControl']
                ));
            }
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            
            $hook_link = $this->hook('presave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            if ($submitted_data_validates) {
                $this->StorageMaster->addWritableField(array(
                    'storage_control_id',
                    'parent_id',
                    'selection_label',
                    'temperature',
                    'temp_unit'
                ));
                
                AppModel::acquireBatchViewsUpdateLock();
                
                // Save storage data
                $this->StorageMaster->id = $storage_master_id;
                if ($this->StorageMaster->save($this->request->data, false)) {
                    $hook_link = $this->hook('postsave_process');
                    if ($hook_link) {
                        require ($hook_link);
                    }
                    
                    // Manage children temperature
                    $storage_temperature = (array_key_exists('temperature', $this->request->data['StorageMaster'])) ? $this->request->data['StorageMaster']['temperature'] : $storage_data['StorageMaster']['temperature'];
                    $storage_temp_unit = (array_key_exists('temp_unit', $this->request->data['StorageMaster'])) ? $this->request->data['StorageMaster']['temp_unit'] : $storage_data['StorageMaster']['temp_unit'];
                    $this->StorageMaster->updateChildrenSurroundingTemperature($storage_master_id, $storage_temperature, $storage_temp_unit);
                    
                    // Manage children selection label
                    if (strcmp($this->request->data['StorageMaster']['selection_label'], $storage_data['StorageMaster']['selection_label']) != 0) {
                        $this->StorageMaster->updateChildrenStorageSelectionLabel($storage_master_id, $this->request->data);
                    }
                    
                    AppModel::releaseBatchViewsUpdateLock();
                    
                    $this->atimFlash(__('your data has been updated'), '/StorageLayout/StorageMasters/detail/' . $storage_master_id);
                }
            }
        }
    }

    function delete($storage_master_id)
    {
        // Get the storage data
        $storage_data = $this->StorageMaster->getOrRedirect($storage_master_id);
        
        // Check deletion is allowed
        $arr_allow_deletion = $this->StorageMaster->allowDeletion($storage_master_id);
        
        // CUSTOM CODE
        
        $hook_link = $this->hook('delete');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if ($arr_allow_deletion['allow_deletion']) {
            // First remove storage from tree
            $this->StorageMaster->id = $storage_master_id;
            $this->StorageMaster->data = array();
            $cleaned_storage_data = array(
                'StorageMaster' => array(
                    'parent_id' => ''
                )
            );
            $this->StorageMaster->addWritableField(array(
                'parent_id'
            ));
            if (! $this->StorageMaster->save($cleaned_storage_data, false)) {
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
            $atim_flash = null;
            if ($this->StorageMaster->atimDelete($storage_master_id, true)) {
                $atim_flash = true;
            } else {
                $atim_flash = false;
            }
            
            $hook_link = $this->hook('postsave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            $this->StorageMaster->bindModel(array(
                'hasMany' => array(
                    'StorageCoordinate'
                )
            ), false);
            if ($atim_flash) {
                $this->atimFlash(__('your data has been deleted'), '/StorageLayout/StorageMasters/search/');
            } else {
                $this->flash(__('error deleting data - contact administrator'), '/StorageLayout/StorageMasters/search/');
            }
        } else {
            $this->flash(__($arr_allow_deletion['msg']), '/StorageLayout/StorageMasters/detail/' . $storage_master_id);
        }
    }

    /**
     * Display into a tree view the studied storage and all its children storages (recursive call)
     * plus both aliquots and TMA slides stored into those storages starting from a specific parent storage.
     *
     * @param $storage_master_id Storage
     *            master id of the studied storage that will be used as tree root.
     * @param int $is_ajax            
     *
     * @author N. Luc
     * @since 2007-05-22
     *        @updated A. Suggitt
     */
    function contentTreeView($storage_master_id = 0, $is_ajax = false)
    {
        if ($is_ajax) {
            $this->layout = 'ajax';
            Configure::write('debug', 0);
        }
        $this->set("is_ajax", $is_ajax);
        
        $storages_nbr_limit = 100;
        $aliquots_nbr_limit = 400;
        $tma_slides_nbr_limit = 100;
        
        $fields_to_sort_on = array(
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
        
        $hook_link = $this->hook('pre_format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        // MANAGE STORAGE DATA
        // Get the storage data
        $storage_data = null;
        $atim_menu = array();
        if ($storage_master_id) {
            $storage_data = $this->StorageMaster->getOrRedirect($storage_master_id);
            $tree_data = $this->StorageMaster->find('all', array(
                'conditions' => array(
                    'StorageMaster.parent_id' => $storage_master_id,
                    'StorageControl.is_tma_block' => '0'
                ),
                'recursive' => '0'
            ));
            $tree_data = $this->StorageMaster->contentNatCaseSort($fields_to_sort_on['StorageMaster'], $tree_data);
            if (sizeof($tree_data) > $storages_nbr_limit)
                $tree_data = array(
                    array(
                        'Generated' => array(
                            'storage_tree_view_item_summary' => __('storage contains too many children storages for display') . ' (' . sizeof($tree_data) . ')'
                        )
                    )
                );
                // Aliquot
            $aliquots = $this->AliquotMaster->find('all', array(
                'conditions' => array(
                    'AliquotMaster.storage_master_id' => $storage_master_id
                ),
                'recursive' => '0'
            ));
            $aliquots = $this->StorageMaster->contentNatCaseSort($fields_to_sort_on['AliquotMaster'], $aliquots);
            if (sizeof($aliquots) > $aliquots_nbr_limit)
                $aliquots = array(
                    array(
                        'Generated' => array(
                            'storage_tree_view_item_summary' => __('storage contains too many aliquots for display') . ' (' . sizeof($aliquots) . ')'
                        )
                    )
                );
            $tree_data = array_merge($tree_data, $aliquots);
            // TMA blocks
            $tma_blocks = $this->TmaBlock->find('all', array(
                'conditions' => array(
                    'TmaBlock.parent_id' => $storage_master_id
                ),
                'recursive' => '0'
            ));
            $tma_blocks = $this->StorageMaster->contentNatCaseSort($fields_to_sort_on['TmaBlock'], $tma_blocks);
            if (sizeof($tma_blocks) > $storages_nbr_limit)
                $tma_blocks = array(
                    array(
                        'Generated' => array(
                            'storage_tree_view_item_summary' => __('storage contains too many tma blocks for display') . ' (' . sizeof($tma_blocks) . ')'
                        )
                    )
                );
            $tree_data = array_merge($tree_data, $tma_blocks);
            // TMA slide
            $tma_slides = $this->TmaSlide->find('all', array(
                'conditions' => array(
                    'TmaSlide.storage_master_id' => $storage_master_id
                ),
                'recursive' => '0'
            ));
            $tma_slides = $this->StorageMaster->contentNatCaseSort($fields_to_sort_on['TmaSlide'], $tma_slides);
            if (sizeof($tma_slides) > $tma_slides_nbr_limit)
                $tma_slides = array(
                    array(
                        'Generated' => array(
                            'storage_tree_view_item_summary' => __('storage contains too many tma slides for display') . ' (' . sizeof($tma_slides) . ')'
                        )
                    )
                );
            $tree_data = array_merge($tree_data, $tma_slides);
            $atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/contentTreeView/%%StorageMaster.id%%');
            if (! $is_ajax && ! $storage_data['StorageControl']['is_tma_block']) {
                // Get data for the add to selected button
                $this->set('add_links', $this->StorageControl->getAddStorageStructureLinks($storage_master_id));
            }
        } else {
            $tree_data = $this->StorageMaster->find('all', array(
                'conditions' => array(
                    'StorageMaster.parent_id IS NULL',
                    'StorageControl.is_tma_block' => '0'
                ),
                'order' => 'CAST(StorageMaster.parent_storage_coord_x AS signed), CAST(StorageMaster.parent_storage_coord_y AS signed)',
                'recursive' => '0'
            ));
            $tree_data = $this->StorageMaster->contentNatCaseSort($fields_to_sort_on['InitialStorageMaster'], $tree_data);
            if (sizeof($tree_data) > $storages_nbr_limit) {
                $this->flash(__('there are too many main storages for display'), '/StorageLayout/StorageMasters/search/');
                return;
            }
            // TMA blocks
            $tma_blocks = $this->TmaBlock->find('all', array(
                'conditions' => array(
                    'TmaBlock.parent_id IS NULL'
                ),
                'recursive' => '0'
            ));
            $tma_blocks = $this->StorageMaster->contentNatCaseSort($fields_to_sort_on['TmaBlock'], $tma_blocks);
            if (sizeof($tma_blocks) > $storages_nbr_limit)
                $tma_blocks = array(
                    array(
                        'Generated' => array(
                            'storage_tree_view_item_summary' => __('storage contains too many tma blocks for display') . ' (' . sizeof($tma_blocks) . ')'
                        )
                    )
                );
            $tree_data = array_merge($tree_data, $tma_blocks);
            $atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/search');
            $this->set("search", true);
            // Get data for the add to selected button
            $this->set('add_links', $this->StorageControl->getAddStorageStructureLinks());
        }
        $ids = array();
        
        foreach ($tree_data as $data_unit) {
            if (isset($data_unit['StorageMaster'])) {
                $ids[] = $data_unit['StorageMaster']['id'];
            } else 
                if (isset($data_unit['TmaBlock'])) {
                    $ids[] = $data_unit['TmaBlock']['id'];
                }
        }
        $ids = array_flip($this->StorageMaster->hasChild($ids)); // array_key_exists is faster than in_array
        foreach ($tree_data as &$data_unit) {
            if (isset($data_unit['StorageMaster']) && ! isset($data_unit['TmaBlock']) && ! isset($data_unit['TmaSlide']) && ! isset($data_unit['AliquotMaster'])) {
                $data_unit['children'] = array_key_exists($data_unit['StorageMaster']['id'], $ids);
            } else 
                if (isset($data_unit['TmaBlock']) && ! isset($data_unit['StorageMaster']) && ! isset($data_unit['TmaSlide']) && ! isset($data_unit['AliquotMaster'])) {
                    $data_unit['children'] = array_key_exists($data_unit['TmaBlock']['id'], $ids);
                }
        }
        
        $this->request->data = $tree_data;
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object. Needed to disable menu options based on storage type
        if (! empty($storage_data)) {
            if (! $this->StorageControl->allowCustomCoordinates($storage_data['StorageControl']['id'], array(
                'StorageControl' => $storage_data['StorageControl']
            ))) {
                // Check storage supports custom coordinates and disable access to coordinates menu option if required
                $atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
            }
            
            if (empty($storage_data['StorageControl']['coord_x_type'])) {
                // Check storage supports coordinates and disable access to storage layout menu option if required
                $atim_menu = $this->inactivateStorageLayoutMenu($atim_menu);
            }
        }
        
        $this->set('atim_menu', $atim_menu);
        $this->set('atim_menu_variables', array(
            'StorageMaster.id' => $storage_master_id
        ));
        
        // Set structure
        $atim_structure = array();
        $atim_structure['StorageMaster'] = $this->Structures->get('form', 'storage_masters_for_storage_tree_view');
        $atim_structure['AliquotMaster'] = $this->Structures->get('form', 'aliquot_masters_for_storage_tree_view');
        $atim_structure['TmaBlock'] = $this->Structures->get('form', 'tma_blocks_for_storage_tree_view');
        $atim_structure['TmaSlide'] = $this->Structures->get('form', 'tma_slides_for_storage_tree_view');
        $atim_structure['Generated'] = $this->Structures->get('form', 'message_for_storage_tree_view');
        $this->set('atim_structure', $atim_structure);
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
    }

    /**
     * Display the content of a storage into a layout.
     *
     * @param $storage_master_id Id
     *            of the studied storage.
     * @param $is_ajax: Tells
     *            wheter the request has to be treated as ajax
     *            query (required to counter issues in Chrome 15 back/forward button on the
     *            page and Opera 11.51 first ajax query that is not recognized as such)
     *            
     * @author N. Luc
     * @since 2007-05-22
     */
    function storageLayout($storage_master_id, $is_ajax = false, $csv_creation = false)
    {
        // MANAGE STORAGE DATA
        
        // Get the storage data
        $storage_data = $this->StorageMaster->getOrRedirect($storage_master_id);
        
        $parent_coordinate_list = array();
        if ($storage_data['StorageControl']['coord_x_type'] == "list") {
            $coordinate_tmp = $this->StorageCoordinate->find('all', array(
                'conditions' => array(
                    'StorageCoordinate.storage_master_id' => $storage_master_id
                ),
                'recursive' => '-1',
                'order' => 'StorageCoordinate.order ASC'
            ));
            foreach ($coordinate_tmp as $key => $value) {
                $parent_coordinate_list[$value['StorageCoordinate']['id']]['StorageCoordinate'] = $value['StorageCoordinate'];
            }
            if (empty($parent_coordinate_list)) {
                if ($is_ajax) {
                    echo json_encode(array(
                        'valid' => 0
                    ));
                    exit();
                } else {
                    $this->flash(__('no layout exists - add coordinates first'), '/StorageLayout/StorageMasters/detail/' . $storage_master_id);
                    return;
                }
            }
        }
        
        // Storage layout not allowed for this type of storage
        if (empty($storage_data['StorageControl']['coord_x_type'])) {
            if ($is_ajax) {
                echo json_encode(array(
                    'valid' => 0
                ));
                exit();
            } else {
                $this->flash(__('no storage layout is defined for this storage type'), '/StorageLayout/StorageMasters/detail/' . $storage_master_id);
                return;
            }
        }
        
        if (! empty($this->request->data)) {
            if ($csv_creation) {
                
                if (isset($this->request->data['Config']))
                    $this->configureCsv($this->request->data['Config']);
            } else {
                
                $data = array();
                $unclassified = array();
                
                $json = (json_decode($this->request->data));
                
                $second_storage_id = null;
                foreach ($json as $element) {
                    if ((int) $element->s && $element->s != $storage_master_id) {
                        if ($second_storage_id == null) {
                            $second_storage_id = $element->s;
                        } else 
                            if ($second_storage_id != $element->s) {
                                // more than 2 storages
                                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                            }
                    }
                }
                
                $storage_data = array(
                    $storage_data
                );
                if ($second_storage_id) {
                    $storage_data[] = $this->StorageMaster->getOrRedirect($second_storage_id);
                }
                $storage_data = AppController::defineArrayKey($storage_data, 'StorageMaster', 'id', true);
                
                $children_coordinate_list = array();
                if (isset($storage_data[$second_storage_id]) && $storage_data[$second_storage_id]['StorageControl']['coord_x_type'] == "list") {
                    $coordinate_tmp = $this->StorageCoordinate->find('all', array(
                        'conditions' => array(
                            'StorageCoordinate.storage_master_id' => $second_storage_id
                        ),
                        'recursive' => '-1',
                        'order' => 'StorageCoordinate.order ASC'
                    ));
                    foreach ($coordinate_tmp as $key => $value) {
                        $children_coordinate_list[$value['StorageCoordinate']['id']]['StorageCoordinate'] = $value['StorageCoordinate'];
                    }
                    if (empty($children_coordinate_list)) {
                        // The 'Pick a storage to drag and drop to' action should limit selection to storage with layout
                        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
                
                // have cells with id as key
                for ($i = sizeof($json) - 1; $i >= 0; -- $i) {
                    // builds a $cell[type][id] array
                    $data[$json[$i]->{'type'}][$json[$i]->{'id'}] = (array) $json[$i];
                }
                
                $all_coordinate_list = $parent_coordinate_list + $children_coordinate_list;
                foreach ($storage_data as $storage_id => $storage_data_unit) {
                    if ($storage_data_unit['StorageControl']['coord_x_type'] == "list") {
                        foreach ($data as &$data_model) {
                            foreach ($data_model as &$value) {
                                if (is_numeric($value['x']) && $value['s'] == $storage_id) {
                                    $value['x'] = $all_coordinate_list[$value['x']]['StorageCoordinate']['coordinate_value'];
                                }
                            }
                        }
                    }
                }
                
                $storages_initial_data = isset($data['StorageMaster']) ? $this->StorageMaster->find('all', array(
                    'conditions' => array(
                        'StorageMaster.id' => array_keys($data['StorageMaster'])
                    )
                )) : array();
                $aliquots_initial_data = isset($data['AliquotMaster']) ? $this->AliquotMaster->find('all', array(
                    'conditions' => array(
                        'AliquotMaster.id' => array_keys($data['AliquotMaster'])
                    )
                )) : array();
                $tmas_initial_data = isset($data['TmaSlide']) ? $this->TmaSlide->find('all', array(
                    'conditions' => array(
                        'TmaSlide.id' => array_keys($data['TmaSlide'])
                    )
                )) : array();
                
                // manual validate/alteration of positions based on position conflict checks
                $storage_config = array();
                $errors_or_warnings_found = $this->StorageMaster->checkBatchLayoutConflicts($data, 'StorageMaster', 'selection_label', $storage_config);
                $errors_or_warnings_found = $this->StorageMaster->checkBatchLayoutConflicts($data, 'AliquotMaster', 'barcode', $storage_config) || $errors_or_warnings_found;
                $errors_or_warnings_found = $this->StorageMaster->checkBatchLayoutConflicts($data, 'TmaSlide', 'barcode', $storage_config) || $errors_or_warnings_found;
                
                AppModel::acquireBatchViewsUpdateLock();
                
                $updated_record_counter = 0;
                
                // update StorageMaster
                $this->StorageMaster->check_writable_fields = false;
                $errors_or_warnings_found = $this->StorageMaster->updateAndSaveDataArray($storages_initial_data, "StorageMaster", "parent_storage_coord_x", "parent_storage_coord_y", "parent_id", $data, $this->StorageMaster, $storage_data, $updated_record_counter) || $errors_or_warnings_found;
                
                // Update AliquotMaster
                $this->AliquotMaster->check_writable_fields = false;
                $errors_or_warnings_found = $this->StorageMaster->updateAndSaveDataArray($aliquots_initial_data, "AliquotMaster", "storage_coord_x", "storage_coord_y", "storage_master_id", $data, $this->AliquotMaster, $storage_data, $updated_record_counter) || $errors_or_warnings_found;
                
                // Update TmaSlide
                $this->TmaSlide->check_writable_fields = false;
                $errors_or_warnings_found = $this->StorageMaster->updateAndSaveDataArray($tmas_initial_data, "TmaSlide", "storage_coord_x", "storage_coord_y", "storage_master_id", $data, $this->TmaSlide, $storage_data, $updated_record_counter) || $errors_or_warnings_found;
                
                AppModel::releaseBatchViewsUpdateLock();
                
                $summary_message = $updated_record_counter ? __("the storage data of %s element(s) have been updated", $updated_record_counter) : __("no storage data has been updated");
                if ($errors_or_warnings_found) {
                    AppController::addWarningMsg(__($summary_message));
                    $storage_data = $storage_data[$storage_master_id];
                } else {
                    $this->atimFlash(__($summary_message), '/StorageLayout/StorageMasters/storageLayout/' . $storage_master_id);
                    return;
                }
            }
        }
        $this->request->data = array();
        
        $fields_to_sort_on = array(
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
        
        $hook_link = $this->hook('pre_format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        $storage_master_c = $this->StorageMaster->find('all', array(
            'conditions' => array(
                'StorageMaster.parent_id' => $storage_master_id
            )
        ));
        $storage_master_c = $this->StorageMaster->contentNatCaseSort($fields_to_sort_on['StorageMaster'], $storage_master_c, true);
        $aliquot_master_c = $this->AliquotMaster->find('all', array(
            'conditions' => array(
                'AliquotMaster.storage_master_id' => $storage_master_id
            ),
            'recursive' => '-1'
        ));
        $aliquot_master_c = $this->StorageMaster->contentNatCaseSort($fields_to_sort_on['AliquotMaster'], $aliquot_master_c, true);
        $tma_slide_c = $this->TmaSlide->find('all', array(
            'conditions' => array(
                'TmaSlide.storage_master_id' => $storage_master_id
            ),
            'recursive' => '-1'
        ));
        $tma_slide_c = $this->StorageMaster->contentNatCaseSort($fields_to_sort_on['TmaSlide'], $tma_slide_c, true);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object. Needed to disable menu options based on storage type
        $atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/storageLayout/%%StorageMaster.id%%');
        
        if (! $this->StorageControl->allowCustomCoordinates($storage_data['StorageControl']['id'], array(
            'StorageControl' => $storage_data['StorageControl']
        ))) {
            // Check storage supports custom coordinates and disable access to coordinates menu option if required
            $atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
        }
        
        // Get all storage control types to build the add to selected button
        if (! $storage_data['StorageControl']['is_tma_block']) {
            // Get data for the add to selected button
            $this->set('add_links', $this->StorageControl->getAddStorageStructureLinks($storage_master_id));
        }
        
        // Add translated storage type to main storage and chidlren storage
        $storage_types_from_id = $this->StorageControl->getStorageTypePermissibleValues();
        $storage_control_id = $storage_data['StorageControl']['id'];
        $storage_data['StorageControl']['translated_storage_type'] = isset($storage_types_from_id[$storage_control_id]) ? $storage_types_from_id[$storage_control_id] : $storage_data['StorageControl']['storage_type'];
        foreach ($storage_master_c as &$new_children_storage) {
            $children_storage_control_id = $new_children_storage['StorageControl']['id'];
            $new_children_storage['StorageControl']['translated_storage_type'] = isset($storage_types_from_id[$children_storage_control_id]) ? $storage_types_from_id[$children_storage_control_id] : $new_children_storage['StorageControl']['storage_type'];
        }
        
        $this->set('atim_menu', $atim_menu);
        $this->set('atim_menu_variables', array(
            'StorageMaster.id' => $storage_master_id
        ));
        
        // Set structure
        $this->Structures->set('storagemasters');
        
        $data['parent'] = $storage_data;
        if (isset($parent_coordinate_list)) {
            $data['parent']['list'] = $parent_coordinate_list;
            $rkey_coordinate_list = array();
            foreach ($parent_coordinate_list as $values) {
                $rkey_coordinate_list[$values['StorageCoordinate']['coordinate_value']] = $values;
            }
        } else {
            $rkey_coordinate_list = null;
        }
        $data['children'] = $storage_master_c;
        $data['children'] = array_merge($data['children'], $aliquot_master_c);
        $data['children'] = array_merge($data['children'], $tma_slide_c);
        
        foreach ($data['children'] as &$children_array) {
            if (isset($children_array['StorageMaster'])) {
                $link = $this->request->webroot . "StorageLayout/StorageMasters/detail/" . $children_array["StorageMaster"]['id'] . "/2";
                $this->StorageMaster->buildChildrenArray($children_array, "StorageMaster", "parent_storage_coord_x", "parent_storage_coord_y", "selection_label", $rkey_coordinate_list, $link, $children_array['StorageControl']['is_tma_block'] ? 'tma block' : 'storage');
            } else 
                if (isset($children_array['AliquotMaster'])) {
                    $link = $this->request->webroot . "InventoryManagement/AliquotMasters/detail/" . $children_array["AliquotMaster"]["collection_id"] . "/" . $children_array["AliquotMaster"]["sample_master_id"] . "/" . $children_array["AliquotMaster"]["id"] . "/2";
                    $this->StorageMaster->buildChildrenArray($children_array, "AliquotMaster", "storage_coord_x", "storage_coord_y", "barcode", $rkey_coordinate_list, $link, "aliquot");
                } else 
                    if (isset($children_array['TmaSlide'])) {
                        $link = $this->request->webroot . "StorageLayout/TmaSlides/detail/" . $children_array["TmaSlide"]['tma_block_storage_master_id'] . "/" . $children_array["TmaSlide"]['id'] . "/2";
                        $this->StorageMaster->buildChildrenArray($children_array, "TmaSlide", "storage_coord_x", "storage_coord_y", "barcode", $rkey_coordinate_list, $link, "slide");
                    }
        }
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        $this->set('data', $data);
        $this->Structures->set('empty', 'empty_structure');
        
        if ($csv_creation) {
            $this->render('storage_layout_csv');
            Configure::write('debug', 0);
        } else 
            if ($is_ajax) {
                $this->render('storage_layout_html');
            }
    }

    function autocompleteLabel()
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
        $term = trim(str_replace('_', '\_', str_replace('%', '\%', $_GET['term'])));
        $conditions = array(
            'StorageMaster.Selection_label LIKE' => $term . '%'
        );
        $rpos = strripos($term, "[");
        if ($rpos) {
            $term2a = substr($term, 0, $rpos - 1);
            $term2b = substr($term, $rpos + 1);
            if ($term2b[strlen($term2b) - 1] == "]") {
                $term2b = substr($term2b, - 1);
            }
            $tmp_condition = $conditions;
            $conditions = array();
            $conditions['or'][] = $tmp_condition;
            $conditions['or'][] = array(
                'StorageMaster.Selection_label LIKE' => $term2a,
                'StorageMaster.code LIKE' => $term2b . '%'
            );
        }
        
        $storage_masters = $this->StorageMaster->find('all', array(
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
        
        $storage_types_from_id = $this->StorageControl->getStorageTypePermissibleValues();
        
        // build javascript textual array
        $result = "";
        $count = 0;
        foreach ($storage_masters as $storage_master) {
            $storage_control_id = $storage_master['StorageControl']['id'];
            $result .= '"' . $storage_master['StorageMaster']['selection_label'] . ' [' . $storage_master['StorageMaster']['code'] . '] / ' . (isset($storage_types_from_id[$storage_control_id]) ? $storage_types_from_id[$storage_control_id] : $storage_master['StorageControl']['storage_type']) . '", ';
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

    function contentListView($storage_master_id, $model = null)
    {
        $storage_master_data = $this->StorageMaster->getOrRedirect($storage_master_id);
        
        $atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/contentListView/%%StorageMaster.id%%');
        if (! $this->StorageControl->allowCustomCoordinates($storage_master_data['StorageControl']['id'], array(
            'StorageControl' => $storage_master_data['StorageControl']
        ))) {
            // Check storage supports custom coordinates and disable access to coordinates menu option if required
            $atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
        }
        if (empty($storage_master_data['StorageControl']['coord_x_type'])) {
            // Check storage supports coordinates and disable access to storage layout menu option if required
            $atim_menu = $this->inactivateStorageLayoutMenu($atim_menu);
        }
        $this->set('atim_menu', $atim_menu);
        $this->set('atim_menu_variables', array(
            'StorageMaster.id' => $storage_master_id
        ));
        
        if (! $model) {
            $this->Structures->set('empty', 'empty_structure');
            if ($storage_master_data['StorageControl']['is_tma_block']) {
                $this->set('models_to_dispay', array(
                    'AliquotMaster' => 'cores'
                ));
            } else {
                $models_to_dispay = array(
                    'StorageMaster' => 'storages',
                    'AliquotMaster' => 'aliquots'
                );
                if ($this->StorageControl->find('count', array(
                    'conditions' => array(
                        'StorageControl.is_tma_block' => '1',
                        'StorageControl.flag_active' => '1'
                    )
                ))) {
                    $models_to_dispay = array_merge($models_to_dispay, array(
                        'TmaBlock' => 'tma blocks',
                        'TmaSlide' => 'tma slides'
                    ));
                }
                $this->set('models_to_dispay', $models_to_dispay);
            }
            if (! $storage_master_data['StorageControl']['is_tma_block']) {
                // Get data for the add to selected button
                $this->set('add_links', $this->StorageControl->getAddStorageStructureLinks($storage_master_id));
            }
            $this->set('is_main_form', true);
        } else {
            switch ($model) {
                case 'StorageMaster':
                    $this->request->data = $this->paginate($this->StorageMaster, array(
                        'StorageMaster.parent_id' => $storage_master_id,
                        'StorageControl.is_tma_block' => '0'
                    ));
                    $this->Structures->set('storage_masters_for_storage_list_view');
                    $this->set('detail_url', '/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%/');
                    $this->set('icon', 'storage');
                    break;
                case 'AliquotMaster':
                    $this->request->data = $this->paginate($this->AliquotMaster, array(
                        'AliquotMaster.storage_master_id' => $storage_master_id
                    ));
                    $this->Structures->set('aliquot_masters_for_storage_list_view');
                    $this->set('detail_url', '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/');
                    $this->set('icon', 'aliquot');
                    break;
                case 'TmaBlock':
                    $this->request->data = $this->paginate($this->TmaBlock, array(
                        'TmaBlock.parent_id' => $storage_master_id
                    ));
                    $this->Structures->set('tma_blocks_for_storage_tree_view');
                    $this->set('detail_url', '/StorageLayout/StorageMasters/detail/%%TmaBlock.id%%/');
                    $this->set('icon', 'tma block');
                    break;
                case 'TmaSlide':
                    $this->request->data = $this->paginate($this->TmaSlide, array(
                        'TmaSlide.storage_master_id' => $storage_master_id
                    ));
                    $this->Structures->set('tma_slides_for_storage_list_view');
                    $this->set('detail_url', '/StorageLayout/TmaSlides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%/');
                    $this->set('icon', 'tma slide');
                    break;
                default:
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            $this->set('is_main_form', false);
        }
        
        // CUTOM CODE
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
    }
}
