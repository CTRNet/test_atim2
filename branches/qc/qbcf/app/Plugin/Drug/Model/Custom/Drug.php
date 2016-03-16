<?php

class DrugCustom extends Drug {
	
	var $name = 'Drug';
	var $useTable = 'drugs';

	function getQbcfChemoDrugPermissibleValues($type) {
		$result = array();
		foreach($this->find('all', array('conditions' => array('Drug.type' => $type), 'order' => array('Drug.generic_name'))) as $drug){
			$result[$drug["Drug"]["id"]] = $drug["Drug"]["generic_name"];
		}
		return $result;
	}
	
	function getChemoDrugPermissibleValues() {
		return $this->getQbcfChemoDrugPermissibleValues('chemotherapy');
	}
	
	function getHormonoDrugPermissibleValues() {
		return $this->getQbcfChemoDrugPermissibleValues('hormonal');
	}
	
	function getBoneSpecificDrugPermissibleValues() {
		return $this->getQbcfChemoDrugPermissibleValues('bone specific');
	}
	
	function getImmunoDrugPermissibleValues() {
		return $this->getQbcfChemoDrugPermissibleValues('immunotherapy');
	}
}

?>