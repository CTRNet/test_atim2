<?php

class DrugCustom extends Drug {
	var $useTable = 'drugs';
	var $name = 'Drug';
	
	function getDrugPermissibleValues() {
		$result = array();
		foreach($this->find('all', array('order' => array('Drug.generic_name'))) as $drug){
			$result[$drug["Drug"]["id"]] = $drug["Drug"]["generic_name"] .' | '.__($drug["Drug"]['type'],true);
		}
		return $result;
	}
}

?>