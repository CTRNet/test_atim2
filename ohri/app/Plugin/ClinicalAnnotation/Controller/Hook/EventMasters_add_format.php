<?php

// --------------------------------------------------------------------------------
// Presentation creation check
// --------------------------------------------------------------------------------
$eventTypeTitle = $eventControlData['EventControl']['disease_site'] . $eventControlData['EventControl']['event_group'] . $eventControlData['EventControl']['event_type'];
if (empty($this->request->data) && ($eventTypeTitle == 'ohrilabmarkers')) {
    
    $existingPresentation = $this->EventMaster->find('first', array(
        'conditions' => array(
            'EventMaster.event_control_id' => $eventControlData['EventControl']['id'],
            'EventMaster.participant_id' => $participantId
        )
    ));
    if (! empty($existingPresentation)) {
        $this->atimFlash('a markers report can only be created once per participant', '/ClinicalAnnotation/EventMasters/listall/' . $eventGroup . '/' . $participantId);
    }
}