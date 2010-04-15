<?php

class ProtocolAppController extends AppController {
		
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/Protocol/';
	}
	
}

?>