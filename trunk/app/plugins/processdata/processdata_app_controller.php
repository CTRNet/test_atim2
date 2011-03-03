<?php

class ProcessDataAppController extends AppController {	

	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/';
	} 
	 
}

?>