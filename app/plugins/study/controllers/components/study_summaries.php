<?php

class StudySummariesComponent extends Object {
	
	function initialize(&$controller, $settings=array()) {
		$this->controller =& $controller;
	}
	
	// TODO: Develop this function to retrun Studies list according different parameters
	function getStudiesList() {
		pr('fonction getStudiesList() deprecated!');		
		return array();
	}
	
}

?>