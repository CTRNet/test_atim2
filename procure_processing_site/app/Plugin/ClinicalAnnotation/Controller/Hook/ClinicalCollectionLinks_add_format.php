<?php 
	
	//Cannot be added to Collection model because user of PROCESSING bank can delete a collection
	//Note there is no interest to add control for CENTRAL BANK because data will be erased
	if(Configure::read('procure_atim_version') != 'BANK') $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	
	if($this->request->data) {
		
		//todo chercher collection...
		$this->request->data['Collection']['id'] = null;

	}
