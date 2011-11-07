<?php

class MenusController extends AdministrateAppController {
	
	var $uses = array('Menu');
	
	// temp beforefilter to allow permissions, ACL tables not updated yet
	function beforeFilter() {
		parent::beforeFilter(); 
		$this->Auth->allowedActions = array('index');
	}

	function index() {
		$this->hook();
		$this->data = $this->Menu->find('threaded', array('conditions'=>array('parent_id!="3" AND parent_id!="11" AND parent_id!="18" AND parent_id!="55" AND parent_id!="70"')));
	}
	
	function detail( $menu_id ) {
		$this->set( 'atim_menu_variables', array('Menu.id'=>$menu_id) );
		$this->hook();
		$this->data = $this->Menu->find('first',array('conditions'=>array('Menu.id'=>$menu_id)));
	}
	
	function edit( $bank_id ) {
		$this->set( 'atim_menu_variables', array('Menu.id'=>$menu_id) );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->Menu->id = $bank_id;
			if ( $this->Menu->save($this->data) ){
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				$this->atimFlash( 'your data has been updated','/administrate/menus/detail/'.$menu_id );
			}
		} else {
			$this->data = $this->Menu->find('first',array('conditions'=>array('Menu.id'=>$menu_id)));
		}
	}
}

?>