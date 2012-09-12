<?php
	
	$default_aliquot_data = array();
	foreach($this->request->data as $new_data_set){
		$tmp_default_aliquot_data = array();
		$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = $this->AliquotMaster->generateDefaultAliquotLabel($new_data_set['parent'], $aliquot_control);
		if(in_array($new_data_set['parent']['ViewSample']['sample_type'], array('dna','rna','amplified rna','cdna'))) {
			$tmp_default_aliquot_data['AliquotDetail.concentration_unit'] = 'ug/ml';
		} else if(in_array($new_data_set['parent']['ViewSample']['sample_type'], array('plasma','pbmc'))) {
			$tmp_default_aliquot_data['AliquotMaster.initial_volume'] = '1';	
		}
		$default_aliquot_data[$new_data_set['parent']['ViewSample']['sample_master_id']] = $tmp_default_aliquot_data;
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
