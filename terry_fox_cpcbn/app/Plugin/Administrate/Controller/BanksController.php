<?php

class BanksController extends AdministrateAppController {
	
	var $uses = array('Administrate.Bank');
	var $paginate = array('Bank'=>array('limit' => pagination_amount,'order'=>'Bank.name ASC')); 
	
	function add(){
		$this->set( 'atim_menu', $this->Menus->get('/Administrate/Banks/index') );
		
		$this->hook();
		
		if ( !empty($this->request->data) ) {
			if ( $this->Bank->save($this->request->data) ){
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				$this->atimFlash( 'your data has been updated','/Administrate/Banks/detail/'.$this->Bank->id );
			}
		}
	}
	
	function index() {
		$this->hook();
		$this->request->data = $this->paginate($this->Bank);
	}
	
	function detail( $bank_id ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id) );
		$this->hook();
		$this->request->data = $this->Bank->find('first',array('conditions'=>array('Bank.id'=>$bank_id)));
	}
	
	function edit( $bank_id ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id) );
		
		$this->hook();
		
		if ( !empty($this->request->data) ) {
			$this->Bank->id = $bank_id;
			if ( $this->Bank->save($this->request->data) ){
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				$this->atimFlash( 'your data has been updated','/Administrate/Banks/detail/'.$bank_id );
			}
		} else {
			$this->request->data = $this->Bank->find('first',array('conditions'=>array('Bank.id'=>$bank_id)));
		}
	}
	
	function delete( $bank_id ) {
		$this->hook();
		if($this->Bank->isBeingUsed($bank_id)){
			$this->flash( 'this bank is being used and cannot be deleted', '/Administrate/Banks/detail/'.$bank_id."/" );
		}else{
			$this->Bank->del( $bank_id );
			$this->atimFlash( 'your data has been deleted', '/Administrate/Banks/index' );
		}
	}
}

?>