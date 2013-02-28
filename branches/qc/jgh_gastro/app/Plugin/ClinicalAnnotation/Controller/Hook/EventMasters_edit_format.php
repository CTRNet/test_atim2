<?php

	//TODO 2013-02-13 temporary control before to hide all cap reports
	if(strpos($event_master_data['EventControl']['event_type'], 'cap report') !== false) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	