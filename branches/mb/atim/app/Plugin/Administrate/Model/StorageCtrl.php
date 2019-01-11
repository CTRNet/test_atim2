<?php

/*
 * This model has been created to resolve issue#...
 * If StorageLayout.StorageControl model is used, the MasterDetailBehavior.afterSave() function
 * is called by any StorageControl->save() function of this controller generating an error.
 * (The following test "if($isControlModel)" return true launching code execution to save detail data).
 * To be sure MasterDetailBehavior Model is not called, created following model changing Control suffix to Ctrl.
 */

/**
 * Class StorageCtrl
 */
class StorageCtrl extends AdministrateAppModel
{

    public $name = 'StorageCtrl';

    public $useTable = 'storage_controls';

    /**
     *
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
     *
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
     *
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        if (isset($this->data['StorageCtrl']['storage_type']) && ! isset($this->data['StorageCtrl']['coord_x_title'])) {
            // *** Storage with no potision ***
            // Check Field
            $unexpectedFields = array(
                'number_of_positions',
                'horizontal_increment',
                'coord_x_title',
                'coord_x_type',
                'coord_x_size',
                'display_x_size',
                'reverse_x_numbering',
                'coord_y_title',
                'coord_y_type',
                'coord_y_size',
                'display_y_size',
                'reverse_y_numbering',
                'check_conflicts'
            );
            foreach ($unexpectedFields as $newUnexpectedField) {
                if (array_key_exists($newUnexpectedField, $this->data['StorageCtrl'])) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            }
            // Check TMA info
            if ($this->data['StorageCtrl']['is_tma_block']) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        } elseif (isset($this->data['StorageCtrl']['coord_x_title']) && isset($this->data['StorageCtrl']['coord_y_title'])) {
            // *** 2d storage && TMA ***
            // Check Field
            if (array_key_exists('horizontal_increment', $this->data['StorageCtrl'])) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            foreach (array(
                'display_x_size',
                'display_y_size'
            ) as $tmpField) {
                if (! preg_match('/^[1-9]/', $this->data['StorageCtrl'][$tmpField])) {
                    $this->validationErrors[$tmpField][] = 'a value has to be set for the display size';
                }
            }
            foreach (array(
                'reverse_x_numbering',
                'reverse_y_numbering'
            ) as $tmpField) {
                if (! strlen($this->data['StorageCtrl'][$tmpField])) {
                    $this->validationErrors[$tmpField][] = 'a value has to be set for the reverse numbering';
                }
            }
            foreach (array(
                'coord_x_type',
                'coord_y_type'
            ) as $tmpField) {
                if ($this->data['StorageCtrl'][$tmpField] == 'list') {
                    $this->validationErrors[$tmpField][] = 'no type list can be set for x or y fields in 2 dimensions storage type';
                }
            }
            if ($this->data['StorageCtrl']['coord_x_type'] == 'alphabetical' && $this->data['StorageCtrl']['display_x_size'] > 24) {
                $this->validationErrors['display_x_size'][] = 'a size of an alphabetical coordinate has to be less than 25 values';
            }
            if ($this->data['StorageCtrl']['coord_y_type'] == 'alphabetical' && $this->data['StorageCtrl']['display_y_size'] > 24) {
                $this->validationErrors['display_y_size'][] = 'a size of an alphabetical coordinate has to be less than 25 values';
            }
            $this->data['StorageCtrl']['coord_x_size'] = $this->data['StorageCtrl']['display_x_size'];
            $this->data['StorageCtrl']['coord_y_size'] = $this->data['StorageCtrl']['display_y_size'];
            $this->data['StorageCtrl']['number_of_positions'] = $this->data['StorageCtrl']['display_x_size'] * $this->data['StorageCtrl']['display_y_size'];
            if (empty($this->data['StorageCtrl']['check_conflicts']))
                $this->data['StorageCtrl']['check_conflicts'] = '0';
            $this->addWritableField(array(
                'coord_x_size',
                'coord_y_size',
                'number_of_positions',
                'check_conflicts'
            ));
        } elseif (isset($this->data['StorageCtrl']['coord_x_title'])) {
            // *** Storage with 1 coordinate - 1d storage ***
            // Check Field
            $unexpectedFields = array(
                'number_of_positions',
                'coord_x_size',
                'coord_y_title',
                'coord_y_type',
                'coord_y_size'
            );
            foreach ($unexpectedFields as $newUnexpectedField) {
                if (array_key_exists($newUnexpectedField, $this->data['StorageCtrl'])) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            }
            if ($this->data['StorageCtrl']['coord_x_type'] != 'list') {
                foreach (array(
                    'display_x_size',
                    'display_y_size'
                ) as $tmpField) {
                    if (! preg_match('/^[1-9]/', $this->data['StorageCtrl'][$tmpField])) {
                        $this->validationErrors[$tmpField][] = 'a value has to be set for the display size';
                    }
                }
                foreach (array(
                    'reverse_x_numbering',
                    'reverse_y_numbering',
                    'horizontal_increment'
                ) as $tmpField) {
                    if (! strlen($this->data['StorageCtrl'][$tmpField])) {
                        $this->validationErrors[$tmpField][] = 'a value has to be set for the reverse numbering';
                    }
                }
                $this->data['StorageCtrl']['coord_x_size'] = $this->data['StorageCtrl']['display_x_size'] * $this->data['StorageCtrl']['display_y_size'];
                $this->data['StorageCtrl']['number_of_positions'] = $this->data['StorageCtrl']['display_x_size'] * $this->data['StorageCtrl']['display_y_size'];
                $this->addWritableField(array(
                    'coord_x_size',
                    'number_of_positions'
                ));
                if ($this->data['StorageCtrl']['coord_x_type'] == 'alphabetical' && $this->data['StorageCtrl']['coord_x_size'] > 24) {
                    $this->validationErrors['display_x_size'][] = 'a size of an alphabetical coordinate has to be less than 25 values';
                    $this->validationErrors['display_y_size'][] = 'a size of an alphabetical coordinate has to be less than 25 values';
                }
            } else {
                $unexpectedFields = array(
                    'display_x_size',
                    'reverse_x_numbering',
                    'display_y_size',
                    'reverse_y_numbering',
                    'horizontal_increment'
                );
                foreach ($unexpectedFields as $newUnexpectedField) {
                    if (strlen($this->data['StorageCtrl'][$newUnexpectedField])) {
                        $this->validationErrors[$newUnexpectedField][] = 'no abscissa and ordinate data has to be set for a list';
                    }
                }
                $this->data['StorageCtrl']['coord_x_size'] = '';
                $this->data['StorageCtrl']['number_of_positions'] = '';
                $this->addWritableField(array(
                    'coord_x_size',
                    'number_of_positions'
                ));
            }
            // Check TMA info
            if (isset($this->data['StorageCtrl']['is_tma_block']) && $this->data['StorageCtrl']['is_tma_block'] != '0') {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        }
        if (isset($this->data['StorageCtrl']['storage_type_en'])) {
            $this->data['StorageCtrl']['storage_type_en'] = trim($this->data['StorageCtrl']['storage_type_en']);
        }
        if (isset($this->data['StorageCtrl']['storage_type_fr'])) {
            $this->data['StorageCtrl']['storage_type_fr'] = trim($this->data['StorageCtrl']['storage_type_fr']);
        }
        
        return parent::validates($options);
    }

    public function validatesAllStorageControls()
    {
        $query = "SELECT storage_type
			FROM storage_controls
			WHERE deleted <> 1
            AND (display_x_size = '0'
				OR display_y_size = '0'
				OR number_of_positions = '0'
                OR set_temperature NOT IN ('0', '1')
                OR is_tma_block NOT IN ('0', '1'))
            
			UNION ALL
            
            SELECT storage_type
			FROM storage_controls
			WHERE deleted <> 1
            AND coord_x_type IS NULL
			AND ((horizontal_increment IS NOT NULL AND horizontal_increment != '')
                OR (permute_x_y IS NOT NULL AND permute_x_y != '' AND permute_x_y != '0')
				OR (number_of_positions IS NOT NULL AND number_of_positions != '')
            
				OR (coord_x_title IS NOT NULL AND coord_x_title != '')
				OR (coord_x_size IS NOT NULL AND coord_x_size != '')
				OR (display_x_size IS NOT NULL AND display_x_size != '')
				OR (reverse_x_numbering IS NOT NULL AND reverse_x_numbering != '')
            
				OR (coord_y_title IS NOT NULL AND coord_y_title != '')
				OR (coord_y_type IS NOT NULL AND coord_y_type != '')
				OR (coord_y_size IS NOT NULL AND coord_y_size != '')
				OR (display_y_size IS NOT NULL AND display_y_size != '')
				OR (reverse_y_numbering IS NOT NULL AND reverse_y_numbering != '')
            
				OR (check_conflicts IS NOT NULL AND check_conflicts != '')
            
                OR is_tma_block = '1')
            
			UNION ALL
            
			SELECT storage_type
			FROM storage_controls
			WHERE deleted <> 1
            AND coord_x_type = 'list'
			AND ((horizontal_increment IS NOT NULL AND horizontal_increment != '')
                OR (permute_x_y IS NOT NULL AND permute_x_y != '' AND permute_x_y != '0')
				OR (number_of_positions IS NOT NULL AND number_of_positions != '')
            
				OR (coord_x_title IS NULL OR coord_x_title = '')
				OR (coord_x_size IS NOT NULL AND coord_x_size != '')
				OR (display_x_size IS NOT NULL AND display_x_size != '')
				OR (reverse_x_numbering IS NOT NULL AND reverse_x_numbering != '')
            
				OR (coord_y_title IS NOT NULL AND coord_y_title != '')
				OR (coord_y_type IS NOT NULL AND coord_y_type != '')
				OR (coord_y_size IS NOT NULL AND coord_y_size != '')
				OR (display_y_size IS NOT NULL AND display_y_size != '')
				OR (reverse_y_numbering IS NOT NULL AND reverse_y_numbering != '')
            
                OR (check_conflicts NOT IN ('0','1', '2'))
            
                OR is_tma_block = '1')
			
            UNION ALL
            
			SELECT storage_type
			FROM storage_controls
			WHERE deleted <> 1
            AND coord_x_type IS NOT NULL AND coord_x_type != 'list'
			AND coord_y_type IS NULL
            AND ((horizontal_increment NOT IN('0','1'))
                OR (permute_x_y IS NOT NULL AND permute_x_y != '' AND permute_x_y != '0')
				OR (number_of_positions IS NULL OR number_of_positions = '')
                OR (number_of_positions != coord_x_size*coord_y_size)
            
				OR (coord_x_title IS NULL OR coord_x_title = '')
				OR (coord_x_size IS NULL OR coord_x_size = '')
				OR (display_x_size IS NULL OR display_x_size = '')
				OR (reverse_x_numbering NOT IN('0','1'))
            
				OR (coord_y_title IS NOT NULL AND coord_y_title != '')
				OR (coord_y_size IS NOT NULL AND coord_y_size != '')
				OR (display_y_size IS NULL OR display_y_size = '')
				OR (reverse_y_numbering NOT IN ('0','1'))
            
				OR (check_conflicts NOT IN ('0','1', '2'))
            
                OR is_tma_block = '1')
			
            UNION ALL
            
			SELECT storage_type
			FROM storage_controls
			WHERE deleted <> 1
            AND coord_x_type IS NOT NULL
			AND coord_y_type IS NOT NULL
            AND ((horizontal_increment IS NOT NULL AND horizontal_increment != '')
				OR (number_of_positions IS NULL OR number_of_positions = '' OR number_of_positions != (coord_x_size*coord_y_size))
            
				OR (coord_x_title IS NULL OR coord_y_title = '')
                OR (coord_x_type NOT IN ('integer', 'alphabetical'))
				OR (coord_x_size IS NULL OR coord_x_size = '' OR coord_x_size != display_x_size)
				OR (display_x_size IS NULL OR display_x_size = '')
				OR (reverse_x_numbering NOT IN('0','1'))
            
				OR (coord_y_title IS NULL OR coord_y_title = '')
                OR (coord_y_type NOT IN ('integer', 'alphabetical'))
				OR (coord_y_size IS NULL OR coord_y_size = '' OR coord_y_size != display_y_size)
				OR (display_y_size IS NULL OR display_y_size = '')
				OR (reverse_y_numbering NOT IN ('0','1'))
            
				OR (check_conflicts NOT IN ('0','1', '2')));";
        
        foreach ($this->query($query) as $newStrCtrl) {
            $storageType = $newStrCtrl[0]['storage_type'];
            AppController::addWarningMsg(__('storage control data of the storage type [%s] are not correctly set - please contact your administartor', $storageType));
        }
    }

    /**
     * Check if a record can be deleted.
     *
     * @param $storageControlId Id of the studied record.
     *       
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2018-07-04
     */
    public function allowDeletion($storageControlId)
    {
        $storageMaster = AppModel::getInstance("StorageLayout", "StorageMaster", true);
        $returnedNbr = $storageMaster->find('count', array(
            'conditions' => array(
                'StorageMaster.storage_control_id' => $storageControlId
            ),
            'recursive' => 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'this storage type has already been used to build a storage'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }
}