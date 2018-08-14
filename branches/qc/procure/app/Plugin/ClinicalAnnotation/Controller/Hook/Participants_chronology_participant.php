<?php
if ($participant['Participant']['procure_patient_withdrawn']) {
    $addToTmpArray(array(
        'date' => $participant['Participant']['procure_patient_refusal_withdrawal_date'],
        'date_accuracy' => $participant['Participant']['procure_patient_refusal_withdrawal_date_accuracy'],
        'event' => __('patient withdrawn'),
        'chronology_details' => '',
        'link' => '/ClinicalAnnotation/Participants/profile/' . $participantId . '/'
    ));
}