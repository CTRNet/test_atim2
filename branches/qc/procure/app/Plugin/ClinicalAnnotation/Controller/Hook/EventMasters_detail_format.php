<?php
$this->set('addLinkForProcureForms', $this->Participant->buildAddProcureFormsButton($participantId));

if ($this->request->data['EventControl']['event_type'] == 'visit/contact') {
    // Set Event Control Id of linked event data to display
    $eventsTypes = array(
        'laboratory',
        'clinical exam',
        'clinical note',
        'other tumor diagnosis'
    );
    $this->set('linkedEventsControlData', $this->EventControl->find('all', array(
        'conditions' => array(
            'EventControl.event_type' => $eventsTypes,
            'EventControl.flag_active' => '1'
        )
    )));
    // Set Treatment Control Id of linked treatment data to display
    $this->TreatmentControl = AppModel::getInstance("ClinicalAnnotation", "TreatmentControl", true);
    $this->set('linkedTxControlData', $this->TreatmentControl->find('all', array(
        'conditions' => array(
            'TreatmentControl.flag_active' => '1'
        )
    )));
    // Set Inteval Dates (previous Medication Worksheet date to studied Medication Worksheet date)
    $intervalStartDate = '-1';
    $intervalStartDateAccuracy = 'c';
    if ($this->request->data['EventMaster']['event_date']) {
        $previousFollowupWoksheetConditions = array(
            'EventMaster.event_control_id' => $this->request->data['EventControl']['id'],
            'EventMaster.participant_id' => $participantId,
            "EventMaster.event_date IS NOT NULL",
            "EventMaster.event_date < '" . $this->request->data['EventMaster']['event_date'] . "'"
        );
        $previousFollowupWoksheetData = $this->EventMaster->find('first', array(
            'conditions' => $previousFollowupWoksheetConditions,
            'order' => array(
                'EventMaster.event_date DESC'
            )
        ));
        if ($previousFollowupWoksheetData) {
            $intervalStartDate = $previousFollowupWoksheetData['EventMaster']['event_date'];
            $intervalStartDateAccuracy = $previousFollowupWoksheetData['EventMaster']['event_date_accuracy'];
        }
    }
    $intervalFinishDate = empty($this->request->data['EventMaster']['event_date']) ? '-1' : $this->request->data['EventMaster']['event_date'];
    $intervalFinishDateAccuracy = empty($this->request->data['EventMaster']['event_date']) ? 'c' : $this->request->data['EventMaster']['event_date_accuracy'];
    $this->set('intervalStartDate', $intervalStartDate);
    $this->set('intervalStartDateAccuracy', $intervalStartDateAccuracy);
    $this->set('intervalFinishDate', $intervalFinishDate);
    $this->set('intervalFinishDateAccuracy', $intervalFinishDateAccuracy);
    // Interval message
    $msg = '';
    $intervalStartDate = preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $intervalStartDate) ? $intervalStartDate : '';
    $intervalFinishDate = preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $intervalFinishDate) ? $intervalFinishDate : '';
    if ($intervalStartDate && $intervalFinishDate) {
        $msg = "clincial data from %start% to %end%";
    } elseif ($intervalStartDate) {
        $msg = "clincial data after %start%";
    } elseif ($intervalFinishDate) {
        $msg = "clincial data before %end%";
    } else {
        $msg = "unable to limit clincial data to a dates interval";
    }
    // Warning message
    $warningMessage = str_replace(array(
        '%start%',
        '%end%'
    ), array(
        $intervalStartDate,
        $intervalFinishDate
    ), __($msg));
    if (($intervalFinishDateAccuracy . $intervalStartDateAccuracy) != 'cc')
        $warningMessage .= ' ' . __("at least one of the studied interval date is inaccurate");
    AppController::addWarningMsg($warningMessage);
}