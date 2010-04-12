<?php

class StudySummariesComponent extends Object {
	
	function initialize(&$controller, $settings=array()) {
		$this->controller =& $controller;
	}
	
	// TODO: Develop this function to retrun Studies list according different parameters
	function getStudiesList() {		
		$studies_list = $this->controller->StudySummary->atim_list(array('conditions' => array('StudySummary.deleted' => '0'), 'order' => array('StudySummary.title ASC')));
		return (empty($studies_list)? array(): $studies_list);
	}
	
}

?>