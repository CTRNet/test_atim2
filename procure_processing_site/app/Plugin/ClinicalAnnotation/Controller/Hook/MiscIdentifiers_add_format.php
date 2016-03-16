<?php 
	switch($controls['MiscIdentifierControl']['misc_identifier_name']) {
		case 'RAMQ':
		case 'hospital number':
			if(Configure::read('procure_atim_version') != 'BANK') $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			break;
		case 'participant study number':
			if(Configure::read('procure_atim_version') != 'PROCESSING') $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			break;
	}
	