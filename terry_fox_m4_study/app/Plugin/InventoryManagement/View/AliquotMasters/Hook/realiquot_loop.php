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

// Set default aliquot label(s)
if (isset($defaultAliquotValues[$parent['AliquotMaster']['sample_master_id']])) {
    foreach ($defaultAliquotValues[$parent['AliquotMaster']['sample_master_id']] as $keyModelField => $defaultValue) {
        $finalOptionsChildren['override'][$keyModelField] = $defaultValue;
    }
}
