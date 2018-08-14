<?php

class AliquotMasterCustom extends AliquotMaster
{

    var $useTable = 'aliquot_masters';

    var $name = 'AliquotMaster';

    public function validates($options = array())
    {
        $valRes = parent::validates($options);
        
        if (array_key_exists('AliquotDetail', $this->data)) {
            if (array_key_exists('block_type', $this->data['AliquotDetail']) && ! in_array(($this->data['AliquotDetail']['block_type'] . $this->data['AliquotDetail']['procure_freezing_type']), array(
                'frozen',
                'frozenISO',
                'frozenISO+OCT',
                'frozenOCT',
                'paraffin'
            ))) {
                $this->validationErrors['procure_freezing_type'][] = 'only frozen blocks can be associated to a freezing type';
                $valRes = false;
            }
            if (array_key_exists('procure_card_completed_datetime', $this->data['AliquotDetail']) && strlen($this->data['AliquotMaster']['storage_datetime'])) {
                $this->validationErrors['storage_datetime'][] = 'no storage datetime has to be completed for whatman paper';
                $valRes = false;
            }
            // Manage Bioanalyzer Concentration and quantity
            if (array_key_exists('concentration', $this->data['AliquotDetail']) && strlen($this->data['AliquotDetail']['concentration']) && ! strlen($this->data['AliquotDetail']['concentration_unit'])) {
                $this->validationErrors['concentration_unit'][] = 'concentration unit has to be completed';
                $valRes = false;
            }
            // Manage Nanodrop Concentration and quantity
            if (array_key_exists('procure_concentration_nanodrop', $this->data['AliquotDetail']) && strlen($this->data['AliquotDetail']['procure_concentration_nanodrop']) && ! strlen($this->data['AliquotDetail']['procure_concentration_unit_nanodrop'])) {
                $this->validationErrors['procure_concentration_unit_nanodrop'][] = 'concentration unit has to be completed';
                $valRes = false;
            }
            if (array_key_exists('procure_freezing_type', $this->data['AliquotDetail']) && $this->data['AliquotDetail']['procure_freezing_type'] == 'OCT') {
                AppController::addWarningMsg(__('block freezing type OCT has not to be used anymore'));
            }
            if (array_key_exists('procure_date_at_minus_80', $this->data['AliquotDetail'])) {
                $procureTimeAtMinus80Days = '';
                if ($this->data['AliquotDetail']['procure_date_at_minus_80'] && $this->data['AliquotMaster']['storage_datetime']) {
                    if ($this->data['AliquotDetail']['procure_date_at_minus_80_accuracy'] == 'c' && in_array($this->data['AliquotMaster']['storage_datetime_accuracy'], array(
                        'c',
                        'h',
                        'i',
                        ''
                    ))) {
                        $datetime1 = new DateTime($this->data['AliquotDetail']['procure_date_at_minus_80']);
                        $datetime2 = new DateTime(substr($this->data['AliquotMaster']['storage_datetime'], 0, 10));
                        $interval = $datetime1->diff($datetime2);
                        if ($interval->invert) {
                            $this->validationErrors['procure_date_at_minus_80'][] = 'error in the date definitions';
                            $valRes = false;
                        } else {
                            $procureTimeAtMinus80Days = $interval->days;
                        }
                    } else {
                        AppController::addWarningMsg(__('storage dates precisions do not allow system to calculate the days at -80'));
                    }
                }
                $this->data['AliquotDetail']['procure_time_at_minus_80_days'] = $procureTimeAtMinus80Days;
                $this->addWritableField(array(
                    'procure_time_at_minus_80_days'
                ));
            }
        }
        
        return $valRes;
    }

    private $validateBarcodeStillLaunched = false;

