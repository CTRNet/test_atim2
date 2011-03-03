<?php

class LabBookAppController extends AppController {	

	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/';
	} 
	 
}

?>