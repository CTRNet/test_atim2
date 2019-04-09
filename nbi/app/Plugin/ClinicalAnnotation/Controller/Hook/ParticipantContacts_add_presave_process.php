<?php
/**
 * **********************************************************************
 * NBI Project..
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2019-02-21
 */

// Manage confidential contcat
if($_SESSION['Auth']['User']['group_id'] != '1') {
    if($participantData['Participant']['bc_nbi_retrospective_bank'] != 'n' && $this->request->data['ParticipantContact']['confidential'] == '1') {
        $submittedDataValidates = false;
        $this->ParticipantContact->validationErrors['confidential'][] = __('you are not allowed to create a confidential contact for retrospective bank participant');
    }
}