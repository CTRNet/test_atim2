<?php

class SopsComponent extends Object {
	
	function initialize(&$controller, $settings=array()) {
		$this->controller =& $controller;
	}

	// TODO: Develop this function to retrun SOP list according to object (AliquotMaster, TmaSlide, etc) and different parameters
	function getSopList() {
		return array();
	}
	
}

?>