<?php
 	
	if($is_specimen){
		$collection_data_tmp = $this->Collection->find('first', array('conditions' => array('Collection.id' => $collection_id), 'recursive' => '-1'));
		if(empty($collection_data_tmp)) $this->redirect('/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true); 
		preg_match('/^([0-9]{4})-([0-9]{2})-([0-9]{2})/', $collection_data_tmp['Collection']['collection_datetime'], $res);
		$tmp_year = (isset($res[1]) && !empty($res[1]))? substr($res[1], 2) : date('y', time());
		$max_ld_lymph_specimen_number = $this->SampleMaster->find('first', array('conditions' => array("SampleMaster.ld_lymph_specimen_number LIKE '$tmp_year%'"), 'fields' => array('MAX(SampleMaster.ld_lymph_specimen_number) as max_ld_lymph_specimen_number'), 'recursive' => -1));
		$default_number = $max_ld_lymph_specimen_number[0]['max_ld_lymph_specimen_number'];
		if(empty($default_number)) {
			$default_number = $tmp_year."001";
		} else {
			$default_number += 1;
		}
		if(5-strlen($default_number)) $default_number = '0'.$default_number;
		
		$this->data['SampleMaster']['ld_lymph_specimen_number'] = $default_number;
	}
