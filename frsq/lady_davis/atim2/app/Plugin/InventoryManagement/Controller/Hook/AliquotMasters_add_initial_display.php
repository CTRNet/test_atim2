<?php
$defaultAliquotData = array();
$tmpCollDataFromId = array();
foreach ($this->request->data as $newDataSet) {
    $tmpDefaultAliquotData = array();
    if (in_array($newDataSet['parent']['ViewSample']['sample_type'], array(
        'pbmc',
        'serum',
        'plasma'
    )) && $aliquotControl['AliquotControl']['aliquot_type'] == 'tube') {
        switch ($newDataSet['parent']['ViewSample']['sample_type']) {
            case 'pbmc':
                $tmpDefaultAliquotData['AliquotMaster.aliquot_label'] = 'Buffy Coat';
                break;
            case 'serum':
                $tmpDefaultAliquotData['AliquotMaster.aliquot_label'] = 'Serum';
                break;
            case 'plasma':
                $bloodData = $this->SampleMaster->find('first', array(
                    'conditions' => array(
                        'SampleMaster.id' => $newDataSet['parent']['ViewSample']['initial_specimen_sample_id']
                    ),
                    'recursive' => '0'
                ));
                if ($bloodData['SampleDetail']['blood_type'] == 'EDTA') {
                    $tmpDefaultAliquotData['AliquotMaster.aliquot_label'] = 'EDTA';
                } else 
                    if ($bloodData['SampleDetail']['blood_type'] == 'CTAD') {
                        $tmpDefaultAliquotData['AliquotMaster.aliquot_label'] = 'CTAD';
                    }
        }
        $existingBloodDerivativeAliquot = $this->AliquotMaster->find('first', array(
            'conditions' => array(
                'AliquotMaster.collection_id' => $newDataSet['parent']['ViewSample']['collection_id'],
                'ViewAliquot.sample_type' => array(
                    'pbmc',
                    'serum',
                    'plasma'
                )
            ),
            'recursive' => '0'
        ));
        if ($existingBloodDerivativeAliquot) {
            $tmpDefaultAliquotData['AliquotMaster.storage_datetime'] = $existingBloodDerivativeAliquot['AliquotMaster']['storage_datetime'];
            switch ($existingBloodDerivativeAliquot['AliquotMaster']['storage_datetime_accuracy']) {
                case 'y':
                // +/- not possible to support
                case 'm':
                    $tmpDefaultAliquotData['AliquotMaster.storage_datetime'] = substr($tmpDefaultAliquotData['AliquotMaster.storage_datetime'], 0, strpos($tmpDefaultAliquotData['AliquotMaster.storage_datetime'], '-'));
                    break;
                case 'd':
                    $tmpDefaultAliquotData['AliquotMaster.storage_datetime'] = substr($tmpDefaultAliquotData['AliquotMaster.storage_datetime'], 0, strrpos($tmpDefaultAliquotData['AliquotMaster.storage_datetime'], '-'));
                    break;
                case 'h':
                    $tmpDefaultAliquotData['AliquotMaster.storage_datetime'] = substr($tmpDefaultAliquotData['AliquotMaster.storage_datetime'], 0, strpos($tmpDefaultAliquotData['AliquotMaster.storage_datetime'], ' '));
                    break;
                case 'i':
                    $tmpDefaultAliquotData['AliquotMaster.storage_datetime'] = substr($tmpDefaultAliquotData['AliquotMaster.storage_datetime'], 0, strpos($tmpDefaultAliquotData['AliquotMaster.storage_datetime'], ':'));
                    break;
            }
        }
    }
    $defaultAliquotData[$newDataSet['parent']['ViewSample']['sample_master_id']] = $tmpDefaultAliquotData;
}
$this->set('defaultAliquotData', $defaultAliquotData);