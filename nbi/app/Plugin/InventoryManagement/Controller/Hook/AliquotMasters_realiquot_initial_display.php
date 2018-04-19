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
foreach ($this->request->data as &$newDataSet) {
    $sampleMasterId = $newDataSet['parent']['AliquotMaster']['sample_master_id'];
    $sampleData = $this->ViewSample->find('first', array(
        'conditions' => array(
            'sample_master_id' => $sampleMasterId
        ),
        'recursive' => - 1
    ));
    $defaultAliquotLabel = $this->AliquotMaster->generateDefaultAliquotLabel($sampleData, $childAliquotCtrl, $newDataSet['parent']['AliquotMaster']['aliquot_label']);
    $defaultAliquotLabels[$sampleMasterId] = $defaultAliquotLabel;
    $counter = 0;
    if (empty($newDataSet['children'])) {
        $newDataSet['children'][] = array();
    }
    foreach ($newDataSet['children'] as &$newAliquot) {
        $counter ++;
        $newAliquot['AliquotMaster']['aliquot_label'] = $defaultAliquotLabels[$sampleMasterId] . (strlen($counter) == 1 ? '0' . $counter : $counter);
    }
}
$this->set('defaultAliquotLabels', $defaultAliquotLabels);