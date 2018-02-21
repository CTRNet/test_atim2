<?php

/** **********************************************************************
 * CUSM-CIM Project.
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-02-21
 */

// Study (then bank) can not be changed to avoid any update on following objects (note: Field Study is supposed to be read-only in edit mode):
// - Collection
// - Aliquot
if (isset($this->request->data['FunctionManagement']['cusm_cim_autocomplete_participant_study_summary_id']) 
|| (isset($this->request->data['Participant']['cusm_cim_study_summary_id']) && $this->request->data['Participant']['cusm_cim_study_summary_id'] != $participantData['Participant']['cusm_cim_study_summary_id'])) {
    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
}
