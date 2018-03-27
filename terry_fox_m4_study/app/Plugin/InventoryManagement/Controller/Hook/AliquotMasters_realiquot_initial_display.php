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
foreach ($this->data as $newDataSet) {
    $sampleMasterId = $newDataSet['parent']['AliquotMaster']['sample_master_id'];
    $sampleData = $this->ViewSample->find('first', array(
        'conditions' => array(
            'sample_master_id' => $sampleMasterId
        ),
        'recursive' => - 1
    ));
    $defaultAliquotLabel = $this->AliquotMaster->generateDefaultAliquotLabel($sampleData, $childAliquotCtrl);
    $defaultAliquotLabels[$sampleMasterId] = $defaultAliquotLabel;
}
$this->set('defaultAliquotLabels', $defaultAliquotLabels);