<?php

class Bank extends AdministrateAppModel {
	function listAllArray(){
		$result = array();
		foreach($this->find('all') as $bank){
			$result[] = array("value" => $bank["Bank"]["id"], "default" => $bank["Bank"]["name"]);
		}
		return $result;
	}
}

?>
