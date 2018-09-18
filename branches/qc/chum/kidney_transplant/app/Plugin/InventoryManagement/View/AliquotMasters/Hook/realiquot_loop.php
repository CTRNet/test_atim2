<?php
if (isset($defaultAliquotLabels[$parent['AliquotMaster']['sample_master_id']])) {
    $finalOptionsChildren['override']['AliquotMaster.aliquot_label'] = $defaultAliquotLabels[$parent['AliquotMaster']['sample_master_id']]['label'];
    $finalOptionsChildren['override']['AliquotMaster.chum_kidney_transp_aliquot_nbr'] = $defaultAliquotLabels[$parent['AliquotMaster']['sample_master_id']]['label_nbr_prefix'];
}