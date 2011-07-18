<?php
class DatamartStructure extends DatamartAppModel {
	var $useTable = 'datamart_structures';
	
	function getIdByModelName($model_name){
		$data = $this->find('first', array('conditions' => array('model' => $model_name), 'recursive' => -1, 'fields' => array('id')));
		if(!empty($data)){
			return $data['DatamartStructure']['id'];
		}
		
		$data = $this->find('first', array('conditions' => array('control_master_model' => $model_name), 'recursive' => -1, 'fields' => array('id')));
		if(!empty($data)){
			return $data['DatamartStructure']['id'];
		}
		
		return null;
	}
	
	
	function getDisplayNameFromId() {
		$result = array();
		
		$data = $this->find('all', array('recursive' => -1));
		foreach($data as $new_ds) {
			$result[$new_ds['DatamartStructure']['id']] = __($new_ds['DatamartStructure']['display_name'],true);
		}
		asort($result);
		
		return $result;		
	}
}