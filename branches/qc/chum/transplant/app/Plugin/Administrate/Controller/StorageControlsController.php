<?php

/**
 * Class StorageControlsController
 */
class StorageControlsController extends AdministrateAppController
{

    public $components = array();

    public $uses = array(
        'StorageLayout.StorageMaster',
        // 'StorageLayout.StorageControl', //Not able to use this one because save process call afterSave() function of MasterDetailBehavior
        'Administrate.StorageCtrl',
        'StructurePermissibleValuesCustom',
        'StructurePermissibleValuesCustomControl'
    );

    public $paginate = array(
        'StorageCtrl' => array(
            'order' => 'StorageCtrl.storage_type ASC'
        )
    );

    public function listAll()
    {
        $this->Structures->set('storage_controls');
        $this->request->data = $this->paginate($this->StorageCtrl, array());
        
        $this->StorageCtrl->validatesAllStorageControls();
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
    }

    /**
     * @param $storageCategory
     * @param null $duplicatedParentStorageControlId
     */
    public function add($storageCategory, $duplicatedParentStorageControlId = null)
    {
        if ($duplicatedParentStorageControlId && empty($this->request->data)) {
            $this->request->data = $this->StorageCtrl->getOrRedirect($duplicatedParentStorageControlId);
            $this->request->data['StorageCtrl']['storage_type'] = '';
            $storageCategory = $this->StorageCtrl->getStorageCategory($this->request->data);
        }
        $this->set('storageCategory', $storageCategory);
        $this->set('atimMenu', $this->Menus->get('/Administrate/StorageControls/listAll/'));
        $this->Structures->set($this->StorageCtrl->getStructure($storageCategory));
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (! $duplicatedParentStorageControlId && ! empty($this->request->data)) {
            // Set system value
            $this->request->data['StorageCtrl']['databrowser_label'] = 'custom#storage types#' . $this->request->data['StorageCtrl']['storage_type'];
            if (! isset($this->request->data['StorageCtrl']['set_temperature']))
                $this->request->data['StorageCtrl']['set_temperature'] = '0';
            if (! isset($this->request->data['StorageCtrl']['check_conflicts']))
                $this->request->data['StorageCtrl']['check_conflicts'] = '0';
            $this->request->data['StorageCtrl']['flag_active'] = '0';
            $this->request->data['StorageCtrl']['is_tma_block'] = ($storageCategory == 'tma') ? '1' : '0';
            $this->request->data['StorageCtrl']['detail_tablename'] = ($storageCategory == 'tma') ? 'std_tma_blocks' : 'std_customs';
            $detailFormAlias = array();
            if ($storageCategory == 'tma')
                $detailFormAlias[] = 'std_tma_blocks';
            $this->request->data['StorageCtrl']['detail_form_alias'] = implode(',', $detailFormAlias);
            $this->StorageCtrl->addWritableField(array(
                'databrowser_label',
                'set_temperature',
                'check_conflicts',
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
                    $controlData = $this->StructurePermissibleValuesCustomControl->find('first', array(
                        'conditions' => array(
                            'StructurePermissibleValuesCustomControl.name' => 'storage types'
                        )
                    ));
                    if (empty($controlData))
                        $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    $existingValue = $this->StructurePermissibleValuesCustom->find('count', array(
                        'conditions' => array(
                            'StructurePermissibleValuesCustom.control_id' => $controlData['StructurePermissibleValuesCustomControl']['id'],
                            'StructurePermissibleValuesCustom.value' => $this->request->data['StorageCtrl']['storage_type']
                        )
                    ));
                    if (! $existingValue) {
                        $dataUnit = array();
                        $dataUnit['StructurePermissibleValuesCustom']['control_id'] = $controlData['StructurePermissibleValuesCustomControl']['id'];
                        $dataUnit['StructurePermissibleValuesCustom']['value'] = $this->request->data['StorageCtrl']['storage_type'];
                        $this->StructurePermissibleValuesCustom->addWritableField(array(
                            'control_id',
                            'value'
                        ));
                        $this->StructurePermissibleValuesCustom->id = null;
                        if (! $this->StructurePermissibleValuesCustom->save($dataUnit))
                            $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    
                    $this->atimFlash(__('your data has been saved') . '<br>' . __('please use custom drop down list administration tool to add storage type translations'), '/Administrate/StorageControls/seeStorageLayout/' . $storageControlId);
                }
            }
        }
    }

    /**
     * @param $storageControlId
     */
    public function edit($storageControlId)
    {
        $storageControlData = $this->StorageCtrl->getOrRedirect($storageControlId);
        if ($storageControlData['StorageCtrl']['flag_active']) {
            $this->atimFlash(__('you are not allowed to work on active storage type'), 'javascript:history.go(-1)');
            return;
        } elseif ($this->StorageMaster->find('count', array(
            'conditions' => array(
                'StorageMaster.storage_control_id' => $storageControlId,
                'StorageMaster.deleted' => array(
                    '0',
                    '1'
                )
            )
        ))) {
            $this->atimFlash(__('this storage type has already been used to build a storage in the past - properties can not be changed anymore'), 'javascript:history.go(-1)');
            return;
        }
        
        $storageCategory = $this->StorageCtrl->getStorageCategory($storageControlData);
        $this->set('storageCategory', $storageCategory);
        $this->set('atimMenu', $this->Menus->get('/Administrate/StorageControls/listAll/'));
        $this->Structures->set($this->StorageCtrl->getStructure($storageCategory));
        $this->set('atimMenuVariables', array(
            'StorageCtrl.id' => $storageControlId
        ));
        
        // CUSTOM CODE: FORMAT DISPLAY DATA
        
        $hookLink = $this->hook('format');
        if ($hookLink) {
            require ($hookLink);
        }
        
        if (empty($this->request->data)) {
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
                if ($this->StorageCtrl->save($this->request->data)) {
                    $hookLink = $this->hook('postsave_process');
                    if ($hookLink) {
                        require ($hookLink);
                    }
                    $this->atimFlash(__('your data has been updated'), '/Administrate/StorageControls/seeStorageLayout/' . $storageControlId);
                }
            }
        }
    }

