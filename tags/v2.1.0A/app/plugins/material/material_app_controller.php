<?php

class MaterialAppController extends AppController {	
	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/';
	}
	
}

?>