<?php

/**
 * Class StorageControlsController
 */
class StorageControlsController extends AdministrateAppController
{

    public $components = array();

    public $uses = array(
        'StorageLayout.StorageMaster',
        'Administrate.StorageCtrl'
    );

    public $paginate = array(
        'StorageCtrl' => array(
            'order' => 'StorageCtrl.storage_type ASC'
        )
    );

    public function listAll()
    {
        $this->Structures->set('storage_controls,storage_control_type_and_translations');
        $this->request->data = $this->paginate($this->StorageCtrl, array());
        
        $this->StorageCtrl->validatesAllStorageControls();
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     *
     * @param $storageCategory
     * @param null $duplicatedParentStorageControlId
     */
    public function add($storageCategory, $duplicatedParentStorageControlId = null)
    {
        if ($duplicatedParentStorageControlId && empty($this->request->data)) {
            $this->request->data = $this->StorageCtrl->getOrRedirect($duplicatedParentStorageControlId);
            $this->request->data['StorageCtrl']['storage_type'] = '';
            $this->request->data['StorageCtrl']['storage_type_en'] = '';
            $this->request->data['StorageCtrl']['storage_type_fr'] = '';
            $storageCategory = $this->StorageCtrl->getStorageCategory($this->request->data);
        }
        $this->set('storageCategory', $storageCategory);
        $this->set('atimMenu', $this->Menus->get('/Administrate/StorageControls/listAll/'));
        $this->Structures->set($this->StorageCtrl->getStructure($storageCategory) . ',storage_control_type_and_translations');
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! $duplicatedParentStorageControlId && ! empty($this->request->data)) {
            // Set system value
            $this->request->data['StorageCtrl']['databrowser_label'] = 'custom#storage types#' . $this->request->data['StorageCtrl']['storage_type'];
            $this->request->data['StorageCtrl']['flag_active'] = '0';
            $this->request->data['StorageCtrl']['is_tma_block'] = ($storageCategory == 'tma') ? '1' : '0';
            $this->request->data['StorageCtrl']['detail_tablename'] = ($storageCategory == 'tma') ? 'std_tma_blocks' : 'std_customs';
            $detailFormAlias = array();
            if ($storageCategory == 'tma')
                $detailFormAlias[] = 'std_tma_blocks';
            $this->request->data['StorageCtrl']['detail_form_alias'] = implode(',', $detailFormAlias);
            $this->StorageCtrl->addWritableField(array(
                'databrowser_label',
                'flag_active',
                'is_tma_block',
                'detail_tablename',
                'detail_form_alias'
            ));
            
            $submittedDataValidates = true;
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                $this->StorageCtrl->id = null;
                if ($this->StorageCtrl->save($this->request->data)) {
                    $storageControlId = $this->StorageCtrl->getLastInsertId();
                    
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    
                    $this->atimFlash(__('your data has been saved'), '/Administrate/StorageControls/seeStorageLayout/' . $storageControlId);
                }
            }
        }
    }

    /**
     *
     * @param $storageControlId
     */
    public function edit($storageControlId)
    {
        $storageControlData = $this->StorageCtrl->getOrRedirect($storageControlId);
        $dataCanBeModified = true;
        $addWarningMsg = null;
        if ($storageControlData['StorageCtrl']['flag_active']) {
            $addWarningMsg = __('you are not allowed to work on active storage type');
            $dataCanBeModified = false;
        } elseif ($this->StorageMaster->find('count', array(
            'conditions' => array(
                'StorageMaster.storage_control_id' => $storageControlId,
                'StorageMaster.deleted' => array(
                    '0',
                    '1'
                )
            )
        ))) {
            $addWarningMsg = __('this storage type has already been used to build a storage in the past - properties can not be changed anymore');
            $dataCanBeModified = false;
        }
        
        $storageCategory = $this->StorageCtrl->getStorageCategory($storageControlData);
        $this->set('storageCategory', $storageCategory);
        $this->set('atimMenu', $this->Menus->get('/Administrate/StorageControls/listAll/'));
        $this->Structures->set('storage_control_type_and_translations' . ($dataCanBeModified ? ',' . $this->StorageCtrl->getStructure($storageCategory) : ''));
        $this->set('atimMenuVariables', array(
            'StorageCtrl.id' => $storageControlId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
            if ($addWarningMsg) {
                AppController::addWarningMsg($addWarningMsg);
            }
            $this->request->data = $storageControlData;
        } else {
            // Validates and set additional data
            $submittedDataValidates = true;
            
            if ($this->request->data['StorageCtrl']['storage_type'] != $storageControlData['StorageCtrl']['storage_type'])
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                
                // CUSTOM CODE: PROCESS SUBMITTED DATA BEFORE SAVE
            
            $hookLink = $this->hook('presave_process');
            if ($hookLink) {
                require ($hookLink);
            }
            
            if ($submittedDataValidates) {
                // Save storage data
                $this->StorageCtrl->id = $storageControlId;
                $this->StorageCtrl->data = array();
                if ($this->StorageCtrl->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Administrate/StorageControls/seeStorageLayout/' . $storageControlId);
                }
            } elseif ($addWarningMsg) {
                AppController::addWarningMsg($addWarningMsg);
            }
        }
    }

    /**
     *
     * @param $storageControlId
     * @param string $redirectTo
     */
    public function changeActiveStatus($storageControlId, $redirectTo = 'listAll')
    {
        $storageControlData = $this->StorageCtrl->getOrRedirect($storageControlId);
        
        $nextUrl = 'javascript:history.go(-1)';
        // if ($redirectTo == 'listAll') {
        // if (! strpos($nextUrl, 'StorageControls/listAll')) {
        // $nextUrl = '/Administrate/StorageControls/listAll/';
        // }
        // } else {
        // $nextUrl = '/Administrate/StorageControls/seeStorageLayout/' . $storageControlId;
        // }
        
        $newData = array();
        if ($storageControlData['StorageCtrl']['flag_active']) {
            // Check no Storage Master use it
            $existingStorageCount = $this->StorageMaster->find('count', array(
                'conditions' => array(
                    'StorageMaster.storage_control_id' => $storageControlId
                )
            ));
            if ($existingStorageCount) {
                $this->atimFlashError(__('this storage type has already been used to build a storage - active status can not be changed'), $nextUrl);
                return;
            }
            $newData['StorageCtrl']['flag_active'] = '0';
        } else {
            $newData['StorageCtrl']['flag_active'] = '1';
        }
        $this->StorageCtrl->addWritableField(array(
            'flag_active'
        ));
        
        $this->StorageCtrl->data = array();
        $this->StorageCtrl->id = $storageControlId;
        if ($this->StorageCtrl->save($newData)) {
            $this->atimFlash(__('your data has been updated'), $nextUrl);
        }
    }

    /**
     * Display the content of a storage into a layout.
     *
     * @param $storageControlId
     * @internal param Id $storageMasterId of the studied storage.* of the studied storage.
     * @internal param $isAjax : Tells
     *           wheter the request has to be treated as ajax
     *           query (required to counter issues in Chrome 15 back/forward button on the
     *           page and Opera 11.51 first ajax query that is not recognized as such)
     *          
     * @author N. Luc
     * @since 2007-05-22
     */
    public function seeStorageLayout($storageControlId)
    {
        $storageControlData = $this->StorageCtrl->getOrRedirect($storageControlId);
        $storageCategory = $this->StorageCtrl->getStorageCategory($storageControlData);
        $this->Structures->set('storage_controls,storage_control_type_and_translations');
        
        $lang = ($_SESSION['Config']['language'] == 'eng') ? 'en' : 'fr';
        $translatedStorageType = $storageControlData['StorageCtrl']['storage_type'];
        if (isset($storageControlData['StorageCtrl']['storage_type_' . $lang]) && strlen($storageControlData['StorageCtrl']['storage_type_' . $lang])) {
            $translatedStorageType = $storageControlData['StorageCtrl']['storage_type_' . $lang];
        }
        $this->set('translatedStorageType', $translatedStorageType);
        
        $noLayoutMsg = '';
        if ($storageCategory == 'no_d') {
            $noLayoutMsg = 'no layout exists';
        } elseif ($storageControlData['StorageCtrl']['coord_x_type'] == 'list') {
            $noLayoutMsg = 'custom layout will be built adding coordinates to a created storage';
        }
        $this->set('noLayoutMsg', $noLayoutMsg);
        
        $this->set('storageControlData', $storageControlData);
        
        $this->set('atimMenu', $this->Menus->get('/Administrate/StorageControls/listAll/'));
        $this->set('atimMenuVariables', array(
            'StorageCtrl.id' => $storageControlId
        ));
        
        $this->Structures->set('empty', 'emptyStructure');
    }

    /**
     *
     * @param $storageControlId
     */
    public function delete($storageControlId)
    {
        $storageControlData = $this->StorageCtrl->getOrRedirect($storageControlId);
        $arrAllowDeletion = $this->StorageCtrl->allowDeletion($storageControlId);
        
        // CUSTOM CODE
        
        $hookLink = $this->hook('delete');
        if ($hookLink) {
            require ($hookLink);
        }
        
        $nextUrl = 'javascript:history.go(-1)';
        // if (! strpos($nextUrl, 'StorageControls/listAll')) {
        // $nextUrl = '/Administrate/StorageControls/listAll/';
        // }
        
        if ($arrAllowDeletion['allow_deletion']) {
            $this->StorageCtrl->data = null;
            
            if ($this->StorageCtrl->atimDelete($storageControlId)) {
                
                $hookLink = $this->hook('postsave_process');
                if ($hookLink) {
                    require ($hookLink);
                }
                $this->atimFlash(__('your data has been deleted'), $nextUrl);
            } else {
                $this->atimFlashError(__('error deleting data - contact administrator'), $nextUrl);
            }
        } else {
            $this->atimFlashWarning(__($arrAllowDeletion['msg']), '/Administrate/StorageControls/seeStorageLayout/' . $storageControlId);
        }
    }
}