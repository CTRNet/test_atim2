<?php
/** **********************************************************************
 * UHN Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 * 
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-05-04
 */
 
// Set default aliquot values
// See controller .\app\Plugin\InventoryManagement\Controller\Hook\

if (isset($defaultAliquotValues[$data['parent']['ViewSample']['sample_master_id']])) {
    foreach ($defaultAliquotValues[$data['parent']['ViewSample']['sample_master_id']] as $keyModelField => $defaultValue) {
        $finalOptionsChildren['override'][$keyModelField] = $defaultValue;
    }
}