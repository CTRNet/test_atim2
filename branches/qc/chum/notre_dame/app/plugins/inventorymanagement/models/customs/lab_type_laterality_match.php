<?php

class LabTypeLateralityMatch extends InventorymanagementAppModel {
		
	var $useTable = 'lab_type_laterality_match';

	function getLaboTypeCodes() {
		$result = array();
		
		foreach($this->find('all', array('conditions' => array("selected_type_code NOT IN ('unknown', 'other')"), 'fields' => 'DISTINCT selected_type_code', 'order' => 'selected_type_code')) as $new_record) {
			$result[] = array('value' => $new_record['LabTypeLateralityMatch']['selected_type_code'], 'default' => $new_record['LabTypeLateralityMatch']['selected_type_code']);
		}
		$result[] = array('value' => 'other', 'default' => __('other', true));
		$result[] = array('value' => 'unknown', 'default' => __('unknown', true));
		
		return $result;
	}
	
	function getLaboLaterality() {
		$result = array();
		
		foreach($this->find('all', array('conditions' => array("selected_labo_laterality NOT IN ('unknown')"), 'fields' => 'DISTINCT selected_labo_laterality', 'order' => 'selected_labo_laterality')) as $new_record) {
			$result[] = array('value' => $new_record['LabTypeLateralityMatch']['selected_labo_laterality'], 'default' => empty($new_record['LabTypeLateralityMatch']['selected_labo_laterality'])? '' : __('lab laterality '.$new_record['LabTypeLateralityMatch']['selected_labo_laterality'] ,true));
		}
		$result[] = array('value' => 'unknown', 'default' => __('unknown', true));
		
		return $result;
	}
	
	
	function getTissueSourcePermissibleValues() {
		$result = array();
		
		foreach($this->find('all', array('conditions' => array("tissue_source_matching NOT IN ('unknown', 'other')"), 'fields' => 'DISTINCT tissue_source_matching', 'order' => 'tissue_source_matching')) as $new_record) {
			$result[] = array('value' => $new_record['LabTypeLateralityMatch']['tissue_source_matching'], 'default' => __($new_record['LabTypeLateralityMatch']['tissue_source_matching'], true));
		}
		$result[] = array('value' => 'other', 'default' => __('other', true));
		$result[] = array('value' => 'unknown', 'default' => __('unknown', true));
		
		return $result;
	}	

}

?>
