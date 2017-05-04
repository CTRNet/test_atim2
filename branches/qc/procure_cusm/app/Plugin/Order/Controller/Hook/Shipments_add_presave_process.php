<?php 

	$this->request->data['Shipment']['procure_created_by_bank'] = Configure::read('procure_bank_id');
	$this->Shipment->addWritableField(array('procure_created_by_bank'));
	