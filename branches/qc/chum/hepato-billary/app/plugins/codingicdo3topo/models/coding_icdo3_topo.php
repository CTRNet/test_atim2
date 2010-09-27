<?php

class CodingIcdo3Topo extends Codingicdo3topoAppModel{

    var $name = 'CodingIcdo3Topo';
	var $useTable = 'coding_icd_o_3_topography';

	var $validate = array();
	
	/**
	 * Gets the description matching a given id
	 * @param $id
	 * @return a description string
	 */
	function getDescription($id){
		if($id != null && strlen($id) > 0){
			$lang = Configure::read('language') == "eng" ? "en" : "fr";
			$query_result = $this->find('first', array('fields' => array('CodingIcdo3Topo.'.$lang.'_description'), 'conditions' => array('CodingIcdo3Topo.id' => $id)));
			return __($query_result['CodingIcdo3Topo'][$lang.'_description'], null);
		}else{
			return "";
		}
	}
	
	function id_blank_or_exists($id){
		$result = true;
		if(strlen($id) > 0){
			$result = is_array($this->CodingIcdo3Topo->find('first', array('fields' => array('CodingIcdo3Topo.id'), 'conditions' => array('CodingIcdo3Topo.id' => $id))));
		}
		return $result;
	}
}

?>