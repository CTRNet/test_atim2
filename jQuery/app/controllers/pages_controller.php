<?php

class PagesController extends AppController {
	
	var $name = 'Pages';
	var $helpers = array('Html', 'Form');

	function beforeFilter() {
		parent::beforeFilter(); 
		$this->Auth->allowedActions = array('display');
	}

	function display( $page_id=NULL ) {
		$results = $this->Page->find('first',array('conditions'=>'Page.id="'.$page_id.'"'));
		$this->set('data',$results);
		
		if ( isset($results) && isset($results['Page']) && isset($results['Page']['use_link']) && $results['Page']['use_link'] ) {
			$use_link = $results['Page']['use_link'];
		} else {
			$use_link = '/menus';
		}
		
		$this->set( 'atim_menu', $this->Menus->get($use_link) );
	}

}

?>