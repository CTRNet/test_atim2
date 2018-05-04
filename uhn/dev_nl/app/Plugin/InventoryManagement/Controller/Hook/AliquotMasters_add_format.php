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
 
// Set default aliquot label(s) if people will add aliquot clicking on green icon "+"
// Default values will be used in view
// See 

$defaultAliquotValues = array();
foreach ($samples as $viewSample) {
    // See function in .\app\Plugin\InventoryManagement\Model\Custom\Aliquotmaster.php
    $defaultAliquotLabel = $this->AliquotMaster->generateDefaultAliquotLabel($viewSample, $aliquotControl);
    $defaultAliquotValues[$viewSample['ViewSample']['sample_master_id']]['AliquotMaster.aliquot_label'] = $defaultAliquotLabel;
    $defaultAliquotValues[$viewSample['ViewSample']['sample_master_id']]['AliquotMaster.in_stock'] = 'no';
    
}
$this->set('defaultAliquotValues', $defaultAliquotValues);
