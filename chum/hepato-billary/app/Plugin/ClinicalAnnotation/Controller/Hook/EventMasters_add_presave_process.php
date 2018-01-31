<?php
$processedEventData = $eventControlData['EventControl']['use_addgrid'] ? $this->request->data : array(
    '0' => $this->request->data
);
foreach ($processedEventData as &$newEventData) {
    $newEventData = $this->EventMaster->addBmiValue($newEventData);
    $newEventData = $this->EventMaster->setHospitalizationDuration($newEventData);
    $newEventData = $this->EventMaster->setIntensiveCareDuration($newEventData);
    $newEventData = $this->EventMaster->completeVolumetry($newEventData, $submittedDataValidates);
    $newEventData = $this->EventMaster->setScores($eventControlData['EventControl']['event_type'], $newEventData, $submittedDataValidates);
}
$this->request->data = $eventControlData['EventControl']['use_addgrid'] ? $processedEventData : $processedEventData['0'];