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
if (isset($defaultAliquotLabels[$parent['AliquotMaster']['sample_master_id']])) {
    $finalOptionsChildren['override']['AliquotMaster.aliquot_label'] = $defaultAliquotLabels[$parent['AliquotMaster']['sample_master_id']];
}