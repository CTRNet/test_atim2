<?php

class LabTypeLateralityMatch extends InventorymanagementAppModel {
		
	var $useTable = 'lab_type_laterality_match';	
		
	function getLaboTypeCodes() {
		$result = array();
		
		foreach($this->find('all', array('conditions' => array("selected_type_code NOT IN ('unknown', 'other')"), 'field' => 'DISTINCT selected_type_code', 'order' => 'selected_type_code')) as $new_record) {
			$result[] = array('value' => $new_record['LabTypeLateralityMatch']['selected_type_code'], 'default' => $new_record['LabTypeLateralityMatch']['selected_type_code']);
		}
		$result[] = array('value' => 'other', 'default' => __('other', true));
		$result[] = array('value' => 'unknown', 'default' => __('unknown', true));
		
		return $result;
	}
	
}

?>
