<?php
class StructurePermissibleValuesCustom extends AppModel {

	var $name = 'StructurePermissibleValuesCustom';

	var $belongsTo = array(       
		'StructurePermissibleValuesCustomControl' => array(           
			'className'    => 'StructurePermissibleValuesCustomControl',            
			'foreignKey'    => 'control_id'));
	
	private static $instance = null;
	protected static $lang = null;
	
	static protected function getLanguage(){
		if(self::$lang == null){
			$tmp_l10n = new L10n();
			$tmp_l10n_map = $tmp_l10n->map();
			self::$lang = isset($tmp_l10n_map[$_SESSION['Config']['language']]) ? $tmp_l10n_map[$_SESSION['Config']['language']]: '';
		}
		return self::$lang;
	}
		
	function getCustomDropdown(array $args){
		$control_name = null;
		if(sizeof($args) == 1) { 
			$control_name = $args['0'];
		}

		$lang = self::getLanguage();
		
		if(self::$instance == null){
			self::$instance = new StructurePermissibleValuesCustom();
			self::$instance->cacheQueries = true;
		}
		$conditions = array('StructurePermissibleValuesCustomControl.name' => $control_name);
		$data = self::$instance->find('all', array('conditions' => $conditions, 'order' => array('StructurePermissibleValuesCustom.display_order', 'StructurePermissibleValuesCustom.'.$lang)));
		if(empty($data)){ 
			return array(); 
		}
		
		$result = array("defined" => array(), "previously_defined" => array());
		foreach($data as $data_unit){
			$value = $data_unit['StructurePermissibleValuesCustom']['value'];
			$translated_value = (isset($data_unit['StructurePermissibleValuesCustom'][$lang]) && (!empty($data_unit['StructurePermissibleValuesCustom'][$lang])))? $data_unit['StructurePermissibleValuesCustom'][$lang]: $value;
			if($data_unit['StructurePermissibleValuesCustom']['use_as_input']){
				$result['defined'][$value] = $translated_value;
			}else{
				$result['previously_defined'][$value] = $translated_value;
			}
		}
		if($data[0]['StructurePermissibleValuesCustom']['display_order'] == 0){
			//sort alphabetically
			natcasesort($result['defined']);
			natcasesort($result['previously_defined']);
		}
		
		return $result;
	}
}