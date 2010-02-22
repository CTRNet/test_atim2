<?php

class ClinicalannotationAppController extends AppController {	

	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/Clinicalannotation/';
	}
	
}

?>