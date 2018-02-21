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
foreach ($this->request->data as &$cusmCimNewSampleAliquotsSet) {
    foreach ($cusmCimNewSampleAliquotsSet['children'] as &$cusmCimNewAliquot) {
        $cusmCimNewAliquot['AliquotMaster']['study_summary_id'] = $cusmCimNewSampleAliquotsSet['parent']['ViewSample']['cusm_cim_study_summary_id'];
        $cusmCimNewAliquot['AliquotMaster']['cusm_cim_bank_id'] = $cusmCimNewSampleAliquotsSet['parent']['ViewSample']['bank_id'];
    }
}
$this->AliquotMaster->addWritableField(array(
    'study_summary_id',
    'cusm_cim_bank_id'
));
