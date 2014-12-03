<?php
	// Set aliquot label
	$default_aliquot_labels = array();
	$aliquot_count = 1;
	foreach($samples as $view_sample){
		$default_aliquot_label = $this->AliquotMaster->generateAliquotLabel($view_sample, $aliquot_control, $aliquot_count);
		$default_aliquot_labels[$view_sample['ViewSample']['sample_master_id']] = $default_aliquot_label;
		$aliquot_count++;
	}
	//print_r($default_aliquot_labels);
	$this->set('default_aliquot_labels', $default_aliquot_labels);