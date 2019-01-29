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
 
// --------------------------------------------------------------------------------
// Set default aliquot label(s)
// --------------------------------------------------------------------------------
foreach ($this->data as $newDataSet) {
    $defaultAliquotLabels[$newDataSet['parent']['AliquotMaster']['sample_master_id']] = $newDataSet['parent']['AliquotMaster']['aliquot_label'];   
}
$this->set('defaultAliquotLabels', $defaultAliquotLabels);