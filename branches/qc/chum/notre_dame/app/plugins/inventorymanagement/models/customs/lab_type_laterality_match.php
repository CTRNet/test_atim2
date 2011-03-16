<?php

class LabTypeLateralityMatch extends InventorymanagementAppModel {
		
	var $useTable = 'lab_type_laterality_match';

	function getLaboTypeCodes() {
		$result = array();
		
		foreach($this->find('all', array('conditions' => array("selected_type_code NOT IN ('unknown', 'other')"), 'fields' => 'DISTINCT selected_type_code', 'order' => 'selected_type_code')) as $new_record) {
			$result[$new_record['LabTypeLateralityMatch']['selected_type_code']] = $new_record['LabTypeLateralityMatch']['selected_type_code'];
		}
		$result['other'] = __('other', true);
		$result['unknown'] = __('unknown', true);
		
		return $result;
	}
	
	function getLaboLaterality() {
		$result = array();
		
		foreach($this->find('all', array('conditions' => array("selected_labo_laterality NOT IN ('unknown')"), 'fields' => 'DISTINCT selected_labo_laterality', 'order' => 'selected_labo_laterality')) as $new_record) {
			$result[$new_record['LabTypeLateralityMatch']['selected_labo_laterality']] = empty($new_record['LabTypeLateralityMatch']['selected_labo_laterality'])? '' : __('lab laterality '.$new_record['LabTypeLateralityMatch']['selected_labo_laterality'] ,true);
		}
		$result['unknown'] = __('unknown', true);
		
		return $result;
	}
	
	
	function getTissueSourcePermissibleValues() {
		$result = array();
		
		foreach($this->find('all', array('conditions' => array("tissue_source_matching NOT IN ('unknown', 'other')"), 'fields' => 'DISTINCT tissue_source_matching', 'order' => 'tissue_source_matching')) as $new_record) {
			$result[$new_record['LabTypeLateralityMatch']['tissue_source_matching']] = __($new_record['LabTypeLateralityMatch']['tissue_source_matching'], true);
		}
		$result['other'] = __('other', true);
		$result['unknown'] = __('unknown', true);
		
		return $result;
	}	

}

?>
