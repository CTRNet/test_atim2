<?php 
		
	//Note there are no interest to add control for CENTRAL BANK because data will be erased
	if(Configure::read('procure_atim_version') != 'BANK') {
		if($sample_data['SampleMaster']['procure_created_by_bank'] != 'p'){
			$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	}