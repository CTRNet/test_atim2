<?php

// --------------------------------------------------------------------------------
// Prevent the paste operation on aliquot label
// --------------------------------------------------------------------------------
$optionsChildren['settings']['paste_disabled_fields'] = array(
    'AliquotMaster.aliquot_label',
    // TODO: Kidney transplant customisation
    'AliquotMaster.barcode'
);