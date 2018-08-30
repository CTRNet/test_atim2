<?php

// --------------------------------------------------------------------------------
// Set default aliquot label(s)
// --------------------------------------------------------------------------------
$defaultAliquotLabels = array();
$defaultInStocks = array();
foreach ($samples as $viewSample) {
    $defaultAliquotLabels[$viewSample['ViewSample']['sample_master_id']] = $viewSample['ViewSample']['identifier_value'] . $viewSample['ViewSample']['chum_kidney_transp_collection_part_type'] . $viewSample['ViewSample']['chum_kidney_transp_collection_time'];
}
$this->set('defaultAliquotLabels', $defaultAliquotLabels);