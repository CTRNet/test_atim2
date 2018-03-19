<?php
$newParticipantData = $this->Participant->getOrRedirect($participantId);
if ($participantData['Participant']['date_of_death'] != $newParticipantData['Participant']['date_of_death'] || $participantData['Participant']['date_of_death_accuracy'] != $newParticipantData['Participant']['date_of_death_accuracy'] || $participantData['Participant']['qc_tf_last_contact'] != $newParticipantData['Participant']['qc_tf_last_contact'] || $participantData['Participant']['qc_tf_last_contact_accuracy'] != $newParticipantData['Participant']['qc_tf_last_contact_accuracy']) {
    $conditions = array(
        'DiagnosisMaster.participant_id' => $participantId,
        'DiagnosisMaster.deleted != 1',
        'DiagnosisControl.category' => 'primary',
        'DiagnosisControl.controls_type' => 'prostate'
    );
    $allProstatPrimaries = $this->DiagnosisMaster->find('all', array(
        'conditions' => $conditions
    ));
    foreach ($allProstatPrimaries as $newPrimary)
        $this->DiagnosisMaster->calculateSurvivalAndBcr($newPrimary['DiagnosisMaster']['id']);
}

if ($participantData['Participant']['date_of_birth'] != $newParticipantData['Participant']['date_of_birth'] || $participantData['Participant']['date_of_birth_accuracy'] != $newParticipantData['Participant']['date_of_birth_accuracy']) {
    $this->DiagnosisMaster->updateAgeAtDx('Participant', $participantId);
}