<?php
/** **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Inventory Management plugin custom code
 * 
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */
 
foreach ($this->request->data as &$newSampleRecord) {
    if (isset($defaultAliquotLabels[$newSampleRecord['parent']['ViewSample']['sample_master_id']])) {
        $defaultAliquotLabel = $defaultAliquotLabels[$newSampleRecord['parent']['ViewSample']['sample_master_id']];
        $aliquotCounter = 0;
        foreach ($newSampleRecord['children'] as &$newAliquotRecord) {
            $aliquotCounter ++;
            $newAliquotRecord['AliquotMaster']['aliquot_label'] = "$defaultAliquotLabel $aliquotCounter";
        }
    }
}