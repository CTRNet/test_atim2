<?php

/**
 * Class AliquotMaster
 */
class AliquotMaster extends InventoryManagementAppModel
{

    public $actsAs = array(
        'MinMax',
        'StoredItem'
    );

    public $belongsTo = array(
        'AliquotControl' => array(
            'className' => 'InventoryManagement.AliquotControl',
            'foreignKey' => 'aliquot_control_id',
            'type' => 'INNER'
        ),
        'Collection' => array(
            'className' => 'InventoryManagement.Collection',
            'foreignKey' => 'collection_id',
            'type' => 'INNER'
        ),
        'SampleMaster' => array(
            'className' => 'InventoryManagement.SampleMaster',
            'foreignKey' => 'sample_master_id',
            'type' => 'INNER'
        ),
        'StorageMaster' => array(
            'className' => 'StorageLayout.StorageMaster',
            'foreignKey' => 'storage_master_id'
        ),
        'StudySummary' => array(
            'className' => 'Study.StudySummary',
            'foreignKey' => 'study_summary_id'
        )
    );

    public $hasOne = array(
        'ViewAliquot' => array(
            'className' => 'InventoryManagement.ViewAliquot',
            'foreignKey' => 'aliquot_master_id',
            'dependent' => true
        )
    );

    public $virtualFields = array(
        'in_stock_order' => 'IF(AliquotMaster.in_stock = "yes - available", 1, IF(AliquotMaster.in_stock = "yes - not available", 2, 3))'
    );

    private static $warningField = "barcode";
    
    // can be overriden into a custom model
    public static $aliquotTypeDropdown = array();

    public static $storageModel = null;

    public static $studyModel = null;

    private $barcodes = array();
    
    // barcode validation, key = barcode, value = id
    public static $volumeCondition = array(
        'OR' => array(
            array(
                'AliquotControl.volume_unit' => null
            ),
            array(
                'AliquotControl.volume_unit' => ''
            )
        )
    );

    public static $joinAliquotControlOnDup = array(
        'table' => 'aliquot_controls',
        'alias' => 'AliquotControl',
        'type' => 'LEFT',
        'conditions' => array(
            'aliquot_masters_dup.aliquot_control_id = AliquotControl.id'
        )
    );

