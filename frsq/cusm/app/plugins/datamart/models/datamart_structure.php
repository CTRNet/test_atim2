<?php
class DatamartStructure extends DatamartAppModel {
	var $useTable = 'datamart_structures';
	
	function getIdByModelName($model_name){
		$data = $this->find('first', array('conditions' => array('model' => $model_name), 'recursive' => -1, 'fields' => array('id')));
		if(count($data)){
			return $data['DatamartStructure']['id'];
		}
		return null;
	}
}