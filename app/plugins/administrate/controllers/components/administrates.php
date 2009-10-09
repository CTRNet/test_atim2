<?php

class AdministratesComponent extends Object {
	
	function initialize(&$controller, $settings=array()) {
		$this->controller =& $controller;
	}
	
	// TODO: Develop this function to retrun Bank list according different parameters
	function getBankList() {		
		$bank_list = $this->controller->Bank->atim_list(array('conditions' => array('Bank.deleted' => '0'), 'order' => array('Bank.name ASC')));
		return $bank_list;
	}
	
}

?>