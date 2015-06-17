<?php 
		
	//ATiM PROCURE PROCESSING BANK
	if($sample_data['SampleMaster']['procure_processing_bank_created_by_system'] == 'y'){
		$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}
	//END ATiM PROCURE PROCESSING BANK
	
		
?>