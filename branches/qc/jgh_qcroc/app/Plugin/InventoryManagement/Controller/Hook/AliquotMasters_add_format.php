<?php

	// --------------------------------------------------------------------------------
	// Set default aliquot label(s)
	// --------------------------------------------------------------------------------
	$default_aliquot_labels = array();
	foreach($samples as $view_sample){
		$default_aliquot_label = $this->AliquotMaster->generateDefaultAliquotLabel($aliquot_control, 
			$view_sample['ViewSample']['acquisition_label'], 
			$view_sample['ViewSample']['sample_type'], 
			$view_sample['ViewSample']['initial_specimen_sample_id'],
			$view_sample['ViewSample']['sample_master_id']);
		$default_aliquot_labels[$view_sample['ViewSample']['sample_master_id']] = $default_aliquot_label;
	}
	$this->set('default_aliquot_labels', $default_aliquot_labels);
