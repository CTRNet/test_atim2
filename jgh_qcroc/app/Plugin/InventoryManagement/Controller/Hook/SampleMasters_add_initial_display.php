<?php 
	
if($is_specimen && $sample_control_data['SampleControl']['sample_type'] != $this->Collection->getCollectionSampleTypeBasedOnCollectionType($collection_data['Collection']['qcroc_collection_type'])) {	
	$this->flash(__('this sample type can not be created for this collection type'), '/InventoryManagement/Collections/detail/' . $collection_id);
}

