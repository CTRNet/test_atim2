<?php
	
	// --------------------------------------------------------------------------------
	// Set default aliquot label(s)
	// -------------------------------------------------------------------------------- 	
	foreach($this->data as $new_data_set){
		$sample_master_id = $new_data_set['parent']['AliquotMaster']['sample_master_id'];
		$sample_data = $this->ViewSample->find('first', array('conditions' => array('sample_master_id' => $sample_master_id), 'recursive' => -1));
		$default_aliquot_label = $this->AliquotMaster->generateDefaultAliquotLabel($sample_data, $child_aliquot_ctrl);
		$default_aliquot_labels[$sample_master_id] = $default_aliquot_label;
	}
	$this->set('default_aliquot_labels', $default_aliquot_labels);
	
?>
