<?php 
	
	foreach($prev_data as &$children){
		foreach($children as &$child_to_save){
			$child_to_save['SampleMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
		}
	}
	$this->SampleMaster->addWritableField(array('procure_created_by_bank'));
	