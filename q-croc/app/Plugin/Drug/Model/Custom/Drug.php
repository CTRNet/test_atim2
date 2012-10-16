<?php

class DrugCustom extends Drug {
	
	var $name = 'Drug';
	var $useTable = 'drugs';
	
 	/**
	 * Get permissible values array gathering all existing drugs.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getDrugPermissibleValues() {
		$result = array();
		foreach($this->find('all', array('order' => array('Drug.generic_name'))) as $drug){
			$result[$drug["Drug"]["id"]] = __($drug["Drug"]["type"]).': ' . $drug["Drug"]["generic_name"];
		}
		asort($result);
		return $result;
	}
}

?>