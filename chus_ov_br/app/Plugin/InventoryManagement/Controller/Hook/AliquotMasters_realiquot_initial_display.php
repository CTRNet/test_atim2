<?php
	
	$default_aliquot_data = array();
	foreach($this->data as $new_data_set){
		$sample_master_id = $new_data_set['parent']['AliquotMaster']['sample_master_id'];
		$default_aliquot_data[$sample_master_id] = array('aliquot_label' => $new_data_set['parent']['AliquotMaster']['aliquot_label']);
		
		if(in_array($new_data_set['parent']['SampleControl']['sample_type'], array('dna','rna'))) {
			$default_aliquot_data[$sample_master_id]['concentration_unit'] = 'ug/ml';
		}
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
	$this->set('default_realiquoted_by','isabelle matte');
	
?>
