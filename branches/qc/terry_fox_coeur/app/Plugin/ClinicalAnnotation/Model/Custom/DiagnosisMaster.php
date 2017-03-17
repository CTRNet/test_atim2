<?php

class DiagnosisMastertCustom extends DiagnosisMaster {
	
	var $useTable = 'diagnosis_masters';
	var $name = 'DiagnosisMaster';
	
	function beforeSave($options = array()) {
		AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}
	
}
