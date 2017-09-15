<?php
$default_aliquot_data = array();
$tmp_coll_data_from_id = array();
foreach ($this->request->data as $new_data_set) {
    $tmp_default_aliquot_data = array();
    if (in_array($new_data_set['parent']['ViewSample']['sample_type'], array(
        'pbmc',
        'serum',
        'plasma'
    )) && $aliquot_control['AliquotControl']['aliquot_type'] == 'tube') {
        switch ($new_data_set['parent']['ViewSample']['sample_type']) {
            case 'pbmc':
                $tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = 'Buffy Coat';
                break;
            case 'serum':
                $tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = 'Serum';
                break;
            case 'plasma':
                $blood_data = $this->SampleMaster->find('first', array(
                    'conditions' => array(
                        'SampleMaster.id' => $new_data_set['parent']['ViewSample']['initial_specimen_sample_id']
                    ),
                    'recursive' => '0'
                ));
                if ($blood_data['SampleDetail']['blood_type'] == 'EDTA') {
                    $tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = 'EDTA';
                } else 
                    if ($blood_data['SampleDetail']['blood_type'] == 'CTAD') {
                        $tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = 'CTAD';
                    }
        }
        $existing_blood_derivative_aliquot = $this->AliquotMaster->find('first', array(
            'conditions' => array(
                'AliquotMaster.collection_id' => $new_data_set['parent']['ViewSample']['collection_id'],
                'ViewAliquot.sample_type' => array(
                    'pbmc',
                    'serum',
                    'plasma'
                )
            ),
            'recursive' => '0'
        ));
        if ($existing_blood_derivative_aliquot) {
            $tmp_default_aliquot_data['AliquotMaster.storage_datetime'] = $existing_blood_derivative_aliquot['AliquotMaster']['storage_datetime'];
            switch ($existing_blood_derivative_aliquot['AliquotMaster']['storage_datetime_accuracy']) {
                case 'y':
                // +/- not possible to support
                case 'm':
                    $tmp_default_aliquot_data['AliquotMaster.storage_datetime'] = substr($tmp_default_aliquot_data['AliquotMaster.storage_datetime'], 0, strpos($tmp_default_aliquot_data['AliquotMaster.storage_datetime'], '-'));
                    break;
                case 'd':
                    $tmp_default_aliquot_data['AliquotMaster.storage_datetime'] = substr($tmp_default_aliquot_data['AliquotMaster.storage_datetime'], 0, strrpos($tmp_default_aliquot_data['AliquotMaster.storage_datetime'], '-'));
                    break;
                case 'h':
                    $tmp_default_aliquot_data['AliquotMaster.storage_datetime'] = substr($tmp_default_aliquot_data['AliquotMaster.storage_datetime'], 0, strpos($tmp_default_aliquot_data['AliquotMaster.storage_datetime'], ' '));
                    break;
                case 'i':
                    $tmp_default_aliquot_data['AliquotMaster.storage_datetime'] = substr($tmp_default_aliquot_data['AliquotMaster.storage_datetime'], 0, strpos($tmp_default_aliquot_data['AliquotMaster.storage_datetime'], ':'));
                    break;
            }
        }
    }
    $default_aliquot_data[$new_data_set['parent']['ViewSample']['sample_master_id']] = $tmp_default_aliquot_data;
}
$this->set('default_aliquot_data', $default_aliquot_data);