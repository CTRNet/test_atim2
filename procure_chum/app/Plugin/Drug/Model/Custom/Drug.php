<?php

class DrugCustom extends Drug {
	var $useTable = 'drugs';
	var $name = 'Drug';
	
	function getMedicationPermissibleValues() {
		$result = array();
		foreach($this->find('all', array('conditions' => array('Drug.type' => array('prostate','open sale','other diseases')), 'order' => array('Drug.type, Drug.generic_name'))) as $drug){
			$result[$drug["Drug"]["id"]] = $drug["Drug"]["generic_name"] .' -- '.__($drug["Drug"]['type'],true);
		}
		return $result;
	}
	
	function getTreatmentDrugPermissibleValues() {
		$result = array();
		foreach($this->find('all', array('conditions' => array('Drug.type' => array('chemotherapy','hormonotherapy')), 'order' => array('Drug.type, Drug.generic_name'))) as $drug){
			$result[$drug["Drug"]["id"]] = $drug["Drug"]["generic_name"] .' -- '.__($drug["Drug"]['type'],true).($drug["Drug"]['procure_study']? ' ['.__('study').']': '');	
		}
		return $result;
	}
}


?>