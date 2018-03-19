<?php

// --------------------------------------------------------------------------------
// Set default aliquot label(s)
// --------------------------------------------------------------------------------
$defaultAliquotLabels = array();
foreach ($samples as $viewSample) {
    $defaultAliquotLabel = $this->AliquotMaster->generateDefaultAliquotLabel($viewSample['ViewSample']);
    $defaultAliquotLabels[$viewSample['ViewSample']['sample_master_id']] = $defaultAliquotLabel;
}
$this->set('defaultAliquotLabels', $defaultAliquotLabels);