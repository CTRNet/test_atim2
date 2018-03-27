<?php
/** **********************************************************************
 * TFRI-4MS Project.
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-03-16
 */

// Participant Site ID or Patient ID can not be modified
if ($this->request->data) {
    if ($this->request->data['Participant']['tfri_m4s_site_id'] != $participantData['Participant']['tfri_m4s_site_id'] 
    || $this->request->data['Participant']['tfri_m4s_site_patient_id'] != $participantData['Participant']['tfri_m4s_site_patient_id']) {
        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
    }
}
