<?php

class ProvidersController extends ProviderAppController
{
	var $uses = array( 'Provider.Provider' );
	var $paginate = array('Provider' => array('limit' => 10, 'order'=>'Provider.name DESC'));
	
	function index(){
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
	}
	
	function search(){
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->set('atim_menu', $this->Menus->get('/provider/providers/index/'));
		
		$this->hook();
		
		$this->data = $this->paginate($this->Provider, $_SESSION['ctrapp_core']['search']['criteria']);
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Provider']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/provider/providers/search/';	
	}
	
	function listall(){
		$this->set('atim_menu', $this->Menus->get('/provider/providers/index/'));
	
		$this->hook();
	
		$this->data = $this->paginate($this->Provider, array());
	}
	
	function add() {
		$this->set('atim_menu', $this->Menus->get('/provider/providers/index/'));
	
		$this->hook();
	
		if ( !empty($this->data) ) {
			if ( $this->Provider->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/provider/providers/detail/'.$this->Provider->getLastInsertId());
			} else {
				$this->data = $this_data;
			}
		} 
	}
	
	function detail( $provider_id=null ){
		if ( !$provider_id ) { $this->redirect( '/pages/err_prov_funct_param_missing', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Provider.id'=>$provider_id) );

		$this->hook();

		$this->data = $this->Provider->find('first',array('conditions'=>array('Provider.id'=>$provider_id)));
	}
	
	function edit( $provider_id=null ){
		if ( !$provider_id ) { $this->redirect( '/pages/err_prov_funct_param_missing', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Provider.id'=>$provider_id) );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->Provider->id = $provider_id;
			if ( $this->Provider->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/provider/providers/detail/'.$provider_id );
			}
		} else {
			$this->data = $this->Provider->find('first',array('conditions'=>array('Provider.id'=>$provider_id)));
		}
	}
	
	function delete( $provider_id=null ){
		if ( !$provider_id ) { $this->redirect( '/pages/err_prov_funct_param_missing', NULL, TRUE ); }
		
		$this->hook();
		
		if( $this->Provider->atim_delete( $provider_id ) ) {
			$this->flash( 'Your data has been deleted.', '/provider/providers/listall/');
		} else {
			$this->flash( 'Error deleting data - Contact administrator.', '/provider/providers/listall/');
		}
	}
}

?>