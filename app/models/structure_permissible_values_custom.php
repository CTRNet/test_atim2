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

		App::import('Core', 'l10n');
		$tmp_l10n = new L10n();
		$lang = isset($tmp_l10n->__l10nMap[$_SESSION['Config']['language']])? $tmp_l10n->__l10nMap[$_SESSION['Config']['language']]: '';
		
		$spvc = new StructurePermissibleValuesCustom();
		$data = $spvc->find('all', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => $control_name), 'order' => array('StructurePermissibleValuesCustom.display_order', 'StructurePermissibleValuesCustom.'.$lang)));
		if(empty($data)){ 
			return array(); 
		}
		
		$result = array();
		foreach($data as $data_unit){
			$value = $data_unit['StructurePermissibleValuesCustom']['value'];
			$translated_value = (isset($data_unit['StructurePermissibleValuesCustom'][$lang]) && (!empty($data_unit['StructurePermissibleValuesCustom'][$lang])))? $data_unit['StructurePermissibleValuesCustom'][$lang]: $value;
			$result[$value] = $translated_value;
		}
		
		return $result;
	}
}