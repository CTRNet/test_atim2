<?php
class StructurePermissibleValuesCustom extends AppModel {

	var $name = 'StructurePermissibleValuesCustom';
	
	static function getCustomDropdown($control_id){
		$spvc = new StructurePermissibleValuesCustom();
		$data = $spvc->find('all', array('conditions' => array('control_id' => $control_id)));
		$result = array();
		foreach($data as $data_unit){
			$result[] = array("value" => $data_unit['StructurePermissibleValuesCustom']['value'], "default" => $data_unit['StructurePermissibleValuesCustom']['value']);
		}
		return $result;
	}
	
	function getDropdownStaff(){
		return StructurePermissibleValuesCustom::getCustomDropdown(1);
	}
	
	function getDropdownLaboratorySites(){
		return StructurePermissibleValuesCustom::getCustomDropdown(2);
	}
	
	function getDropdownCollectionSites(){
		return StructurePermissibleValuesCustom::getCustomDropdown(3);
	}
	
	function getDropdownSpecimenSupplierDepartments(){
		return StructurePermissibleValuesCustom::getCustomDropdown(4);
	}
	
	function getDropdownToors(){
		return StructurePermissibleValuesCustom::getCustomDropdown(5);
	}
}