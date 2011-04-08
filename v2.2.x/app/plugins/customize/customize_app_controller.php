<?php

class CustomizeAppController extends AppController {	

	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/';
	}

}

?>