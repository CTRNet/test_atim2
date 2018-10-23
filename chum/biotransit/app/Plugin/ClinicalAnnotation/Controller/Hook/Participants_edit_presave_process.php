<?php

/**
 * **********************************************************************
 * CHUM-BioTransit Project
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-10-22
 */

// Check fields that could not be modified to avoid data integrity issue 
// (Note: These fields should be displayed in read-only mode):
$fieldsToValidate = array(
    'StudySummary.title',
    'Participant.chum_biotransit_study_summary_id',
    'Participant.chum_biotransit_participant_study_number',
    'Participant.chum_biotransit_institution'
);
foreach ($fieldsToValidate as $modelField) {
    list ($tmpModel, $tmpField) = explode('.', $modelField);
    if ((isset($this->request->data[$tmpModel][$tmpField]) && $this->request->data[$tmpModel][$tmpField] != $participantData[$tmpModel][$tmpField])) {
        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
    }
}
if (isset($this->request->data['FunctionManagement']['chum_biotransit_autocomplete_participant_study_summary_id'])) {
    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
}