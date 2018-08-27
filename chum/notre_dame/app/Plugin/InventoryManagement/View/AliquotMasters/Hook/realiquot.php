<?php

// --------------------------------------------------------------------------------
// Prevent the paste operation on aliquot label
// --------------------------------------------------------------------------------
$optionsChildren['settings']['paste_disabled_fields'] = array(
    'AliquotMaster.aliquot_label'
);

unset($createdAliquotStructureOverride['Realiquoting.realiquoting_datetime']);
unset($createdAliquotStructureOverride['AliquotMaster.storage_datetime']);