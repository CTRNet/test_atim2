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
    
    $tmpDefaultAliquotData = array();
    
    // Storage
    
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
    if ($lastStoredAliquot) {
        $tmpDefaultAliquotData['FunctionManagement.recorded_storage_selection_label'] = $this->StorageMaster->getStorageLabelAndCodeForDisplay(array(
            'StorageMaster' => $lastStoredAliquot['StorageMaster']
        ));
    }
    
    // barcode & more
    
    $barcodeSuffix = null;switch ($newSampleRecord['parent']['ViewSample']['sample_type'] . '-' . $aliquotControl['AliquotControl']['aliquot_type']) {
        // --------------------------------------------------------------------------------
        // BLOOD
        // --------------------------------------------------------------------------------
        case 'blood-tube':
            $sampleData = $this->SampleMaster->find('first', array(
                'conditions' => array(
                    'SampleMaster.id' => $newSampleRecord['parent']['ViewSample']['sample_master_id']
                ),
                'recursive' => 0
            ));
            if ($sampleData['SampleDetail']['blood_type'] == 'paxgene') {
                $barcodeSuffix = '-RNB';
            }
            break;
        case 'serum-tube':
            $barcodeSuffix = '-SER';
            break;
        case 'plasma-tube':
            $barcodeSuffix = '-PLA';
            break;
        case 'pbmc-tube':
            $barcodeSuffix = '-PBMC';
            break;
        case 'buffy coat-tube':
            $barcodeSuffix = '-BFC';
            break;
        // --------------------------------------------------------------------------------
        // URINE
        // --------------------------------------------------------------------------------
        case 'centrifuged urine-tube':
            $barcodeSuffix = '-URN';
            break;
        // --------------------------------------------------------------------------------
        // TISSUE
        // --------------------------------------------------------------------------------
        case 'tissue-block':
            $barcodeSuffix = '-FRZ';
            break;
        // --------------------------------------------------------------------------------
        // RNA/RNA
        // --------------------------------------------------------------------------------
        case 'rna-tube':
        case 'dna-tube':
            $barcodeSuffix = '-' . (strtoupper($newSampleRecord['parent']['ViewSample']['sample_type']));
            $tmpDefaultAliquotData['AliquotDetail.concentration_unit'] = 'ng/ul';
            if (is_null($templateInitId) && sizeof($newSampleRecord['children']) == 1)
                $newSampleRecord['children'][1] = $newSampleRecord['children'][0];
            break;
    }
    
    if ($barcodeSuffix) {
        $participantIdentifier = empty($newSampleRecord['parent']['ViewSample']['participant_identifier']) ? '?' : $newSampleRecord['parent']['ViewSample']['participant_identifier'];
        $visite = $newSampleRecord['parent']['ViewSample']['procure_visit'];
        $tmpDefaultAliquotData['AliquotMaster.barcode'] = $participantIdentifier . ' ' . $visite . ' ' . $barcodeSuffix;
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
    }
    
    if ($tmpDefaultAliquotData) {
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