<?php
class AdhocCustom extends Adhoc{
	var $useTable = 'datamart_adhoc';
	var $name = 'Adhoc';
	
	static function test($parameters){
		$aliquot_model = AppModel::getInstance("inventorymanagement", "AliquotMaster", true);
		return array($aliquot_model->find('first'));
	}
}