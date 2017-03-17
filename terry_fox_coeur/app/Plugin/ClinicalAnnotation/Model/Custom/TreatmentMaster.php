<?php

class TreatmentMastertCustom extends TreatmentMaster {
	
	var $useTable = 'treatment_masters';
	var $name = 'TreatmentMaster';
	
	function beforeSave($options = array()) {
		AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}
	
}
