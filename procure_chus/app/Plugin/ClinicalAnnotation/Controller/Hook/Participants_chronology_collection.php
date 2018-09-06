<?php
$chronolgyDataCollection['chronology_details'] = $collection['Collection']['procure_visit'];
$querySpecimens = "SELECT DISTINCT SampleControl.sample_type 
		FROM sample_masters SampleMaster 
		INNER JOIN sample_controls SampleControl ON SampleControl.id = SampleMaster.sample_control_id
		WHERE SampleMaster.deleted <> 1
		AND SampleControl.sample_category = 'specimen'
		AND SampleMaster.collection_id = " . $collection['Collection']['id'];
$specimens = $collectionModel->query($querySpecimens);
if ($specimens) {
    $tmpSpecimens = array();
    foreach ($specimens as $newSampleType)
        $tmpSpecimens[] = __($newSampleType['SampleControl']['sample_type']);
    $chronolgyDataCollection['chronology_details'] .= " (" . implode(' & ', $tmpSpecimens) . ")";
}