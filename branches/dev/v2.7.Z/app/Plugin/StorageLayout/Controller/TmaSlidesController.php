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
 * Class TmaSlidesController
 */
class TmaSlidesController extends StorageLayoutAppController
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
        'TmaSlide' => array(
            'order' => 'TmaSlide.barcode DESC'
        )
    );

    /*
     * --------------------------------------------------------------------------
     * DISPLAY FUNCTIONS
     * --------------------------------------------------------------------------
     */
    /**
     *
     * @param $tmaBlockStorageMasterId
     */
    public function listAll($tmaBlockStorageMasterId)
    {
        // MANAGE DATA
        
        // Get the storage data
        $storageData = $this->StorageMaster->getOrRedirect($tmaBlockStorageMasterId);
        
        // Verify storage is tma block
        if (! $storageData['StorageControl']['is_tma_block']) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get TMA slide liste
        $this->request->data = $this->paginate($this->TmaSlide, array(
            'TmaSlide.tma_block_storage_master_id' => $tmaBlockStorageMasterId
        ));
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object. Needed to disable menu options based on storage type
        $atimMenu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
        
        // Inactivate Storage Coordinate Menu (unpossible for TMA type)
        $atimMenu = $this->inactivateStorageCoordinateMenu($atimMenu);
        
        $this->set('atimMenu', $atimMenu);
        $this->set('atimMenuVariables', array(
            'StorageMaster.id' => $tmaBlockStorageMasterId
        ));
        
        // Set structure
        $this->Structures->set('tma_slides');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param null $tmaBlockStorageMasterId
     */
    public function add($tmaBlockStorageMasterId = null)
    {
        // GET DATA
        $initialDisplay = false;
        $tmaBlockIds = array();
        
        $this->setUrlToCancel();
        $urlToCancel = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        if ($tmaBlockStorageMasterId != null) {
            // User is workning on a tma block
            $tmaBlockIds = array(
                $tmaBlockStorageMasterId
            );
            if (empty($this->request->data))
                $initialDisplay = true;
        } elseif (isset($this->request->data['TmaBlock']['id'])) {
            // User launched an action from the DataBrowser or a Report Form
            if ($this->request->data['TmaBlock']['id'] == 'all' && isset($this->request->data['node'])) {
                // The displayed elements number was higher than the databrowser_and_report_results_display_limit
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $this->request->data['TmaBlock']['id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
            $tmaBlockIds = array_filter($this->request->data['TmaBlock']['id']);
            $initialDisplay = true;
        } elseif (! empty($this->request->data)) {
            // User submit data of the TmaSlide.add() form
            $tmaBlockIds = array_keys($this->request->data);
        } else {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel);
            return;
        }
        
        // Get TMA Blocks data
        
        $tmaBlocks = $this->StorageMaster->find('all', array(
            'conditions' => array(
                'StorageMaster.id' => $tmaBlockIds
            ),
            'recursive' => 0
        ));
        if ($initialDisplay)
            $this->StorageMaster->sortForDisplay($tmaBlocks, $tmaBlockIds);
        $tmaBlocksFromId = array();
        $realStorageSelected = false; // Different than TMA block
        foreach ($tmaBlocks as &$tmaBlockData) {
            $tmaBlockData = array_merge(array(
                'Block' => $tmaBlockData['StorageMaster']
            ), $tmaBlockData);
            $tmaBlocksFromId[$tmaBlockData['StorageMaster']['id']] = $tmaBlockData;
            if (! $tmaBlockData['StorageControl']['is_tma_block'])
                $realStorageSelected = true;
        }
        if ($realStorageSelected) {
            $this->atimFlashWarning(__('at least one selected item is not a tma block'), $urlToCancel);
            return;
        }
        $displayLimit = Configure::read('TmaSlideCreation_processed_items_limit');
        if (sizeof($tmaBlocksFromId) > $displayLimit) {
            $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", $urlToCancel);
            return;
        }
        if (sizeof($tmaBlocksFromId) != sizeof($tmaBlockIds))
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            
            // SET MENU AND STRUCTURE DATA
        
        $this->set('urlToCancel', $urlToCancel);
        $this->set('tmaBlockStorageMasterId', $tmaBlockStorageMasterId);
        
        // Set menu
        if ($tmaBlockStorageMasterId != null) {
            // Get the current menu object. Needed to disable menu options based on storage type
            $atimMenu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
            // Inactivate Storage Coordinate Menu (unpossible for TMA type)
            $this->set('atimMenu', $this->inactivateStorageCoordinateMenu($atimMenu));
            // Variables
            $this->set('atimMenuVariables', array(
                'StorageMaster.id' => $tmaBlockStorageMasterId
            ));
        } else {
            $this->set('atimMenu', $this->Menus->get('/StorageLayout/StorageMasters/search/'));
            $this->set('atimMenuVariables', array());
        }
        
        // Set structure
        $this->Structures->set('tma_slides');
        $this->Structures->set('tma_blocks_for_slide_creation', 'tma_blocks_atim_structure');
        
        // MANAGE DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($initialDisplay) {
            
            $this->request->data = array();
            foreach ($tmaBlocks as $blockDataUnit) {
                $this->request->data[] = array(
                    'parent' => $blockDataUnit,
                    'children' => array()
                );
            }
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            $previousData = $this->request->data;
            $this->request->data = array();
            
            // validate
            $errors = array();
            $tmaSlidesToCreate = array();
            $line = 0;
            
            $recordCounter = 0;
            foreach ($previousData as $keyBlockStorageMasterId => $dataUnit) {
                $recordCounter ++;
                
                if (! array_key_exists($keyBlockStorageMasterId, $tmaBlocksFromId))
                    $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $tmaBlockData = $tmaBlocksFromId[$keyBlockStorageMasterId];
                
                unset($dataUnit['Block']);
                
                if (empty($dataUnit)) {
                    $errors['']['you must create at least one slide for each tma'][$recordCounter] = $recordCounter;
                }
                foreach ($dataUnit as &$useDataUnit) {
                    $useDataUnit['TmaSlide']['tma_block_storage_master_id'] = $keyBlockStorageMasterId;
                    $this->TmaSlide->data = null;
                    $this->TmaSlide->set($useDataUnit);
                    if (! $this->TmaSlide->validates()) {
                        foreach ($this->TmaSlide->validationErrors as $field => $msgs) {
                            $msgs = is_array($msgs) ? $msgs : array(
                                $msgs
                            );
                            foreach ($msgs as $msg)
                                $errors[$field][$msg][$recordCounter] = $recordCounter;
                        }
                    }
                    $useDataUnit = $this->TmaSlide->data;
                }
                $tmaSlidesToCreate = array_merge($tmaSlidesToCreate, $dataUnit);
                
                $this->request->data[] = array(
                    'parent' => $tmaBlockData,
                    'children' => $dataUnit
                );
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if (empty($errors)) {
                
                AppModel::acquireBatchViewsUpdateLock();
                
                // saving
                $this->TmaSlide->addWritableField(array(
                    'tma_block_storage_master_id',
                    'storage_master_id'
                ));
                $this->TmaSlide->writableFieldsMode = 'addgrid';
                $this->TmaSlide->saveAll($tmaSlidesToCreate, array(
                    'validate' => false
                ));
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                if ($tmaBlockStorageMasterId != null) {
                    $this->atimFlash(__('your data has been saved'), '/StorageLayout/StorageMasters/detail/' . $tmaBlockStorageMasterId);
                } else {
                    // batch
                    $lastId = $this->TmaSlide->getLastInsertId();
                    $batchIds = range($lastId - count($tmaSlidesToCreate) + 1, $lastId);
                    $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                    $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                    $batchSetData = array(
                        'BatchSet' => array(
                            'datamart_structure_id' => $datamartStructure->getIdByModelName('TmaSlide'),
                            'flag_tmp' => true
                        )
                    );
                    $batchSetModel->checkWritableFields = false;
                    $batchSetModel->saveWithIds($batchSetData, $batchIds);
                    $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId());
                }
            } else {
                $this->TmaSlide->validationErrors = array();
                foreach ($errors as $field => $msgAndLines) {
                    foreach ($msgAndLines as $msg => $lines) {
                        $this->TmaSlide->validationErrors[$field][] = __($msg) . (($recordCounter != 1) ? ' - ' . str_replace('%s', implode(",", $lines), __('see # %s')) : '');
                    }
                }
            }
        }
    }

    /**
     *
     * @param $tmaBlockStorageMasterId
     * @param $tmaSlideId
     * @param int $isFromTreeViewOrLayout
     */
    public function detail($tmaBlockStorageMasterId, $tmaSlideId, $isFromTreeViewOrLayout = 0)
    {
        // $isFromTreeViewOrLayout : 0-Normal, 1-Tree view, 2-Stoarge layout
        
        // MANAGE DATA
        
        // Get the storage data
        $storageData = $this->StorageMaster->getOrRedirect($tmaBlockStorageMasterId);
        
        // Verify storage is tma block
        if (! $storageData['StorageControl']['is_tma_block']) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get the tma slide data
        $tmaSlideData = $this->TmaSlide->find('first', array(
            'conditions' => array(
                'TmaSlide.id' => $tmaSlideId,
                'TmaSlide.tma_block_storage_master_id' => $tmaBlockStorageMasterId
            )
        ));
        if (empty($tmaSlideData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $this->request->data = $tmaSlideData;
        
        // Define if this detail form is displayed into the children storage tree view
        $this->set('isFromTreeViewOrLayout', $isFromTreeViewOrLayout);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object. Needed to disable menu options based on storage type
        $atimMenu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
        
        // Inactivate Storage Coordinate Menu (unpossible for TMA type)
        $atimMenu = $this->inactivateStorageCoordinateMenu($atimMenu);
        
        $this->set('atimMenu', $atimMenu);
        
        $atimMenuVariables = array();
        $atimMenuVariables['TmaSlide.id'] = $tmaSlideId;
        $atimMenuVariables['StorageMaster.id'] = $tmaBlockStorageMasterId;
        $this->set('atimMenuVariables', $atimMenuVariables);
        
        // Set structure
        $this->Structures->set('tma_slides');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $tmaBlockStorageMasterId
     * @param $tmaSlideId
     * @param int $fromSlidePage
     */
    public function edit($tmaBlockStorageMasterId, $tmaSlideId, $fromSlidePage = 0)
    {
        // MANAGE DATA
        
        // Get the storage data
        $storageData = $this->StorageMaster->getOrRedirect($tmaBlockStorageMasterId);
        
        // Verify storage is tma block
        if (! $storageData['StorageControl']['is_tma_block']) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get the tma slide data
        $tmaSlideData = $this->TmaSlide->find('first', array(
            'conditions' => array(
                'TmaSlide.id' => $tmaSlideId,
                'TmaSlide.tma_block_storage_master_id' => $tmaBlockStorageMasterId
            )
        ));
        if (empty($tmaSlideData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $this->set('fromSlidePage', $fromSlidePage);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object. Needed to disable menu options based on storage type
        $atimMenu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
        
        // Inactivate Storage Coordinate Menu (unpossible for TMA type)
        $atimMenu = $this->inactivateStorageCoordinateMenu($atimMenu);
        
        $this->set('atimMenu', $atimMenu);
        
        $atimMenuVariables = array();
        $atimMenuVariables['TmaSlide.id'] = $tmaSlideId;
        $atimMenuVariables['StorageMaster.id'] = $tmaBlockStorageMasterId;
        $this->set('atimMenuVariables', $atimMenuVariables);
        
        // Set structure
        $this->Structures->set('tma_slides');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            
            $tmaSlideData['FunctionManagement']['recorded_storage_selection_label'] = $this->StorageMaster->getStorageLabelAndCodeForDisplay(array(
                'StorageMaster' => $tmaSlideData['StorageMaster']
            ));
            $tmaSlideData['FunctionManagement']['autocomplete_tma_slide_study_summary_id'] = $this->StudySummary->getStudyDataAndCodeForDisplay(array(
                'StudySummary' => array(
                    'id' => $tmaSlideData['TmaSlide']['study_summary_id']
                )
            ));
            $this->request->data = $tmaSlideData;
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            // Update data
            
            // Validates data
            $submittedDataValidates = true;
            
            $this->request->data['TmaSlide']['id'] = $tmaSlideId;
            $this->TmaSlide->set($this->request->data);
            if (! $this->TmaSlide->validates()) {
                $submittedDataValidates = false;
            }
            
            // Reste data to get position data
            $this->request->data = $this->TmaSlide->data;
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                // Save tma slide data
                $this->TmaSlide->addWritableField(array(
                    'storage_master_id'
                ));
                $this->TmaSlide->id = $tmaSlideId;
                if ($this->TmaSlide->save($this->request->data, false)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/StorageLayout/TmaSlides/detail/' . $tmaBlockStorageMasterId . '/' . $tmaSlideId);
                }
            }
        }
    }

    public function editInBatch()
    {
        // MANAGE DATA
        $this->setUrlToCancel();
        $urlToCancel = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        $initialDisplay = false;
        $criteria = array(
            'TmaSlide.id' => '-1'
        );
        $tmaSlideIds = array();
        $initialSlideData = array();
        if (isset($this->request->data['TmaSlide']['id'])) {
            // User launched an action from the DataBrowser or a Report Form
            if ($this->request->data['TmaSlide']['id'] == 'all' && isset($this->request->data['node'])) {
                // The displayed elements number was higher than the databrowser_and_report_results_display_limit
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $this->request->data['TmaSlide']['id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
            $tmaSlideIds = array_filter($this->request->data['TmaSlide']['id']);
            $criteria = array(
                'TmaSlide.id' => $tmaSlideIds
            );
            $initialDisplay = true;
        } elseif (! empty($this->request->data)) {
            // User submit data of the TmaSlide.editInBatch() form
            $tmaSlideIds = explode(',', $this->request->data['tma_slide_ids']);
        } else {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel);
            return;
        }
        unset($this->request->data['tma_slide_ids']);
        
        if ($initialDisplay) {
            $initialSlideData = $this->TmaSlide->find('all', array(
                'conditions' => $criteria,
                'order' => 'TmaSlide.barcode ASC'
            ));
            if (empty($initialSlideData)) {
                $this->atimFlashWarning(__('no slide to update'), $urlToCancel);
                return;
            }
            if ($tmaSlideIds)
                $this->TmaSlide->sortForDisplay($initialSlideData, $tmaSlideIds);
            $displayLimit = Configure::read('TmaSlideCreation_processed_items_limit');
            if (sizeof($initialSlideData) > $displayLimit) {
                $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", $urlToCancel);
                return;
            }
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('urlToCancel', $urlToCancel);
        $this->set('tmaSlideIds', implode(',', $tmaSlideIds));
        
        // Set menu
        $this->set('atimMenu', $this->Menus->get('/StorageLayout/StorageMasters/search/'));
        $this->set('atimMenuVariables', array());
        
        // Set structure
        $this->Structures->set('tma_slides,tma_blocks_for_slide_creation');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // SAVE DATA
        
        if ($initialDisplay) {
            $this->request->data = $initialSlideData;
            foreach ($this->request->data as &$newSlidesData) {
                $newSlidesData['FunctionManagement']['recorded_storage_selection_label'] = $this->StorageMaster->getStorageLabelAndCodeForDisplay(array(
                    'StorageMaster' => $newSlidesData['StorageMaster']
                ));
                $newSlidesData['FunctionManagement']['autocomplete_tma_slide_study_summary_id'] = $this->StudySummary->getStudyDataAndCodeForDisplay(array(
                    'StudySummary' => array(
                        'id' => $newSlidesData['TmaSlide']['study_summary_id']
                    )
                ));
            }
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            
            // Launch validation
            $submittedDataValidates = true;
            
            $errors = array();
            $recordCounter = 0;
            $updatedTmaSlideIds = array();
            foreach ($this->request->data as $key => &$newStudiedTma) {
                $recordCounter ++;
                // Get id
                if (! isset($newStudiedTma['TmaSlide']['id']))
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $updatedTmaSlideIds[] = $newStudiedTma['TmaSlide']['id'];
                // Launch Slide validation
                $this->TmaSlide->data = array();
                $this->TmaSlide->set($newStudiedTma);
                $submittedDataValidates = ($this->TmaSlide->validates()) ? $submittedDataValidates : false;
                foreach ($this->TmaSlide->validationErrors as $field => $msgs) {
                    $msgs = is_array($msgs) ? $msgs : array(
                        $msgs
                    );
                    foreach ($msgs as $msg)
                        $errors['TmaSlide'][$field][$msg][] = $recordCounter;
                }
                // Reset data
                $newStudiedTma = $this->TmaSlide->data;
            }
            
            if ($this->TmaSlide->find('count', array(
                'conditions' => array(
                    'TmaSlide.id' => $updatedTmaSlideIds
                ),
                'recursive' => - 1
            )) != sizeof($updatedTmaSlideIds)) {
                // In case a TMA slide has just been deleted by another user before we submitted updated data
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                
                // Launch save process
                
                AppModel::acquireBatchViewsUpdateLock();
                
                $this->TmaSlide->addWritableField(array(
                    'storage_master_id'
                ));
                $this->TmaSlide->writableFieldsMode = 'editgrid';
                foreach ($this->request->data as $tmaData) {
                    // Save data
                    $this->TmaSlide->data = array();
                    $this->TmaSlide->id = $tmaData['TmaSlide']['id'];
                    if (! $this->TmaSlide->save($tmaData['TmaSlide'], false)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                // Creat Batchset then redirect
                
                $batchIds = $tmaSlideIds;
                $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                $batchSetData = array(
                    'BatchSet' => array(
                        'datamart_structure_id' => $datamartStructure->getIdByModelName('TmaSlide'),
                        'flag_tmp' => true
                    )
                );
                $batchSetModel->checkWritableFields = false;
                $batchSetModel->saveWithIds($batchSetData, $batchIds);
                $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId());
            } else {
                // Set error message
                foreach ($errors as $model => $fieldMessages) {
                    $this->{$model}->validationErrors = array();
                    foreach ($fieldMessages as $field => $messages) {
                        foreach ($messages as $message => $linesNbr) {
                            if (! array_key_exists($field, $this->{$model}->validationErrors)) {
                                $this->{$model}->validationErrors[$field][] = __($message) . ' - ' . str_replace('%s', implode(',', $linesNbr), __('see line %s'));
                            } else {
                                $this->{$model}->validationErrors[][] = __($message) . ' - ' . str_replace('%s', implode(',', $linesNbr), __('see line %s'));
                            }
                        }
                    }
                }
            }
        }
    }

    /**
     *
     * @param $tmaBlockStorageMasterId
     * @param $tmaSlideId
     */
    public function delete($tmaBlockStorageMasterId, $tmaSlideId)
    {
        // MANAGE DATA
        
        // Get the storage data
        $storageData = $this->StorageMaster->getOrRedirect($tmaBlockStorageMasterId);
        
        // Verify storage is tma block
        if (! $storageData['StorageControl']['is_tma_block']) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get the tma slide data
        $tmaSlideData = $this->TmaSlide->find('first', array(
            'conditions' => array(
                'TmaSlide.id' => $tmaSlideId,
                'TmaSlide.tma_block_storage_master_id' => $tmaBlockStorageMasterId
            )
        ));
        if (empty($tmaSlideData)) {
            $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->TmaSlide->allowDeletion($tmaSlideId);
        
        // CUSTOM CODE
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            // Delete tma slide
            if ($this->TmaSlide->atimDelete($tmaSlideId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/StorageLayout/StorageMasters/detail/' . $tmaBlockStorageMasterId);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/StorageLayout/TmaSlides/detail/' . $tmaBlockStorageMasterId . '/' . $tmaSlideId);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/StorageLayout/TmaSlides/detail/' . $tmaBlockStorageMasterId . '/' . $tmaSlideId);
        }
    }

    public function autocompleteBarcode()
    {
        
        // layout = ajax to avoid printing layout
        $this->layout = 'ajax';
        // debug = 0 to avoid printing debug queries that would break the javascript array
        Configure::write('debug', 0);
        
        $results = array();
        
        // query the database
        $term = str_replace(array(
            "\\",
            '%',
            '_'
        ), array(
            "\\\\",
            '\%',
            '\_'
        ), $_GET['term']);
        $terms = array();
        $termsUses = array();
        foreach (explode(' ', $term) as $keyWord) {
            $terms[] = array(
                "TmaSlide.barcode LIKE" => '%' . $keyWord . '%'
            );
        }
        
        $conditions = array(
            'AND' => $terms
        );
        $fields = 'TmaSlide.barcode';
        $order = 'TmaSlide.barcode ASC';
        $joins = array();
        
        $hookLink = $this->hook('query_args');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $results = $this->TmaSlide->find('all', array(
            'conditions' => $conditions,
            'fields' => $fields,
            'order' => $order,
            'joins' => $joins,
            'limit' => 10,
            'recursive' => - 1
        ));
        
        // build javascript textual array
        $result = "";
        foreach ($results as $dataUnit) {
            $result .= '"' . str_replace(array(
                '\\',
                '"'
            ), array(
                '\\\\',
                '\"'
            ), $dataUnit['TmaSlide']['barcode']) . '", ';
        }
        if (sizeof($result) > 0) {
            $result = substr($result, 0, - 2);
        }
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->set('result', "[" . $result . "]");
    }

    public function autocompleteTmaSlideImmunochemistry()
    {
        
        // layout = ajax to avoid printing layout
        $this->layout = 'ajax';
        // debug = 0 to avoid printing debug queries that would break the javascript array
        Configure::write('debug', 0);
        
        $results = array();
        
        // query the database
        $term = str_replace(array(
            "\\",
            '%',
            '_'
        ), array(
            "\\\\",
            '\%',
            '\_'
        ), $_GET['term']);
        $terms = array();
        $termsUses = array();
        foreach (explode(' ', $term) as $keyWord) {
            $terms[] = array(
                "TmaSlide.immunochemistry LIKE" => '%' . $keyWord . '%'
            );
            $termsUses[] = array(
                "TmaSlideUse.immunochemistry LIKE" => '%' . $keyWord . '%'
            );
        }
        
        $conditions = array(
            'AND' => $terms
        );
        $fields = 'TmaSlide.immunochemistry';
        $order = 'TmaSlide.immunochemistry ASC';
        $joins = array();
        
        $conditionsUses = array(
            'AND' => $termsUses
        );
        $fieldsUses = 'TmaSlideUse.immunochemistry';
        $orderUses = 'TmaSlideUse.immunochemistry ASC';
        $joinsUses = array();
        
        $hookLink = $this->hook('query_args');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $data = $this->TmaSlide->find('all', array(
            'conditions' => $conditions,
            'fields' => $fields,
            'order' => $order,
            'joins' => $joins,
            'limit' => 10,
            'recursive' => - 1
        ));
        
        foreach ($data as $dataUnit)
            $results[$dataUnit['TmaSlide']['immunochemistry']] = $dataUnit['TmaSlide']['immunochemistry'];
        
        $data = $this->TmaSlideUse->find('all', array(
            'conditions' => $conditionsUses,
            'fields' => $fieldsUses,
            'order' => $orderUses,
            'joins' => $joinsUses,
            'limit' => 10,
            'recursive' => - 1
        ));
        
        foreach ($data as $dataUnit)
            $results[$dataUnit['TmaSlideUse']['immunochemistry']] = $dataUnit['TmaSlideUse']['immunochemistry'];
        
        ksort($results);
        
        // build javascript textual array
        $result = "";
        foreach ($results as $dataUnit) {
            $result .= '"' . str_replace(array(
                '\\',
                '"'
            ), array(
                '\\\\',
                '\"'
            ), $dataUnit) . '", ';
        }
        if (sizeof($result) > 0) {
            $result = substr($result, 0, - 2);
        }
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $this->set('result', "[" . $result . "]");
    }
}