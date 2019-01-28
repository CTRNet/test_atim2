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
 
if (isset($defaultAliquotLabels[$parent['AliquotMaster']['sample_master_id']])) {
    $finalOptionsChildren['override']['AliquotMaster.aliquot_label'] = $defaultAliquotLabels[$parent['AliquotMaster']['sample_master_id']];
}