<?php
$defaultAliquotData = array();
foreach ($this->request->data as $newDataSet) {
    $tmpDefaultAliquotData = array();
    if (in_array($newDataSet['parent']['ViewSample']['sample_type'], array(
        'buffy coat',
        'serum',
        'plasma'
    )) && $aliquotControl['AliquotControl']['aliquot_type'] == 'tube') {
        switch ($newDataSet['parent']['ViewSample']['sample_type']) {
            case 'buffy coat':
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
                    'recursive' => 0
                ));
                if ($bloodData['SampleDetail']['blood_type'] == 'EDTA') {
                    $tmpDefaultAliquotData['AliquotMaster.aliquot_label'] = 'EDTA';
                } elseif ($bloodData['SampleDetail']['blood_type'] == 'CTAD') {
                    $tmpDefaultAliquotData['AliquotMaster.aliquot_label'] = 'CTAD';
                } else {
                    $tmpDefaultAliquotData['AliquotMaster.aliquot_label'] = 'plasma';
                }
                break;
        }
    }
    $defaultAliquotData[$newDataSet['parent']['ViewSample']['sample_master_id']] = $tmpDefaultAliquotData;
}
$this->set('defaultAliquotData', $defaultAliquotData);