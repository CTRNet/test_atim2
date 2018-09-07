<?php

// --------------------------------------------------------------------------------
// Prevent the paste operation on aliquot barcode
// --------------------------------------------------------------------------------
$optionsChildren['settings']['paste_disabled_fields'] = array(
    'AliquotMaster.barcode'
);

unset($createdAliquotStructureOverride['Realiquoting.realiquoting_datetime']);
unset($createdAliquotStructureOverride['AliquotMaster.storage_datetime']);