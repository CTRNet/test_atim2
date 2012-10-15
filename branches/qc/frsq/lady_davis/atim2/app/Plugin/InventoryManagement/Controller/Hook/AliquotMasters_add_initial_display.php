<?php
	
	$default_aliquot_data = array();
	$tmp_coll_data_from_id = array();
	foreach($this->request->data as $new_data_set){
		$tmp_default_aliquot_data = array();
		if(($new_data_set['parent']['ViewSample']['sample_type'] == 'tissue') && $aliquot_control['AliquotControl']['aliquot_type'] == 'tube') {
			$tmp_col_id = $new_data_set['parent']['ViewSample']['collection_id'];
			$tmp_col_data = array();
			if(array_key_exists($tmp_col_id, $tmp_coll_data_from_id)) {
				$tmp_col_data = $tmp_coll_data_from_id[$tmp_col_id];
			} else {
				$tmp_col_data = $this->Collection->find('first', array('conditions' => array('Collection.id' => $tmp_col_id), 'recursive' => '-1'));
				$tmp_coll_data_from_id[$tmp_col_id] = $tmp_col_data;
			}
		} else if(($new_data_set['parent']['ViewSample']['sample_type'] == 'pbmc') && $aliquot_control['AliquotControl']['aliquot_type'] == 'tube') {
			$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = 'Buffy Coat';
		} else if(($new_data_set['parent']['ViewSample']['sample_type'] == 'serum') && $aliquot_control['AliquotControl']['aliquot_type'] == 'tube') {
			$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = 'Serum';	
		} else if(($new_data_set['parent']['ViewSample']['sample_type'] == 'plasma') && $aliquot_control['AliquotControl']['aliquot_type'] == 'tube') {
			$blood_data = $this->SampleMaster->find('first', array('conditions' => array('SampleMaster.id' => $new_data_set['parent']['ViewSample']['initial_specimen_sample_id']), 'recursive' => '0'));
			if($blood_data['SampleDetail']['blood_type'] == 'EDTA') {
				$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = 'EDTA';
			} else if($blood_data['SampleDetail']['blood_type'] == 'CTAD') {
				$tmp_default_aliquot_data['AliquotMaster.aliquot_label'] = 'CTAD';
			}
		}						
		$default_aliquot_data[$new_data_set['parent']['ViewSample']['sample_master_id']] = $tmp_default_aliquot_data;
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
