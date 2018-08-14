<?php
$chronolgy_data_collection['chronology_details'] = $collection['Collection']['procure_visit'];
$query_specimens = "SELECT DISTINCT SampleControl.sample_type 
		FROM sample_masters SampleMaster 
		INNER JOIN sample_controls SampleControl ON SampleControl.id = SampleMaster.sample_control_id
		WHERE SampleMaster.deleted <> 1
		AND SampleControl.sample_category = 'specimen'
		AND SampleMaster.collection_id = " . $collection['Collection']['id'];
$specimens = $collection_model->query($query_specimens);
if ($specimens) {
    $tmp_specimens = array();
    foreach ($specimens as $new_sample_type)
        $tmp_specimens[] = __($new_sample_type['SampleControl']['sample_type']);
    $chronolgy_data_collection['chronology_details'] .= " (" . implode(' & ', $tmp_specimens) . ")";
}