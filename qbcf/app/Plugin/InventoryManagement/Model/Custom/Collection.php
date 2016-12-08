<?php

class CollectionCustom extends Collection {
	
	var $useTable = 'collections';
	var $name = 'Collection';
	
	function validates($options = array()){
		if(isset($this->data['Collection']['qbcf_pathology_id'])) {
			if(!isset($this->data['Collection']['collection_property'])) {
				AppController::getInstance()->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );
			}
			if($this->data['Collection']['collection_property'] == 'independent collection') {
				if($this->data['Collection']['qbcf_pathology_id'] != 'Control') {
					$this->validationErrors['qbcf_pathology_id'][] = 'please set pathology id value to control';
				}
				if($this->find('count', array('conditions' => array('Collection.collection_property' => 'independent collection', 'Collection.id != '.$this->id)))) {
					$this->validationErrors['collection_property'][] = 'only one control collection can be created';
				}
			}
		}
		return parent::validates($options);	
	}
	
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
