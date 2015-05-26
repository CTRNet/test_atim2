<?php
	
	// --------------------------------------------------------------------------------
	// Set default aliquot label(s)
	// -------------------------------------------------------------------------------- 	
	foreach($this->request->data as &$new_data_set){
		$sample_master_id = $new_data_set['parent']['AliquotMaster']['sample_master_id'];
		$default_aliquot_label = $this->AliquotMaster->generateDefaultAliquotLabel($child_aliquot_ctrl,
			$new_data_set['parent']['ViewAliquot']['acquisition_label'],
			$new_data_set['parent']['ViewAliquot']['sample_type'],
			$new_data_set['parent']['SampleMaster']['initial_specimen_sample_id'],
			$new_data_set['parent']['ViewAliquot']['sample_master_id'],
			$new_data_set['parent']['ViewAliquot']);
		$default_aliquot_labels[$sample_master_id] = $default_aliquot_label;	
	}
	$this->set('default_aliquot_labels', $default_aliquot_labels);
	
?>
