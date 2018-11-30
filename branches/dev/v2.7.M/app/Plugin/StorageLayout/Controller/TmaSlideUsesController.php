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
 * Class TmaSlideUsesController
 */
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
    /**
     *
     * @param null $tmaSlideId
     */
    public function add($tmaSlideId = null)
    {
        // GET DATA
        $initialDisplay = false;
        $tmaSlideIds = array();
        
        $this->setUrlToCancel();
        $urlToCancel = $this->request->data['url_to_cancel'];
        unset($this->request->data['url_to_cancel']);
        
        if ($tmaSlideId != null) {
            // User is workning on a tma block
            $tmaSlideIds = array(
                $tmaSlideId
            );
            if (empty($this->request->data))
                $initialDisplay = true;
        } elseif (isset($this->request->data['TmaSlide']['id'])) {
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
            $initialDisplay = true;
        } elseif (! empty($this->request->data)) {
            // User submit data of the TmaSlide.add() form
            $tmaSlideIds = array_keys($this->request->data);
        } else {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel);
            return;
        }
        
        // Get TMA Blocks data
        
        $tmaSlides = $this->TmaSlide->find('all', array(
            'conditions' => array(
                'TmaSlide.id' => $tmaSlideIds
            ),
            'recursive' => 0
        ));
        if ($initialDisplay)
            $this->TmaSlide->sortForDisplay($tmaSlides, $tmaSlideIds);
        $tmaSlidesFromId = array();
        foreach ($tmaSlides as &$tmaSlideData) {
            $tmaSlidesFromId[$tmaSlideData['TmaSlide']['id']] = $tmaSlideData;
        }
        
        $displayLimit = Configure::read('TmaSlideCreation_processed_items_limit');
        if (sizeof($tmaSlidesFromId) > $displayLimit) {
            $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", $urlToCancel);
            return;
        }
        if (sizeof($tmaSlidesFromId) != sizeof($tmaSlideIds))
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            
            // SET MENU AND STRUCTURE DATA
        
        $this->set('urlToCancel', $urlToCancel);
        $this->set('tmaSlideId', $tmaSlideId);
        
        // Set menu
        if ($tmaSlideId != null) {
            // Get the current menu object. Needed to disable menu options based on storage type
            $atimMenu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
            // Inactivate Storage Coordinate Menu (unpossible for TMA type)
            $this->set('atimMenu', $this->inactivateStorageCoordinateMenu($atimMenu));
            // Variables
            $this->set('atimMenuVariables', array(
                'StorageMaster.id' => $tmaSlidesFromId[$tmaSlideId]['Block']['id']
            ));
        } else {
            $this->set('atimMenu', $this->Menus->get('/StorageLayout/StorageMasters/search/'));
            $this->set('atimMenuVariables', array());
        }
        
        // Set structure
        $this->Structures->set('tma_slide_uses');
        $this->Structures->set(($tmaSlideId ? '' : 'tma_blocks_for_slide_creation,') . 'tma_slides_for_use_creation', 'tma_slides_atim_structure');
        
        // MANAGE DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($initialDisplay) {
            
            $this->request->data = array();
            foreach ($tmaSlides as $tmaSlide) {
                $this->request->data[] = array(
                    'parent' => $tmaSlide,
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
            $tmaSlideUsesToCreate = array();
            $line = 0;
            
            $recordCounter = 0;
            foreach ($previousData as $studiedTmaSlideId => $dataUnit) {
                $recordCounter ++;
                
                if (! array_key_exists($studiedTmaSlideId, $tmaSlidesFromId))
                    $this->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $tmaSlideData = $tmaSlidesFromId[$studiedTmaSlideId];
                
                unset($dataUnit['Block']);
                unset($dataUnit['TmaSlide']);
                
                if (empty($dataUnit)) {
                    $errors['']['you must create at least one use for each tma slide'][$recordCounter] = $recordCounter;
                }
                foreach ($dataUnit as &$useDataUnit) {
                    $useDataUnit['TmaSlideUse']['tma_slide_id'] = $studiedTmaSlideId;
                    $this->TmaSlideUse->data = null;
                    $this->TmaSlideUse->set($useDataUnit);
                    if (! $this->TmaSlideUse->validates()) {
                        foreach ($this->TmaSlideUse->validationErrors as $field => $msgs) {
                            $msgs = is_array($msgs) ? $msgs : array(
                                $msgs
                            );
                            foreach ($msgs as $msg)
                                $errors[$field][$msg][$recordCounter] = $recordCounter;
                        }
                    }
                    $useDataUnit = $this->TmaSlideUse->data;
                }
                $tmaSlideUsesToCreate = array_merge($tmaSlideUsesToCreate, $dataUnit);
                
                $this->request->data[] = array(
                    'parent' => $tmaSlideData,
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
                $this->TmaSlideUse->addWritableField(array(
                    'tma_slide_id'
                ));
                $this->TmaSlideUse->writableFieldsMode = 'addgrid';
                $this->TmaSlideUse->saveAll($tmaSlideUsesToCreate, array(
                    'validate' => false
                ));
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                if ($tmaSlideId != null) {
                    $this->atimFlash(__('your data has been saved'), '/StorageLayout/TmaSlides/detail/' . $tmaSlidesFromId[$tmaSlideId]['TmaSlide']['tma_block_storage_master_id'] . '/' . $tmaSlideId);
                } else {
                    // batch
                    $lastId = $this->TmaSlideUse->getLastInsertId();
                    $batchIds = range($lastId - count($tmaSlideUsesToCreate) + 1, $lastId);
                    $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                    $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                    $batchSetData = array(
                        'BatchSet' => array(
                            'datamart_structure_id' => $datamartStructure->getIdByModelName('TmaSlideUse'),
                            'flag_tmp' => true
                        )
                    );
                    $batchSetModel->checkWritableFields = false;
                    $batchSetModel->saveWithIds($batchSetData, $batchIds);
                    $this->atimFlash(__('your data has been saved'), '/Datamart/BatchSets/listall/' . $batchSetModel->getLastInsertId());
                }
            } else {
                $this->TmaSlideUse->validationErrors = array();
                foreach ($errors as $field => $msgAndLines) {
                    foreach ($msgAndLines as $msg => $lines) {
                        $this->TmaSlideUse->validationErrors[$field][] = __($msg) . (($recordCounter != 1) ? ' - ' . str_replace('%s', implode(",", $lines), __('see # %s')) : '');
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
    public function listAll($tmaBlockStorageMasterId, $tmaSlideId)
    {
        // MANAGE DATA
        
        // Get the storage data
        $tmaSlideData = $this->TmaSlide->getOrRedirect($tmaSlideId);
        if ($tmaSlideData['TmaSlide']['tma_block_storage_master_id'] != $tmaBlockStorageMasterId) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get TMA slide use list
        $this->request->data = $this->paginate($this->TmaSlideUse, array(
            'TmaSlideUse.tma_slide_id' => $tmaSlideId
        ));
        
        // Set structure
        $this->Structures->set('tma_slide_uses');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $tmaSlideUseId
     */
    public function edit($tmaSlideUseId)
    {
        // MANAGE DATA
        
        // Get data
        $tmaSlideUseData = $this->TmaSlideUse->getOrRedirect($tmaSlideUseId);
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        // Get the current menu object. Needed to disable menu options based on storage type
        $atimMenu = $this->Menus->get('/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%');
        
        // Inactivate Storage Coordinate Menu (unpossible for TMA type)
        $atimMenu = $this->inactivateStorageCoordinateMenu($atimMenu);
        
        $this->set('atimMenu', $atimMenu);
        
        $atimMenuVariables = array();
        $atimMenuVariables['TmaSlideUse.id'] = $tmaSlideUseId;
        $atimMenuVariables['TmaSlide.id'] = $tmaSlideUseData['TmaSlide']['id'];
        $atimMenuVariables['StorageMaster.id'] = $tmaSlideUseData['TmaSlide']['tma_block_storage_master_id'];
        $this->set('atimMenuVariables', $atimMenuVariables);
        
        // Set structure
        $this->Structures->set('tma_slide_uses');
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            
            $tmaSlideUseData['FunctionManagement']['autocomplete_tma_slide_use_study_summary_id'] = $this->StudySummary->getStudyDataAndCodeForDisplay(array(
                'StudySummary' => array(
                    'id' => $tmaSlideUseData['TmaSlideUse']['study_summary_id']
                )
            ));
            $this->request->data = $tmaSlideUseData;
            
            $hookLink = $this->hook('initial_display');
            if ($hookLink) {
                require ($hookLink);
            }
        } else {
            // Update data
            
            // Validates data
            $submittedDataValidates = true;
            
            $this->request->data['TmaSlideUse']['id'] = $tmaSlideUseId;
            $this->TmaSlideUse->set($this->request->data);
            if (! $this->TmaSlideUse->validates()) {
                $submittedDataValidates = false;
            }
            
            // Reste data to get position data
            $this->request->data = $this->TmaSlideUse->data;
            
            // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                // Save tma slide data
                $this->TmaSlideUse->id = $tmaSlideUseId;
                if ($this->TmaSlideUse->save($this->request->data, false)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/StorageLayout/TmaSlides/detail/' . $tmaSlideUseData['TmaSlide']['tma_block_storage_master_id'] . '/' . $tmaSlideUseData['TmaSlide']['id']);
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
            'TmaSlideUse.id' => '-1'
        );
        $tmaSlideUseIds = array();
        $initialSlideUsesData = array();
        if (isset($this->request->data['TmaSlideUse']['id'])) {
            // User launched an action from the DataBrowser or a Report Form
            if ($this->request->data['TmaSlideUse']['id'] == 'all' && isset($this->request->data['node'])) {
                // The displayed elements number was higher than the databrowser_and_report_results_display_limit
                $this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
                $browsingResult = $this->BrowsingResult->find('first', array(
                    'conditions' => array(
                        'BrowsingResult.id' => $this->request->data['node']['id']
                    )
                ));
                $this->request->data['TmaSlideUse']['id'] = explode(",", $browsingResult['BrowsingResult']['id_csv']);
            }
            $tmaSlideUseIds = array_filter($this->request->data['TmaSlideUse']['id']);
            $criteria = array(
                'TmaSlideUse.id' => $tmaSlideUseIds
            );
            $initialDisplay = true;
        } elseif (! empty($this->request->data)) {
            // User submit data of the TmaSlideUse.editInBatch() form
            $tmaSlideUseIds = explode(',', $this->request->data['tma_slide_use_ids']);
        } else {
            $this->atimFlashError((__('you have been redirected automatically') . ' (#' . __LINE__ . ')'), $urlToCancel);
            return;
        }
        unset($this->request->data['tma_slide_use_ids']);
        
        if ($initialDisplay) {
            $initialSlideUsesData = $this->TmaSlideUse->find('all', array(
                'conditions' => $criteria,
                'order' => 'TmaSlideUse.date ASC',
                'recursive' => 2
            ));
            if (empty($initialSlideUsesData)) {
                $this->atimFlashWarning(__('no slide use to update'), $urlToCancel);
                return;
            }
            if ($tmaSlideUseIds)
                $this->TmaSlideUse->sortForDisplay($initialSlideUsesData, $tmaSlideUseIds);
            $displayLimit = Configure::read('TmaSlideCreation_processed_items_limit');
            if (sizeof($initialSlideUsesData) > $displayLimit) {
                $this->atimFlashWarning(__("batch init - number of submitted records too big") . " (>$displayLimit)", $urlToCancel);
                return;
            }
            foreach ($initialSlideUsesData as &$tmpData)
                $tmpData['Block'] = $tmpData['TmaSlide']['Block'];
        }
        
        // MANAGE FORM, MENU AND ACTION BUTTONS
        
        $this->set('urlToCancel', $urlToCancel);
        $this->set('tmaSlideUseIds', implode(',', $tmaSlideUseIds));
        
        // Set menu
        $this->set('atimMenu', $this->Menus->get('/StorageLayout/StorageMasters/search/'));
        $this->set('atimMenuVariables', array());
        
        // Set structure
        $this->Structures->set('tma_slide_uses,tma_slides_for_use_creation,tma_blocks_for_slide_creation');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        // SAVE DATA
        
        if ($initialDisplay) {
            $this->request->data = $initialSlideUsesData;
            foreach ($this->request->data as &$newSlideUseData) {
                $newSlideUseData['FunctionManagement']['autocomplete_tma_slide_use_study_summary_id'] = $this->StudySummary->getStudyDataAndCodeForDisplay(array(
                    'StudySummary' => array(
                        'id' => $newSlideUseData['TmaSlideUse']['study_summary_id']
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
            $updatedTmaSlideUseIds = array();
            foreach ($this->request->data as &$newStudiedTmaUse) {
                $recordCounter ++;
                // Get id
                if (! isset($newStudiedTmaUse['TmaSlideUse']['id']))
                    $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $updatedTmaSlideUseIds[] = $newStudiedTmaUse['TmaSlideUse']['id'];
                // Check date should be tested or not
                $date = null;
                if (! is_array($newStudiedTmaUse['TmaSlideUse']['date'])) {
                    $date = $newStudiedTmaUse['TmaSlideUse']['date'];
                    unset($newStudiedTmaUse['TmaSlideUse']['date']);
                }
                // Launch Slide validation
                $this->TmaSlideUse->data = array();
                $this->TmaSlideUse->set($newStudiedTmaUse);
                $submittedDataValidates = ($this->TmaSlideUse->validates()) ? $submittedDataValidates : false;
                foreach ($this->TmaSlideUse->validationErrors as $field => $msgs) {
                    $msgs = is_array($msgs) ? $msgs : array(
                        $msgs
                    );
                    foreach ($msgs as $msg)
                        $errors['TmaSlideUse'][$field][$msg][] = $recordCounter;
                }
                // Reset data
                $newStudiedTmaUse = $this->TmaSlideUse->data;
                if (! is_null($date))
                    $newStudiedTmaUse['TmaSlideUse']['date'] = $date;
            }
            
            if ($this->TmaSlideUse->find('count', array(
                'conditions' => array(
                    'TmaSlideUse.id' => $updatedTmaSlideUseIds
                ),
                'recursive' => - 1
            )) != sizeof($updatedTmaSlideUseIds)) {
                // In case a TMA slide use has just been deleted by another user before we submitted updated data
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                
                // Launch save process
                
                AppModel::acquireBatchViewsUpdateLock();
                
                $this->TmaSlideUse->writableFieldsMode = 'editgrid';
                foreach ($this->request->data as $tmaData) {
                    // Save data
                    $this->TmaSlideUse->data = array();
                    $this->TmaSlideUse->id = $tmaData['TmaSlideUse']['id'];
                    if (! $this->TmaSlideUse->save($tmaData['TmaSlideUse'], false)) {
                        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                
                AppModel::releaseBatchViewsUpdateLock();
                
                // Creat Batchset then redirect
                
                $batchIds = $tmaSlideUseIds;
                $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
                $batchSetModel = AppModel::getInstance('Datamart', 'BatchSet', true);
                $batchSetData = array(
                    'BatchSet' => array(
                        'datamart_structure_id' => $datamartStructure->getIdByModelName('TmaSlideUse'),
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
     * @param $tmaSlideUseId
     */
    public function delete($tmaSlideUseId)
    {
        // MANAGE DATA
        
        // Get the use data
        $tmaSlideUseData = $this->TmaSlideUse->getOrRedirect($tmaSlideUseId);
        
        // Check deletion is allowed
        $arrAllowDeletion = $this->TmaSlideUse->allowDeletion($tmaSlideUseId);
        
        // CUSTOM CODE
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if ($arrAllowDeletion['allow_deletion']) {
            // Delete tma slide Use
            if ($this->TmaSlideUse->atimDelete($tmaSlideUseId)) {
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), '/StorageLayout/TmaSlides/detail/' . $tmaSlideUseData['TmaSlide']['tma_block_storage_master_id'] . '/' . $tmaSlideUseData['TmaSlide']['id']);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), '/StorageLayout/TmaSlides/detail/' . $tmaSlideUseData['TmaSlide']['tma_block_storage_master_id'] . '/' . $tmaSlideUseData['TmaSlide']['id']);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/StorageLayout/TmaSlides/detail/' . $tmaSlideUseData['TmaSlide']['tma_block_storage_master_id'] . '/' . $tmaSlideUseData['TmaSlide']['id']);
        }
    }
}