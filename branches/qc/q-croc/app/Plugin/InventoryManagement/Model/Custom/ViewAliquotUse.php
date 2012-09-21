<?php

class ViewAliquotUseCustom extends ViewAliquotUse {
	var $name = 'ViewAliquotUse';
	
	function getUseDefinitions() {
		$result = array(
			'aliquot shipment'	=> __('aliquot shipment'),
			'quality control'	=> __('quality control'),
			'internal use'	=> __('internal use'),
			'sample derivative creation'	=> __('sample derivative creation'),
			'realiquoted to'	=> __('realiquoted to'),
			'specimen review'	=> __('specimen review'));
		
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
		
		$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
		$use_and_event_types = $StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => 'aliquot use and event types')));
		foreach($use_and_event_types as $new_type) $result[$new_type['StructurePermissibleValuesCustom']['value']] = strlen($new_type['StructurePermissibleValuesCustom'][$lang])? $new_type['StructurePermissibleValuesCustom'][$lang] : $new_type['StructurePermissibleValuesCustom']['value'];
		
		$transfer_types = $StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => 'Aliquot Transfer: Types')));
		foreach($transfer_types as $new_type) $result[$new_type['StructurePermissibleValuesCustom']['value']] = __('aliquot transfer').' ('.(strlen($new_type['StructurePermissibleValuesCustom'][$lang])? $new_type['StructurePermissibleValuesCustom'][$lang] : $new_type['StructurePermissibleValuesCustom']['value']).')';
		
		asort($result);
		return $result;
	}
	
	function  getSitesAndHDQStaff() {
		$result = array();
		
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
		
		$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
		$all_values = $StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => array('Staff : Sites', 'Staff : HDQ'))));
		foreach($all_values as $new_value) $result[$new_value['StructurePermissibleValuesCustom']['value']] = strlen($new_value['StructurePermissibleValuesCustom'][$lang])? $new_value['StructurePermissibleValuesCustom'][$lang] : $new_value['StructurePermissibleValuesCustom']['value'];
		
		asort($result);
		return $result;
	}
	
	function  getLaboratoryStaff() {
		$result = array();
	
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
	
		$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
		$all_values = $StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => array('Staff : JGH', 'Staff : HDQ'))));
		foreach($all_values as $new_value) $result[$new_value['StructurePermissibleValuesCustom']['value']] = strlen($new_value['StructurePermissibleValuesCustom'][$lang])? $new_value['StructurePermissibleValuesCustom'][$lang] : $new_value['StructurePermissibleValuesCustom']['value'];
	
		asort($result);
		return $result;
	}	
	

}

?>
