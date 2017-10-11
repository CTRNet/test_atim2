<?php

// --------------------------------------------------------------------------------
// Generate Sample Label
// --------------------------------------------------------------------------------
if ($submittedDataValidates) {
    $workingData = $this->request->data;
    $workingData['SampleControl'] = $sampleData['SampleControl'];
    $workingData['SampleMaster']['initial_specimen_sample_id'] = $sampleData['SampleMaster']['initial_specimen_sample_id'];
    
    $this->SampleMaster->addWritableField('qc_nd_sample_label');
    $this->request->data['SampleMaster']['qc_nd_sample_label'] = $this->SampleMaster->createSampleLabel($collectionId, $workingData);
    
    $this->SampleMaster->data = array();
}