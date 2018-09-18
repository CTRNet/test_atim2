<?php
// --------------------------------------------------------------------------------
// Prevent the paste operation on aliquot label
// --------------------------------------------------------------------------------
$optionsChildren['settings']['paste_disabled_fields'] = array(
    'AliquotMaster.aliquot_label',
    'AliquotMaster.chum_kidney_transp_aliquot_nbr',
    'AliquotMaster.barcode'
);