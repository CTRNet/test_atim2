<?php
	
	// --------------------------------------------------------------------------------
	// Set custom initial data including default aliquot label(s)
	// -------------------------------------------------------------------------------- 	
	// Get Samples Data
	$sample_master_ids = array();
	foreach($this->data as $new_data_set){ $sample_master_ids[] = $new_data_set['parent']['AliquotMaster']['sample_master_id']; }
	$samples = $this->ViewSample->find('all', array('conditions' => array('sample_master_id' => $sample_master_ids), 'recursive' => -1));
	$samples_from_id = array();
	foreach($samples as $new_sample) $samples_from_id[$new_sample['ViewSample']['sample_master_id']] = $new_sample;
	
	// Add aliquot label
	foreach($this->data as &$new_data_set){ 
		$default_aliquot_label = $this->AliquotMaster->generateDefaultAliquotLabel($samples_from_id[$new_data_set['parent']['AliquotMaster']['sample_master_id']], $child_aliquot_ctrl);
		$new_data_set['children'] = array(array('AliquotMaster'=>array('aliquot_label' => $default_aliquot_label)));
	}
	
?>
