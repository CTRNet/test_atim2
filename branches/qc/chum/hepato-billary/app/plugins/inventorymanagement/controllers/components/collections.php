<?php

class CollectionsComponent extends Object {
	
	function initialize(&$controller, $settings=array()) {
		$this->controller =& $controller;
	}
	
	/**
	 * Get list of banks.
	 * 
	 * Note: Function to allow bank to customize this function when they don't use 
	 * ADministrate module.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getBankList() {
		return $this->controller->Administrates->getBankList();
	}
	
	/**
	 * Get list of SOPs existing to build collection.
	 * 
	 * Note: Function to allow bank to customize this function when they don't use 
	 * SOP module.
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getCollectionSopList() {
		return $this->controller->Sops->getSopList();
	}
}

?>