<?php
if ($aliquotControlId == 54) {
    AppController::getInstance()->redirect('/Pages/qc_nd_no_flask', null, true);
}

// --------------------------------------------------------------------------------
// Set default aliquot label(s)
// --------------------------------------------------------------------------------
$defaultAliquotLabels = array();
$defaultInStocks = array();
foreach ($samples as $viewSample) {
    $defaultAliquotLabel = $this->AliquotMaster->generateDefaultAliquotLabel($viewSample, $aliquotControl);
    $defaultAliquotLabels[$viewSample['ViewSample']['sample_master_id']] = $defaultAliquotLabel;
    if (preg_match('/(\-EDB)|(\-SRB)|(\-URI)/', $defaultAliquotLabel))
        $defaultInStocks[$viewSample['ViewSample']['sample_master_id']] = 'no';
}
$this->set('defaultAliquotLabels', $defaultAliquotLabels);
$this->set('defaultInStocks', $defaultInStocks);

// remove default storage date
unset($structureOverride['AliquotMaster.storage_datetime']);
$this->set('structureOverride', $structureOverride);