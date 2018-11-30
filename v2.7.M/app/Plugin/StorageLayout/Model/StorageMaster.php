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
 * Class StorageMaster
 */
class StorageMaster extends StorageLayoutAppModel
{

    public $belongsTo = array(
        'StorageControl' => array(
            'className' => 'StorageLayout.StorageControl',
            'foreignKey' => 'storage_control_id'
        )
    );

    public $actsAs = array(
        'Tree',
        'StoredItem'
    );

    public $registeredView = array(
        'InventoryManagement.ViewAliquot' => array(
            'StorageMaster.id'
        ),
        'StorageLayout.ViewStorageMaster' => array(
            'StorageMaster.id'
        )
    );

    public $usedStoragePos = array();

    public $storageSelectionLabelsAlreadyChecked = array();

    public $storageLabelAndCodeForDisplayAlreadySet = array();

    const POSITION_FREE = 1;
    
    // the position is free
    const POSITION_OCCUPIED = 2;
    
    // the position is already occupied (in the db)
    const POSITION_DOUBLE_SET = 3;
    
    // the position is being defined more than once
    const CONFLICTS_IGNORE = 0;

    const CONFLICTS_WARN = 1;

    const CONFLICTS_ERR = 2;

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['StorageMaster.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'StorageMaster.id' => $variables['StorageMaster.id']
                )
            ));
            $title = '';
            if ($result['StorageControl']['is_tma_block']) {
                $title = __('TMA-blc');
            } else {
                $lang = ($_SESSION['Config']['language'] == 'eng') ? 'en' : 'fr';
                $title = (isset($result['StorageControl']['storage_type' . $lang]) && strlen(isset($result['StorageControl']['storage_type' . $lang]))) ? $result['StorageControl']['storage_type' . $lang] : $result['StorageControl']['storage_type'];
            }
            
            $return = array(
                'menu' => array(
                    null,
                    ($title . ' : ' . $result['StorageMaster']['short_label'])
                ),
                'title' => array(
                    null,
                    ($title . ' : ' . $result['StorageMaster']['short_label'])
                ),
                'data' => $result,
                'structure alias' => 'storagemasters'
            );
        }
        
        return $return;
    }

    /**
     *
     * @return bool
     */
    private function insideItself()
    {
        $parentId = $this->data['StorageMaster']['parent_id'];
        while (! empty($parentId)) {
            $parent = $this->find('first', array(
                'conditions' => array(
                    'StorageMaster.id' => $parentId
                )
            ));
            assert(! empty($parent));
            if ($parent['StorageMaster']['id'] == $this->data['StorageMaster']['id']) {
                return true;
            }
            $parentId = $parent['StorageMaster']['parent_id'];
        }
        return false;
    }

    /**
     *
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        if (! (array_key_exists('FunctionManagement', $this->data) && array_key_exists('recorded_storage_selection_label', $this->data['FunctionManagement']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Check parent storage definition
        $parentStorageSelectionResults = $this->validateAndGetStorageData($this->data['FunctionManagement']['recorded_storage_selection_label'], $this->data['StorageMaster']['parent_storage_coord_x'], $this->data['StorageMaster']['parent_storage_coord_y']);
        $parentStorageData = $parentStorageSelectionResults['storage_data'];
        
        // Update storage data
        $this->data['StorageMaster']['parent_id'] = isset($parentStorageData['StorageMaster']['id']) ? $parentStorageData['StorageMaster']['id'] : null;
        
        if (array_key_exists('id', $this->data['StorageMaster']) && $this->insideItself()) {
            $this->validationErrors['recorded_storage_selection_label'][] = 'you can not store your storage inside itself';
        } elseif (! empty($parentStorageData) && ($parentStorageData['StorageControl']['is_tma_block'])) {
            $this->validationErrors['recorded_storage_selection_label'][] = 'you can not define a tma block as a parent storage';
        } else {
            if ($parentStorageSelectionResults['change_position_x_to_uppercase']) {
                $this->data['StorageMaster']['parent_storage_coord_x'] = strtoupper($this->data['StorageMaster']['parent_storage_coord_x']);
            }
            if ($parentStorageSelectionResults['change_position_y_to_uppercase']) {
                $this->data['StorageMaster']['parent_storage_coord_y'] = strtoupper($this->data['StorageMaster']['parent_storage_coord_y']);
            }
            
            // Set error
            if (! empty($parentStorageSelectionResults['storage_definition_error'])) {
                $this->validationErrors['recorded_storage_selection_label'][] = $parentStorageSelectionResults['storage_definition_error'];
            }
            if (! empty($parentStorageSelectionResults['position_x_error'])) {
                $this->validationErrors['parent_storage_coord_x'][] = $parentStorageSelectionResults['position_x_error'];
            }
            if (! empty($parentStorageSelectionResults['position_y_error'])) {
                $this->validationErrors['parent_storage_coord_y'][] = $parentStorageSelectionResults['position_y_error'];
            }
            
            if (empty($this->validationErrors['recorded_storage_selection_label']) && empty($this->validationErrors['parent_storage_coord_x']) && empty($this->validationErrors['parent_storage_coord_y']) && isset($parentStorageSelectionResults['storage_data']['StorageControl']) && $parentStorageSelectionResults['storage_data']['StorageControl']['check_conflicts'] && (strlen($this->data['StorageMaster']['parent_storage_coord_x']) > 0 || strlen($this->data['StorageMaster']['parent_storage_coord_y']) > 0)) {
                $exception = $this->id ? array(
                    "StorageMaster" => $this->id
                ) : array();
                $positionStatus = $this->positionStatusQuick($parentStorageSelectionResults['storage_data']['StorageMaster']['id'], array(
                    'x' => $this->data['StorageMaster']['parent_storage_coord_x'],
                    'y' => $this->data['StorageMaster']['parent_storage_coord_y']
                ), $exception);
                
                $msg = null;
                if ($positionStatus == StorageMaster::POSITION_OCCUPIED) {
                    $msg = __('the storage [%s] already contained something at position [%s, %s]');
                } elseif ($positionStatus == StorageMaster::POSITION_DOUBLE_SET) {
                    $msg = __('you have set more than one element in storage [%s] at position [%s, %s]');
                }
                
                if ($msg != null) {
                    $msg = sprintf($msg, $parentStorageSelectionResults['storage_data']['StorageMaster']['selection_label'], $this->data['StorageMaster']['parent_storage_coord_x'], $this->data['StorageMaster']['parent_storage_coord_y']);
                    if ($parentStorageSelectionResults['storage_data']['StorageControl']['check_conflicts'] == self::CONFLICTS_WARN) {
                        AppController::addWarningMsg($msg);
                    } else {
                        $this->validationErrors['parent_storage_coord_x'][] = $msg;
                    }
                }
            }
        }
        
        $this->isDuplicatedStorageBarCode($this->data);
        
        if (isset($this->data['StorageMaster']['temperature']) && ! empty($this->data['StorageMaster']['temperature']) && (! isset($this->data['StorageMaster']['temp_unit']) || empty($this->data['StorageMaster']['temp_unit']))) {
            $this->validationErrors['temp_unit'][] = 'when defining a temperature, the temperature unit is required';
        }
        
        return parent::validates($options);
    }

    /**
     *
     * @param $storageData
     * @return bool
     */
    public function isDuplicatedStorageBarCode($storageData)
    {
        if (empty($storageData['StorageMaster']['barcode'])) {
            return false;
        }
        
        // Check duplicated barcode into db
        $barcode = $storageData['StorageMaster']['barcode'];
        $criteria = array(
            'StorageMaster.barcode' => $barcode
        );
        $storageHavingDuplicatedBarcode = $this->find('all', array(
            'conditions' => $criteria,
            'recursive' => - 1
        ));
        if (! empty($storageHavingDuplicatedBarcode)) {
            foreach ($storageHavingDuplicatedBarcode as $duplicate) {
                if ((! array_key_exists('id', $storageData['StorageMaster'])) || ($duplicate['StorageMaster']['id'] != $storageData['StorageMaster']['id'])) {
                    $this->validationErrors['barcode'][] = 'barcode must be unique';
                }
            }
        }
    }

    /**
     *
     * @return array
     */
    public static function getStoragesDropdown()
    {
        return array();
    }

    /**
     *
     * @param $recordedSelectionLabel
     * @param $positionX
     * @param $positionY
     * @param bool $isSampleCore
     * @return array
     */
    public function validateAndGetStorageData($recordedSelectionLabel, $positionX, $positionY, $isSampleCore = false)
    {
        $storageData = array();
        $storageDefinitionError = null;
        
        $positionXError = null;
        $changePositionXToUppercase = false;
        
        $positionYError = null;
        $changePositionYToUppercase = false;
        
        if (! empty($recordedSelectionLabel)) {
            $storageData = $this->getStorageDataFromStorageLabelAndCode($recordedSelectionLabel);
            
            if (isset($storageData['StorageMaster']) && isset($storageData['StorageControl'])) {
                // One storage has been found
                
                if ((! $isSampleCore) && ($storageData['StorageControl']['is_tma_block'])) {
                    // 1- Check defined storage is not a TMA Block when studied element is a sample core
                    $storageDefinitionError = 'only sample core can be stored into tma block';
                } else {
                    // 2- Check position
                    
                    $positionXValidation = $this->validatePositionValue($storageData, $positionX, 'x');
                    $positionYValidation = $this->validatePositionValue($storageData, $positionY, 'y');
                    
                    // Manage position x
                    if (! $positionXValidation['validated']) {
                        $positionXError = 'an x coordinate does not match format';
                    } elseif ($positionYValidation['validated'] && $storageData['StorageControl']['coord_x_size'] > 0 && strlen($positionX) == 0 && strlen($positionY) > 0) {
                        $positionXError = 'an x coordinate needs to be defined';
                    } elseif ($positionXValidation['change_position_to_uppercase']) {
                        $changePositionXToUppercase = true;
                    }
                    
                    // Manage position y
                    if (! $positionYValidation['validated']) {
                        $positionYError = 'an y coordinate does not match format';
                    } elseif ($positionXValidation['validated'] && $storageData['StorageControl']['coord_y_size'] > 0 && strlen($positionY) == 0 && strlen($positionX) > 0) {
                        $positionYError = 'a y coordinate needs to be defined';
                    } elseif ($positionYValidation['change_position_to_uppercase']) {
                        $changePositionYToUppercase = true;
                    }
                }
            } else {
                // An error has been detected
                $storageDefinitionError = $storageData['error'];
                $storageData = array();
            }
        } else {
            // No storage selected: no position should be set
            if (! empty($positionX)) {
                $positionXError = 'no x coordinate has to be recorded when no storage is selected';
            }
            if (! empty($positionY)) {
                $positionYError = 'no y coordinate has to be recorded when no storage is selected';
            }
        }
        
        return array(
            'storage_data' => $storageData,
            
            'storage_definition_error' => $storageDefinitionError,
            'position_x_error' => $positionXError,
            'position_y_error' => $positionYError,
            
            'change_position_x_to_uppercase' => $changePositionXToUppercase,
            'change_position_y_to_uppercase' => $changePositionYToUppercase
        );
    }

    /**
     * Validate a value set to define position of an entity into a storage coordinate ('x' or 'y').
     *
     * @param $storageData Storage data including storage master, storage control, etc.
     * @param $position Position value.
     * @param $coord Studied storage coordinate ('x' or 'y').
     *       
     * @return Array containing results
     *         ['validated'] => TRUE if validated
     *         ['change_position_to_uppercase'] => TRUE if position value should be changed to uppercase to be validated
     *        
     * @author N. Luc
     * @since 2009-08-16
     */
    public function validatePositionValue($storageData, $position, $coord)
    {
        if (! in_array($coord, array(
            'x',
            'y'
        ))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if ($storageData['StorageControl']['permute_x_y']) {
            $coord = ($coord == 'x') ? 'y' : 'x';
        }
        
        $validationResults = array(
            'validated' => true,
            'change_position_to_uppercase' => false
        );
        
        // Launch validation
        if (empty($position)) {
            return $validationResults;
        }
        
        // Get allowed position for this storage coordinate
        $arrAllowedPosition = $this->buildAllowedStoragePosition($storageData, $coord);
        
        // Check position
        if (array_key_exists($position, $arrAllowedPosition['array_to_display'])) {
            return $validationResults;
        } else {
            $upperCasePosition = strtoupper($position);
            if (array_key_exists($upperCasePosition, $arrAllowedPosition['array_to_display'])) {
                $validationResults['change_position_to_uppercase'] = true;
                return $validationResults;
            }
        }
        
        // Position value has not been validated
        $validationResults['validated'] = false;
        
        return $validationResults;
    }

    /**
     * Build list of values that could be selected to define position coordinate (X or Y) of a children
     * storage within a studied storage.
     *
     *
     * List creation is based on the coordinate information set into the control data of the storage.
     *
     * When:
     * - TYPE = 'alphabetical' and SIZE is not null
     * System will build a list of alphabetical values ('A', 'B', 'C', etc)
     * having a number of items defined by the coordinate SIZE.
     *
     * - TYPE = 'integer' and SIZE is not null
     * System will build list of integer values ('1' + '2' + '3' + etc)
     * having a number of items defined by the coordinate SIZE.
     *
     * - TYPE = 'liste' and SIZE is null
     * System will search cutom coordinate values set by the user.
     * (This list is uniquely supported for coordinate 'X').
     *
     * @param $storageData Storage data including storage master, storage control, etc.
     * @param $coord Coordinate flag that should be studied ('x', 'y').
     *       
     * @return Array gathering 2 sub arrays:
     *         [array_to_display] = array($allowedCoordinate => $allowedCoordinate)
     *         // key = value = 'allowed coordinate'
     *         // array_to_display should be used to get list of allowed coordinates and set drop down list for position selection
     *         [array_to_order] = array($coordinateOrder => $allowedCoordinate)
     *         // key = 'coordinate order', value = 'allowed coordinate')
     *         // array_to_order should be used to build an ordered display
     *        
     * @author N. Luc
     * @since 2007-05-22
     *        @updated A. Suggitt
     */
    public function buildAllowedStoragePosition($storageData, $coord)
    {
        if (! array_key_exists('coord_' . $coord . '_type', $storageData['StorageControl'])) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Build array
        $arrayToDisplay = array();
        $arrayToOrder = array();
        
        if (! empty($storageData['StorageControl']['coord_' . $coord . '_type'])) {
            if (! empty($storageData['StorageControl']['coord_' . $coord . '_size'])) {
                // TYPE and SIZE are both defined for the studied coordinate: The system can build a list.
                $size = $storageData['StorageControl']['coord_' . $coord . '_size'];
                if (! is_numeric($size)) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                if (strcmp($storageData['StorageControl']['coord_' . $coord . '_type'], 'alphabetical') == 0) {
                    // Alphabetical drop down list
                    $arrayToOrder = array_slice(range('A', 'Z'), 0, $size);
                } elseif (strcmp($storageData['StorageControl']['coord_' . $coord . '_type'], 'integer') == 0) {
                    // Integer drop down list
                    $arrayToOrder = range('1', $size);
                } else {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            } else {
                // Only TYPE is defined for the studied coordinate: The system can only return a custom coordinate list set by user.
                if ((strcmp($storageData['StorageControl']['coord_' . $coord . '_type'], 'list') == 0) && (strcmp($coord, 'x') == 0)) {
                    $storageCoordinate = AppModel::getInstance("StorageLayout", "StorageCoordinate", true);
                    $coordinates = $storageCoordinate->atimList(array(
                        'conditions' => array(
                            'StorageCoordinate.storage_master_id' => $storageData['StorageMaster']['id'],
                            'StorageCoordinate.dimension' => $coord
                        ),
                        'order' => 'StorageCoordinate.order ASC',
                        'recursive' => - 1
                    ));
                    if (! empty($coordinates)) {
                        foreach ($coordinates as $newCoordinate) {
                            $coordinateValue = $newCoordinate['StorageCoordinate']['coordinate_value'];
                            $coordinateOrder = $newCoordinate['StorageCoordinate']['order'];
                            $arrayToOrder[$coordinateOrder] = $coordinateValue;
                        }
                    }
                } else {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            }
        }
        if (! empty($arrayToOrder)) {
            $arrayToDisplay = array_combine($arrayToOrder, $arrayToOrder);
        }
        return array(
            'array_to_display' => $arrayToDisplay,
            'array_to_order' => array_flip($arrayToOrder)
        );
    }

    /**
     * Finds the storage id
     *
     * @param String $storageLabelAndCode a single string with the format "label [code]"
     * @return storage data (array('StorageMaster' => array(), 'StorageControl' => array()) when found, array('error' => message) otherwise
     */
    public function getStorageDataFromStorageLabelAndCode($storageLabelAndCode)
    {
        
        // -- NOTE ----------------------------------------------------------------
        //
        // This function is linked to a function of the StorageMaster controller
        // called autocompleteLabel()
        // and to functions of the StorageMaster model
        // getStorageLabelAndCodeForDisplay().
        //
        // When you override the getStorageDataFromStorageLabelAndCode() function,
        // check if you need to override these functions.
        //
        // ------------------------------------------------------------------------
        if (! isset($this->storageSelectionLabelsAlreadyChecked[$storageLabelAndCode])) {
            $results = array();
            $selectedStorages = array();
            $term = str_replace(array(
                "\\",
                '%',
                '_'
            ), array(
                "\\\\",
                '\%',
                '\_'
            ), $storageLabelAndCode);
            if (preg_match_all("/([^\b]+)\ \[([^\[]+)\]/", $term, $matches, PREG_SET_ORDER) > 0) {
                // Auto complete tool has been used
                $selectedStorages = $this->find('all', array(
                    'conditions' => array(
                        "StorageMaster.selection_label LIKE " => '%' . $matches[0][1] . '%',
                        'StorageMaster.code' => $matches[0][2]
                    )
                ));
            } else {
                // consider $storageLabelAndCode contains just seleciton label
                $selectedStorages = $this->find('all', array(
                    'conditions' => array(
                        'StorageMaster.selection_label LIKE' => $term
                    )
                ));
            }
            if (sizeof($selectedStorages) == 1) {
                $this->storageSelectionLabelsAlreadyChecked[$storageLabelAndCode] = array(
                    'StorageMaster' => $selectedStorages[0]['StorageMaster'],
                    'StorageControl' => $selectedStorages[0]['StorageControl']
                );
            } elseif (sizeof($selectedStorages) > 1) {
                $this->storageSelectionLabelsAlreadyChecked[$storageLabelAndCode] = array(
                    'error' => str_replace('%s', $storageLabelAndCode, __('more than one storages matche the selection label [%s]'))
                );
            } else {
                $this->storageSelectionLabelsAlreadyChecked[$storageLabelAndCode] = array(
                    'error' => str_replace('%s', $storageLabelAndCode, __('no storage matches the selection label [%s]'))
                );
            }
        }
        
        return $this->storageSelectionLabelsAlreadyChecked[$storageLabelAndCode];
    }

    /**
     *
     * @param $storageData
     * @return mixed|string
     */
    public function getStorageLabelAndCodeForDisplay($storageData)
    {
        
        // -- NOTE ----------------------------------------------------------------
        //
        // This function is linked to a function of the StorageMaster controller
        // called autocompleteLabel()
        // and to functions of the StorageMaster model
        // getStorageDataFromStorageLabelAndCode().
        //
        // When you override the getStorageDataFromStorageLabelAndCode() function,
        // check if you need to override these functions.
        //
        // ------------------------------------------------------------------------
        $formattedData = '';
        
        if ((! empty($storageData)) && isset($storageData['StorageMaster']['id']) && (! empty($storageData['StorageMaster']['id']))) {
            if (! isset($this->storageLabelAndCodeForDisplayAlreadySet[$storageData['StorageMaster']['id']])) {
                $storageControlModel = AppModel::getInstance('StorageLayout', 'StorageControl', true);
                if (! array_key_exists('StorageControl', $storageData)) {
                    $storageData += $storageControlModel->findById($storageData['StorageMaster']['storage_control_id']);
                }
                $storageTypesFromId = $this->StorageControl->getStorageTypePermissibleValues();
                $this->storageLabelAndCodeForDisplayAlreadySet[$storageData['StorageMaster']['id']] = $storageData['StorageMaster']['selection_label'] . ' [' . $storageData['StorageMaster']['code'] . '] / ' . (isset($storageTypesFromId[$storageData['StorageControl']['id']]) ? $storageTypesFromId[$storageData['StorageControl']['id']] : $storageData['StorageControl']['storage_type']);
            }
            $formattedData = $this->storageLabelAndCodeForDisplayAlreadySet[$storageData['StorageMaster']['id']];
        }
        
        return $formattedData;
    }

    /**
     * Using the id of a storage, the function will return formatted storages path
     * starting from the root to the studied storage.
     *
     * @param $studiedStorageMasterId ID of the studied storage.
     *       
     * @return Storage path (string).
     *        
     * @author N. Luc
     * @since 2009-08-12
     */
    public function getStoragePath($studiedStorageMasterId)
    {
        $storagePathData = $this->getPath($studiedStorageMasterId, null, '0');
        
        $storageControlModel = AppModel::getInstance('StorageLayout', 'StorageControl', true);
        $storageTypesFromId = $this->StorageControl->getStorageTypePermissibleValues();
        
        $pathToDisplay = '';
        $separator = '';
        if (! empty($storagePathData)) {
            foreach ($storagePathData as $newParentStorageData) {
                $storageType = isset($storageTypesFromId[$newParentStorageData['StorageControl']['id']]) ? $storageTypesFromId[$newParentStorageData['StorageControl']['id']] : $newParentStorageData['StorageControl']['storage_type'];
                $pathToDisplay .= $separator . $newParentStorageData['StorageMaster']['code'] . " ($storageType)";
                $separator = ' > ';
            }
        }
        
        return $pathToDisplay;
    }

    /**
     *
     * @param array $storageMasterIds The storage master ids whom child existence will be verified
     * @return array Returns the storage master ids having child
     */
    public function hasChild(array $storageMasterIds)
    {
        // child can be a storage or an aliquot
        $result = array_unique(array_filter($this->find('list', array(
            'fields' => array(
                "StorageMaster.parent_id"
            ),
            'conditions' => array(
                'StorageMaster.parent_id' => $storageMasterIds
            )
        ))));
        $storageMasterIds = array_diff($storageMasterIds, $result);
        $aliquotMaster = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
        $tmaSlide = AppModel::getInstance("StorageLayout", "TmaSlide", true);
        return array_merge($result, array_unique(array_filter($aliquotMaster->find('list', array(
            'fields' => array(
                'AliquotMaster.storage_master_id'
            ),
            'conditions' => array(
                'AliquotMaster.storage_master_id' => $storageMasterIds
            )
        )))), array_unique(array_filter($tmaSlide->find('list', array(
            'fields' => array(
                'TmaSlide.storage_master_id'
            ),
            'conditions' => array(
                'TmaSlide.storage_master_id' => $storageMasterIds
            )
        )))));
    }

    /**
     *
     * Enter description here ...
     *
     * @param array $childrenArray
     * @param unknown_type $typeKey
     * @param unknown_type $labelKey
     * @return mixed
     */
    public function getLabel(array $childrenArray, $typeKey, $labelKey)
    {
        return isset($childrenArray[$typeKey][$labelKey]) ? $childrenArray[$typeKey][$labelKey] : null;
    }

    /**
     *
     * @param int $storageMasterId
     * @return array
     */
    public function allowDeletion($storageMasterId)
    {
        // Check storage contains no chlidren storage
        $nbrChildrenStorages = $this->find('count', array(
            'conditions' => array(
                'StorageMaster.parent_id' => $storageMasterId
            ),
            'recursive' => - 1
        ));
        if ($nbrChildrenStorages > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'children storage exists within the deleted storage'
            );
        }
        
        // Check storage contains no aliquots
        $aliquotMasterModel = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
        $nbrStorageAliquots = $aliquotMasterModel->find('count', array(
            'conditions' => array(
                'AliquotMaster.storage_master_id' => $storageMasterId
            ),
            'recursive' => - 1
        ));
        if ($nbrStorageAliquots > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'aliquot exists within the deleted storage'
            );
        }
        
        // Check storage is not a block attached to tma slide
        $tmaSlideModel = AppModel::getInstance("StorageLayout", "TmaSlide", true);
        $nbrTmaSlides = $tmaSlideModel->find('count', array(
            'conditions' => array(
                'TmaSlide.tma_block_storage_master_id' => $storageMasterId
            ),
            'recursive' => - 1
        ));
        if ($nbrTmaSlides > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'slide exists for the deleted tma'
            );
        }
        
        // verify storage is not attached to tma slide
        $nbrChildrenStorages = $tmaSlideModel->find('count', array(
            'conditions' => array(
                'TmaSlide.storage_master_id' => $storageMasterId
            ),
            'recursive' => - 1
        ));
        if ($nbrChildrenStorages > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'slide exists within the deleted storage'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    /**
     *
     * @param $storageData
     * @param $storageControlData
     */
    public function manageTemperature(&$storageData, $storageControlData)
    {
        if ($storageData['StorageMaster']['storage_control_id'] != $storageControlData['StorageControl']['id'])
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            
            // storage temperature
        if (! $storageControlData['StorageControl']['set_temperature']) {
            if (! empty($storageData['StorageMaster']['parent_id'])) {
                $parentStorageData = $this->find('first', array(
                    'conditions' => array(
                        'StorageMaster.id' => $storageData['StorageMaster']['parent_id']
                    ),
                    'recursive' => - 1
                ));
                if (empty($parentStorageData)) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                // Define storage surrounding temperature based on selected parent temperature
                $storageData['StorageMaster']['temperature'] = $parentStorageData['StorageMaster']['temperature'];
                $storageData['StorageMaster']['temp_unit'] = $parentStorageData['StorageMaster']['temp_unit'];
            } else {
                $storageData['StorageMaster']['temperature'] = null;
                $storageData['StorageMaster']['temp_unit'] = null;
            }
        }
    }

    /**
     * Get the selection label of a storage.
     *
     * @param $storageData Storage data including storage master, storage control, etc.
     *       
     * @return The new storage selection label.
     *        
     * @author N. Luc
     * @since 2009-09-13
     */
    public function getSelectionLabel($storageData)
    {
        if (empty($storageData['StorageMaster']['parent_id'])) {
            // No parent exists: Selection Label equals short label
            return $storageData['StorageMaster']['short_label'];
        }
        
        // Set selection label according to the parent selection label
        $parentStorageData = $this->find('first', array(
            'conditions' => array(
                'StorageMaster.id' => $storageData['StorageMaster']['parent_id']
            ),
            'recursive' => - 1
        ));
        if (empty($parentStorageData)) {
            AppController::getInstance()->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        return ($this->createSelectionLabel($storageData, $parentStorageData));
    }

    /**
     * Create the selection label of a storage.
     *
     * @param Storage $storageData Parent
     *        storage data including storage master, storage control, etc.
     *       
     * @param $parentStorageData
     * @return The created selection label.
     *        
     * @author N. Luc
     * @since 2009-09-13
     */
    public function createSelectionLabel($storageData, $parentStorageData)
    {
        if (! array_key_exists('selection_label', $parentStorageData['StorageMaster'])) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        if (! array_key_exists('short_label', $storageData['StorageMaster'])) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        return ($parentStorageData['StorageMaster']['selection_label'] . '-' . $storageData['StorageMaster']['short_label']);
    }

    /**
     * Manage the selection label of the children storages of a specific parent storage.
     *
     * @param $parentStorageId ID of the parent storage that should be studied
     *        to update the selection labels of its children storages.
     * @param $parentStorageData Parent storage data.
     *       
     * @author N. Luc
     * @since 2008-01-31
     *        @updated A. Suggitt
     */
    public function updateChildrenStorageSelectionLabel($parentStorageId, $parentStorageData)
    {
        $arrStudiedParentsData = array(
            $parentStorageId => $parentStorageData
        );
        
        while (! empty($arrStudiedParentsData)) {
            // Search 'direct' children to update
            $conditions = array();
            $conditions['StorageMaster.parent_id'] = array_keys($arrStudiedParentsData);
            
            $childrenStorageToUpdate = $this->find('all', array(
                'conditions' => $conditions,
                'recursive' => - 1
            ));
            $newArrStudiedParentsData = array();
            foreach ($childrenStorageToUpdate as $newChildrenToUpdate) {
                // New children to update
                $studiedChildrenId = $newChildrenToUpdate['StorageMaster']['id'];
                $parentStorageData = $arrStudiedParentsData[$newChildrenToUpdate['StorageMaster']['parent_id']];
                
                $storageDataToUpdate = array();
                $storageDataToUpdate['StorageMaster']['selection_label'] = $this->createSelectionLabel($newChildrenToUpdate, $parentStorageData);
                
                $this->id = $studiedChildrenId;
                $this->data = null;
                if (! $this->save($storageDataToUpdate, false)) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                // Re-populate the list of parent storages to study
                $newChildrenToUpdate['StorageMaster']['selection_label'] = $storageDataToUpdate['StorageMaster']['selection_label'];
                $newArrStudiedParentsData[$studiedChildrenId] = $newChildrenToUpdate;
            }
            
            $arrStudiedParentsData = $newArrStudiedParentsData;
        }
        
        return;
    }

    /**
     * Create code of a new storage.
     *
     *
     * @param $storageMasterId Storage master id of the studied storage.
     * @param $storageData Storage data including storage master, storage control, etc.
     * @param $storageControlData Control data of the studied storage.
     *       
     * @return The new code.
     *        
     * @author N. Luc
     * @since 2008-01-31
     *        @updated A. Suggitt
     * @deprecated
     *
     */
    public function createCode($storageMasterId, $storageData, $storageControlData)
    {
        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $storageCode = $storageMasterId;
        
        return $storageCode;
    }

    /**
     * Update the surrounding temperature and unit of children storages.
     *
     * Note: only children storages having temperature or unit different than the parent will
     * be updated.
     *
     * @param $parentStorageMasterId Id of the parent storage.
     * @param $parentTemperature Parent storage temperature.
     * @param $parentTempUnit Parent storage temperature unit.
     *       
     * @author N. Luc
     * @since 2007-05-22
     *        @updated A. Suggitt
     */
    public function updateChildrenSurroundingTemperature($parentStorageMasterId, $parentTemperature, $parentTempUnit)
    {
        $studiedParentStorageIds = array(
            $parentStorageMasterId => $parentStorageMasterId
        );
        
        while (! empty($studiedParentStorageIds)) {
            // Search 'direct' children to update
            $conditions = array();
            $conditions['StorageMaster.parent_id'] = $studiedParentStorageIds;
            $conditions['StorageControl.set_temperature'] = '0';
            $conditions['OR'] = array();
            
            if (empty($parentTemperature) && (! is_numeric($parentTemperature))) {
                $conditions['OR'][] = "StorageMaster.temperature IS NOT NULL";
            } else {
                $conditions['OR'][] = "StorageMaster.temperature IS NULL";
                $conditions['OR'][] = "StorageMaster.temperature != '$parentTemperature'";
            }
            
            if (empty($parentTempUnit)) {
                $conditions['OR'][] = "StorageMaster.temp_unit IS NOT NULL";
                $conditions['OR'][] = "StorageMaster.temp_unit != ''";
            } else {
                $conditions['OR'][] = "StorageMaster.temp_unit IS NULL";
                $conditions['OR'][] = "StorageMaster.temp_unit != '$parentTempUnit'";
            }
            
            $studiedParentStorageIds = array();
            
            $childrenStorageToUpdate = $this->find('all', array(
                'conditions' => $conditions,
                'recursive' => 0
            ));
            foreach ($childrenStorageToUpdate as $newChildrenToUpdate) {
                // New children to update
                $studiedChildrenId = $newChildrenToUpdate['StorageMaster']['id'];
                
                $storageDataToUpdate = array();
                $storageDataToUpdate['StorageMaster']['temperature'] = $parentTemperature;
                $storageDataToUpdate['StorageMaster']['temp_unit'] = $parentTempUnit;
                
                $this->data = array();
                $this->id = $studiedChildrenId;
                if (! $this->save($storageDataToUpdate, false)) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                // Re-populate the list of parent storages to study
                $studiedParentStorageIds[$studiedChildrenId] = $studiedChildrenId;
            }
        }
        
        return;
    }

    /**
     * Parses the data_array and updates it with the rcv_data array.
     * Saves the modifications into the database and
     * cleans it of the no longer related data.
     *
     * @param $dataArray
     * @param $type
     * @param $xKey
     * @param $yKey
     * @param $storageParentKey
     * @param $rcvData
     * @param $updaterModel
     * @param array $storageControls
     * @param $updatedRecordCounter
     * @return bool
     * @internal param $ data_array The data read from the database* data_array The data read from the database
     * @internal param $ type The current type we are seeking* type The current type we are seeking
     * @internal param $ x_key The name of the key for the x coordinate* x_key The name of the key for the x coordinate
     * @internal param $ y_key The name of the key for the y coordinate* y_key The name of the key for the y coordinate
     * @internal param $ storage_parent_key The name of the key of the parent storage id* storage_parent_key The name of the key of the parent storage id
     * @internal param $ rcv_data The data received from the user* rcv_data The data received from the user
     * @internal param $ updater_model The model to use to update the data* updater_model The model to use to update the data
     * @internal param $ storage_control* storage_control
     */
    public function updateAndSaveDataArray($dataArray, $type, $xKey, $yKey, $storageParentKey, $rcvData, $updaterModel, array $storageControls, &$updatedRecordCounter)
    {
        $errorFound = false;
        foreach ($dataArray as &$initDataUnit) {
            $initDataId = $initDataUnit[$type]['id'];
            $storageControl = in_array($rcvData[$type][$initDataId]['s'], array(
                'u',
                't'
            )) ? null : $storageControls[$rcvData[$type][$initDataId]['s']]['StorageControl'];
            if (($initDataUnit[$type][$xKey] != $rcvData[$type][$initDataId]['x'] && ! (in_array($rcvData[$type][$initDataId]['x'], array(
                'u',
                't'
            )) && $initDataUnit[$type][$xKey] == '') && ! ($storageControl && $storageControl['coord_x_size'] == null && $storageControl['coord_x_type'] != 'list' && $rcvData[$type][$initDataId]['x'] == '1')) || ($initDataUnit[$type][$yKey] != $rcvData[$type][$initDataId]['y'] && ! (in_array($rcvData[$type][$initDataId]['y'], array(
                'u',
                't'
            )) && $initDataUnit[$type][$yKey] == '') && ! ($storageControl && $storageControl['coord_y_size'] == null && $storageControl['coord_y_type'] != 'list' && $rcvData[$type][$initDataId]['y'] == '1')) || $initDataUnit[$type][$storageParentKey] != $rcvData[$type][$initDataId]['s']) {
                
                // only save what changed
                $updateTempAndLabel = $initDataUnit[$type][$storageParentKey] != $rcvData[$type][$initDataId]['s'] && $type == 'StorageMaster';
                
                // this is is a cell
                if ($rcvData[$type][$initDataId]['x'] == 't') {
                    // trash
                    $initDataUnit[$type][$xKey] = '';
                    $initDataUnit[$type][$yKey] = '';
                    $initDataUnit[$type][$storageParentKey] = null;
                } elseif ($rcvData[$type][$initDataId]['x'] == 'u') {
                    // unclassified
                    $initDataUnit[$type][$xKey] = '';
                    $initDataUnit[$type][$yKey] = '';
                    $initDataUnit[$type][$storageParentKey] = $rcvData[$type][$initDataId]['s'];
                } else {
                    // positioned
                    if (! $storageControl)
                        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    $initDataUnit[$type][$xKey] = ($storageControl['coord_x_size'] == null && $storageControl['coord_x_type'] != 'list' ? '' : $rcvData[$type][$initDataId]['x']);
                    $initDataUnit[$type][$yKey] = ($storageControl['coord_y_size'] == null && $storageControl['coord_y_type'] != 'list' ? '' : $rcvData[$type][$initDataId]['y']);
                    $initDataUnit[$type][$storageParentKey] = $rcvData[$type][$initDataId]['s'];
                }
                
                $saveNewPostion = true;
                if ($type == "StorageMaster") {
                    // check if within itself
                    $this->data = $initDataUnit;
                    if ($this->insideItself()) {
                        $data = $this->findById($initDataId);
                        $this->validationErrors[][] = __('trying to put storage [%s] within itself failed', $this->getLabel($data, 'StorageMaster', 'selection_label')) . ' ' . __("storage data (including position) don't have been updated");
                        $errorFound = true;
                        $saveNewPostion = false;
                    }
                }
                
                if ($storageControl && $storageControl['is_tma_block']) {
                    if ($type != 'AliquotMaster' || $initDataUnit['SampleControl']['sample_type'] != 'tissue' || $initDataUnit['AliquotControl']['aliquot_type'] != 'core') {
                        $data = $updaterModel->findById($initDataId);
                        if ($type == 'StorageMaster') {
                            $this->validationErrors[][] = __('you can not define a tma block as a parent storage') . ' ' . str_replace('%s', $this->getLabel($data, 'StorageMaster', 'selection_label'), __('see # %s')) . ' ' . __("storage data (including position) don't have been updated");
                        } else {
                            $this->validationErrors[][] = __('only sample core can be stored into tma block') . ' ' . str_replace('%s', $this->getLabel($data, $type, 'barcode'), __('see # %s')) . ' ' . __("storage data (including position) don't have been updated");
                        }
                        $errorFound = true;
                        $saveNewPostion = false;
                    }
                }
                
                // clean the array asap to gain efficiency
                unset($rcvData[$type][$initDataId]);
                
                if ($saveNewPostion) {
                    // Save new item postions
                    if ($updateTempAndLabel) {
                        $this->manageTemperature($initDataUnit, $initDataUnit);
                        $initDataUnit['StorageMaster']['selection_label'] = $this->getSelectionLabel($initDataUnit);
                    }
                    
                    $updaterModel->pkeySafeguard = false;
                    $updaterModel->save($initDataUnit[$type], false);
                    $updatedRecordCounter ++;
                    
                    if ($updateTempAndLabel) {
                        $this->updateChildrenStorageSelectionLabel($initDataId, $initDataUnit);
                        
                        if (! $initDataUnit['StorageControl']['set_temperature']) {
                            $this->updateChildrenSurroundingTemperature($initDataId, $initDataUnit['StorageMaster']['temperature'], $initDataUnit['StorageMaster']['temp_unit']);
                        }
                    }
                }
            }
        }
        
        return $errorFound;
    }

    /**
     *
     * @param $childrenArray
     * @param $typeKey
     * @param $xKey
     * @param $yKey
     * @param $labelKey
     * @param $coordinateList
     * @param $link
     * @param string $iconName
     */
    public function buildChildrenArray(&$childrenArray, $typeKey, $xKey, $yKey, $labelKey, $coordinateList, $link, $iconName = "detail")
    {
        $childrenArray['DisplayData']['id'] = $childrenArray[$typeKey]['id'];
        $childrenArray['DisplayData']['y'] = strlen($childrenArray[$typeKey][$yKey]) > 0 ? $childrenArray[$typeKey][$yKey] : 1;
        if ($coordinateList == null) {
            $childrenArray['DisplayData']['x'] = $childrenArray[$typeKey][$xKey];
        } elseif (isset($coordinateList[$childrenArray[$typeKey][$xKey]])) {
            $childrenArray['DisplayData']['x'] = $coordinateList[$childrenArray[$typeKey][$xKey]]['StorageCoordinate']['id'];
            $childrenArray['DisplayData']['y'] = 1;
        } else {
            $childrenArray['DisplayData']['x'] = "";
        }
        if (is_null($childrenArray['DisplayData']['x']))
            $childrenArray['DisplayData']['x'] = '';
        if (is_null($childrenArray['DisplayData']['y']))
            $childrenArray['DisplayData']['y'] = '';
        
        $childrenArray['DisplayData']['label'] = $this->getLabel($childrenArray, $typeKey, $labelKey);
        $childrenArray['DisplayData']['barcode'] = (isset($childrenArray['AliquotMaster']['barcode'])) ? $childrenArray['AliquotMaster']['barcode'] : "";
        $childrenArray['DisplayData']['type'] = $typeKey;
        $childrenArray['DisplayData']['link'] = $link;
        $childrenArray['DisplayData']['icon_name'] = $iconName;
    }

    /**
     * Checks whether a storage position is already occupied or not.
     * This is a
     * quick check up that will not behave properly on bogus positions.
     *
     * @param int $storageMasterId
     * @param array $position ("x" => int [, "y" => int])
     * @param array $exception (model name => id). An exception to ommit when
     *        checking availability. Usefull when editing something.
     * @return const POSITION_*
     */
    public function positionStatusQuick($storageMasterId, array $position, array $exception = array())
    {
        // check if an aliquot occupies the position
        $conditions = array(
            'AliquotMaster.storage_master_id' => $storageMasterId,
            'AliquotMaster.in_stock !=' => "no"
        );
        foreach ($position as $key => $val) {
            $conditions['AliquotMaster.storage_coord_' . $key] = $val;
        }
        if (array_key_exists("AliquotMaster", $exception)) {
            $conditions['AliquotMaster.id !='] = $exception['AliquotMaster'];
        }
        $aliquotMasterModel = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
        $tmp = $aliquotMasterModel->find('first', array(
            'conditions' => $conditions,
            'recursive' => - 1
        ));
        if (! empty($tmp)) {
            return StorageMaster::POSITION_OCCUPIED;
        }
        
        // check if a storage occupies the position
        $conditions = array(
            'StorageMaster.parent_id' => $storageMasterId
        );
        foreach ($position as $key => $val) {
            $conditions['StorageMaster.parent_storage_coord_' . $key] = $val;
        }
        if (array_key_exists("StorageMaster", $exception)) {
            $conditions['StorageMaster.id !='] = $exception['StorageMaster'];
        }
        
        $tmp = $this->find('first', array(
            'conditions' => $conditions,
            'recursive' => - 1
        ));
        if (! empty($tmp)) {
            return StorageMaster::POSITION_OCCUPIED;
        }
        
        // check if a TMA occupies the position
        $conditions = array(
            'TmaSlide.storage_master_id' => $storageMasterId
        );
        foreach ($position as $key => $val) {
            $conditions['TmaSlide.storage_coord_' . $key] = $val;
        }
        if (array_key_exists("TmaSlide", $exception)) {
            $conditions['TmaSlide.id !='] = $exception['TmaSlide'];
        }
        $tmaSlideModel = AppModel::getInstance("StorageLayout", "TmaSlide", true);
        $tmp = $tmaSlideModel->find('first', array(
            'conditions' => $conditions,
            'recursive' => - 1
        ));
        if (! empty($tmp)) {
            return StorageMaster::POSITION_OCCUPIED;
        }
        
        // check if a current check occupies the position
        if (array_key_exists('y', $position) && ! empty($position['y'])) {
            if (isset($this->usedStoragePos[$storageMasterId][$position['x']][$position['y']])) {
                return StorageMaster::POSITION_DOUBLE_SET;
            }
        } elseif (isset($this->usedStoragePos[$storageMasterId][$position['x']])) {
            return StorageMaster::POSITION_DOUBLE_SET;
        }
        $this->usedStoragePos[$storageMasterId][$position['x']][$position['y']] = 'used';
        
        return StorageMaster::POSITION_FREE;
    }

    /**
     * Checks conflicts for batch layout
     *
     * @param $data
     * @param $modelName
     * @param $labelName
     * @param $cumulStorageData
     * @return bool
     */
    public function checkBatchLayoutConflicts(&$data, $modelName, $labelName, &$cumulStorageData)
    {
        $conflictsFound = false;
        if (isset($data[$modelName])) {
            foreach ($data[$modelName] as &$modelData) {
                $storageId = $modelData['s'];
                if ($modelData['x'] == 'u' || $modelData['x'] == 't') {
                    continue;
                }
                if (! array_key_exists($storageId, $cumulStorageData)) {
                    $storage = $this->findById($storageId);
                    $cumulStorageData[$storageId] = $storage;
                    $cumulStorageData[$storageId]['printed_label'] = $this->getLabel($storage, 'StorageMaster', 'selection_label');
                }
                
                if (isset($cumulStorageData[$storageId]['pos'][$modelData['x']][$modelData['y']])) {
                    $msg = __('conflict detected in storage [%s] at position [%s, %s]', $cumulStorageData[$storageId]['printed_label'], $modelData['x'], $modelData['y']);
                    // react
                    if ($cumulStorageData[$storageId]['StorageControl']['check_conflicts'] == StorageMaster::CONFLICTS_WARN) {
                        AppController::addWarningMsg($msg);
                        $conflictsFound = true;
                    } elseif ($cumulStorageData[$storageId]['StorageControl']['check_conflicts'] == StorageMaster::CONFLICTS_ERR) {
                        $this->validationErrors[][] = ($msg . ' ' . __('unclassifying additional items'));
                        $modelData['x'] = '';
                        $modelData['y'] = '';
                        $conflictsFound = true;
                    }
                } else {
                    // save the item label
                    $model = AppModel::getInstance(null, $modelName, true);
                    $modelFullData = $model->findById($modelData['id']);
                    $cumulStorageData[$storageId]['pos'][$modelData['x']][$modelData['y']] = $this->getLabel($modelFullData, $modelName, $labelName);
                }
            }
        }
        
        return $conflictsFound;
    }

    /**
     *
     * @param $modelsAndFields
     * @param $contentsToSort
     * @param bool $descOrder
     * @return array
     */
    public function contentNatCaseSort($modelsAndFields, $contentsToSort, $descOrder = false)
    {
        $valueToKey = array();
        $valuesToSort = array();
        $firstTest = true;
        foreach ($contentsToSort as $key => $newContent) {
            $sortedValue = '';
            foreach ($modelsAndFields as $modelAndField) {
                list ($model, $field) = explode('.', $modelAndField);
                if ($firstTest) {
                    if (! array_key_exists($model, $newContent) || ! array_key_exists($field, $newContent[$model]))
                        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    $firstTest = false;
                }
                $sortedValue .= $newContent[$model][$field];
            }
            $valueToKey[$sortedValue][] = $key;
            $valuesToSort[$sortedValue] = $sortedValue;
        }
        natcasesort($valuesToSort);
        if ($descOrder)
            $valuesToSort = array_reverse($valuesToSort);
        $sortedContents = array();
        foreach ($valuesToSort as $sortedValue) {
            if (! array_key_exists($sortedValue, $valueToKey))
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            foreach ($valueToKey[$sortedValue] as $key) {
                if (! array_key_exists($key, $contentsToSort))
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $sortedContents[] = $contentsToSort[$key];
            }
        }
        return $sortedContents;
    }
}