<?php

// --------------------------------------------------------------------------------
// Prevent the paste operation on aliquot barcode
// --------------------------------------------------------------------------------
$optionsChildren['settings']['paste_disabled_fields'] = array(
    'AliquotMaster.barcode'
);

unset($createdAliquotOverrideData['Realiquoting.realiquoting_datetime']);
unset($createdAliquotOverrideData['AliquotMaster.storage_datetime']);