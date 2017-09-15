<?php
if ($isSpecimen && ($sampleControlData['SampleControl']['sample_type'] != $collectionData['Collection']['qc_lady_specimen_type'])) {
    $this->SampleMaster->validationErrors['sample_type'][] = 'the collection type and the type of the specimen you are trying to create do not match';
    $submittedDataValidates = false;
}