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
			if($tmp_col_data['Collection']['collection_datetime_accuracy'] == 'c') {
				$tmp_default_aliquot_data['AliquotDetail.qc_lady_real_collection_time'] = substr($tmp_col_data['Collection']['collection_datetime'],(strpos($tmp_col_data['Collection']['collection_datetime'], ' ')+1), 5);
			}
		}
		$default_aliquot_data[$new_data_set['parent']['ViewSample']['sample_master_id']] = $tmp_default_aliquot_data;
	}
	$this->set('default_aliquot_data', $default_aliquot_data);
