<?php
 	
	if($is_specimen){
		$tmp_year = date('y', time());
		$max_ld_lymph_specimen_number = $this->SampleMaster->find('first', array('conditions' => array("SampleMaster.ld_lymph_specimen_number LIKE '$tmp_year%'"), 'fields' => array('MAX(SampleMaster.ld_lymph_specimen_number) as max_ld_lymph_specimen_number'), 'recursive' => -1));
		$default_number = $max_ld_lymph_specimen_number[0]['max_ld_lymph_specimen_number'];
		if(empty($default_number)) {
			$default_number = $tmp_year."001";
		} else {
			$default_number += 1;
		}
		$this->data['SampleMaster']['ld_lymph_specimen_number'] = $default_number;
	}
