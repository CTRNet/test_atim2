<?php

class CollectionsController extends InventorymanagementAppController {

	var $uses = array('Collection');
	var $paginate = array('Collection'=>array('limit'=>10,'order'=>'Collection.collection_datetime ASC, Collection.acquisition_label ASC')); 
	
	function index() {
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
	}
	
	function search() {
		$this->set( 'atim_menu', $this->Menus->get('/inventorymanagement/collections/index') );
			
		// if SEARCH form data, parse and create conditions
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->data = $this->paginate($this->Collection, $_SESSION['ctrapp_core']['search']['criteria']);
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Collection']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/inventorymanagement/collections/search';
	}

	function detail( $collection_id ) {
		$this->set( 'atim_menu_variables', array('Collection.id'=>$collection_id) );
		$this->data = $this->Collection->find('first',array('conditions'=>array('Collection.id'=>$collection_id)));
	}
	
	function add() {
		$this->set( 'atim_menu', $this->Menus->get('/inventorymanagement/collections/index') );
		
		if ( !empty($this->data) ) {
			if ( $this->Collection->save($this->data) ) $this->flash( 'Your data has been updated.','/inventorymanagement/collections/detail/'.$this->Collection->id );
		}
	}
	
	function edit( $collection_id ) {
		$this->set( 'atim_menu_variables', array('Collection.id'=>$collection_id) );
		
		if ( !empty($this->data) ) {
			$this->Collection->id = $collection_id;
			if ( $this->Collection->save($this->data) ) $this->flash( 'Your data has been updated.','/inventorymanagement/collections/detail/'.$collection_id );
		} else {
			$this->data = $this->Collection->find('first',array('conditions'=>array('Collection.id'=>$collection_id)));
		}
	}

}

?>