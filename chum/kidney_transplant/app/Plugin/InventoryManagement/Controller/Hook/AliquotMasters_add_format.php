<?php
// --------------------------------------------------------------------------------
// Set default aliquot label(s)
// --------------------------------------------------------------------------------
$defaultAliquotLabels = array();
foreach ($samples as $viewSample) {
    $labelNbrPrefix = '';
    switch ($viewSample['ViewSample']['sample_type']) {
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
    $defaultAliquotLabels[$viewSample['ViewSample']['sample_master_id']] = array(
        'label' => $viewSample['ViewSample']['identifier_value'] . $viewSample['ViewSample']['chum_kidney_transp_collection_part_type'] . $viewSample['ViewSample']['chum_kidney_transp_collection_time'],
        'label_nbr_prefix' => $labelNbrPrefix
    );
}
$this->set('defaultAliquotLabels', $defaultAliquotLabels);