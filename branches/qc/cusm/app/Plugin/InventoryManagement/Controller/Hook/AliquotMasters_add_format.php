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
$defaultAliquotLabels = array();
foreach ($samples as $viewSample) {
    $defaultAliquotLabels[$viewSample['ViewSample']['sample_master_id']] = $this->AliquotMaster->getDefaultAliquotLabel($viewSample, isset($templateNodeDefaultValues) ? $templateNodeDefaultValues : array());
}
$this->set('defaultAliquotLabels', $defaultAliquotLabels);