    /**
     * @param $storageControlId
     * @param string $redirectTo
     */
    public function changeActiveStatus($storageControlId, $redirectTo = 'listAll')
    {
        $storageControlData = $this->StorageCtrl->getOrRedirect($storageControlId);
        
        $newData = array();
        if ($storageControlData['StorageCtrl']['flag_active']) {
            // Check no Storage Master use it
            $existingStorageCount = $this->StorageMaster->find('count', array(
                'conditions' => array(
                    'StorageMaster.storage_control_id' => $storageControlId
                )
            ));
            if ($existingStorageCount) {
                $this->atimFlash(__('this storage type has already been used to build a storage - active status can not be changed'), 'javascript:history.go(-1)');
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
            $this->atimFlash(__('your data has been updated'), "/Administrate/StorageControls/$redirectTo/$storageControlId");
        }
    }

    /**
     * Display the content of a storage into a layout.
     *
     * @param $storageControlId
     * @internal param Id $storageMasterId of the studied storage.*            of the studied storage.
     * @internal param $isAjax : Tells
     *            wheter the request has to be treated as ajax
     *            query (required to counter issues in Chrome 15 back/forward button on the
     *            page and Opera 11.51 first ajax query that is not recognized as such)
     *
     * @author N. Luc
     * @since 2007-05-22
     */
    public function seeStorageLayout($storageControlId)
    {
        $storageControlData = $this->StorageCtrl->getOrRedirect($storageControlId);
        $storageCategory = $this->StorageCtrl->getStorageCategory($storageControlData);
        $this->Structures->set('storage_controls');
        
        $noLayoutMsg = '';
        if ($storageCategory == 'no_d') {
            $noLayoutMsg = 'no layout exists';
        } elseif ($storageControlData['StorageCtrl']['coord_x_type'] == 'list') {
            $noLayoutMsg = 'custom layout will be built adding coordinates to a created storage';
        }
        $this->set('noLayoutMsg', $noLayoutMsg);
        
        $translatedStorageType = $this->StructurePermissibleValuesCustom->getTranslatedCustomDropdownValue('storage types', $storageControlData['StorageCtrl']['storage_type']);
        $storageControlData['StorageCtrl']['translated_storage_type'] = ($translatedStorageType !== false) ? $translatedStorageType : $storageControlData['StorageCtrl']['storage_type'];
        $this->set('storageControlData', $storageControlData);
        
        $this->set('atimMenu', $this->Menus->get('/Administrate/StorageControls/listAll/'));
        $this->set('atimMenuVariables', array(
            'StorageCtrl.id' => $storageControlId
        ));
        
        $this->Structures->set('empty', 'emptyStructure');
    }
}