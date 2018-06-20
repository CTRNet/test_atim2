<?php

/** **********************************************************************
 * UHN
 * ***********************************************************************
 *
 * CLinicalAnnotation plugin custom code
 *
 * Class AliquotMasterCustom
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-06-20
 */
 
// Check if no participant has been found into ATiM but returned by ATiM 
if ($participantFoundInHospitalSystem) {
    unset($structureLinks['index']['detail']);
    unset($finalOptions['links']['index']['detail']);
    $structureLinks['index']['add'] = '/ClinicalAnnotation/Participants/add/uhn_result_key=%%Participant.uhn_result_key%%';
    $finalOptions['links']['index']['add'] = $structureLinks['index']['add'];
}
