<?php

class StudyAppController extends AppController
{	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/';
	}
}

?>