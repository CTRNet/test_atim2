<?php

// --------------------------------------------------------------------------------
// Prevent the paste operation on aliquot barcode
// --------------------------------------------------------------------------------
$optionsChildren['settings']['paste_disabled_fields'] = array(
    'AliquotMaster.barcode'
);