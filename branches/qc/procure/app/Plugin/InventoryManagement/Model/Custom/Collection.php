<?php

class CollectionCustom extends Collection {
	var $useTable = 'collections';
	var $name = 'Collection';
	
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
	
	function validates($options = array()) {
		$res = parent::validates($options);
		if(isset($this->data['Collection']) && isset($this->data['Collection']['procure_visit'])) {
			$procure_visit = trim($this->data['Collection']['procure_visit']);
			if(preg_match('/^[Vv]{0,1}((0{0,1}[1-9])|([1-9][0-9]))([\.,]([1-9])){0,1}$/', $procure_visit, $matches)) {
				$this->data['Collection']['procure_visit'] = 'V'.sprintf("%02s",$matches[1]).((isset($matches[5]) && $matches[5])? '.'.$matches[5] : '');
			} else {
				$res = false;
				$this->validationErrors['procure_visit'][] = __('wrong procure collection visit format');
			}
		}
		return $res;
	}
	
	function allowDeletion($collection_id){
	    if($this->data['Collection']['procure_visit'] == 'Controls') {
	        return array('allow_deletion' => false, 'msg' => 'control collection - collection can not be deleted');
	    }
	    return parent::allowDeletion($collection_id);
	}
	
}

?>
