<?php

class DiagnosisMasterCustom extends DiagnosisMaster {
	var $useTable = 'diagnosis_masters';
	var $name = "DiagnosisMaster";
	
	function find($type = 'first', $query = array()) {
		$arr_sardo_top_morpho_char_matches = array('á'=>'a','à'=>'a','â'=>'a','ä'=>'a','ã'=>'a','å'=>'a','ç'=>'c','é'=>'e','è'=>'e','ê'=>'e','ë'=>'e','í'=>'i','ì'=>'i','î'=>'i','ï'=>'i','ñ'=>'n','ó'=>'o','ò'=>'o','ô'=>'o','ö'=>'o','õ'=>'o','ú'=>'u','ù'=>'u','û'=>'u','ü'=>'u','ý'=>'y','ÿ'=>'y');
		if($type == 'all' && isset($query['conditions'])) {
			foreach($query['conditions'] as $key => $val) {				
				if(is_string($val) && preg_match('/(qc_nd_sardo_morphology_key_words)|(qc_nd_sardo_topography_key_words)/', $val)) {
					$val = preg_replace(array('/qc_nd_sardo_morphology_key_words/','/qc_nd_sardo_topography_key_words/'), array('qc_nd_sardo_morphology_desc','qc_nd_sardo_topography_desc'), $val);
					$val = str_replace(array_keys($arr_sardo_top_morpho_char_matches), $arr_sardo_top_morpho_char_matches, strtolower($val));
					$query['conditions'][$key] = $val;
				} else if(preg_match('/(qc_nd_sardo_morphology_key_words)|(qc_nd_sardo_topography_key_words)/', $key)){
					$new_key = preg_replace(array('/qc_nd_sardo_morphology_key_words/','/qc_nd_sardo_topography_key_words/'), array('qc_nd_sardo_morphology_desc','qc_nd_sardo_topography_desc'), $key);
					$query['conditions'][$new_key] = $query['conditions'][$key];
					foreach($query['conditions'][$new_key] as $key2 => &$val2) $val2 = str_replace(array_keys($arr_sardo_top_morpho_char_matches), $arr_sardo_top_morpho_char_matches, strtolower($val2));
					unset($query['conditions'][$key]);
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