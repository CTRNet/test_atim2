<?php

class AdministrateAppController extends AppController {	

	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/Administrate/';
	}

}

?>