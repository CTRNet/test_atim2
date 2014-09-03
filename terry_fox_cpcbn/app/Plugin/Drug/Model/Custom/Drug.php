<?php

class DrugCustom extends Drug {
	
	var $name = 'Drug';
	var $useTable = 'drugs';
	
 	function getHormDrugPermissibleValues() {
		$result = array();
		foreach($this->find('all', array('conditions' => array('Drug.type' => 'hormonal'), 'order' => array('Drug.generic_name'))) as $drug){
			$result[$drug["Drug"]["id"]] = $drug["Drug"]["generic_name"];
		}
		return $result;
	}
	function getChemoDrugPermissibleValues() {
		$result = array();
		foreach($this->find('all', array('conditions' => array('Drug.type' => 'chemotherapy'), 'order' => array('Drug.generic_name'))) as $drug){
			$result[$drug["Drug"]["id"]] = $drug["Drug"]["generic_name"];
		}
		return $result;
	}
	function getBoneDrugPermissibleValues() {
		$result = array();
		foreach($this->find('all', array('conditions' => array('Drug.type' => 'bone'), 'order' => array('Drug.generic_name'))) as $drug){
			$result[$drug["Drug"]["id"]] = $drug["Drug"]["generic_name"];
		}
		return $result;
	}
	function getHrDrugPermissibleValues() {
		$result = array();
		foreach($this->find('all', array('conditions' => array('Drug.type' => 'HR'), 'order' => array('Drug.generic_name'))) as $drug){
			$result[$drug["Drug"]["id"]] = $drug["Drug"]["generic_name"];
		}
		return $result;
	}
}





?>