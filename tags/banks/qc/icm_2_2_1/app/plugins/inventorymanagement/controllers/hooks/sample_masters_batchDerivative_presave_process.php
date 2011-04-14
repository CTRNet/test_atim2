<?php
	
	// --------------------------------------------------------------------------------
	// Generate Sample Label
	// -------------------------------------------------------------------------------- 	
	if(empty($errors)){
		foreach($prev_data as $parent_id => &$children){
			foreach($children as $key => &$child){
				if(is_numeric($key)) {
					$child['SampleMaster']['sample_label'] = $this->SampleMaster->createSampleLabel($child['SampleMaster']['collection_id'],($child + $children_control_data));
				}
			}
		}
 	}
	
?>
