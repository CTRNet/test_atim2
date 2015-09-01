<?php

class CollectionCustom extends Collection {
	var $useTable = 'collections';
	var $name = 'Collection';
	
	var $procure_transferred_aliquots_limit = 50;
	
	function allowLinkDeletion($collection_id) {
		$res = parent::allowLinkDeletion($collection_id);
		if($res['allow_deletion'] == false) return $res;
		
		//Check no aliquot linked to the collection
		$aliquot_model = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
		$collection_aliquots_count = $aliquot_model->find('count', array('conditions' => array('AliquotMaster.collection_id' => $collection_id), 'recursive' => '-1'));
		if($collection_aliquots_count) {
			return array('allow_deletion' => false, 'msg' => 'the link cannot be deleted - collection contains at least one aliquot');
			
		}
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	
}

?>
