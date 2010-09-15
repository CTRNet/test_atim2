<?php
class Codingicd10AppController extends AppController {	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/';
	}
}