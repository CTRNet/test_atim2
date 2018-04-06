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

// Set default values for the field SampleMaster.aliquot label 
// with data previously recorded into defaultAliquotLabels variable.
if (isset($defaultAliquotLabels[$data['parent']['ViewSample']['sample_master_id']])) {
    $finalOptionsChildren['override']['AliquotMaster.aliquot_label'] = $defaultAliquotLabels[$data['parent']['ViewSample']['sample_master_id']];
}