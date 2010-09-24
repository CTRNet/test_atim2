<?php
class Codingicdo3topoAppController extends AppController {	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/';
	}
}