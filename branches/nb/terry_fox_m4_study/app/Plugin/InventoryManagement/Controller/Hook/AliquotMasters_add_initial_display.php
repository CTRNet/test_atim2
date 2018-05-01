<?php
/** **********************************************************************
 * TFRI-M4S Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-03-16
 */

// Set incremental aliquot label(s)
if (isset($defaultAliquotValues)) {
    foreach ($this->request->data as &$newSampleAndAliquots) {
        $sampleMasterId = $newSampleAndAliquots['parent']['ViewSample']['sample_master_id'];
        if (array_key_exists($sampleMasterId, $defaultAliquotValues)) {
            $counter = 0;
            foreach ($newSampleAndAliquots['children'] as &$newAliquot) {
                $counter ++;
                $newAliquot['AliquotMaster']['aliquot_label'] = $defaultAliquotValues[$sampleMasterId]['AliquotMaster.aliquot_label'] . '-' . (strlen($counter) == 1 ? '0' . $counter : $counter);
            }
        }
    }
}