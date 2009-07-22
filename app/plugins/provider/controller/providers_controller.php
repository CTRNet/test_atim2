<?php

class ProvidersController extend ProviderAppController
{
	var $uses = array( 'Provider.Provider' );
	var $paginate = array('Provider' => array('limit' => 10, 'order'=>'Provider.name DESC'));
	
	function index(){
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
	}
	
	function search(){
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->data = $this->paginate($this->Provider, $_SESSION['ctrapp_core']['search']['criteria']);
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Protocol']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/provider/providers/search/';	
	}
	
	function listall(){
		$this->set('atim_menu', $this->Menus->get('/provider/providers/index/'));
	
		$this->data = $this->paginate($this->Provider, array());
	}
	
	function add() {
		$this->set('atim_menu', $this->Menus->get('/provider/providers/index/'));
	
		if ( !empty($this->data) ) {
			if ( $this->Provider->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/provider/providers/detail/'.$this->Provider->getLastInsertId());
			} else {
				$this->data = $this_data;
			}
		} 
	}
	
	function detail( $provider_id=null ){
		if ( !$provider_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Provider.id'=>$provider_id) );
		$this->data = $this->Provider->find('first',array('conditions'=>array('Provider.id'=>$provider_id)));
	}
	
	function edit( $provider_id=null ){
		if ( !$provider_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Provider.id'=>$provider_id) );
		
		if ( !empty($this->data) ) {
			$this->Provider->id = $provider_id;
			if ( $this->Provider->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/provider/providers/detail/'.$provider_id );
			}
		} else {
			$this->data = $this->Provider->find('first',array('conditions'=>array('Provider.id'=>$Provider_id)));
		}
	}
	
	function delete( $provider_id=null ){
		if ( !$provider_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		if( $this->Provider->del( $provider_id ) ) {
			$this->flash( 'Your data has been deleted.', '/provider/providers/listall/');
		} else {
			$this->flash( 'Your data has been deleted.', '/provider/providers/listall/');
		}
	}
}

?>