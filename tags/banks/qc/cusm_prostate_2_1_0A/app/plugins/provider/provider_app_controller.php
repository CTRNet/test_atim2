<?php

class ProviderAppController extends AppController {
	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/';
	}
}

?>