<?php
$chronolgyDataParticipantBirth = null;

if ($chronolgyDataParticipantDeath)
    $chronolgyDataParticipantDeath['chronology_details'] = $healthStatusValues[$participant['Participant']['vital_status']];
if ($participant['Participant']['qbcf_suspected_date_of_death']) {
    $addToTmpArray(array(
        'date' => $participant['Participant']['qbcf_suspected_date_of_death'],
        'date_accuracy' => $participant['Participant']['qbcf_suspected_date_of_death_accuracy'],
        'event' => __('supected date of death'),
        'chronology_details' => $healthStatusValues[$participant['Participant']['vital_status']],
        'link' => '/ClinicalAnnotation/Participants/profile/' . $participantId . '/'
    ));
}
if ($participant['Participant']['qbcf_last_contact']) {
    $addToTmpArray(array(
        'date' => $participant['Participant']['qbcf_last_contact'],
        'date_accuracy' => $participant['Participant']['qbcf_last_contact_accuracy'],
        'event' => __('last contact'),
        'chronology_details' => '',
        'link' => '/ClinicalAnnotation/Participants/profile/' . $participantId . '/'
    ));
}