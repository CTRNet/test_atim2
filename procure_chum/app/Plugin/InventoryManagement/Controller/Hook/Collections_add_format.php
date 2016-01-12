<?php 
	
	//Cannot be added to Collection model because user of PROCESSING bank can delete a collection
	//Note there are no interest to add control for CENTRAL BANK because data will be erased
	if(Configure::read('procure_atim_version') != 'BANK') {
		AppController::addWarningMsg(__("you have been redirected to the 'add transferred aliquots' form"));
		$this->redirect('/InventoryManagement/Collections/loadTransferredAliquotsData/1', null, true);
	}