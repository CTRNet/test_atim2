<?php
unset($_SESSION['chum_kidney_transp_donor_consent']);
if (isset($this->request->data['ConsentMaster']['chum_kidney_transp_donor_consent']) && $this->request->data['ConsentMaster']['chum_kidney_transp_donor_consent'] == '1') {
    $_SESSION['chum_kidney_transp_donor_consent'] = true;
    $urlToFlash = $urlToFlash = '/ClinicalAnnotation/ParticipantContacts/add/' . $participantId;
}