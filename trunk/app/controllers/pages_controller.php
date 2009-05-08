<?php

class PagesController extends AppController {
	
	var $name = 'Pages';
	var $helpers = array('Html', 'Form');

	function beforeFilter() {
		parent::beforeFilter(); 
		$this->Auth->allowedActions = array('display');
	}

	function display( $page_id=NULL ) {
		$this->set( 'data', $this->Page->find('first',array('conditions'=>'Page.id="'.$page_id.'"')) );
	}

}

?>