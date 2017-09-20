<?php
if ($participant['Participant']['qc_tf_last_contact']) {
    $addToTmpArray(array(
        'date' => $participant['Participant']['qc_tf_last_contact'],
        'date_accuracy' => $participant['Participant']['qc_tf_last_contact_accuracy'],
        'event' => __('last contact'),
        'chronology_details' => '',
        'link' => '/ClinicalAnnotation/Participants/profile/' . $participantId . '/'
    ));
}

if ($participant['Participant']['qc_tf_suspected_date_of_death']) {
    $addToTmpArray(array(
        'date' => $participant['Participant']['qc_tf_suspected_date_of_death'],
        'date_accuracy' => $participant['Participant']['qc_tf_suspected_date_of_death_accuracy'],
        'event' => __('date of death'),
        'chronology_details' => __('suspected'),
        'link' => '/ClinicalAnnotation/Participants/profile/' . $participantId . '/'
    ));
}