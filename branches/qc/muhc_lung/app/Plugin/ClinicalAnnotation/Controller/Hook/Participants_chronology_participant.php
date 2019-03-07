<?php
/** **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 * 
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */

if (strlen($participant['Participant']['cusm_tumor_registery_first_contact_at_muhc']) > 0) {
    $chronolgyCusmDataToAdd = array(
        'date' => $participant['Participant']['cusm_tumor_registery_first_contact_at_muhc'],
        'date_accuracy' => $participant['Participant']['cusm_tumor_registery_first_contact_at_muhc_accuracy'],
        'event' => __('first contact at muhc'),
        'chronology_details' => '',
        'link' => '/ClinicalAnnotation/Participants/profile/' . $participantId . '/'
    );
    $addToTmpArray($chronolgyCusmDataToAdd);
}

if (strlen($participant['Participant']['cusm_tumor_registery_last_contact_at_muhc']) > 0) {
    $chronolgyCusmDataToAdd = array(
        'date' => $participant['Participant']['cusm_tumor_registery_last_contact_at_muhc'],
        'date_accuracy' => $participant['Participant']['cusm_tumor_registery_last_contact_at_muhc_accuracy'],
        'event' => __('last contact at muhc'),
        'chronology_details' => '',
        'link' => '/ClinicalAnnotation/Participants/profile/' . $participantId . '/'
    );
    $addToTmpArray($chronolgyCusmDataToAdd);
}