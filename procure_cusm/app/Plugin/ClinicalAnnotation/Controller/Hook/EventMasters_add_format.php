<?php
$this->set('evHeader', __($eventControlData['EventControl']['event_type']));

// Set default data
$structureOverride = array();
switch ($eventControlData['EventControl']['event_type']) {
    case 'laboratory':
        $structureOverride['EventDetail.biochemical_relapse'] = 'n';
        break;
    case 'visit/contact':
        $structureOverride['EventDetail.refusing_treatments'] = 'n';
        break;
}
$this->set('structureOverride', $structureOverride);

// Set data for validation
$this->EventMaster->setEventTypeForDataEntryValidation($eventControlData['EventControl']['event_type']);

// Clinical file update process
if (empty($this->request->data))
    $this->Participant->setNextUrlOfTheClinicalFileUpdateProcess($participantId, $this->passedArgs);
$this->Participant->addClinicalFileUpdateProcessInfo();