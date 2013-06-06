<?php
	
	if($is_specimen){
		$collection_data_tmp = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id), 'recursive' => '-1'));
		if(empty($collection_data_tmp)) $this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		preg_match('/^([0-9]{4})-([0-9]{2})-([0-9]{2})/', $collection_data_tmp['Collection']['collection_datetime'], $res);
		$tmp_year = (isset($res[1]) && !empty($res[1]))? substr($res[1], 2) : date('y', time());	
		$max_ld_lymph_specimen_number = $this->SampleMaster->find('first', array('conditions' => array("SampleMaster.ld_lymph_specimen_number LIKE '$tmp_year%'"), 'fields' => array('MAX(SampleMaster.ld_lymph_specimen_number) as max_ld_lymph_specimen_number'), 'recursive' => -1));
		$default_number = $max_ld_lymph_specimen_number[0]['max_ld_lymph_specimen_number'];	
		if(empty($default_number)) {
			$default_number = $tmp_year.(($tmp_year > 13)? '0':'')."001";
		} else if($default_number == '13999') {
			$default_number = '13A01';
		} else if(preg_match('/^(13([A-Z])([0-9]{2}))$/', $default_number, $matches)) {
			$character = $matches[2];
			$incremental_value = $matches[3];
			if($character.$incremental_value == 'Z99') $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			$incremental_value++;
			if(strlen($incremental_value) == 1) $incremental_value = '0'.$incremental_value;
			if($incremental_value == '100') {
				$character = chr(ord($character)+1);
				$incremental_value = '01';
			}
			$default_number = '13'.$character.$incremental_value;
		} else {
			$default_number += 1;
		}
		if(strlen($default_number) == 4) $default_number = '0'.$default_number;
		$this->request->data['SampleMaster']['ld_lymph_specimen_number'] = $default_number;
	}
