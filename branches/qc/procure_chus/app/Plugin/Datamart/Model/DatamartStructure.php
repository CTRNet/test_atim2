<?php
class DatamartStructure extends DatamartAppModel {
	var $useTable = 'datamart_structures';
	
	function getIdByModelName($model_name){
		$data = $this->find('first', array('conditions' => array('OR' => array('model' => $model_name, 'control_master_model' => $model_name)), 'recursive' => -1, 'fields' => array('id')));
		if(!empty($data)){
			return $data['DatamartStructure']['id'];
		}
		
		return null;
	}
	
	
	function getDisplayNameFromId() {
		$result = array();
		
		$data = $this->find('all', array('recursive' => -1));
		foreach($data as $new_ds) {
			$result[$new_ds['DatamartStructure']['id']] = __($new_ds['DatamartStructure']['display_name']);
		}
		natcasesort($result);
		
		return $result;		
	}
	
	/**
	 * Retrieves the model associated to the id
	 * @param int $id
	 * @param string $model_name If null, the model defined in the db will be used. If not, $model_name will be. 
	 * @return AppModel
	 */
	function getModel($id, $model_name = null){
		$d = $this->findById($id);
		return AppModel::getInstance($d['DatamartStructure']['plugin'], $model_name ?: $d['DatamartStructure']['model']);
	}
	
	function getDisplayNameFromModel() {
		$data = $this->find('all', array('conditions' => array(), 'recursive' => -1, 'fields' => array('DatamartStructure.model', 'DatamartStructure.control_master_model', 'DatamartStructure.display_name')));
		$results = array();
		foreach($data as $new_record) {
			$results[$new_record['DatamartStructure']['model']] = __($new_record['DatamartStructure']['display_name']);
			if(isset($new_record['DatamartStructure']['control_master_model'])) $results[$new_record['DatamartStructure']['control_master_model']] = __($new_record['DatamartStructure']['display_name']);
		}
		return $results;
	}
}