    public $registeredView = array(
        'InventoryManagement.ViewAliquot' => array(
            'AliquotMaster.id'
        ),
        'InventoryManagement.ViewAliquotUse' => array(
            'AliquotMaster.id',
            'AliquotMasterChild.id'
        )
    );

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['AliquotMaster.id'])) {
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'AliquotMaster.collection_id' => $variables['Collection.id'],
                    'AliquotMaster.sample_master_id' => $variables['SampleMaster.id'],
                    'AliquotMaster.id' => $variables['AliquotMaster.id']
                )
            ));
            if (! isset($result['AliquotMaster']['storage_coord_y'])) {
                $result['AliquotMaster']['storage_coord_y'] = "";
            }
            $return = array(
                'menu' => array(
                    null,
                    __($result['AliquotControl']['aliquot_type']) . ' : ' . $result['AliquotMaster']['barcode']
                ),
                'title' => array(
                    null,
                    __($result['AliquotControl']['aliquot_type']) . ' : ' . $result['AliquotMaster']['barcode']
                ),
                'data' => $result,
                'structure alias' => 'aliquot_masters'
            );
        }
        
        return $return;
    }

    /**
     *
     * @param $aliquotMasterId
     * @return array
     */
    public function getStorageHistory($aliquotMasterId)
    {
        $storageData = array();
        
        $qry = "SELECT sm.*, am.* FROM aliquot_masters_revs AS am
				LEFT JOIN  aliquot_masters_revs AS amn ON amn.version_id=(SELECT version_id FROM aliquot_masters_revs WHERE id=am.id AND version_id > am.version_id ORDER BY version_id ASC LIMIT 1)
				LEFT JOIN storage_masters_revs AS sm ON am.storage_master_id=sm.id
				LEFT JOIN storage_masters_revs AS smn ON smn.version_id=(SELECT version_id FROM storage_masters_revs WHERE id=sm.id AND version_id > sm.version_id ORDER BY version_id ASC LIMIT 1)
				WHERE am.id='" . $aliquotMasterId . "' AND (
					(am.version_created >= sm.version_created AND 
					(am.version_created < smn.version_created OR smn.version_created IS NULL)) OR 
					(sm.version_created > am.version_created AND (sm.version_created <= amn.version_created OR amn.version_created IS NULL)) 
					OR am.storage_master_id IS NULL) ORDER BY am.version_id";
        $storageDataTmp = $this->tryCatchQuery($qry);
        
        $previous = array_shift($storageDataTmp);
        while ($current = array_shift($storageDataTmp)) {
            if ($previous['sm']['id'] != $current['sm']['id']) {
                // filter 1 - new storage
                $storageData[]['custom'] = array(
                    'date' => $current['am']['version_created'],
                    'event' => __('new storage') . " " . __('from') . ": [" . (strlen($previous['sm']['selection_label']) > 0 ? $previous['sm']['selection_label'] . ", " . __('position') . ": (" . $previous['am']['storage_coord_x'] . ", " . $previous['am']['storage_coord_y'] . "), " . __('temperature') . ": " . $previous['sm']['temperature'] . __($previous['sm']['temp_unit']) : __('no storage')) . "] " . __('to') . ": [" . (strlen($current['sm']['selection_label']) > 0 ? $current['sm']['selection_label'] . ", " . __('position') . ": (" . $current['am']['storage_coord_x'] . ", " . $current['am']['storage_coord_y'] . "), " . __('temperature') . ": " . $current['sm']['temperature'] . __($current['sm']['temp_unit']) : __('no storage')) . "]"
                );
            } elseif ($previous['sm']['temperature'] != $current['sm']['temperature'] || $previous['sm']['selection_label'] != $current['sm']['selection_label']) {
                // filter 2, storage changes (temperature, label)
                $event = "";
                if ($previous['sm']['temperature'] != $current['sm']['temperature']) {
                    $event .= __('storage temperature changed') . ". " . __('from') . ": " . (strlen($previous['sm']['temperature']) > 0 ? $previous['sm']['temperature'] : "?") . __($previous['sm']['temp_unit']) . " " . __('to') . ": " . (strlen($current['sm']['temperature']) > 0 ? $current['sm']['temperature'] : "?") . __($current['sm']['temp_unit']) . ". ";
                }
                if ($previous['sm']['selection_label'] != $current['sm']['selection_label']) {
                    $event .= __("selection label updated") . ". " . __("from") . ": " . $previous['sm']['selection_label'] . " " . __("to") . ": " . $current['sm']['selection_label'] . ". ";
                }
                $storageData[]['custom'] = array(
                    'date' => $current['sm']['version_created'],
                    'event' => $event
                );
            } elseif ($previous['am']['storage_coord_x'] != $current['am']['storage_coord_x'] || $previous['am']['storage_coord_y'] != $current['am']['storage_coord_y']) {
                // filter 3, aliquot position change
                $coordFrom = $previous['am']['storage_coord_x'] . ", " . $previous['am']['storage_coord_y'];
                $coordTo = $current['am']['storage_coord_x'] . ", " . $current['am']['storage_coord_y'];
                $storageData[]['custom'] = array(
                    'date' => $current['am']['version_created'],
                    'event' => __('moved within storage') . " " . __('from') . ": [" . $coordFrom . "] " . __('to') . ": [" . $coordTo . "]. "
                );
            }
            
            $previous = $current;
        }
        
        return $storageData;
    }

    /**
     * **
     *
     * @deprecated
     *
     * @param $aliquotMasterId
     * @param bool $updateCurrentVolume
     * @param bool $updateUsesCounter
     * @param bool $removeFromStockIfEmptyVolume
     * @return FALSE
     */
    public function updateAliquotUseAndVolume($aliquotMasterId, $updateCurrentVolume = true, $updateUsesCounter = true, $removeFromStockIfEmptyVolume = false)
    {
        return $this->updateAliquotVolume($aliquotMasterId, $removeFromStockIfEmptyVolume);
    }

    /**
     * Update the current volume of an aliquot.
     *
     * Note:
     * - When the intial volume is null, the current volume will be set to null.
     * - Status and status reason won't be updated.
     *
     * @param $aliquotMasterId Master Id of the aliquot.
     * @param bool $removeFromStockIfEmptyVolume
     * @return FALSE when error has been detected
     *        
     *         @remove_from_stock_if_empty boolean Will set in stock to false and remove the aliquot from storage
     *        
     * @author N. Luc
     *         @date 2007-08-15
     */
    public function updateAliquotVolume($aliquotMasterId, $removeFromStockIfEmptyVolume = false)
    {
        if (empty($aliquotMasterId)) {
            AppController::getInstance()->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Get aliquot data
        $aliquotData = $this->getOrRedirect($aliquotMasterId);
        
        // Set variables
        $aliquotDataToSave = array();
        $aliquotUses = null;
        
        // MANAGE CURRENT VOLUME
        
        $initialVolume = $aliquotData['AliquotMaster']['initial_volume'];
        
        // Manage new current volume
        if (empty($initialVolume)) {
            // Initial_volume is null or equal to 0
            // To be sure value and type of both variables are identical
            $currentVolume = $initialVolume;
        } else {
            // A value has been set for the intial volume
            if ((! is_numeric($initialVolume)) || ($initialVolume < 0)) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $totalUsedVolume = 0;
            $viewAliquotUse = AppModel::getInstance("InventoryManagement", "ViewAliquotUse", true);
            $aliquotUses = $this->tryCatchQuery(str_replace('%%WHERE%%', "AND AliquotMaster.id= $aliquotMasterId", $viewAliquotUse::$tableQuery));
            foreach ($aliquotUses as $aliquotUse) {
                $usedVolume = $aliquotUse['0']['used_volume'];
                if (! empty($usedVolume)) {
                    // Take used volume in consideration only when this one is not empty
                    if ((! is_numeric($usedVolume)) || ($usedVolume < 0)) {
                        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                    $totalUsedVolume += $usedVolume;
                }
            }
            
            $currentVolume = round(($initialVolume - $totalUsedVolume), 5);
            if ($currentVolume < 0) {
                $currentVolume = 0;
                $tmpMsg = __("the aliquot with barcode [%s] has reached a volume below 0");
                AppController::addWarningMsg(sprintf($tmpMsg, $aliquotData['AliquotMaster']['barcode']));
            }
        }
        
        $aliquotDataToSave["current_volume"] = $currentVolume;
        if ($currentVolume <= 0 && $removeFromStockIfEmptyVolume) {
            $aliquotDataToSave['storage_master_id'] = null;
            $aliquotDataToSave['storage_coord_x'] = null;
            $aliquotDataToSave['storage_coord_y'] = null;
            $aliquotDataToSave['in_stock'] = 'no';
            $aliquotDataToSave['in_stock_detail'] = 'empty';
        }
        
        // SAVE DATA
        
        $aliquotDataToSave['id'] = $aliquotMasterId;
        
        // ---------------------------------------------------------
        // Set data to empty array to guaranty
        // no merge will be done with previous AliquotMaster data
        // when AliquotMaster set() function will be called again.
        // ---------------------------------------------------------
        $this->data = array(); //
        $this->id = $aliquotMasterId;
        $this->read();
        $saveRequired = false;
        foreach ($aliquotDataToSave as $keyToSave => $valueToSave) {
            if ($keyToSave == "current_volume")
                $this->data['AliquotMaster'][$keyToSave] = str_replace('0.00000', '0', $this->data['AliquotMaster'][$keyToSave]);
            if (strcmp($this->data['AliquotMaster'][$keyToSave], $valueToSave)) {
                $saveRequired = true;
            }
        }
        
        $prevCheckWritableFields = $this->checkWritableFields;
        $this->checkWritableFields = false;
        $result = $saveRequired && ! $this->save(array(
            "AliquotMaster" => $aliquotDataToSave
        ), false);
        $this->checkWritableFields = $prevCheckWritableFields;
        return ! $result;
    }

    /**
     *
     * @return array
     */
    public function getRealiquotDropdown()
    {
        return self::$aliquotTypeDropdown;
    }

    /**
     * Additional validation rule to validate stock status and storage.
     *
     * @see Model::validates()
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        if (isset($this->data['AliquotMaster']['in_stock']) && $this->data['AliquotMaster']['in_stock'] == 'no' && (! empty($this->data['AliquotMaster']['storage_master_id']) || ! empty($this->data['FunctionManagement']['recorded_storage_selection_label']))) {
            $this->validationErrors['in_stock'][] = 'an aliquot being not in stock can not be linked to a storage';
        }
        
        $this->validateAndUpdateAliquotStorageData();
        
        $this->validateAndUpdateAliquotStudyData();
        
        if (isset($this->data['AliquotMaster']['barcode'])) {
            $this->checkDuplicatedAliquotBarcode($this->data);
        }
        
        return parent::validates($options);
    }

    /**
     * Check both aliquot storage definition and aliquot positions and set error if required.
     */
    public function validateAndUpdateAliquotStorageData()
    {
        $aliquotData = & $this->data;
        
        // check data structure
        $tmpArrToCheck = array_values($aliquotData);
        if ((! is_array($aliquotData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['AliquotMaster']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Load model
        if (self::$storageModel == null) {
            self::$storageModel = AppModel::getInstance("StorageLayout", "StorageMaster", true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $aliquotData) && array_key_exists('recorded_storage_selection_label', $aliquotData['FunctionManagement'])) {
            if (! isset($aliquotData['AliquotControl']['aliquot_type'])) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            $isSampleCore = ($aliquotData['AliquotControl']['aliquot_type'] == 'core');
            
            // Check the aliquot storage definition
            $arrStorageSelectionResults = self::$storageModel->validateAndGetStorageData($aliquotData['FunctionManagement']['recorded_storage_selection_label'], $aliquotData['AliquotMaster']['storage_coord_x'], $aliquotData['AliquotMaster']['storage_coord_y'], $isSampleCore);
            
            $setStorage = false;
            foreach (array(
                'storage_data',
                'storage_definition_error',
                'position_x_error',
                'position_y_error',
                'change_position_x_to_uppercase',
                'change_position_y_to_uppercase'
            ) as $key) {
                if (! empty($arrStorageSelectionResults[$key])) {
                    $setStorage = true;
                }
            }
            
            if ($setStorage) {
                // Update aliquot data
                $aliquotData['AliquotMaster']['storage_master_id'] = isset($arrStorageSelectionResults['storage_data']['StorageMaster']['id']) ? $arrStorageSelectionResults['storage_data']['StorageMaster']['id'] : null;
                if ($arrStorageSelectionResults['change_position_x_to_uppercase']) {
                    $aliquotData['AliquotMaster']['storage_coord_x'] = strtoupper($aliquotData['AliquotMaster']['storage_coord_x']);
                }
                if ($arrStorageSelectionResults['change_position_y_to_uppercase']) {
                    $aliquotData['AliquotMaster']['storage_coord_y'] = strtoupper($aliquotData['AliquotMaster']['storage_coord_y']);
                }
                
                // Set error
                if (! empty($arrStorageSelectionResults['storage_definition_error'])) {
                    $this->validationErrors['recorded_storage_selection_label'][] = $arrStorageSelectionResults['storage_definition_error'];
                }
                if (! empty($arrStorageSelectionResults['position_x_error'])) {
                    $this->validationErrors['storage_coord_x'][] = $arrStorageSelectionResults['position_x_error'];
                }
                if (! empty($arrStorageSelectionResults['position_y_error'])) {
                    $this->validationErrors['storage_coord_y'][] = $arrStorageSelectionResults['position_y_error'];
                }
                
                if (empty($this->validationErrors['storage_coord_x']) && empty($this->validationErrors['storage_coord_y']) && array_key_exists('StorageControl', $arrStorageSelectionResults['storage_data']) && $arrStorageSelectionResults['storage_data']['StorageControl']['check_conflicts'] && (strlen($aliquotData['AliquotMaster']['storage_coord_x']) > 0 || strlen($aliquotData['AliquotMaster']['storage_coord_y']) > 0)) {
                    $exception = $this->id ? array(
                        'AliquotMaster' => $this->id
                    ) : array();
                    $positionStatus = $this->StorageMaster->positionStatusQuick($arrStorageSelectionResults['storage_data']['StorageMaster']['id'], array(
                        'x' => $aliquotData['AliquotMaster']['storage_coord_x'],
                        'y' => $aliquotData['AliquotMaster']['storage_coord_y']
                    ), $exception);
                    
                    $msg = null;
                    if ($positionStatus == StorageMaster::POSITION_OCCUPIED) {
                        $msg = __('the storage [%s] already contained something at position [%s, %s]');
                    } elseif ($positionStatus == StorageMaster::POSITION_DOUBLE_SET) {
                        $msg = __('you have set more than one element in storage [%s] at position [%s, %s]');
                    }
                    if ($msg != null) {
                        $msg = sprintf($msg, $arrStorageSelectionResults['storage_data']['StorageMaster']['selection_label'], $aliquotData['AliquotMaster']['storage_coord_x'], $aliquotData['AliquotMaster']['storage_coord_y']);
                        if ($arrStorageSelectionResults['storage_data']['StorageControl']['check_conflicts'] == 1) {
                            AppController::addWarningMsg($msg);
                        } else {
                            $this->validationErrors['storage_coord_x'][] = $msg;
                        }
                    }
                }
            } else {
                $aliquotData['AliquotMaster']['storage_master_id'] = null;
            }
        } elseif ((array_key_exists('storage_coord_x', $aliquotData['AliquotMaster']) && ! empty($aliquotData['AliquotMaster']['storage_coord_x'])) || (array_key_exists('storage_coord_y', $aliquotData['AliquotMaster']) && ! empty($aliquotData['AliquotMaster']['storage_coord_y']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
    }

    /**
     * Check aliquot study definition and set error if required.
     */
    public function validateAndUpdateAliquotStudyData()
    {
        $aliquotData = & $this->data;
        
        // check data structure
        $tmpArrToCheck = array_values($aliquotData);
        if ((! is_array($aliquotData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['AliquotMaster']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $aliquotData) && array_key_exists('autocomplete_aliquot_master_study_summary_id', $aliquotData['FunctionManagement'])) {
            $aliquotData['AliquotMaster']['study_summary_id'] = null;
            $aliquotData['FunctionManagement']['autocomplete_aliquot_master_study_summary_id'] = trim($aliquotData['FunctionManagement']['autocomplete_aliquot_master_study_summary_id']);
            if (strlen($aliquotData['FunctionManagement']['autocomplete_aliquot_master_study_summary_id'])) {
                // Load model
                if (self::$studyModel == null)
                    self::$studyModel = AppModel::getInstance("Study", "StudySummary", true);
                    
                    // Check the aliquot study definition
                $arrStudySelectionResults = self::$studyModel->getStudyIdFromStudyDataAndCode($aliquotData['FunctionManagement']['autocomplete_aliquot_master_study_summary_id']);
                
                // Set study summary id
                if (isset($arrStudySelectionResults['StudySummary'])) {
                    $aliquotData['AliquotMaster']['study_summary_id'] = $arrStudySelectionResults['StudySummary']['id'];
                }
                
                // Set error
                if (isset($arrStudySelectionResults['error'])) {
                    $this->validationErrors['autocomplete_aliquot_master_study_summary_id'][] = $arrStudySelectionResults['error'];
                }
            }
        }
    }

    /**
     * Check created barcodes are not duplicated and set error if they are.
     *
     * Note:
     * - This function supports form data structure built by either 'add' form or 'datagrid' form.
     * - Has been created to allow customisation.
     *
     * @param $aliquotData
     * @return Following results array:
     *         array(
     *         'is_duplicated_barcode' => TRUE when barcodes are duplicaed,
     *         'messages' => array($message1, $message2, ...)
     *         )
     * @internal param Aliquots $aliquotsData data stored into an array having structure like either:* data stored into an array having structure like either:
     *           - $aliquotsData = array('AliquotMaster' => array(...))
     *           or
     *           - $aliquotsData = array(array('AliquotMaster' => array(...)))
     *          
     * @author N. Luc
     *         @date 2007-08-15
     */
    public function checkDuplicatedAliquotBarcode($aliquotData)
    {
        
        // check data structure
        $tmpArrToCheck = array_values($aliquotData);
        if ((! is_array($aliquotData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['AliquotMaster']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $barcode = $aliquotData['AliquotMaster']['barcode'];
        
        // Check duplicated barcode into submited record
        if (! strlen($barcode)) {
            // Not studied
        } elseif (isset($this->barcodes[$barcode])) {
            $this->validationErrors['barcode'][] = str_replace('%s', $barcode, __('you can not record barcode [%s] twice'));
        } else {
            $this->barcodes[$barcode] = '';
        }
        
        // Check duplicated barcode into db
        $criteria = array(
            'AliquotMaster.barcode' => $barcode
        );
        $aliquotsHavingDuplicatedBarcode = $this->find('all', array(
            'conditions' => array(
                'AliquotMaster.barcode' => $barcode
            ),
            'recursive' => - 1
        ));
        
        if (! empty($aliquotsHavingDuplicatedBarcode)) {
            foreach ($aliquotsHavingDuplicatedBarcode as $duplicate) {
                if ((! array_key_exists('id', $aliquotData['AliquotMaster'])) || ($duplicate['AliquotMaster']['id'] != $aliquotData['AliquotMaster']['id'])) {
                    $this->validationErrors['barcode'][] = str_replace('%s', $barcode, __('the barcode [%s] has already been recorded'));
                }
            }
        }
    }

    /**
     *
     * @param array $aliquotMasterIds
     * @return array
     */
    public function hasChild(array $aliquotMasterIds)
    {
        $viewAliquotUse = AppModel::getInstance("InventoryManagement", "ViewAliquotUse", true);
        return array_unique(array_filter($viewAliquotUse->find('list', array(
            'fields' => array(
                'ViewAliquotUse.aliquot_master_id'
            ),
            'conditions' => array(
                'ViewAliquotUse.aliquot_master_id' => $aliquotMasterIds
            )
        ))));
    }

    /**
     * Get default storage date for a new created aliquot.
     *
     * @param $sampleMasterData Master data of the studied sample.
     *       
     * @return Default storage date.
     *        
     * @author N. Luc
     * @since 2009-09-11
     *        @updated N. Luc
     * @deprecated
     *
     */
    public function getDefaultStorageDate($sampleMasterData)
    {
        list ($date, $dateAccuaracy) = $this->getDefaultStorageDateAndAccuracy($sampleMasterData);
        return strlen($date) ? $date : null;
    }

    /**
     * Get default storage date and accuracy for a new created aliquot.
     *
     * @param $sampleMasterData Master data of the studied sample.
     *       
     * @return array(default storage date, accuracy).
     *        
     * @author N. Luc
     * @since 2016-09-29
     *        @updated N. Luc
     */
    public function getDefaultStorageDateAndAccuracy($sampleMasterData)
    {
        $sampleMasterModel = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
        $derivativeDetailModel = AppModel::getInstance("InventoryManagement", "DerivativeDetail", true);
        switch ($sampleMasterData['SampleControl']['sample_category']) {
            case 'specimen':
                // Default creation date will be the specimen reception date
                $sampleMaster = $sampleMasterModel->getOrRedirect($sampleMasterData['SampleMaster']['id']);
                return array(
                    $sampleMaster['SpecimenDetail']['reception_datetime'],
                    $sampleMaster['SpecimenDetail']['reception_datetime_accuracy']
                );
            
            case 'derivative':
                // Default creation date will be the derivative creation date or Specimen reception date
                $derivativeDetailData = $derivativeDetailModel->find('first', array(
                    'conditions' => array(
                        'DerivativeDetail.sample_master_id' => $sampleMasterData['SampleMaster']['id']
                    ),
                    'recursive' => - 1
                ));
                if (empty($derivativeDetailData)) {
                    $this->redirect('/Pages/err_plugin_funct_param_missing?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                return array(
                    $derivativeDetailData['DerivativeDetail']['creation_datetime'],
                    $derivativeDetailData['DerivativeDetail']['creation_datetime_accuracy']
                );
            
            default:
                $this->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        return array(
            '',
            ''
        );
    }

    /**
     * Check if an aliquot can be deleted.
     *
     * @param $aliquotMasterId Id of the studied sample.
     *       
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2007-10-16
     */
    public function allowDeletion($aliquotMasterId)
    {
        // Check aliquot has no use
        $aliquotInternalUseModel = AppModel::getInstance("InventoryManagement", "AliquotInternalUse", true);
        $returnedNbr = $aliquotInternalUseModel->find('count', array(
            'conditions' => array(
                'AliquotInternalUse.aliquot_master_id' => $aliquotMasterId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'use exists for the deleted aliquot'
            );
        }
        
        // Check aliquot is not linked to realiquoting process
        $realiquotingModel = AppModel::getInstance("InventoryManagement", "Realiquoting", true);
        $returnedNbr = $realiquotingModel->find('count', array(
            'conditions' => array(
                'Realiquoting.parent_aliquot_master_id' => $aliquotMasterId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'realiquoting data exists for the deleted aliquot'
            );
        }
        
        // Check aliquot is not linked to review
        $aliquotReviewMasterModel = AppModel::getInstance("InventoryManagement", "AliquotReviewMaster", true);
        $returnedNbr = $aliquotReviewMasterModel->find('count', array(
            'conditions' => array(
                'AliquotReviewMaster.aliquot_master_id' => $aliquotMasterId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'review exists for the deleted aliquot'
            );
        }
        
        // Check aliquot is not linked to order
        $orderItemModel = AppModel::getInstance("Order", "OrderItem", true);
        $returnedNbr = $orderItemModel->find('count', array(
            'conditions' => array(
                'OrderItem.aliquot_master_id' => $aliquotMasterId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'order exists for the deleted aliquot'
            );
        }
        
        // Check aliquot is not linked to a qc
        $qualityCtrlModel = AppModel::getInstance("InventoryManagement", "QualityCtrl", true);
        $returnedNbr = $qualityCtrlModel->find('count', array(
            'conditions' => array(
                'QualityCtrl.aliquot_master_id' => $aliquotMasterId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'quality control data exists for the deleted aliquot'
            );
        }
        
        // Check aliquot is not linked to a derivative
        $sourceAliquotModel = AppModel::getInstance("InventoryManagement", "SourceAliquot", true);
        $returnedNbr = $sourceAliquotModel->find('count', array(
            'conditions' => array(
                'SourceAliquot.aliquot_master_id' => $aliquotMasterId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'derivative creation data exists for the deleted aliquot'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    /**
     * Get the default realiquoting date.
     *
     * @param $aliquotDataForSelection Sample Aliquots that could be defined as child.
     *       
     * @return Default realiquoting date.
     *        
     * @author N. Luc
     * @since 2009-09-11
     *        @updated N. Luc
     */
    public function getDefaultRealiquotingDate($aliquotDataForSelection)
    {
        // Get first found storage datetime
        foreach ($aliquotDataForSelection as $aliquot) {
            if (! empty($aliquot['AliquotMaster']['storage_datetime'])) {
                return $aliquot['AliquotMaster']['storage_datetime'];
            }
        }
        return null;
    }

    /**
     *
     * @param array $aliquot with either a key 'id' referring to an array
     *        of ids, or a key 'data' referring to AliquotMaster.
     * @param If|string $modelName If
     *        the aliquot array contains data, the model name
     *        to use.
     * @return an array having unconsented aliquot as key and their consent
     *         status as value. This function refers to
     *         ViewCollection->getUnconsentedCollections.
     */
    public function getUnconsentedAliquots(array $aliquot, $modelName = 'AliquotMaster')
    {
        $data = null;
        $keyName = null;
        // preping to fetch the collection ids
        if (array_key_exists('id', $aliquot)) {
            $data = $this->find('all', array(
                'fields' => array(
                    'AliquotMaster.id',
                    'AliquotMaster.collection_id'
                ),
                'conditions' => array(
                    'AliquotMaster.id' => $aliquot['id']
                ),
                'recursive' => - 1
            ));
            $modelName = 'AliquotMaster';
            $keyName = 'id';
        } else {
            $data = array_key_exists($modelName, $aliquot) ? array(
                $aliquot
            ) : $aliquot;
            if ($modelName == 'ViewAliquot') {
                $keyName = $modelName == 'AliquotMaster' ? 'id' : 'aliquot_master_id';
            }
        }
        
        // collections ids and collection/aliquot assocs
        $collectionAliquotAssoc = array();
        $collectionIds = array();
        foreach ($data as &$dataUnit) {
            $collectionAliquotAssoc[$dataUnit[$modelName]['collection_id']][] = $dataUnit[$modelName][$keyName];
            $collectionIds[] = $dataUnit[$modelName]['collection_id'];
        }
        
        // getting unconsented collections
        $collectionModel = AppModel::getInstance("InventoryManagement", "ViewCollection", true);
        $unconsentedCollections = $collectionModel->getUnconsentedParticipantCollections(array(
            'id' => $collectionIds
        ));
        
        // building the result array
        $results = array();
        foreach ($unconsentedCollections as $collectionId => $status) {
            $results += array_fill_keys($collectionAliquotAssoc[$collectionId], $status);
        }
        
        return $results;
    }

    /**
     *
     * @param array $queryData
     * @return array
     */
    public function beforeFind($queryData)
    {
        $queryData['joins'][] = array(
            'table' => 'sample_masters',
            'alias' => 'sample_master_dup',
            'type' => 'INNER',
            'conditions' => array(
                'AliquotMaster.sample_master_id = sample_master_dup.id'
            )
        );
        $queryData['joins'][] = array(
            'table' => 'sample_controls',
            'alias' => 'SampleControl',
            'type' => 'INNER',
            'conditions' => array(
                'sample_master_dup.sample_control_id = SampleControl.id'
            )
        );
        if (empty($queryData['fields'])) {
            $queryData['fields'] = array(
                '*'
            );
        }
        
        return $queryData;
    }

    /**
     *
     * @param $modelId
     * @param bool $cascade
     * @return bool
     */
    public function atimDelete($modelId, $cascade = true)
    {
        if (parent::atimDelete($modelId, $cascade)) {
            // delete realiquotings where current id is child
            $realiquotingModel = AppModel::getInstance('InventoryManagement', 'Realiquoting', true);
            $realiquotings = $realiquotingModel->find('all', array(
                'conditions' => array(
                    'Realiquoting.child_aliquot_master_id' => $modelId
                )
            ));
            $parents = array();
            foreach ($realiquotings as $realiquoting) {
                $parents[] = $realiquoting['Realiquoting']['parent_aliquot_master_id'];
                $realiquotingModel->atimDelete($realiquoting['Realiquoting']['id']);
            }
            $parents = array_unique($parents);
            foreach ($parents as $parent) {
                $this->updateAliquotVolume($parent);
            }
            return true;
        }
        return false;
    }

    /**
     *
     * @param $onField
     * @return array
     */
    public static function joinOnAliquotDup($onField)
    {
        return array(
            'table' => 'aliquot_masters',
            'alias' => 'aliquot_masters_dup',
            'type' => 'LEFT',
            'conditions' => array(
                $onField . ' = aliquot_masters_dup.id'
            )
        );
    }

    /**
     *
     * @param $functionManagementData
     * @param $submittedAliquotMasterData
     * @param $aliquotIds
     * @return array
     */
    public function validateAliquotMasterDataUpdateInBatch($functionManagementData, $submittedAliquotMasterData, $aliquotIds)
    {
        // Set in_stock value
        // Use of field 'FunctionManagement.in_stock' to support empty value that means 'in_stock' value has not to be changed
        // (Can not use field AliquotMaster.in_stock value because this one is linked to a 'not empty' validation)
        $submittedAliquotMasterData['in_stock'] = $functionManagementData['in_stock'];
        
        $validates = true;
        
        // Check submitted data conflicts
        
        if (strlen($functionManagementData['recorded_storage_selection_label']) && (($functionManagementData['remove_from_storage'] == '1') || ($submittedAliquotMasterData['in_stock'] == 'no'))) {
            $validates = false;
            $this->validationErrors['recorded_storage_selection_label'][] = __('data conflict: you can not remove aliquot and set a storage');
            if ($submittedAliquotMasterData['in_stock'] == 'no')
                $this->validationErrors['in_stock'][] = __('data conflict: you can not remove aliquot and set a storage');
        }
        if (isset($functionManagementData['autocomplete_aliquot_master_study_summary_id']) && strlen($functionManagementData['autocomplete_aliquot_master_study_summary_id']) && $functionManagementData['remove_study_summary_id'] == '1') {
            $validates = false;
            $this->validationErrors['autocomplete_aliquot_master_study_summary_id'][] = __('data conflict: you can not delete data and set a new one');
        }
        foreach ($submittedAliquotMasterData as $key => $value) {
            if (strlen($submittedAliquotMasterData[$key]) && array_key_exists('remove_' . $key, $functionManagementData) && $functionManagementData['remove_' . $key] == '1') {
                $validates = false;
                $this->validationErrors[$key][] = __('data conflict: you can not delete data and set a new one');
            }
        }
        
        // Set gerenated aliquot master data plus launch validation on this data set
        
        $aliquotMasterDataToUpdate = array(
            'AliquotMaster' => array_filter($submittedAliquotMasterData)
        );
        $positionDeletionWarningMessage = null;
        
        if ($validates) {
            // Work on storage data
            if ($functionManagementData['recorded_storage_selection_label']) {
                $aliquotMasterDataToUpdate['FunctionManagement']['recorded_storage_selection_label'] = $functionManagementData['recorded_storage_selection_label'];
                $aliquotMasterDataToUpdate['AliquotMaster']['storage_coord_x'] = null;
                $aliquotMasterDataToUpdate['AliquotMaster']['storage_coord_y'] = null;
                $this->addWritableField(array(
                    'storage_master_id',
                    'storage_coord_x',
                    'storage_coord_y'
                ));
                
                $positionDeletionWarningMessage = 'aliquots positions have been deleted';
                
                if (empty($submittedAliquotMasterData['in_stock'])) {
                    // New stock value has not been set then won't be updated: Control above detected no conflict - Check data in db
                    $condtions = array(
                        'AliquotMaster.id' => $aliquotIds,
                        'AliquotMaster.in_stock' => 'no'
                    );
                    $aliquotNotInStock = $this->find('count', array(
                        'conditions' => $condtions,
                        'recursive' => - 1
                    ));
                    if ($aliquotNotInStock) {
                        $validates = false;
                        $positionDeletionWarningMessage = '';
                        $this->validationErrors['recorded_storage_selection_label'][] = __('data conflict: at least one updated aliquot is defined as not in stock - please update in stock value');
                    }
                }
            } elseif (($functionManagementData['remove_from_storage'] == '1') || ($submittedAliquotMasterData['in_stock'] == 'no')) {
                // Aliquots not in stcok anymore : Erase storage data
                $aliquotMasterDataToUpdate['AliquotMaster']['storage_master_id'] = null;
                $aliquotMasterDataToUpdate['AliquotMaster']['storage_coord_x'] = null;
                $aliquotMasterDataToUpdate['AliquotMaster']['storage_coord_y'] = null;
                $this->addWritableField(array(
                    'storage_master_id',
                    'storage_coord_x',
                    'storage_coord_y'
                ));
            }
            // Work on study
            if (isset($functionManagementData['autocomplete_aliquot_master_study_summary_id']) && $functionManagementData['autocomplete_aliquot_master_study_summary_id']) {
                $aliquotMasterDataToUpdate['FunctionManagement']['autocomplete_aliquot_master_study_summary_id'] = $functionManagementData['autocomplete_aliquot_master_study_summary_id'];
                $this->addWritableField(array(
                    'study_summary_id'
                ));
            } elseif (isset($functionManagementData['remove_study_summary_id']) && ($functionManagementData['remove_study_summary_id'] == '1')) {
                $aliquotMasterDataToUpdate['AliquotMaster']['study_summary_id'] = null;
                $this->addWritableField(array(
                    'study_summary_id'
                ));
            }
            // Work on other data
            foreach ($submittedAliquotMasterData as $key => $value) {
                if (array_key_exists('remove_' . $key, $functionManagementData) && $functionManagementData['remove_' . $key] == '1') {
                    $aliquotMasterDataToUpdate['AliquotMaster'][$key] = null;
                }
            }
        }
        if ($validates) {
            $aliquotMasterDataToUpdate['AliquotMaster']['aliquot_control_id'] = 1; // to allow validation, remove afterward
            $notCoreNbr = $this->find('count', array(
                'conditions' => array(
                    'AliquotMaster.id' => $aliquotIds,
                    "AliquotControl.aliquot_type != 'core'"
                )
            ));
            $aliquotMasterDataToUpdate['AliquotControl']['aliquot_type'] = $notCoreNbr ? 'not core' : 'core'; // to allow tma storage check (check aliquot != than core is not stored into TMA block), remove afterward
            $this->set($aliquotMasterDataToUpdate);
            if (! $this->validates()) {
                $validates = false;
            }
            $aliquotMasterDataToUpdate = $this->data;
            unset($aliquotMasterDataToUpdate['AliquotMaster']['aliquot_control_id']);
            unset($aliquotMasterDataToUpdate['AliquotControl']['aliquot_type']);
        }
        
        if (sizeof($aliquotMasterDataToUpdate['AliquotMaster']) == '1' && array_key_exists('__validated__', $aliquotMasterDataToUpdate['AliquotMaster']))
            $aliquotMasterDataToUpdate['AliquotMaster'] = array(); // No data to save
        
        return array(
            $aliquotMasterDataToUpdate,
            $validates,
            $positionDeletionWarningMessage
        );
    }

    /**
     *
     * @param $data
     * @return array
     */
    public function getAliquotDataStorageAndStockToApplyToAll($data)
    {
        $errors = array();
        $usedAliquotDataToApplyToAll = array();
        if (isset($data['FunctionManagement']) && array_key_exists('in_stock', $data['FunctionManagement'])) {
            if ($data['FunctionManagement']['remove_in_stock_detail'] && strlen($data['AliquotMaster']['in_stock_detail'])) {
                $errors['in_stock_detail'][__('data conflict: you can not delete data and set a new one')][] = __('data to apply to all');
                $data['FunctionManagement']['remove_in_stock_detail'] = '';
                $data['AliquotMaster']['in_stock_detail'] = '';
            }
            // In stock detail of parent to apply to all
            foreach (array(
                'FunctionManagement',
                'AliquotMaster'
            ) as $tmpModel) {
                if (isset($data[$tmpModel])) {
                    foreach ($data[$tmpModel] as $tmpField => $tmpFieldValue) {
                        if (! empty($data[$tmpModel][$tmpField])) {
                            if ($tmpModel . '.' . $tmpField == 'FunctionManagement.in_stock') {
                                $usedAliquotDataToApplyToAll['AliquotMaster'][$tmpField] = $data[$tmpModel][$tmpField];
                            } elseif ($tmpModel . '.' . $tmpField == 'FunctionManagement.remove_in_stock_detail') {
                                $usedAliquotDataToApplyToAll['AliquotMaster']['in_stock_detail'] = '';
                            } else {
                                $usedAliquotDataToApplyToAll[$tmpModel][$tmpField] = $data[$tmpModel][$tmpField];
                            }
                        }
                    }
                }
            }
        }
        return array(
            $usedAliquotDataToApplyToAll,
            $errors
        );
    }

    /**
     * Find the list of aliquot related to the barcode and check if the storage type is TMA
     *
     * @param type $storageId
     * @param type $barcode
     * @return array The list of aliquot
     */
    public function getAliquotByBarcode($storageId, $barcode)
    {
        $aliquots = $this->find('all', array(
            'conditions' => array(
                'BINARY(AliquotMaster.barcode)' => $barcode
            ),
            'fields' => array(
                'AliquotMaster.id',
                'AliquotMaster.barcode',
                'AliquotMaster.aliquot_label',
                'AliquotMaster.collection_id',
                'AliquotMaster.aliquot_control_id',
                'AliquotMaster.sample_master_id',
                'AliquotMaster.sop_master_id',
                'AliquotMaster.in_stock',
                'AliquotMaster.storage_master_id',
                'AliquotMaster.storage_coord_x',
                'AliquotMaster.storage_coord_y',
                'AliquotMaster.aliquot_control_id',
                'StorageMaster.short_label',
                'AliquotControl.aliquot_type',
                'AliquotMaster.id'
            )
        ));
        $storageMasterModel = AppModel::getInstance('StorageLayout', 'StorageMaster');
        
        $storage = $storageMasterModel->find('first', array(
            'conditions' => array(
                'StorageMaster.id' => $storageId
            )
        ));
        $isTma = $storage['StorageControl']['is_tma_block'];
        return array(
            'aliquots' => $aliquots,
            'isTma' => $isTma
        );
    }

    /**
     * readCsvAndConvertToArray Read the CSV file and put the information in to the arrays with
     *
     * @param type $dataFile The file information come from front-end
     * @param type $storageId Storage ID
     * @return array The message, validation and Array of data
     */
    public function readCsvAndConvertToArray($dataFile, $storageId, $csvSeparator = CSV_SEPARATOR)
    {
        $response = array(
            "valid" => 1,
            "message" => "",
            "data" => array()
        );
        if (empty($dataFile)) {
            $response["message"] = __('error in opening csv file');
            $response["valid"] = 0;
            return $response;
        }
        
        $fileName = $dataFile["tmp_name"];
        $size = $dataFile["size"];
        $name = $dataFile["name"];
        $error = $dataFile["error"];
        
        $debug = (Configure::read("debug") > 0) ? true : false;
        
        $maxUploadFileSize = Configure::read("maxUploadFileSize");
        if ($size > $maxUploadFileSize) {
            $response["message"] = __('the file size should be less than %d bytes', Configure::read('maxUploadFileSize'));
            $response["valid"] = 0;
            return $response;
        }
        
        try {
            $handle = fopen($fileName, "r");
        } catch (Exception $ex) {
            $response["message"] = ($debug) ? __('error in opening %s', $name) : $ex . getMessage();
            $response["valid"] = 0;
            return $response;
        }
        
        if ($handle == false) {
            $response["message"] = __('error in opening %s', $name);
            $response["valid"] = 0;
            return $response;
        }
        
        if (! empty($error)) {
            $response["message"] = ($debug) ? __('error in opening %s', $name) : $error;
            $response["valid"] = 0;
            return $response;
        }
        
        $row = 1;
        $header = fgetcsv($handle, 1000, $csvSeparator);
        if ($header == false) {
            $response["message"] = __("error in csv header file");
            $response["valid"] = 0;
            return $response;
        }
        
        $barcode = $x = $y = - 1;
        $numColumn = count($header);
        for ($c = 0; $c < $numColumn; $c ++) {
            $data[$c] = Inflector::singularize(strtolower(trim($header[$c])));
            if ($data[$c] == 'barcode') {
                $barcode = $c;
            } elseif ($data[$c] == 'x') {
                $x = $c;
            } elseif ($data[$c] == 'y') {
                $y = $c;
            }
        }
        
        if (! isset($data[0]) || ! isset($data[1])) {
            if ($x == - 1) {
                $response["message"] = __("should have X column");
                $response["valid"] = 0;
                return $response;
            }
            
            if ($barcode == - 1) {
                $response["message"] = __("should have barcode column");
                $response["valid"] = 0;
                return $response;
            }
        } elseif ($x == - 1 && $barcode == - 1) {
            $barcode = 0;
            $x = 1;
            if (isset($data[2])) {
                $y = 2;
            }
            rewind($handle);
            $row = 0;
        }
        
        $storageMasterModel = AppModel::getInstance('StorageLayout', 'StorageMaster');
        $storage = $storageMasterModel->find('first', array(
            'conditions' => array(
                'StorageMaster.id' => $storageId
            )
        ));
        $coordXSize = $storage['StorageControl']['coord_x_size'];
        $coordYSize = $storage['StorageControl']['coord_y_size'];
        $coordXType = $storage['StorageControl']['coord_x_type'];
        $coordYType = $storage['StorageControl']['coord_y_type'];
        $permut = $storage['StorageControl']['permute_x_y'];
        if ($permut) {
            list ($coordXSize, $coordYSize) = array(
                $coordYSize,
                $coordXSize
            );
            list ($coordXType, $coordYType) = array(
                $coordYType,
                $coordXType
            );
        }
        if ($coordXType == 'list') {
            $y = - 1;
            $storageCoordinateModel = AppModel::getInstance('StorageLayout', 'StorageCoordinate');
            $storage = $storageCoordinateModel->find('all', array(
                'conditions' => array(
                    'StorageCoordinate.storage_master_id' => $storageId
                )
            ));
            $response["message"] = __('for now listed storage is not supported');
            $response["valid"] = 0;
            return $response;
        }
        
        $isTma = $storage['StorageControl']['is_tma_block'];
        
        if (! empty($coordYSize) && $coordYSize > 0 && $y == - 1) {
            $response["message"] = __("should have Y column");
            $response["valid"] = 0;
            return $response;
        }
        if (empty($coordYSize) && $y != - 1) {
            // $y = - 1;
        }
        
        $dataArray = array();
        $barcodes = array();
        
        while (($data = fgetcsv($handle, 1000, $csvSeparator)) !== false) {
            foreach ($data as &$d) {
                $d = trim($d);
            }
            $row ++;
            if (empty($data[$barcode])) {
                continue;
            }
            
            $dataArray["message"] = array(
                "warning" => array(),
                "error" => array()
            );
            $dataArray["class"] = "";
            
            $dataArray["barcode"] = $data[$barcode];
            $barcodes[] = $data[$barcode];
            
            $dataArray["OK"] = 1;
            if ($coordXType == 'alphabetical') {
                $xx = strtoupper($data[$x]);
                $dataArray["x"] = $xx;
                if (is_numeric($xx)) {
                    $dataArray["message"]["error"][] = __("the x dimension should be alphabetical");
                    $dataArray["OK"] = 0;
                } elseif (! (is_string($xx) && 'A' <= $xx && $xx <= chr(64 + $coordXSize) && strlen($xx) == 1)) {
                    $dataArray["message"]["error"][] = __("error in x dimension: %s", $xx);
                    $dataArray["OK"] = 0;
                }
            } elseif ($coordXType == 'integer') {
                $dataArray["x"] = $data[$x];
                if (! is_numeric($data[$x])) {
                    $dataArray["message"]["error"][] = __("the x dimension should be numeric");
                    $dataArray["OK"] = 0;
                } elseif (! (0 <= $data[$x] && $data[$x] <= $coordXSize) && ! $error) {
                    $dataArray["OK"] = 0;
                    $dataArray["message"]["error"][] = __("the x dimension out of range <= %s", $coordXSize);
                    $dataArray["x"] = - $data[$x];
                }
            }
            
            if ($y != - 1) {
                if (empty($coordYSize) && ! empty($data[$y])) {
                    $dataArray["OK"] = 0;
                    $dataArray["message"]["error"][] = __("should not have y dimension");
                } elseif ($coordYType == 'alphabetical') {
                    $yy = strtoupper($data[$y]);
                    $dataArray["y"] = $yy;
                    if (is_numeric($yy)) {
                        $dataArray["OK"] = 0;
                        $dataArray["message"]["error"][] = __("the y dimension should be alphabetical");
                    } elseif (! (is_string($yy) && 'A' <= $yy && $yy <= chr(64 + $coordYSize) && strlen($yy) == 1)) {
                        $dataArray["OK"] = 0;
                        $dataArray["message"]["error"][] = __("error in y dimension: %s", $yy);
                    }
                } elseif ($coordYType == 'integer') {
                    $dataArray["y"] = $data[$y];
                    if (! is_numeric($data[$y])) {
                        $dataArray["OK"] = 0;
                        $dataArray["message"]["error"][] = __("the y dimension should be numeric");
                    } elseif (! (1 <= $data[$y] && $data[$y] <= $coordYSize) && ! $error) {
                        $dataArray["OK"] = 0;
                        $dataArray["message"]["error"][] = __("the y dimension out of range <= %s", $coordYSize);
                        $dataArray["y"] = - $data[$y];
                    }
                }
            }
            
            $response['data'][] = $dataArray;
        }
        $aliquotsCheckAll = $this->find('all', array(
            'conditions' => array(
                'BINARY(AliquotMaster.barcode)' => $barcodes
            ),
            'fields' => array(
                'AliquotMaster.id',
                'AliquotMaster.barcode',
                'AliquotMaster.aliquot_label',
                'AliquotMaster.collection_id',
                'AliquotMaster.aliquot_control_id',
                'AliquotMaster.sample_master_id',
                'AliquotMaster.sop_master_id',
                'AliquotMaster.in_stock',
                'AliquotMaster.storage_master_id',
                'AliquotMaster.storage_coord_x',
                'AliquotMaster.storage_coord_y',
                'AliquotMaster.aliquot_control_id',
                'StorageMaster.short_label',
                'AliquotControl.aliquot_type',
                'AliquotMaster.id'
            )
        ));
        $barcodesList = array();
        foreach ($response['data'] as &$dataArray) {
            $aliquotsCheck = array();
            foreach ($aliquotsCheckAll as $ali) {
                if ($ali['AliquotMaster']['barcode'] == $dataArray['barcode']) {
                    $aliquotsCheck[] = $ali;
                    break;
                }
            }
            
            if (count($aliquotsCheck) == 1) {
                $resultCheck = $aliquotsCheck[0];
                $dataArray["id"] = $resultCheck['AliquotMaster']['id'];
                $dataArray["collectionId"] = $resultCheck['AliquotMaster']['collection_id'];
                $dataArray["sampleMasterId"] = $resultCheck['AliquotMaster']['sample_master_id'];
                $xCheck = $resultCheck['AliquotMaster']['storage_coord_x'];
                $yCheck = $resultCheck['AliquotMaster']['storage_coord_y'];
                $storageLabelCheck = $resultCheck['StorageMaster']['short_label'];
                $aliquotTypeCheck = $resultCheck['AliquotControl']['aliquot_type'];
                $availableCheck = $resultCheck['AliquotMaster']['in_stock'];
                $labelCheck = $resultCheck['AliquotMaster']['aliquot_label'];
                
                if ((! empty($xCheck) || ! empty($yCheck) || ! empty($storageLabelCheck)) && strpos($dataArray["class"], 'duplicated-aliquot') === false) {
                    $dataArray["message"]['warning'][] = __('this aliquot is registered in another place. label: %s, x: %s, y: %s', $storageLabelCheck, $xCheck, $yCheck);
                    $dataArray["class"] = 'duplicated-aliquot warning-aliquot';
                }
                if ($aliquotTypeCheck != 'core' && $isTma) {
                    $dataArray["message"]['error'][] = __('only sample core can be stored into tma block');
                    $error = true;
                }
                if ($availableCheck == 'no' && ! $error) {
                    $dataArray["message"]['error'][] = __('aliquot is not in stock');
                    $error = true;
                }
                if (! $error) {
                    if (in_array($dataArray['barcode'], $barcodesList) !== false) {
                        // $dataArray["message"]['warning'][] = __("duplicate barcode in csv file");
                        foreach ($response['data'] as $k => $aliquotValue) {
                            if ($aliquotValue['barcode'] == $dataArray['barcode']) {
                                if (empty($aliquotValue["message"]['error'])) {
                                    $existe = false;
                                    foreach ($aliquotValue["message"]['warning'] as $message) {
                                        if ($message == __("duplicate barcode in csv file")) {
                                            $existe = true;
                                            break;
                                        }
                                    }
                                    if (! $existe) {
                                        $response['data'][$k]["message"]['warning'][] = __("duplicate barcode in csv file");
                                    }
                                }
                            }
                        }
                    }
                    $barcodesList[] = $dataArray['barcode'];
                }
            } elseif (count($aliquotsCheck) == 0) {
                $dataArray["message"]['error'][] = __('aliquot does not exist');
                $error = true;
            }
            if (! empty($labelCheck)) {
                $dataArray["label"] = $labelCheck;
            }
        }
        fclose($handle);
        return $response;
    }
}