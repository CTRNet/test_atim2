<?php

// --------------------------------------------------------------------------------
// hepatobiliary-lab-biology :
// Set participant surgeries list for hepatobiliary-lab-biology.
// --------------------------------------------------------------------------------
$eventControlData = array(
    'EventControl' => $eventMasterData['EventControl']
);
$surgeriesForLabReport = $this->EventMaster->getParticipantSurgeriesList($eventControlData, $participantId);
if (! is_null($surgeriesForLabReport))
    $this->set('surgeriesForLabReport', $surgeriesForLabReport);