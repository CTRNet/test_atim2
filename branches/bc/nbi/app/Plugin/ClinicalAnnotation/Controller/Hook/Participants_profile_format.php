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

// Check PHN# and BCCA# are unique
$loopProperties = array(
    'bc_nbi_phn_number' => 'more than one participants have the same phn number into atim',
    'bc_nbi_bc_cancer_agency_id' => 'more than one participants have the same bcca number into atim');
foreach($loopProperties as $atimField => $warningMsg) {
    if (isset($this->request->data['Participant'][$atimField]) && strlen($this->request->data['Participant'][$atimField]) && $this->request->data['Participant'][$atimField] != CONFIDENTIAL_MARKER) {
        $conditionsToCheckParticipantIsUnique = array(
            'Participant.bc_nbi_phn_number' => $this->request->data['Participant'][$atimField],
            "Participant.id != $participantId"
        );
        if ($_SESSION['Auth']['User']['group_id'] != '1') {
            $conditionsToCheckParticipantIsUnique["Participant.bc_nbi_retrospective_bank"] = 'n';
            if($this->request->data['Participant']['bc_nbi_retrospective_bank'] != 'n') {
                // Retrospective Bank Participant
                // User does not have access to this number, so search does not have to be done
                $conditionsToCheckParticipantIsUnique[] = "Participant.id = -1";
            }
        }
        $isDuplicated = $this->Participant->find('count', array(
            'conditions' => $conditionsToCheckParticipantIsUnique
        ));
        if ($isDuplicated) {
            AppController::addWarningMsg(__($warningMsg));
        }
    }
}