    public function validateBarcode($barcode, $procureCreatedByBank, $procureParticipantIdentifier = null, $procureVisit = null)
    {
        // Check if user is recording data for new collected samples (considering user is using collection tempalte or not)
        $isCollectionTempalteUse = isset(AppController::getInstance()->passedArgs['templateInitId']) ? true : false;
        // Launch validation
        $error = false;
        if (! $procureParticipantIdentifier || ! $procureVisit || ! preg_match('/^' . $procureParticipantIdentifier . ' ' . $procureVisit . ' \-[A-Z]{3}/', $barcode)) {
            if (! $isCollectionTempalteUse) {
                if (! $this->validateBarcodeStillLaunched) {
                    AppController::addWarningMsg(__('aliquot barcode format errror - warning'));
                }
            } else {
                $error = 'aliquot barcode format errror - error';
            }
        }
        $this->validateBarcodeStillLaunched = true;
        return $error;
    }

    public function calculateRnaQuantity($aliquotData)
    {
        // Get initial volume
        $currentVolume = null;
        if (array_key_exists('AliquotMaster', $aliquotData) && array_key_exists('current_volume', $aliquotData['AliquotMaster']) && array_key_exists('AliquotControl', $aliquotData) && array_key_exists('volume_unit', $aliquotData['AliquotControl'])) {
            if ($aliquotData['AliquotControl']['volume_unit'] == 'ul') {
                if (strlen($aliquotData['AliquotMaster']['current_volume']))
                    $currentVolume = $aliquotData['AliquotMaster']['current_volume'];
            } else {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        }
        // Calculate quantity
        $procureTotalQuantityUg = '';
        $procureTotalQuantityUgNanodrop = '';
        if (! is_null($currentVolume)) {
            // Bioanalyzer
            if (array_key_exists('AliquotDetail', $aliquotData) && array_key_exists('concentration', $aliquotData['AliquotDetail']) && strlen($aliquotData['AliquotDetail']['concentration']) && array_key_exists('concentration_unit', $aliquotData['AliquotDetail'])) {
                $concentration = $aliquotData['AliquotDetail']['concentration'];
                switch ($aliquotData['AliquotDetail']['concentration_unit']) {
                    case 'pg/ul':
                        $concentration = $concentration / 1000;
                    case 'ng/ul':
                        $concentration = $concentration / 1000;
                    case 'ug/ul':
                        $procureTotalQuantityUg = $currentVolume * $concentration;
                        break;
                    default:
                        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            }
            // Nanodrop
            if (array_key_exists('AliquotDetail', $aliquotData) && array_key_exists('procure_concentration_nanodrop', $aliquotData['AliquotDetail']) && strlen($aliquotData['AliquotDetail']['procure_concentration_nanodrop']) && array_key_exists('procure_concentration_unit_nanodrop', $aliquotData['AliquotDetail'])) {
                $concentration = $aliquotData['AliquotDetail']['procure_concentration_nanodrop'];
                switch ($aliquotData['AliquotDetail']['procure_concentration_unit_nanodrop']) {
                    case 'pg/ul':
                        $concentration = $concentration / 1000;
                    case 'ng/ul':
                        $concentration = $concentration / 1000;
                    case 'ug/ul':
                        $procureTotalQuantityUgNanodrop = $currentVolume * $concentration;
                        break;
                    default:
                        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            }
        }
        return array(
            $procureTotalQuantityUg,
            $procureTotalQuantityUgNanodrop
        );
    }

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
        // PROCURE
        $aliquotDetailDataToSave = array();
        if ($saveRequired && $aliquotData['SampleControl']['sample_type'] == 'rna' && $aliquotData['AliquotControl']['aliquot_type'] == 'tube' && array_key_exists('current_volume', $aliquotDataToSave)) {
            $tmpAliquotData = $aliquotData;
            $tmpAliquotData['AliquotMaster']['current_volume'] = $aliquotDataToSave["current_volume"];
            list ($aliquotDetailDataToSave['procure_total_quantity_ug'], $aliquotDetailDataToSave['procure_total_quantity_ug_nanodrop']) = $this->calculateRnaQuantity($tmpAliquotData);
        }
        $result = $saveRequired && ! $this->save(array(
            "AliquotMaster" => $aliquotDataToSave,
            "AliquotDetail" => $aliquotDetailDataToSave
        ), false);
        // $result = $saveRequired && !$this->save(array("AliquotMaster" => $aliquotDataToSave), false);
        // END PROCURE
        $this->checkWritableFields = $prevCheckWritableFields;
        return ! $result;
    }
}