<?php
class CollectionCustom extends Collection{

	var $name = "Collection";
	var $useTable = "collections";
	
	function getQcrocCollectionProject() {
		$result = array();
		$this->MiscIdentifierControl = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifierControl", true);
		foreach($this->MiscIdentifierControl->find('all', array('conditions' => array('flag_active = 1',"misc_identifier_name LIKE '%QCROC%'"))) as $qcroc_identifier_control) {
			$result[$qcroc_identifier_control['MiscIdentifierControl']['id']] = __($qcroc_identifier_control['MiscIdentifierControl']['misc_identifier_name']);
		}
		natcasesort($result);
		return $result;
	}
}
