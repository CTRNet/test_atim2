<?php

class CollectionsComponent extends Object {
	
	function initialize(&$controller, $settings=array()) {
		$this->controller =& $controller;
	}
	
	/**
	 * Get formatted list of banks.
	 * 
	 * Note: Function to allow bank to customize this function when they don't use 
	 * ADministrate module.
	 * 
	 * @return Bank list into array having following structure: 
	 * 	array($bank_id => $bank_label_built_by_function)
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getBankList() {
		$bank_list = $this->controller->Administrates->getBankList();
		if(empty($bank_list)) { return array(); }
		
		$bank_list_to_return = array();
		foreach($bank_list as $new_bank) {
			$bank_list_to_return[$new_bank['Bank']['id']] = $new_bank['Bank']['name'];
		}
	
		return $bank_list_to_return;
	}
	
	/**
	 * Get formatted list of SOPs existing to build collection.
	 * 
	 * Note: Function to allow bank to customize this function when they don't use 
	 * SOP module.
	 * 
	 * @return SOP list into array having following structure: 
	 * 	array($sop_id => $sop_label_built_by_function)
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getCollectionSopList() {
		$sop_list = $this->controller->Sops->getSopList();
		if(empty($sop_list)) { return array(); }
		
		$sop_list_to_return = array();
		foreach($sop_list as $sop_masters) {
			$sop_list_to_return[$sop_masters['SopMaster']['id']] = $sop_masters['SopMaster']['code'];
		}
	
		return $sop_list_to_return;		
	}
}

?>