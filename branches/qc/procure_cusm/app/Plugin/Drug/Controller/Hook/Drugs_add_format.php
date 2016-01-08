<?php 
	
	if(Configure::read('procure_atim_version') == 'PROCESSING') $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
