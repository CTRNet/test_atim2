<?php

class StoragelayoutAppController extends AppController {	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/Storagelayout/';
	}
}

?>