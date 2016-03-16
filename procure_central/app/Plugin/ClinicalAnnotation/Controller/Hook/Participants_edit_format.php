<?php 
	
	//Cannot be added to Participant model because participant record will be updated by system for any MiscIdentifier creation/modification
	//And there are no interest to ad control for CENTRAL BANK because data will be erased
	if(Configure::read('procure_atim_version') != 'BANK') $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
