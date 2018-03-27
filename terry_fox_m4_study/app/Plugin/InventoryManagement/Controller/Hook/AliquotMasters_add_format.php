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
$defaultAliquotLabels = array();
foreach ($samples as $viewSample) {
    $defaultAliquotLabel = $this->AliquotMaster->generateDefaultAliquotLabel($viewSample, $aliquotControl);
    $defaultAliquotLabels[$viewSample['ViewSample']['sample_master_id']] = $defaultAliquotLabel;
}
$this->set('defaultAliquotLabels', $defaultAliquotLabels);