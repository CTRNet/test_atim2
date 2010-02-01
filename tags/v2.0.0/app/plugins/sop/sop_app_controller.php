<?php

class SopAppController extends AppController
{	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/Sop/';
	}
	
}

?>