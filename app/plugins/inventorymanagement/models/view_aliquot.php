<?php

class ViewAliquot extends InventorymanagementAppModel {
	
	private static $AliquotUse = null;
	
	/**
	 * Defines Generated.aliquot_use_counter when ViewAliquot.aliquot_master_id is defined
	 * @see Model::afterFind()
	 */
	function afterFind($results){
		if(self::$AliquotUse == null){
			self::$AliquotUse = AppModel::atimNew("inventorymanagement", "AliquotUse", true);
		}
		foreach($results as &$result){
			$result['Generated']['aliquot_use_counter'] = self::$AliquotUse->find('count', array('conditions' => array('AliquotUse.aliquot_master_id' => $result['ViewAliquot']['aliquot_master_id'])));
		}
		return $results;
	}
}

?>
