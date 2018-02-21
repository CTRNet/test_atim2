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

// Collection could only be linked to a participant
// Both bank_id and cusm_cim_study_summary_id have to be copied from participant
if (($collectionData && ! $collectionData['Collection']['participant_id']) || (! $collectionData && ! isset($this->request->data['Collection']['participant_id']))) {
    $submittedDataValidates = false;
    $this->Collection->validationErrors['participant_id'][] = __('a created collection should be linked to a participant');
} else if($collectionData) {
    if(!$collectionData['Participant']['cusm_cim_bank_id'] || !$collectionData['Participant']['cusm_cim_study_summary_id'] ) {
        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
    }
    $this->request->data['Collection']['bank_id'] = $collectionData['Participant']['cusm_cim_bank_id'];
    $this->request->data['Collection']['cusm_cim_study_summary_id'] = $collectionData['Participant']['cusm_cim_study_summary_id'];
    $this->Collection->addWritableField(array(
        'bank_id',
        'cusm_cim_study_summary_id'
    ));
} else if($copySrcData) {
    if(!$copySrcData['Participant']['cusm_cim_bank_id'] || !$copySrcData['Participant']['cusm_cim_study_summary_id'] ) {
        $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
    }
    $this->request->data['Collection']['bank_id'] = $copySrcData['Participant']['cusm_cim_bank_id'];
    $this->request->data['Collection']['cusm_cim_study_summary_id'] = $copySrcData['Participant']['cusm_cim_study_summary_id'];
    $this->Collection->addWritableField(array(
        'bank_id',
        'cusm_cim_study_summary_id'
    ));
} else {
    $this->redirect('/Pages/err_plugin_record_err?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
}
