<?php

// --------------------------------------------------------------------------------
// Check Event Type could be created more than once
// --------------------------------------------------------------------------------
$uniqueEventTypeList = array(
    'clinical-presentation',
    'lifestyle-summary',
    'medical_history-medical past history record summary',
    'imagery-medical imaging record summary',
    'clinical-cirrhosis medical past history'
);
if (in_array(($eventControlData['EventControl']['event_group'] . '-' . $eventControlData['EventControl']['event_type']), $uniqueEventTypeList)) {
    $tmpConditions = array(
        'EventMaster.participant_id' => $participantId,
        'EventMaster.event_control_id' => $eventControlData['EventControl']['id']
    );
    if ($this->EventMaster->find('count', array(
        'conditions' => array(
            $tmpConditions
        )
    ))) {
        $this->atimFlashWarning(__('this type of event has already been created for your participant'), '/ClinicalAnnotation/EventMasters/listall/' . $eventGroup . '/' . $participantId);
        return;
    }
}

// --------------------------------------------------------------------------------
// hepatobiliary-lab-biology :
// Set participant surgeries list for hepatobiliary-lab-biology.
// --------------------------------------------------------------------------------
$surgeriesForLabReport = $this->EventMaster->getParticipantSurgeriesList($eventControlData, $participantId);
if (! is_null($surgeriesForLabReport))
    $this->set('surgeriesForLabReport', $surgeriesForLabReport);