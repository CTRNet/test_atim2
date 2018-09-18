<?php

// --------------------------------------------------------------------------------
// Prevent the paste operation on aliquot barcode
// --------------------------------------------------------------------------------
$optionsChildren['settings']['paste_disabled_fields'] = array(
    'AliquotMaster.barcode'
);

if (isset($procureAliquotDefaultValue) && ! empty($procureAliquotDefaultValue)) {
    $optionsChildren["override"] = array_merge($optionsChildren["override"], $procureAliquotDefaultValue);
}