<?php
	
	// --------------------------------------------------------------------------------
	// Set default aliquot label(s)
	// -------------------------------------------------------------------------------- 	
	foreach($this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.id' => explode(",", $parent_aliquots_ids)), 'recursive' => 0)) as $tmp_new_parent){
		$sample_master_id = $tmp_new_parent['AliquotMaster']['sample_master_id'];
		$default_aliquot_label = $this->AliquotMaster->generateDefaultAliquotLabel($child_aliquot_ctrl,
			$tmp_new_parent['ViewAliquot']['acquisition_label'],
			$tmp_new_parent['ViewAliquot']['sample_type'],
			$tmp_new_parent['SampleMaster']['initial_specimen_sample_id'],
			$tmp_new_parent['ViewAliquot']['sample_master_id'],
			$tmp_new_parent['ViewAliquot']);
		$default_aliquot_labels[$sample_master_id] = $default_aliquot_label;
	}
	$this->set('default_aliquot_labels', $default_aliquot_labels);
	
?>
