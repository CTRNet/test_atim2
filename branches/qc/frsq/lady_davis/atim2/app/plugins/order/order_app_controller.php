<?php

class OrderAppController extends AppController {	
	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/Order/';
	}
	
}

?>