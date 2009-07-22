<?php

class ProviderAppController extends AppController 
{
	var $name = 'Providers';
	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/provider/';
	}
}

?>