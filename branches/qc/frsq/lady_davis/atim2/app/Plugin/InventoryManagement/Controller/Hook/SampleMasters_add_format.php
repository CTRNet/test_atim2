<?php 
if($is_specimen && ($sample_control_data['SampleControl']['sample_type'] != $collection_data['Collection']['qc_lady_specimen_type'])) {
	$this->flash('the collection type and the type of the specimen you are trying to create do not match', '/InventoryManagement/Collections/detail/' . $collection_id);
}
