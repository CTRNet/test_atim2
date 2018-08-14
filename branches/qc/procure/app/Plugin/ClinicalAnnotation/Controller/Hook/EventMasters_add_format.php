<?php
$this->set('evHeader', __($eventControlData['EventControl']['event_type']));

// Set default data
$overrideData = array();
switch ($eventControlData['EventControl']['event_type']) {
    case 'laboratory':
        $overrideData['EventDetail.biochemical_relapse'] = 'n';
        break;
    case 'visit/contact':
        $overrideData['EventDetail.refusing_treatments'] = 'n';
        break;
}
$this->set('overrideData', $overrideData);

// Set data for validation
$this->EventMaster->setEventTypeForDataEntryValidation($eventControlData['EventControl']['event_type']);

// Clinical file update process
if (empty($this->request->data))
    $this->Participant->setNextUrlOfTheClinicalFileUpdateProcess($participantId, $this->passedArgs);
$this->Participant->addClinicalFileUpdateProcessInfo();