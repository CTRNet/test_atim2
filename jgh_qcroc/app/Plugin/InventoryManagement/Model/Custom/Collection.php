<?php
class CollectionCustom extends Collection{

	var $name = "Collection";
	var $useTable = "collections";
	
	function getQcrocCollectionProjectNumbers($misc_identifier_control_id = null) {
		$result = array();
		$this->MiscIdentifierControl = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifierControl", true);
		$conditions = array("misc_identifier_name REGEXP '^QCROC\-[0-9]+$'", 'flag_active = 1');
		if($misc_identifier_control_id) $conditions[] = "id = $misc_identifier_control_id";
		foreach($this->MiscIdentifierControl->find('all', array('conditions' => $conditions)) as $qcroc_identifier_control) {
			$result[$qcroc_identifier_control['MiscIdentifierControl']['id']] = str_replace('QCROC-','', $qcroc_identifier_control['MiscIdentifierControl']['misc_identifier_name']);
		}
		natcasesort($result);
		return $result;
	}
	
	function getCollectionSampleTypeBasedOnCollectionType($collection_type) {
		switch($collection_type){
			case 'T':
				return 'tissue';
				break;
			case 'B':
				return 'blood';
				break;
			default:
				return '';
		}
	}
}
