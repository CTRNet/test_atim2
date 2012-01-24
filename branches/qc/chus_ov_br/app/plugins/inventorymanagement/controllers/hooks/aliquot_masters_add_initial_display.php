<?php
	
	$default_aliquot_data = array();
	foreach($samples as $view_sample){
		$default_aliquot_label = $this->AliquotMaster->generateDefaultAliquotLabel($view_sample, $aliquot_control);
		$default_aliquot_data[$view_sample['ViewSample']['sample_master_id']] = array('aliquot_label' => $default_aliquot_label);
		
		if(in_array($view_sample['ViewSample']['sample_type'], array('dna','rna'))) {
			$default_aliquot_data[$view_sample['ViewSample']['sample_master_id']]['concentration_unit'] = 'ug/ml';
		}
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
		
?>
