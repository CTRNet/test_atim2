<?php
	
	if(isset($sample_data['Generated']['coll_to_rec_spent_time_msg']) 
	&& !empty($sample_data['Collection']['collection_datetime']) 
	&& !empty($sample_data['SpecimenDetail']['reception_datetime'])) {
		if(($sample_data['Collection']['collection_datetime_accuracy'] != 'c') || ($sample_data['SpecimenDetail']['reception_datetime_accuracy'] != 'c')) {
			$sample_data['Generated']['coll_to_rec_spent_time_msg'] = '<span class="red">'.__('insufficient accuracy of the dates', true).'</span>';
			$this->set('sample_master_data', $sample_data);
		}
		
	} else if(isset($sample_data['Generated']['coll_to_creation_spent_time_msg'])	 
	&& !empty($sample_data['Collection']['collection_datetime']) 
	&& !empty($sample_data['DerivativeDetail']['creation_datetime'])) {
		pr($sample_data['Collection']['collection_datetime'].'/'.$sample_data['DerivativeDetail']['creation_datetime']);
		if(($sample_data['Collection']['collection_datetime_accuracy'] != 'c') || ($sample_data['DerivativeDetail']['creation_datetime_accuracy'] != 'c')) {
			$sample_data['Generated']['coll_to_creation_spent_time_msg'] = '<span class="red">'.__('insufficient accuracy of the dates', true).'</span>';
			$this->set('sample_master_data', $sample_data);
		}
	}
								
?>

