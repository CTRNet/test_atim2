<?php
if (isset($defaultAliquotLabels[$parent['AliquotMaster']['sample_master_id']])) {
    $finalOptionsChildren['override']['AliquotMaster.aliquot_label'] = $defaultAliquotLabels[$parent['AliquotMaster']['sample_master_id']];
}