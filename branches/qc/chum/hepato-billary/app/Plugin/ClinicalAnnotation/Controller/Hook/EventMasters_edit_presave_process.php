<?php
$this->request->data = $this->EventMaster->addBmiValue($this->request->data);
$this->request->data = $this->EventMaster->setHospitalizationDuration($this->request->data);
$this->request->data = $this->EventMaster->setIntensiveCareDuration($this->request->data);
$this->request->data = $this->EventMaster->completeVolumetry($this->request->data, $submittedDataValidates);
$this->request->data = $this->EventMaster->setScores($eventControlData['EventControl']['event_type'], $this->request->data, $submittedDataValidates);