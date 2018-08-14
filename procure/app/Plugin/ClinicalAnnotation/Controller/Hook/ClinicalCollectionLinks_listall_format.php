<?php
$this->set('addLinkForProcureForms', $this->Participant->buildAddProcureFormsButton($participantId));

foreach ($this->request->data as &$unit) {
    $sampleTypes = array();
    foreach ($unit['SampleMaster'] as $newSample)
        $sampleTypes[__($newSample['initial_specimen_sample_type'])] = '';
    ksort($sampleTypes);
    $unit['Generated']['procure_generated_sample_types'] = implode(', ', array_keys($sampleTypes));
}