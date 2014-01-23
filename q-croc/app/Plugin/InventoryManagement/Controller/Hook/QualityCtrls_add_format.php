<?php
	
	$default_qc_data = array();
	foreach($this->request->data as $data_id => $new_data_set) {
		if(!in_array($new_data_set['parent']['ViewSample']['sample_type'], array('dna','rna'))) {
			$this->flash((__('you can only create quality control for dna and rna').' (#'.__LINE__.')'), $cancel_button, 5);
			return;
		}
		$tmp_default_qc_data = array();
		if($new_data_set['parent']['ViewSample']['sample_type'] == 'dna') {
			$tmp_default_qc_data['QualityCtrl.type'] = 'picogreen gel';
		} else {
			$tmp_default_qc_data['QualityCtrl.unit'] = 'rin';
			$tmp_default_qc_data['QualityCtrl.type'] = 'bioanalyzer';	
		}
		$default_qc_data[$new_data_set['parent']['ViewSample']['sample_master_id']] = $tmp_default_qc_data;
	}
	$this->set('default_qc_data', $default_qc_data);