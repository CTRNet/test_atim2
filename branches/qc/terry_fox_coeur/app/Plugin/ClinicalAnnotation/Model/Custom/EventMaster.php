<?php

class EventMastertCustom extends EventMaster {
	
	var $useTable = 'event_masters';
	var $name = 'EventMaster';
	
	function beforeSave($options = array()) {
		AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}
	
}
