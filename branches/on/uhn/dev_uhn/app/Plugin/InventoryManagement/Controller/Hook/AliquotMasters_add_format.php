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
// and keep them into the defaultAliquotLabels variable to display them
// into the view (see .ctp file).
$defaultAliquotLabels = array();
foreach ($samples as $viewSample) {
    $defaultAliquotLabel = $this->AliquotMaster->generateDefaultAliquotLabel($viewSample, $aliquotControl);
    $defaultAliquotLabels[$viewSample['ViewSample']['sample_master_id']] = $defaultAliquotLabel;
}
$this->set('defaultAliquotLabels', $defaultAliquotLabels);