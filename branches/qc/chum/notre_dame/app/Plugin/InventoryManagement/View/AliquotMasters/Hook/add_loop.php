<?php
if (isset($defaultAliquotLabels[$data['parent']['ViewSample']['sample_master_id']])) {
    $finalOptionsChildren['override']['AliquotMaster.aliquot_label'] = $defaultAliquotLabels[$data['parent']['ViewSample']['sample_master_id']];
}
if (isset($defaultInStocks[$data['parent']['ViewSample']['sample_master_id']])) {
    $finalOptionsChildren['override']['AliquotMaster.in_stock'] = $defaultInStocks[$data['parent']['ViewSample']['sample_master_id']];
}