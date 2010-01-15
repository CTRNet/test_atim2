<?php

class DrugAppController extends AppController {	
	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/Drug/';
	}
	
}

?>