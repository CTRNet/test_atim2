<?php 
	
	$this->request->data['SampleMaster']['procure_created_by_bank'] = Configure::read('procure_bank_id');
	$this->SampleMaster->addWritableField(array('procure_created_by_bank'));
	