<?php
	
	// --------------------------------------------------------------------------------
	// Generate Sample Label
	// -------------------------------------------------------------------------------- 	
	if(empty($errors)){
		$this->SampleMaster->addWritableField('qc_nd_sample_label');
		foreach($prev_data as $parent_id => &$children){
			foreach($children as $key => &$child){
				if(is_numeric($key)) {
					$child['SampleControl']['qc_nd_sample_type_code'] = $children_control_data['SampleControl']['qc_nd_sample_type_code'];
					$child['SampleMaster']['qc_nd_sample_label'] = $this->SampleMaster->createSampleLabel($child['SampleMaster']['collection_id'],($child + $children_control_data));
				}
			}
		}
 	}
	
?>
