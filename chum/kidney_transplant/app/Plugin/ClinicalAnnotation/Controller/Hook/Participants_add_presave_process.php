<?php
if (array_key_exists('qc_chum_initial_display', $this->request->data) && $this->request->data['qc_chum_initial_display']) {
    $submittedDataValidates = false;
    $this->request->data = array();
    $this->request->data['Participant']['vital_status'] = 'alive';
    $this->request->data['Participant']['chum_kidney_transp_vih'] = 'n';
}