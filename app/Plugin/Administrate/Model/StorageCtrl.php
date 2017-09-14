<?php

/*
 * This model has been created to resolve issue#...
 *
 * If StorageLayout.StorageControl model is used, the MasterDetailBehavior.afterSave() function
 * is called by any StorageControl->save() function of this controller generating an error.
 * (The following test "if($isControlModel)" return true launching code execution to save detail data).
 *
 * To be sure MasterDetailBehavior Model is not called, created following model changing Control suffix to Ctrl.
 */

/**
 * Class StorageCtrl
 */
class StorageCtrl extends AdministrateAppModel
{

    //
    public $name = 'StorageCtrl';

    public $useTable = 'storage_controls';

    /**
     * @param $data
     * @return string
     */
    public function getStorageCategory($data)
    {
        $storageCategory = 'no_d';
        if ($data['StorageCtrl']['is_tma_block']) {
            $storageCategory = 'tma';
        } elseif ($data['StorageCtrl']['coord_y_title']) {
            $storageCategory = '2d';
        } elseif ($data['StorageCtrl']['coord_x_title']) {
            $storageCategory = '1d';
        }
        return $storageCategory;
    }

    /**
     * @param $storageCategory
     * @return null|string
     */
    public function getStructure($storageCategory)
    {
        $structures = null;
        switch ($storageCategory) {
            case 'no_d':
                $structures = 'storage_control_no_d';
                break;
            case '1d':
                $structures = 'storage_control_1d';
                break;
            case '2d':
                $structures = 'storage_control_2d';
                break;
            case 'tma':
                $structures = 'storage_control_tma';
                break;
            default:
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        return $structures;
    }

    /**
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        if (isset($this->data['StorageCtrl']['coord_x_title']) && isset($this->data['StorageCtrl']['coord_y_title'])) {
            // 2d storage
            if (empty($this->data['StorageCtrl']['coord_x_size']))
                $this->validationErrors['coord_x_size'][] = 'the coordinate x size has to be completed';
            if ($this->data['StorageCtrl']['coord_x_type'] == 'list')
                $this->validationErrors['coord_x_type'][] = 'no type list can be set for x or y fields in 2 dimensions storage type';
            if ($this->data['StorageCtrl']['coord_y_type'] == 'list')
                $this->validationErrors['coord_y_type'][] = 'no type list can be set for x or y fields in 2 dimensions storage type';
            if ($this->data['StorageCtrl']['coord_x_type'] == 'alphabetical' && $this->data['StorageCtrl']['coord_x_size'] > 24)
                $this->validationErrors['coord_x_size'][] = 'a size of an alphabetical coordinate has to be less than 25 values';
            if ($this->data['StorageCtrl']['coord_y_type'] == 'alphabetical' && $this->data['StorageCtrl']['coord_y_size'] > 24)
                $this->validationErrors['coord_y_size'][] = 'a size of an alphabetical coordinate has to be less than 25 values';
        } elseif (isset($this->data['StorageCtrl']['coord_x_title'])) {
            // 1d storage
            if (strlen($this->data['StorageCtrl']['coord_x_size']) && $this->data['StorageCtrl']['coord_x_type'] == 'list')
                $this->validationErrors['coord_x_size'][] = 'no coordinate x size has to be set for list';
            if (! strlen($this->data['StorageCtrl']['coord_x_size']) && $this->data['StorageCtrl']['coord_x_type'] != 'list')
                $this->validationErrors['coord_x_size'][] = 'a coordinate x size has to be set';
            if ($this->data['StorageCtrl']['coord_x_type'] != 'list' && (($this->data['StorageCtrl']['display_x_size'] * $this->data['StorageCtrl']['display_y_size']) != $this->data['StorageCtrl']['coord_x_size']))
                $this->validationErrors['coord_x_size'][] = 'display y size * display y size should be equal to coord x size';
        }
        return parent::validates($options);
    }

    /**
     * @param $passedArgs
     * @return array
     */
    public function getListArgs($passedArgs)
    {
        $listArgs = array();
        foreach ($passedArgs as $key => $val)
            if ($key && in_array($key, array(
                'limit',
                'sort',
                'direction',
                'page'
            )))
                $listArgs[$key] = $val;
        return $listArgs;
    }

    public function validatesAllStorageControls()
    {
        $structurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
        $translatedStorageTypes = $structurePermissibleValuesCustom->getCustomDropdown(array(
            'storage types'
        ));
        $translatedStorageTypes = array_merge($translatedStorageTypes['defined'], $translatedStorageTypes['previously_defined']);
        $query = "SELECT storage_type
			FROM storage_controls
			WHERE coord_x_type IS NULL
			AND (coord_x_size IS NOT NULL
				OR display_x_size != '0'
				OR coord_y_type IS NOT NULL
				OR coord_y_size IS NOT NULL
				OR display_y_size != '0')
			UNION ALL
			SELECT storage_type
			FROM storage_controls
			WHERE coord_x_type = 'list'
			AND (coord_x_size IS NOT NULL
				OR display_x_size != '0'
				OR coord_y_type IS NOT NULL
				OR coord_y_size IS NOT NULL
				OR display_y_size != '0')
			UNION ALL
			SELECT storage_type
			FROM storage_controls
			WHERE coord_x_type IS NOT NULL AND coord_x_type != 'list'
			AND coord_y_type IS NOT NULL
			AND (coord_x_type NOT IN ('integer', 'alphabetical')
				OR coord_x_size IS NULL
				OR coord_x_size < 1
				OR display_x_size != '0'
				OR coord_y_type NOT IN ('integer', 'alphabetical')
				OR coord_y_size IS NULL
				OR coord_y_size < 1
				OR display_y_size != '0')
			UNION ALL
			SELECT storage_type
			FROM storage_controls
			WHERE coord_x_type IS NOT NULL AND coord_x_type != 'list'
			AND coord_y_type IS NULL
			AND (coord_x_type NOT IN ('integer', 'alphabetical')
				OR coord_x_size IS NULL
				OR coord_x_size < 1
				OR display_x_size = '0'
				OR coord_y_size IS NOT NULL
				OR display_y_size IS NULL
				OR display_y_size = '0'
				OR (coord_x_size != (display_x_size*display_y_size)));";
        foreach ($this->query($query) as $newStrCtrl) {
            $storageType = $newStrCtrl[0]['storage_type'];
            $storageType = isset($translatedStorageTypes[$storageType]) ? $translatedStorageTypes[$storageType] : $storageType;
            AppController::addWarningMsg(__('storage control data of the storage type [%s] are not correctly set - please contact your administartor', $storageType));
        }
    }
}