<?php
 	
	if($is_specimen){
		$tmp_year = date('y', time());
		$max_specimen_number = $this->SampleMaster->find('first', array('conditions' => array("SampleMaster.specimen_number LIKE '$tmp_year%'"), 'fields' => array('MAX(SampleMaster.specimen_number) as max_specimen_number'), 'recursive' => -1));
		$default_number = $max_specimen_number[0]['max_specimen_number'];
		if(empty($default_number)) {
			$default_number = $tmp_year."001";
		} else {
			$default_number += 1;
		}
		$this->data['SampleMaster']['specimen_number'] = $default_number;
	}
