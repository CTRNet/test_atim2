<?php

class CollectionCustom extends Collection {
	
	var $useTable = 'collections';
	var $name = 'Collection';
	
	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
	
		if(isset($results[0]['Collection'])) {
			$ViewCollectionModel = null;
			foreach($results as &$result) {
				//Manage confidential information and create the collection qbcf_pathology_id to display: Will Use data returned by ViewCollection.afterFind() function
				if(array_key_exists('qbcf_pathology_id', $result['Collection'])) {
					$collection_view_data = null;
					if(!isset($result['ViewCollection'])) {
						if(!$ViewCollectionModel) $ViewCollectionModel = AppModel::getInstance("InventoryManagement", "ViewCollection", true);
						$collection_view_data = $ViewCollectionModel->find('first', array('conditions' => array('ViewCollection.collection_id' => $result['Collection']['id']), 'recursive' => '-1'));
					} else {
						$collection_view_data = array('ViewCollection' => $result['ViewCollection']);
					}
					if(isset($result['Collection']['qbcf_pathology_id'])) {
						$result['Collection']['qbcf_pathology_id'] = isset($collection_view_data['ViewCollection']['qbcf_pathology_id'])? $collection_view_data['ViewCollection']['qbcf_pathology_id'] : CONFIDENTIAL_MARKER;
					}
				}
			}
		} else if(isset($results['Collection'])){
			pr('TODO afterFind Collection');
			pr($results);
			exit;
		}
	
		return $results;
	}
}

?>
