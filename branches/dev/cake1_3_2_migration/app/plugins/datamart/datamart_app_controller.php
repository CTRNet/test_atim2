<?php

class DatamartAppController extends AppController {

	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/Datamart/';
	}

}

?>