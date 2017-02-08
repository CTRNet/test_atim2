<?php

class ConsentMasterCustom extends ConsentMaster {
	var $useTable = 'consent_masters';
	var $name = 'ConsentMaster';
	
	function beforeSave($options = array()){
		if(Configure::read('procure_atim_version') != 'BANK') AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
		return parent::beforeSave($options);
	}
}

?>