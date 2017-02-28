<?php 

	$this->request->data['Order']['procure_created_by_bank'] = Configure::read('procure_bank_id');
	$this->Order->addWritableField(array('procure_created_by_bank'));
	