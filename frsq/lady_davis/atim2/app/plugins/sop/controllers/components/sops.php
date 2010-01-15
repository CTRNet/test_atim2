<?php

class SopsComponent extends Object {
	
	function initialize(&$controller, $settings=array()) {
		$this->controller =& $controller;
	}

	// TODO: Develop this function to retrun SOP list according to object (AliquotMaster, TmaSlide, etc) and different parameters
	function getSopList() {
		$sops_list = $this->controller->SopMaster->atim_list(array('conditions' => array('SopMaster.deleted' => '0'), 'order' => array('SopMaster.title ASC')));
		return (empty($sops_list)? array(): $sops_list);
	}
	
}

?>