<?php
	
	if(isset($aliquot_data['Generated']['coll_to_stor_spent_time_msg']) 
	&& !empty($aliquot_data['Collection']['collection_datetime']) 
	&& !empty($aliquot_data['AliquotMaster']['storage_datetime'])) {	
		if(($aliquot_data['Collection']['collection_datetime_accuracy'] != 'c') || ($aliquot_data['AliquotMaster']['storage_datetime_accuracy'] != 'c')) {
			$aliquot_data['Generated']['coll_to_stor_spent_time_msg'] = '<span class="red">'.__('insufficient accuracy of the dates', true).'</span>';
			$this->set('sample_master_data', $aliquot_data);
		}
	}
	if(isset($aliquot_data['Generated']['rec_to_stor_spent_time_msg']) 
	&& !empty($aliquot_data['SpecimenDetail']['reception_datetime']) 
	&& !empty($aliquot_data['AliquotMaster']['storage_datetime'])) {
		if(($aliquot_data['SpecimenDetail']['reception_datetime_accuracy'] != 'c') || ($aliquot_data['AliquotMaster']['storage_datetime_accuracy'] != 'c')) {
			$aliquot_data['Generated']['rec_to_stor_spent_time_msg'] = '<span class="red">'.__('insufficient accuracy of the dates', true).'</span>';
			$this->set('sample_master_data', $aliquot_data);
		}
	}
	if(isset($aliquot_data['Generated']['creat_to_stor_spent_time_msg']) 
	&& !empty($aliquot_data['DerivativeDetail']['creation_datetime']) 
	&& !empty($aliquot_data['AliquotMaster']['storage_datetime'])) {
		if(($aliquot_data['DerivativeDetail']['creation_datetime_accuracy'] != 'c') || ($aliquot_data['AliquotMaster']['storage_datetime_accuracy'] != 'c')) {
			$aliquot_data['Generated']['creat_to_stor_spent_time_msg'] = '<span class="red">'.__('insufficient accuracy of the dates', true).'</span>';
			$this->set('sample_master_data', $aliquot_data);
		}
	}	
	$this->set('aliquot_master_data', $aliquot_data);
	
?>

