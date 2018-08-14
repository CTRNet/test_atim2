<?php

// $aliquotControl
if ($aliquotControl['AliquotControl']['aliquot_type'] == 'whatman paper') {
    AppController::addWarningMsg(__('whatman paper should not be created anymore'));
}

$defaultAliquotData = array();
$processingSiteLastBarcode = null;
$dataSetNbrInError = array();
$tmpRecordCounter = 0;
foreach ($this->request->data as &$newSampleRecord) {
    
    // ATiM Processing Site Data Check
    // ===================================================
    // A new aliquot can be created for a sample created by system to migrate aliquot from ATiM-Processing site and defined as created by another bank than the bank of the ATiM used when
    // at least one aliquot is still recorded for this sample (aliquot previously transferred from bank different than PS3 to 'Processing Site'
    // and now merged into the ATiM of PS3)
    
    $tmpRecordCounter ++;
    if ($newSampleRecord['parent']['ViewSample']['procure_created_by_bank'] == 's') {
        $tmpAliquotsCount = $this->AliquotMaster->find('count', array(
            'conditions' => array(
                'AliquotMaster.sample_master_id' => $newSampleRecord['parent']['ViewSample']['sample_master_id']
            )
        ));
        if (! $tmpAliquotsCount) {
            $dataSetNbrInError[] = $tmpRecordCounter;
        }
    }
    
    // Set Default Data
    // ===================================================
    
    $setDefaultValue = true;
    $tmpDefaultAliquotData = array();
    
    $sampleData = $this->SampleMaster->find('first', array(
        'conditions' => array(
            'SampleMaster.id' => $newSampleRecord['parent']['ViewSample']['sample_master_id']
        ),
        'recursive' => 0
    ));
    
    $participantIdentifier = empty($newSampleRecord['parent']['ViewSample']['participant_identifier']) ? '?' : $newSampleRecord['parent']['ViewSample']['participant_identifier'];
    $visite = $newSampleRecord['parent']['ViewSample']['procure_visit'];
    
    $barcodeSuffix = '-?';
    $defaultInStockValue = 'yes - available';
    $defaultStorageDatetime = ($sampleData['SampleControl']['sample_category'] == 'specimen') ? $sampleData['SpecimenDetail']['reception_datetime'] : $sampleData['DerivativeDetail']['creation_datetime'];
    $defaultStorageDatetimeAccuracy = 'h';
    if (in_array($newSampleRecord['parent']['ViewSample']['sample_type'], array(
        'serum',
        'pbmc',
        'buffy coat',
        'plasma'
    ))) {
        $sampleControlIds = $this->SampleControl->find('list', array(
            'conditions' => array(
                'sample_type' => array(
                    'serum',
                    'plasma',
                    'buffy coat',
                    'pbmc'
                )
            )
        ));
        $aliquotControlIds = $this->AliquotControl->find('list', array(
            'conditions' => array(
                'sample_control_id' => $sampleControlIds
            )
        ));
        $collectionBloodDerivativeAliquots = $this->AliquotMaster->find('first', array(
            'conditions' => array(
                'AliquotMaster.collection_id' => $newSampleRecord['parent']['ViewSample']['collection_id'],
                'AliquotMaster.aliquot_control_id' => $aliquotControlIds
            ),
            'order' => array(
                'AliquotMaster.storage_datetime DESC'
            ),
            'recursive' => 1
        ));
        if ($collectionBloodDerivativeAliquots) {
            $defaultStorageDatetime = $collectionBloodDerivativeAliquots['AliquotMaster']['storage_datetime'];
            $defaultStorageDatetimeAccuracy = $collectionBloodDerivativeAliquots['AliquotMaster']['storage_datetime_accuracy'];
        }
    }
    $defaultVolume = '';
    $defaultConcentrationUnit = '';
    $defaultHemolysisSigns = '';
    
    $defaultStorage = null;
    $lastStoredAliquot = $this->AliquotMaster->find('first', array(
        'conditions' => array(
            'AliquotMaster.aliquot_control_id' => $aliquotControl['AliquotControl']['id'],
            'AliquotMaster.storage_master_id IS NOT NULL'
        ),
        'recursive' => 0,
        'order' => array(
            'AliquotMaster.created DESC'
        )
    ));
    if ($lastStoredAliquot)
        $defaultStorage = $this->StorageMaster->getStorageLabelAndCodeForDisplay(array(
            'StorageMaster' => $lastStoredAliquot['StorageMaster']
        ));
    
    switch ($newSampleRecord['parent']['ViewSample']['sample_type'] . '-' . $aliquotControl['AliquotControl']['aliquot_type']) {
        // --------------------------------------------------------------------------------
        // BLOOD
        // --------------------------------------------------------------------------------
        case 'blood-tube':
            switch ($sampleData['SampleDetail']['blood_type']) {
                case 'paxgene':
                    $barcodeSuffix = '-RNB';
                    $defaultVolume = '9';
                    break;
                default:
                    $barcodeSuffix = '-?';
                    $defaultInStockValue = 'no';
            }
            break;
        case 'serum-tube':
            $defaultHemolysisSigns = 'n';
            $defaultVolume = '1.8';
            $barcodeSuffix = '-SER';
            break;
        case 'plasma-tube':
            $defaultHemolysisSigns = 'n';
            $defaultVolume = '1.8';
            $barcodeSuffix = '-PLA';
            break;
        case 'pbmc-tube':
            $barcodeSuffix = '-PBMC';
            $defaultVolume = '1';
            $tmpDefaultAliquotData['AliquotDetail.procure_date_at_minus_80'] = substr($defaultStorageDatetime, 0, 10);
            $tmpDefaultAliquotData['AliquotDetail.procure_date_at_minus_80_accuracy'] = str_replace(array(
                '',
                'i',
                'h'
            ), array(
                'c',
                'c',
                'c'
            ), $defaultStorageDatetimeAccuracy);
            if ($tmpDefaultAliquotData['AliquotDetail.procure_date_at_minus_80_accuracy'] == 'c') {
                $defaultStorageDatetime = date('Y-m-d', strtotime($tmpDefaultAliquotData['AliquotDetail.procure_date_at_minus_80'] . "+1 day"));
                $defaultStorageDatetimeAccuracy = 'h';
            } else {
                $defaultStorageDatetime = '';
                $defaultStorageDatetimeAccuracy = '';
            }
            break;
        case 'buffy coat-tube':
            $barcodeSuffix = '-BFC';
            break;
        // --------------------------------------------------------------------------------
        // URINE
        // --------------------------------------------------------------------------------
        case 'urine-cup':
            $barcodeSuffix = '-URI';
            $defaultInStockValue = 'no';
            $defaultVolume = $sampleData['SampleDetail']['collected_volume'];
            break;
        case 'centrifuged urine-tube':
            $barcodeSuffix = '-URN';
            $defaultVolume = '5';
            break;
        // --------------------------------------------------------------------------------
        // TISSUE
        // --------------------------------------------------------------------------------
        case 'tissue-block':
            $barcodeSuffix = '-FRZ';
            break;
        // --------------------------------------------------------------------------------
        // RNA
        // --------------------------------------------------------------------------------
        case 'rna-tube':
            $barcodeSuffix = '-RNA';
            $defaultConcentrationUnit = 'ng/ul';
            if (is_null($templateInitId) && sizeof($newSampleRecord['children']) == 1)
                $newSampleRecord['children'][1] = $newSampleRecord['children'][0];
            break;
        // --------------------------------------------------------------------------------
        // DNA
        // --------------------------------------------------------------------------------
        case 'dna-tube':
            $barcodeSuffix = '-DNA';
            $defaultConcentrationUnit = 'ng/ul';
            if (is_null($templateInitId) && sizeof($newSampleRecord['children']) == 1)
                $newSampleRecord['children'][1] = $newSampleRecord['children'][0];
            break;
        // --------------------------------------------------------------------------------
        // Unknown
        // --------------------------------------------------------------------------------
        default:
            $setDefaultValue = false;
    }
    
    // SET data
    
    if ($setDefaultValue) {
        $tmpDefaultAliquotData['AliquotMaster.barcode'] = $participantIdentifier . ' ' . $visite . ' ' . $barcodeSuffix;
        $tmpDefaultAliquotData['AliquotMaster.in_stock'] = $defaultInStockValue;
        $tmpDefaultAliquotData['AliquotMaster.storage_datetime'] = $defaultStorageDatetime;
        $tmpDefaultAliquotData['AliquotMaster.storage_datetime_accuracy'] = $defaultStorageDatetimeAccuracy;
        if (strlen($defaultVolume))
            $tmpDefaultAliquotData['AliquotMaster.initial_volume'] = $defaultVolume;
        if ($defaultConcentrationUnit)
            $tmpDefaultAliquotData['AliquotDetail.concentration_unit'] = $defaultConcentrationUnit;
        if ($defaultHemolysisSigns)
            $tmpDefaultAliquotData['AliquotDetail.hemolysis_signs'] = $defaultHemolysisSigns;
        if ($defaultStorage)
            $tmpDefaultAliquotData['FunctionManagement.recorded_storage_selection_label'] = $defaultStorage;
            // Add barcode suffix number
        $counter = 0;
        foreach ($newSampleRecord['children'] as &$newAliquot) {
            $counter ++;
            if ($counter == '2' && $newSampleRecord['parent']['ViewSample']['sample_type'] == 'buffy coat') {
                $counter ++;
                $newAliquot['AliquotMaster']['initial_volume'] = '0.3';
            }
            $newAliquot['AliquotMaster']['barcode'] = $tmpDefaultAliquotData['AliquotMaster.barcode'] . $counter;
        }
        $defaultAliquotData[$newSampleRecord['parent']['ViewSample']['sample_master_id']] = $tmpDefaultAliquotData;
    }
}
$this->set('defaultAliquotData', $defaultAliquotData);

// ATiM Processing Site Data Check
// ===================================================

if ($dataSetNbrInError) {
    $this->atimFlashError(__('no aliquot can be created from sample created by system/script to migrate data from the processing site with no aliquot') . ' ' . str_replace('%s', '[' . implode('] ,[', $dataSetNbrInError) . ']', __('see # %s')), $urlToCancel, 5);
    return;
}