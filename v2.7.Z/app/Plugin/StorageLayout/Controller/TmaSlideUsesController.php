<?php

class TmaSlideUsesController extends StorageLayoutAppController
{

    public $components = array();

    public $uses = array(
        'StorageLayout.StorageMaster',
        'StorageLayout.TmaSlide',
        'StorageLayout.TmaSlideUse',
        'StorageLayout.StorageCoordinate',
        'StorageLayout.StorageControl',
        
        'Study.StudySummary'
    );

    public $paginate = array(
        'TmaSlideUse' => array(
            'order' => 'TmaSlideUse.date DESC'
        )
    );

    /* ----------------------------- TMA SLIDES ANALYSIS ------------------------ */
    function add($tma_slide_id = null)
    {
        // GET DATA
        $initial_display = false;
        $tma_slide_ids = array();
        
        $this->setUrlToCancel();
        $url_to_cancel = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        if ($tma_slide_id != null) {
            // User is workning on a tma block
            $tma_slide_ids = array(
                $tma_slide_id
            );
            if (empty($this->request->data))
                $initial_display = true;
        } else 
            if (isset($this->request->data['TmaSlide']['id'])) {
                // User launched an action from the DataBrowser or a Report Form
                if ($this->request->data['TmaSlide']['id'] == 'all' && isset($this->request->data['node'])) {
                    // The displayed elements number was higher than the databrowser_and_report_results_display_limit
                    $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                    $browsing_result = $this->BrowsingResult->find('first', array(
                        'conditions' => array(
                            'BrowsingResult.id' => $this->request->data['node']['id']
                        )
                    ));
                    $this->request->data['TmaSlide']['id'] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
                }
                $tma_slide_ids = array_filter($this->request->data['TmaSlide']['id']);
                $initial_display = true;
            } else 
                if (! empty($this->request->data)) {
                    // User submit data of the TmaSlide.add() form
                    $tma_slide_ids = array_keys($this->request->data);
                } else {
                    $this->flash((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $url_to_cancel, 5);
                    return;
                }
        
        // Get TMA Blocks data
        
        $tma_slides = $this->TmaSlide->find('all', array(
            'conditions' => array(
                'TmaSlide.id' => $tma_slide_ids
            ),
            'recursive' => '0'
        ));
        if ($initial_display)
            $this->TmaSlide->sortForDisplay($tma_slides, $tma_slide_ids);
        $tma_slides_from_id = array();
        foreach ($tma_slides as &$tma_slide_data) {
            $tma_slides_from_id[$tma_slide_data['TmaSlide']['id']] = $tma_slide_data;
        }
        
        $display_limit = Configure::read('TmaSlideCreation_processed_items_limit');
        if (sizeof($tma_slides_from_id) > $display_limit) {
            $this->flash(__("batch init - number of submitted records too big") . " (>$display_limit)", $url_to_cancel, 5);
            return;
        }
        if (sizeof($tma_slides_from_id) != sizeof($tma_slide_ids))
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            
            // SET MENU AND STRUCTURE DATA
        
        $this->set('url_to_cancel', $url_to_cancel);
        $this->set('tma_slide_id', $tma_slide_id);
        
        // Set menu
        if ($tma_slide_id != null) {
            // Get the current menu object. Needed to disable menu options based on storage type
            $atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
            // Inactivate Storage Coordinate Menu (unpossible for TMA type)
            $this->set('atim_menu', $this->inactivateStorageCoordinateMenu($atim_menu));
            // Variables
            $this->set('atim_menu_variables', array(
                'StorageMaster.id' => $tma_slides_from_id[$tma_slide_id]['Block']['id']
            ));
        } else {
            $this->set('atim_menu', $this->Menus->get('/StorageLayout/StorageMasters/search/'));
            $this->set('atim_menu_variables', array());
        }
        
        // Set structure
        $this->Structures->set('tma_slide_uses');
        $this->Structures->set(($tma_slide_id ? '' : 'tma_blocks_for_slide_creation,') . 'tma_slides_for_use_creation', 'tma_slides_atim_structure');
        
        // MANAGE DATA
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if ($initial_display) {
            
            $this->request->data = array();
            foreach ($tma_slides as $tma_slide) {
                $this->request->data[] = array(
                    'parent' => $tma_slide,
                    'children' => array()
                );
            }
            
            $hook_link = $this->hook('initial_display');
            if ($hook_link) {
                require ($hook_link);
            }
        } else {
            $previous_data = $this->request->data;
            $this->request->data = array();
            
            // validate
            $errors = array();
            $tma_slide_uses_to_create = array();
            $line = 0;
            
            $record_counter = 0;
            foreach ($previous_data as $studied_tma_slide_id => $data_unit) {
                $record_counter ++;
                
                if (! array_key_exists($studied_tma_slide_id, $tma_slides_from_id))
                    $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $tma_slide_data = $tma_slides_from_id[$studied_tma_slide_id];
                
                unset($data_unit['Block']);
                unset($data_unit['TmaSlide']);
                
                if (empty($data_unit)) {
                    $errors['']['you must create at least one use for each tma slide'][$record_counter] = $record_counter;
                }
                foreach ($data_unit as &$use_data_unit) {
                    $use_data_unit['TmaSlideUse']['tma_slide_id'] = $studied_tma_slide_id;
                    $this->TmaSlideUse->data = null;
                    $this->TmaSlideUse->set($use_data_unit);
                    if (! $this->TmaSlideUse->validates()) {
                        foreach ($this->TmaSlideUse->validationErrors as $field => $msgs) {
                            $msgs = is_array($msgs) ? $msgs : array(
                                $msgs
                            );
                            foreach ($msgs as $msg)
                                $errors[$field][$msg][$record_counter] = $record_counter;
                        }
                    }
                    $use_data_unit = $this->TmaSlideUse->data;
                }
                $tma_slide_uses_to_create = array_merge($tma_slide_uses_to_create, $data_unit);
                
                $this->request->data[] = array(
                    'parent' => $tma_slide_data,
                    'children' => $data_unit
                );
            }
            
            $hook_link = $this->hook('presave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            if (empty($errors)) {
                
                AppModel::acquireBatchViewsUpdateLock();
                
                // saving
                $this->TmaSlideUse->addWritableField(array(
                    'tma_slide_id'
                ));
                $this->TmaSlideUse->writable_fields_mode = 'addgrid';
                $this->TmaSlideUse->saveAll($tma_slide_uses_to_create, array(
                    'validate' => false
                ));
                
                $hook_link = $this->hook('postsave_process');
                if ($hook_link) {
                    require ($hook_link);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                if ($tma_slide_id != null) {
                    $this->atimFlash(__('your data has been saved'), '/StorageLayout/TmaSlides/detail/' . $tma_slides_from_id[$tma_slide_id]['TmaSlide']['tma_block_storage_master_id'] . '/' . $tma_slide_id);
                } else {
                    // batch
                    $last_id = $this->TmaSlideUse->getLastInsertId();
                    $batch_ids = range($last_id - count($tma_slide_uses_to_create) + 1, $last_id);
                    $datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                    $batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
                    $batch_set_data = array(
                        'BatchSet' => array(
                            'datamart_structure_id' => $datamart_structure->getIdByModelName('TmaSlideUse'),
                            'flag_tmp' => true
                        )
                    );
                    $batch_set_model->check_writable_fields = false;
                    $batch_set_model->saveWithIds($batch_set_data, $batch_ids);
                    $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batch_set_model->getLastInsertId());
                }
            } else {
                $this->TmaSlideUse->validationErrors = array();
                foreach ($errors as $field => $msg_and_lines) {
                    foreach ($msg_and_lines as $msg => $lines) {
                        $this->TmaSlideUse->validationErrors[$field][] = __($msg) . (($record_counter != 1) ? ' - ' . str_replace('%s', implode(",", $lines), __('see # %s')) : '');
                    }
                }
            }
        }
    }

    function listAll($tma_block_storage_master_id, $tma_slide_id)
    {
        // MANAGE DATA
        
        // Get the storage data
        $tma_slide_data = $this->TmaSlide->getOrRedirect($tma_slide_id);
        if ($tma_slide_data['TmaSlide']['tma_block_storage_master_id'] != $tma_block_storage_master_id) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get TMA slide use list
        $this->request->data = $this->paginate($this->TmaSlideUse, array(
            'TmaSlideUse.tma_slide_id' => $tma_slide_id
        ));
        
        // Set structure
        $this->Structures->set('tma_slide_uses');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
    }

    function edit($tma_slide_use_id)
    {
        // MANAGE DATA
        
        // Get data
        $tma_slide_use_data = $this->TmaSlideUse->getOrRedirect($tma_slide_use_id);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object. Needed to disable menu options based on storage type
        $atim_menu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
        
        // Inactivate Storage Coordinate Menu (unpossible for TMA type)
        $atim_menu = $this->inactivateStorageCoordinateMenu($atim_menu);
        
        $this->set('atim_menu', $atim_menu);
        
        $atim_menu_variables = array();
        $atim_menu_variables['TmaSlideUse.id'] = $tma_slide_use_id;
        $atim_menu_variables['TmaSlide.id'] = $tma_slide_use_data['TmaSlide']['id'];
        $atim_menu_variables['StorageMaster.id'] = $tma_slide_use_data['TmaSlide']['tma_block_storage_master_id'];
        $this->set('atim_menu_variables', $atim_menu_variables);
        
        // Set structure
        $this->Structures->set('tma_slide_uses');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if (empty($this->request->data)) {
            
            $tma_slide_use_data['FunctionManagement']['autocomplete_tma_slide_use_study_summary_id'] = $this->StudySummary->getStudyDataAndCodeForDisplay(array(
                'StudySummary' => array(
                    'id' => $tma_slide_use_data['TmaSlideUse']['study_summary_id']
                )
            ));
            $this->request->data = $tma_slide_use_data;
            
            $hook_link = $this->hook('initial_display');
            if ($hook_link) {
                require ($hook_link);
            }
        } else {
            // Update data
            
            // Validates data
            $submitted_data_validates = true;
            
            $this->request->data['TmaSlideUse']['id'] = $tma_slide_use_id;
            $this->TmaSlideUse->set($this->request->data);
            if (! $this->TmaSlideUse->validates()) {
                $submitted_data_validates = false;
            }
            
            // Reste data to get position data
            $this->request->data = $this->TmaSlideUse->data;
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            
            $hook_link = $this->hook('presave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            if ($submitted_data_validates) {
                // Save tma slide data
                $this->TmaSlideUse->id = $tma_slide_use_id;
                if ($this->TmaSlideUse->save($this->request->data, false)) {
                    $hook_link = $this->hook('postsave_process');
                    if ($hook_link) {
                        require ($hook_link);
                    }
                    $this->atimFlash(__('your data has been updated'), '/StorageLayout/TmaSlides/detail/' . $tma_slide_use_data['TmaSlide']['tma_block_storage_master_id'] . '/' . $tma_slide_use_data['TmaSlide']['id']);
                }
            }
        }
    }

    function editInBatch()
    {
        // MANAGE DATA
        $this->setUrlToCancel();
        $url_to_cancel = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        $initial_display = false;
        $criteria = array(
            'TmaSlideUse.id' => '-1'
        );
        $tma_slide_use_ids = array();
        $initial_slide_uses_data = array();
        if (isset($this->request->data['TmaSlideUse']['id'])) {
            // User launched an action from the DataBrowser or a Report Form
            if ($this->request->data['TmaSlideUse']['id'] == 'all' && isset($this->request->data['node'])) {
                // The displayed elements number was higher than the databrowser_and_report_results_display_limit
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsing_result = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $this->request->data['TmaSlideUse']['id'] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
            }
            $tma_slide_use_ids = array_filter($this->request->data['TmaSlideUse']['id']);
            $criteria = array(
                'TmaSlideUse.id' => $tma_slide_use_ids
            );
            $initial_display = true;
        } else 
            if (! empty($this->request->data)) {
                // User submit data of the TmaSlideUse.editInBatch() form
                $tma_slide_use_ids = explode(',', $this->request->data['tma_slide_use_ids']);
            } else {
                $this->flash((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $url_to_cancel, 5);
                return;
            }
        unset($this->request->data['tma_slide_use_ids']);
        
        if ($initial_display) {
            $initial_slide_uses_data = $this->TmaSlideUse->find('all', array(
                'conditions' => $criteria,
                'order' => 'TmaSlideUse.date ASC',
                'recursive' => '2'
            ));
            if (empty($initial_slide_uses_data)) {
                $this->flash(__('no slide use to update'), $url_to_cancel);
                return;
            }
            if ($tma_slide_use_ids)
                $this->TmaSlideUse->sortForDisplay($initial_slide_uses_data, $tma_slide_use_ids);
            $display_limit = Configure::read('TmaSlideCreation_processed_items_limit');
            if (sizeof($initial_slide_uses_data) > $display_limit) {
                $this->flash(__("batch init - number of submitted records too big") . " (>$display_limit)", $url_to_cancel, 5);
                return;
            }
            foreach ($initial_slide_uses_data as &$tmp_data)
                $tmp_data['Block'] = $tmp_data['TmaSlide']['Block'];
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('url_to_cancel', $url_to_cancel);
        $this->set('tma_slide_use_ids', implode(',', $tma_slide_use_ids));
        
        // Set menu
        $this->set('atim_menu', $this->Menus->get('/StorageLayout/StorageMasters/search/'));
        $this->set('atim_menu_variables', array());
        
        // Set structure
        $this->Structures->set('tma_slide_uses,tma_slides_for_use_creation,tma_blocks_for_slide_creation');
        
        $hook_link = $this->hook('format');
        if ($hook_link) {
            require ($hook_link);
        }
        
        // SAVE DATA
        
        if ($initial_display) {
            $this->request->data = $initial_slide_uses_data;
            foreach ($this->request->data as &$new_slide_use_data) {
                $new_slide_use_data['FunctionManagement']['autocomplete_tma_slide_use_study_summary_id'] = $this->StudySummary->getStudyDataAndCodeForDisplay(array(
                    'StudySummary' => array(
                        'id' => $new_slide_use_data['TmaSlideUse']['study_summary_id']
                    )
                ));
            }
            
            $hook_link = $this->hook('initial_display');
            if ($hook_link) {
                require ($hook_link);
            }
        } else {
            
            // Launch validation
            $submitted_data_validates = true;
            
            $errors = array();
            $record_counter = 0;
            $updated_tma_slide_use_ids = array();
            foreach ($this->request->data as &$new_studied_tma_use) {
                $record_counter ++;
                // Get id
                if (! isset($new_studied_tma_use['TmaSlideUse']['id']))
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $updated_tma_slide_use_ids[] = $new_studied_tma_use['TmaSlideUse']['id'];
                // Check date should be tested or not
                $date = null;
                if (! is_array($new_studied_tma_use['TmaSlideUse']['date'])) {
                    $date = $new_studied_tma_use['TmaSlideUse']['date'];
                    unset($new_studied_tma_use['TmaSlideUse']['date']);
                }
                // Launch Slide validation
                $this->TmaSlideUse->data = array();
                $this->TmaSlideUse->set($new_studied_tma_use);
                $submitted_data_validates = ($this->TmaSlideUse->validates()) ? $submitted_data_validates : false;
                foreach ($this->TmaSlideUse->validationErrors as $field => $msgs) {
                    $msgs = is_array($msgs) ? $msgs : array(
                        $msgs
                    );
                    foreach ($msgs as $msg)
                        $errors['TmaSlideUse'][$field][$msg][] = $record_counter;
                }
                // Reset data
                $new_studied_tma_use = $this->TmaSlideUse->data;
                if (! is_null($date))
                    $new_studied_tma_use['TmaSlideUse']['date'] = $date;
            }
            
            if ($this->TmaSlideUse->find('count', array(
                'conditions' => array(
                    'TmaSlideUse.id' => $updated_tma_slide_use_ids
                ),
                'recursive' => '-1'
            )) != sizeof($updated_tma_slide_use_ids)) {
                // In case a TMA slide use has just been deleted by another user before we submitted updated data
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $hook_link = $this->hook('presave_process');
            if ($hook_link) {
                require ($hook_link);
            }
            
            if ($submitted_data_validates) {
                
                // Launch save process
                
                AppModel::acquireBatchViewsUpdateLock();
                
                $this->TmaSlideUse->writable_fields_mode = 'editgrid';
                foreach ($this->request->data as $tma_data) {
                    // Save data
                    $this->TmaSlideUse->data = array();
                    $this->TmaSlideUse->id = $tma_data['TmaSlideUse']['id'];
                    if (! $this->TmaSlideUse->save($tma_data['TmaSlideUse'], false)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
                
                $hook_link = $this->hook('postsave_process');
                if ($hook_link) {
                    require ($hook_link);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                // Creat Batchset then redirect
                
                $batch_ids = $tma_slide_use_ids;
                $datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                $batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
                $batch_set_data = array(
                    'BatchSet' => array(
                        'datamart_structure_id' => $datamart_structure->getIdByModelName('TmaSlideUse'),
                        'flag_tmp' => true
                    )
                );
                $batch_set_model->check_writable_fields = false;
                $batch_set_model->saveWithIds($batch_set_data, $batch_ids);
                $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batch_set_model->getLastInsertId());
            } else {
                // Set error message
                foreach ($errors as $model => $field_messages) {
                    $this->{$model}->validationErrors = array();
                    foreach ($field_messages as $field => $messages) {
                        foreach ($messages as $message => $lines_nbr) {
                            if (! array_key_exists($field, $this->{$model}->validationErrors)) {
                                $this->{$model}->validationErrors[$field][] = __($message) . ' - ' . str_replace('%s', implode(',', $lines_nbr), __('see line %s'));
                            } else {
                                $this->{$model}->validationErrors[][] = __($message) . ' - ' . str_replace('%s', implode(',', $lines_nbr), __('see line %s'));
                            }
                        }
                    }
                }
            }
        }
    }

    function delete($tma_slide_use_id)
    {
        // MANAGE DATA
        
        // Get the use data
        $tma_slide_use_data = $this->TmaSlideUse->getOrRedirect($tma_slide_use_id);
        
        // Check deletion is allowed
        $arr_allow_deletion = $this->TmaSlideUse->allowDeletion($tma_slide_use_id);
        
        // CUSTOM CODE
        
        $hook_link = $this->hook('delete');
        if ($hook_link) {
            require ($hook_link);
        }
        
        if ($arr_allow_deletion['allow_deletion']) {
            // Delete tma slide Use
            if ($this->TmaSlideUse->atimDelete($tma_slide_use_id)) {
                $hook_link = $this->hook('postsave_process');
                if ($hook_link) {
                    require ($hook_link);
                }
                $this->atimFlash(__('your data has been deleted'), '/StorageLayout/TmaSlides/detail/' . $tma_slide_use_data['TmaSlide']['tma_block_storage_master_id'] . '/' . $tma_slide_use_data['TmaSlide']['id']);
            } else {
                $this->flash(__('error deleting data - contact administrator'), '/StorageLayout/TmaSlides/detail/' . $tma_slide_use_data['TmaSlide']['tma_block_storage_master_id'] . '/' . $tma_slide_use_data['TmaSlide']['id']);
            }
        } else {
            $this->flash(__($arr_allow_deletion['msg']), '/StorageLayout/TmaSlides/detail/' . $tma_slide_use_data['TmaSlide']['tma_block_storage_master_id'] . '/' . $tma_slide_use_data['TmaSlide']['id']);
        }
    }
}