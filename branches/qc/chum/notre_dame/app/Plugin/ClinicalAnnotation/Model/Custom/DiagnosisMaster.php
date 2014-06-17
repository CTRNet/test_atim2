<?php

class DiagnosisMasterCustom extends DiagnosisMaster {
	var $useTable = 'diagnosis_masters';
	var $name = "DiagnosisMaster";
	
	function find($type = 'first', $query = array()) {
		if($type == 'all' && isset($query['conditions'])) {
			foreach($query['conditions'] as $key => &$val) {
				if(!is_array($val)) {
					$val = preg_replace(array('/qc_nd_sardo_morphology_key_words/','/qc_nd_sardo_topography_key_words/'), array('qc_nd_sardo_morphology_desc','qc_nd_sardo_topography_desc'), $val);
				}
			}	
		}
		return parent::find($type, $query);
	}
	
	function beforeSave($options = array()) {
		AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}
	
}
?>