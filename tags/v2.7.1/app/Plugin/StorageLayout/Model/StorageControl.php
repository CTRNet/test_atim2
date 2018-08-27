<?php

/**
 * Class StorageControl
 */
class StorageControl extends StorageLayoutAppModel
{

    public $masterFormAlias = 'storagemasters';

    /**
     * Get permissible values array gathering all existing storage types.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    public function getStorageTypePermissibleValues()
    {
        // Build tmp array to sort according to translated value
        $lang = ($_SESSION['Config']['language'] == 'eng') ? 'en' : 'fr';
        $result = array();
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1'
            )
        )) as $storageControl) {
            $translatedStorageType = $storageControl['StorageControl']['storage_type'];
            if (isset($storageControl['StorageControl']['storage_type_' . $lang]) && strlen($storageControl['StorageControl']['storage_type_' . $lang])) {
                $translatedStorageType = $storageControl['StorageControl']['storage_type_' . $lang];
            }
            $result[$storageControl['StorageControl']['id']] = $translatedStorageType;
        }
        natcasesort($result);
        return $result;
    }

    /**
     *
     * @return array
     */
    public function getNonTmaBlockStorageTypePermissibleValues()
    {
        $storageTypesFromId = $this->getStorageTypePermissibleValues();
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1',
                'is_tma_block = 1',
                'id' => array_keys($storageTypesFromId)
            ),
            'fields' => array(
                'StorageControl.id'
            )
        )) as $newTmaBlockStorageControlId) {
            unset($storageTypesFromId[$newTmaBlockStorageControlId['StorageControl']['id']]);
        }
        return $storageTypesFromId;
    }

    /**
     *
     * @return array
     */
    public function getTmaBlockStorageTypePermissibleValues()
    {
        $storageTypesFromId = $this->getStorageTypePermissibleValues();
        $tmaBlockControlIds = array();
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1',
                'is_tma_block = 1',
                'id' => array_keys($storageTypesFromId)
            ),
            'fields' => array(
                'StorageControl.id'
            )
        )) as $newTmaBlockStorageControlId)
            $tmaBlockControlIds[] = $newTmaBlockStorageControlId['StorageControl']['id'];
        foreach ($storageTypesFromId as $storageControlId => $val)
            if (! in_array($storageControlId, $tmaBlockControlIds))
                unset($storageTypesFromId[$storageControlId]);
        return $storageTypesFromId;
    }

    /**
     *
     * @param null $storageMasterId
     * @return array|string
     */
    public function getAddStorageStructureLinks($storageMasterId = null)
    {
        $storageTypesFromId = $this->getStorageTypePermissibleValues();
        $tmaBlockControlIds = array();
        foreach ($this->find('all', array(
            'conditions' => array(
                'flag_active = 1',
                'is_tma_block = 1',
                'id' => array_keys($storageTypesFromId)
            ),
            'fields' => array(
                'StorageControl.id'
            )
        )) as $newTmaBlockStorageControlId)
            $tmaBlockControlIds[] = $newTmaBlockStorageControlId['StorageControl']['id'];
        $addLinks = array();
        foreach ($storageTypesFromId as $storageControlId => $translatedStorageType) {
            $addLinks[$translatedStorageType] = array(
                'link' => "/StorageLayout/StorageMasters/add/$storageControlId/" . ($storageMasterId ? $storageMasterId . "/" : ''),
                'icon' => in_array($storageControlId, $tmaBlockControlIds) ? 'add_tma_block' : 'add_storage'
            );
        }
        if (empty($addLinks))
            $addLinks = '/underdevelopment/';
        return $addLinks;
    }

    /**
     * Define if the coordinate 'x' list of a storage having a specific type
     * can be set by the application user.
     *
     * Note: Only storage having storage type including one dimension and a coordinate type 'x'
     * equals to 'list' can support custom coordinate 'x' list.
     *
     * @param $storageControlId Storage Control ID of the studied storage.
     * @param $storageControlData Storage Control Data of the studied storage (not required).
     *       
     * @return true when the coordinate 'x' list of a storage can be set by the user.
     *        
     * @author N. Luc
     * @since 2008-02-04
     *        @updated A. Suggitt
     */
    public function allowCustomCoordinates($storageControlId, $storageControlData = null)
    {
        // Check for storage control data, if none get the control data
        if (empty($storageControlData)) {
            $storageControlData = $this->getOrRedirect($storageControlId);
        }
        
        if ($storageControlData['StorageControl']['id'] !== $storageControlId) {
            $this->controller->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Check the control data and set boolean for return.
        if (! ((strcmp($storageControlData['StorageControl']['coord_x_type'], 'list') == 0) && empty($storageControlData['StorageControl']['coord_x_size']) && empty($storageControlData['StorageControl']['coord_y_type']) && empty($storageControlData['StorageControl']['coord_y_size']))) {
            return false;
        }
        
        return true;
    }

    /**
     *
     * @param $storageControlData
     * @return string
     */
    public function getStorageLayoutDescription($storageControlData)
    {
        $description = '';
        
        $coordXTitle = $storageControlData['StorageControl']['coord_x_title'];
        $coordYTitle = $storageControlData['StorageControl']['coord_y_title'];
        $lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
        $structurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
        $allCoordinatesTitles = $structurePermissibleValuesCustom->find('all', array(
            'conditions' => array(
                'StructurePermissibleValuesCustomControl.name' => 'storage coordinate titles',
                'StructurePermissibleValuesCustom.value' => array(
                    $coordXTitle,
                    $coordYTitle
                )
            )
        ));
        foreach ($allCoordinatesTitles as $newCoordinate) {
            if ($coordXTitle == $newCoordinate['StructurePermissibleValuesCustom']['value']) {
                $coordXTitle = strlen($newCoordinate['StructurePermissibleValuesCustom'][$lang]) ? $newCoordinate['StructurePermissibleValuesCustom'][$lang] : $newCoordinate['StructurePermissibleValuesCustom']['value'];
            }
            if ($coordYTitle == $newCoordinate['StructurePermissibleValuesCustom']['value']) {
                $coordYTitle = strlen($newCoordinate['StructurePermissibleValuesCustom'][$lang]) ? $newCoordinate['StructurePermissibleValuesCustom'][$lang] : $newCoordinate['StructurePermissibleValuesCustom']['value'];
            }
        }
        
        if (isset($storageControlData['StorageControl']['coord_x_title'])) {
            // Set horizontal layout desciption
            $description .= $coordXTitle . ' (' . (isset($storageControlData['StorageControl']['coord_x_type']) ? __('type') . ' ' . __($storageControlData['StorageControl']['coord_x_type']) : '') . (isset($storageControlData['StorageControl']['coord_x_size']) ? ' / ' . __('coordinate size') . ' ' . __($storageControlData['StorageControl']['coord_x_size']) : '') . ')';
            
            if (isset($storageControlData['StorageControl']['coord_y_title'])) {
                // Set vertical layout desciption
                $description .= '<br>';
                $description .= $coordYTitle . ' (' . (isset($storageControlData['StorageControl']['coord_y_type']) ? __('type') . ' ' . __($storageControlData['StorageControl']['coord_y_type']) : '') . (isset($storageControlData['StorageControl']['coord_y_size']) ? ' / ' . __('coordinate size') . ' ' . __($storageControlData['StorageControl']['coord_y_size']) : '') . ')';
            }
        }
        
        return (empty($description) ? 'n/a' : $description);
    }

    /**
     *
     * @param mixed $results
     * @param bool $primary
     * @return mixed
     */
    public function afterFind($results, $primary = false)
    {
        return $this->applyMasterFormAlias($results, $primary);
    }
}