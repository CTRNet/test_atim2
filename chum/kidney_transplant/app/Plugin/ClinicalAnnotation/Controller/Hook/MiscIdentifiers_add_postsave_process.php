<?php
// --------------------------------------------------------------------------------
// Set next kidney bank identifier
// --------------------------------------------------------------------------------
if ($_SESSION['created_participant']['next_identifier_controls']) {
    $nextIdentifierName = array_shift($_SESSION['created_participant']['next_identifier_controls']);
    if ($nextIdentifierName) {
        $miscIdentifierControlId = $this->MiscIdentifierControl->find('first', array(
            'conditions' => array(
                'MiscIdentifierControl.misc_identifier_name' => $nextIdentifierName,
                'MiscIdentifierControl.flag_active' => 1
            )
        ));
        if ($miscIdentifierControlId) {
            $miscIdentifierControlId = $miscIdentifierControlId['MiscIdentifierControl']['id'];
            $urlToFlash = "/ClinicalAnnotation/MiscIdentifiers/add/$participantId/$miscIdentifierControlId";
            $this->atimFlash(__('your data has been saved'), $urlToFlash);
        }
    }
}