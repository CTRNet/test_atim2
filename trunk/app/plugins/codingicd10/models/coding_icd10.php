<?php

class CodingIcd10 extends AppModel {

    var $name = 'CodingIcd10';
	var $useTable = 'coding_icd10';

	var $validate = array();
	
	/**
	 * Gets the description matching a given id
	 * @param $id
	 * @return a description string
	 */
	function getDescription($id){
		if($id != null && strlen($id) > 0){
			$query_result = $this->find('first', array('fields' => array('CodingIcd10.description'), 'conditions' => array('CodingIcd10.id' => $id)));
			return $query_result['CodingIcd10']['description'];
		}else{
			return "";
		}
	}
	
	function id_blank_or_exists($id){
		$result = true;
		if(strlen($id) > 0){
			$result = is_array($this->CodingIcd10->find('first', array('fields' => array('CodingIcd10.id'), 'conditions' => array('CodingIcd10.id' => $id))));
		}
		return $result;
	}
}

?>