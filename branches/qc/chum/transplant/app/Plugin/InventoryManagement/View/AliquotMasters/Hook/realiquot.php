<?php

// --------------------------------------------------------------------------------
// Prevent the paste operation on aliquot label
// --------------------------------------------------------------------------------
$optionsChildren['settings']['paste_disabled_fields'] = array(
    'AliquotMaster.aliquot_label',
    // TODO: Kidney transplant customisation
    'AliquotMaster.barcode'
);

unset($createdAliquotOverrideData['Realiquoting.realiquoting_datetime']);
unset($createdAliquotOverrideData['AliquotMaster.storage_datetime']);