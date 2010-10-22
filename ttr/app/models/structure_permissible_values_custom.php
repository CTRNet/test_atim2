<?php
class StructurePermissibleValuesCustom extends AppModel {

	var $name = 'StructurePermissibleValuesCustom';

	var $belongsTo = array(       
		'StructurePermissibleValuesCustomControl' => array(           
			'className'    => 'StructurePermissibleValuesCustomControl',            
			'foreignKey'    => 'control_id'));
		
	function getCustomDropdown($args){
		$control_name = null;
		if(sizeof($args) == 1) { 
			$control_name = $args['0'];
		} 		
		
		$spvc = new StructurePermissibleValuesCustom();
		$data = $spvc->find('all', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => $control_name)));
		
		if(empty($data)) { return array(); }
		
		App::import('Core', 'l10n');
		$tmp_l10n = new L10n();
		$lang = isset($tmp_l10n->__l10nMap[$_SESSION['Config']['language']])? $tmp_l10n->__l10nMap[$_SESSION['Config']['language']]: '';

		$tmp_result = array();
		foreach($data as $data_unit){
			$value = $data_unit['StructurePermissibleValuesCustom']['value'];
			$translated_value = (isset($data_unit['StructurePermissibleValuesCustom'][$lang]) && (!empty($data_unit['StructurePermissibleValuesCustom'][$lang])))? $data_unit['StructurePermissibleValuesCustom'][$lang]: $value;
			$tmp_result[$value] = $translated_value;
		}
		asort($tmp_result);

		$result = array();
		foreach($tmp_result as $value => $default){
			$result[] = array("value" => $value, "default" => $default);
		}
		return $result;
	}
}