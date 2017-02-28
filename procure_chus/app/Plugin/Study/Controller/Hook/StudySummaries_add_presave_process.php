<?php 

	$this->request->data['StudySummary']['procure_created_by_bank'] = Configure::read('procure_bank_id');
	$this->StudySummary->addWritableField(array('procure_created_by_bank'));
	