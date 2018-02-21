<?php
/** **********************************************************************
 * CUSM-CIM Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-02-21
 */

// Set aliquot bank and study ids
$parentAliquots = $this->AliquotMaster->find('all', array(
    'conditions' => array(
        'AliquotMaster.id' => explode(",", $parentAliquotsIds)
    ),
    'recursive' => 0
));
$parentAliquotIdToIds = array();
foreach ($parentAliquots as $newParentAliquot) {
    $parentAliquotIdToIds[$newParentAliquot['AliquotMaster']['id']] = array(
        'study_summary_id' => $newParentAliquot['Collection']['cusm_cim_study_summary_id'],
        'cusm_cim_bank_id' => $newParentAliquot['Collection']['bank_id']
    );
}
foreach ($this->request->data as &$cusmCimNewSampleAliquotsSet) {
    foreach ($cusmCimNewSampleAliquotsSet['children'] as &$cusmCimNewAliquot) {
        $cusmCimNewAliquot['AliquotMaster']['study_summary_id'] = $parentAliquotIdToIds[$cusmCimNewSampleAliquotsSet['parent']['AliquotMaster']['id']]['study_summary_id'];
        $cusmCimNewAliquot['AliquotMaster']['cusm_cim_bank_id'] = $parentAliquotIdToIds[$cusmCimNewSampleAliquotsSet['parent']['AliquotMaster']['id']]['cusm_cim_bank_id'];
    }
}
$this->AliquotMaster->addWritableField(
    'cusm_cim_bank_id', 'aliquot_masters'
);
