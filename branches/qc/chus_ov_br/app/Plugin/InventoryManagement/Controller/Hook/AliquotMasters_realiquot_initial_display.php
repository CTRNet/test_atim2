<?php
	
	$default_aliquot_data = array();
	foreach($this->request->data as $new_data_set){
		$tmp_default_aliquot_data = array();
		$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = $new_data_set['parent']['AliquotMaster']['aliquot_label'];
		if(in_array($new_data_set['parent']['SampleControl']['sample_type'], array('dna','rna'))) {
			$tmp_default_aliquot_data['AliquotDetail.concentration_unit'] = 'ug/ml';
		} else if(in_array($new_data_set['parent']['SampleControl']['sample_type'], array('plasma','pbmc'))) {
			$tmp_default_aliquot_data['AliquotMaster.initial_volume'] = '1';
		}
		$default_aliquot_data[$new_data_set['parent']['AliquotMaster']['id']] = $tmp_default_aliquot_data;
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
