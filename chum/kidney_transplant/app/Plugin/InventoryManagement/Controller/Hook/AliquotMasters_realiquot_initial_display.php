<?php
// --------------------------------------------------------------------------------
// Set default aliquot label(s)
// --------------------------------------------------------------------------------
foreach ($this->data as $newDataSet) {
    $defaultAliquotLabels[$newDataSet['parent']['AliquotMaster']['sample_master_id']] = $newDataSet['parent']['AliquotMaster']['aliquot_label'];
    $labelNbrPrefix = '';
    switch ($newDataSet['parent']['SampleControl']['sample_type']) {
        case 'tissue':
            $labelNbrPrefix = 'D';
            break;
        case 'buffy coat':
            $labelNbrPrefix = 'F';
            break;
        case 'plasma':
            $labelNbrPrefix = 'B';
            break;
        case 'serum':
            $labelNbrPrefix = 'A';
            break;
        case 'centrifuged urine':
            $labelNbrPrefix = 'E';
            break;
    }
    $defaultAliquotLabels[$newDataSet['parent']['AliquotMaster']['sample_master_id']] = array(
        'label' => $newDataSet['parent']['AliquotMaster']['aliquot_label'],
        'label_nbr_prefix' => $labelNbrPrefix
    );
    
}
$this->set('defaultAliquotLabels', $defaultAliquotLabels);