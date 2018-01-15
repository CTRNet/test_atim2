<?php
if ($submittedDataValidates) {
    // --------------------------------------------------------------------------------
    // Generate Sample Label
    // --------------------------------------------------------------------------------
    $this->request->data['SampleControl'] = $sampleControlData['SampleControl'];
    $this->SampleMaster->addWritableField('qc_nd_sample_label');
    $this->request->data['SampleMaster']['qc_nd_sample_label'] = $this->SampleMaster->createSampleLabel($collectionId, ($this->request->data + $sampleControlData));
}