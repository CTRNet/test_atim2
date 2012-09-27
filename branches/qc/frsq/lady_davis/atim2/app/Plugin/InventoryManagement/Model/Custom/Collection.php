<?php

class CollectionCustom extends Collection {
	
	var $name = 'Collection';
	var $useTable = 'collections';
	
	function  getSpecimenTypePrecision($data_entry = false, $predefined_specimen_type = null) {
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
		$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
		
		$types_to_add = array('tissue' => 'Tissue', 'blood' => 'Blood');
		if(!is_null($predefined_specimen_type)) {	
			if(!array_key_exists($predefined_specimen_type, $types_to_add)) AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
			$types_to_add = array($predefined_specimen_type => $types_to_add[$predefined_specimen_type]);
		}
		
		$result = array('' => '');
		foreach($types_to_add as $new_type_lower_case => $new_type) {		
			$conditions = array('StructurePermissibleValuesCustomControl.name' => 'Collection : '.$new_type.' type precision');
			if($data_entry)  $conditions['StructurePermissibleValuesCustom.use_as_input'] = '1';	
			$all_values = $StructurePermissibleValuesCustom->find('all', array('conditions' => $conditions));
			foreach($all_values as $new_value) { 
				$result[$new_type_lower_case.'||'.$new_value['StructurePermissibleValuesCustom']['value']] = __($new_type_lower_case).' : '.(strlen($new_value['StructurePermissibleValuesCustom'][$lang])? $new_value['StructurePermissibleValuesCustom'][$lang] : $new_value['StructurePermissibleValuesCustom']['value']);
			}
		}	
		asort($result);
		return $result;
	}
	
}

?>
