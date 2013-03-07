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
		$arr_allow_deletion = $this->Bank->allowDeletion($bank_id);
		
		// CUSTOM CODE
		$hook_link = $this->hook();
		if ($hook_link) {
			require($hook_link);
		}
		
		if ($arr_allow_deletion['allow_deletion']) {
			if ($this->Bank->atimDelete( $bank_id )) {
				$this->atimFlash( 'your data has been deleted', '/Administrate/Banks/index');
			} else {
				$this->flash( 'error deleting data - contact administrator', '/Administrate/Banks/index');
			}
		} else {
			$this->flash(__('this bank is being used and cannot be deleted').': '.__($arr_allow_deletion['msg']),  '/Administrate/Banks/detail/'.$bank_id."/");
		}
	}
}

?>