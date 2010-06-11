<?php

class BanksController extends AdministrateAppController {
	
	var $uses = array('Administrate.Bank');
	var $paginate = array('Bank'=>array('limit' => pagination_amount,'order'=>'Bank.name ASC')); 
	
	function add(){
		$this->set( 'atim_menu', $this->Menus->get('/administrate/banks') );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			
			if ( $this->Bank->save($this->data) ) $this->flash( 'your data has been updated','/administrate/banks/detail/'.$this->Bank->id );
		}
	}
	
	function index() {
		$this->hook();
		$this->data = $this->paginate($this->Bank);
	}
	
	function detail( $bank_id ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id) );
		$this->hook();
		$this->data = $this->Bank->find('first',array('conditions'=>array('Bank.id'=>$bank_id)));
	}
	
	function edit( $bank_id ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id) );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->Bank->id = $bank_id;
			if ( $this->Bank->save($this->data) ) $this->flash( 'your data has been updated','/administrate/banks/detail/'.$bank_id );
		} else {
			$this->data = $this->Bank->find('first',array('conditions'=>array('Bank.id'=>$bank_id)));
		}
	}
	
	function delete( $bank_id ) {
		$this->hook();
		if($this->Bank->isBeingUsed($bank_id)){
			$this->flash( 'this bank is being used and cannot be deleted', '/administrate/banks/detail/'.$bank_id."/" );
		}else{
			$this->Bank->del( $bank_id );
			$this->flash( 'your data has been deleted', '/administrate/banks/index' );
		}
	}
}

?>