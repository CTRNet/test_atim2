<?php

class PagesController extends AppController {
	
	var $name = 'Pages';
	var $helpers = array('Html', 'Form');

	function beforeFilter() {
		parent::beforeFilter(); 
		$this->Auth->allowedActions = array('display');
	}

	function display( $page_id = NULL) {
		$results = $this->Page->find('first',array('conditions'=>'Page.id="'.$page_id.'"'));
		
		if(isset($_GET['err_msg'])){
			//this message will be displayed in red
			$results['err_trace'] = urldecode($_GET['err_msg']);
		}
		$results['Page']['language_body'] = __($results['Page']['language_body'], true);
		if(isset($_GET['p'])){
			//these will be replaced in the body string
			$p = $_GET['p'];
			if(count($p) == 1){
				$results['Page']['language_body'] = sprintf($results['Page']['language_body'], $p[0]);
			}else if(count($p) == 2){
				$results['Page']['language_body'] = sprintf($results['Page']['language_body'], $p[0], $p[1]);
			}else if(count($p) == 3){
				$results['Page']['language_body'] = sprintf($results['Page']['language_body'], $p[0], $p[1], $p[2]);
			}else if(count($p) > 3){
				$results['Page']['language_body'] = sprintf($results['Page']['language_body'], $p[0], $p[1], $p[2], $p[3]);
			}
			//if it's more than 4 we'll get a warning 
		}
		
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