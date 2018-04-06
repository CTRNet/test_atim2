<?php
/** **********************************************************************
 * NBI Project..
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-04-06
 */

// Add aliquot_label default values displayed at the initial display step.
// The aliquot_label default values are generated joining the default values 
// for the field SampleMaster.aliquot label (see $defaultAliquotLabels)
// and an incremental value.
if (isset($defaultAliquotLabels)) {
    foreach ($this->request->data as &$newSampleAndAliquots) {
        $sampleMasterId = $newSampleAndAliquots['parent']['ViewSample']['sample_master_id'];
        if (array_key_exists($sampleMasterId, $defaultAliquotLabels)) {
            $counter = 0;
            foreach ($newSampleAndAliquots['children'] as &$newAliquot) {
                $counter ++;
                $newAliquot['AliquotMaster']['aliquot_label'] = $defaultAliquotLabels[$sampleMasterId] . '-' . (strlen($counter) == 1 ? '0' . $counter : $counter);
            }
        }
    }
}