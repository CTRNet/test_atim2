<?php
if (isset($defaultAliquotLabels[$data['parent']['ViewSample']['sample_master_id']])) {
    $finalOptionsChildren['override']['AliquotMaster.aliquot_label'] = $defaultAliquotLabels[$data['parent']['ViewSample']['sample_master_id']]['label'];
    $finalOptionsChildren['override']['AliquotMaster.chum_kidney_transp_aliquot_nbr'] = $defaultAliquotLabels[$data['parent']['ViewSample']['sample_master_id']]['label_nbr_prefix']; 
}