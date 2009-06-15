<?php

class SopExtendsController extends SopAppController {

	var $uses = array('SopMaster', 'SopExtend', 'Material');
	var $paginate = array('SopMaster'=>array('limit'=>10,'order'=>'SopMaster.title ASC'));
	
	function listall() {
		$this->data = $this->paginate($this->SopMaster);
	}
	
	function detail() {
		$this->data = $this->SopMaster->find('first',array('conditions'=>array('SopMaster.id'=>$sop_master_id)));
	}
	
	function add( ) {
		$this->set( 'atim_menu', $this->Menus->get('/sop_master/listall/') );
		
		if ( !empty($this->data) ) {
			if ( $this->SopMaster->save($this->data) ) $this->flash( 'Your data has been updated.','/sop_master/detail/'.$this->SopMaster->id );
		}
	}
	
	function edit( $sop_master_id) {
		$this->set( 'atim_menu_variables', array( 'SopMaster.id'=>$sop_master_id) );
		
		if ( !empty($this->data) ) {
			$this->SopMaster->id = $sop_master_id;
			if ( $this->SopMaster->save($this->data) ) $this->flash( 'Your data has been updated.','/sop_master/detail/'.$sop_master_id );
		} else {
			$this->data = $this->SopMaster->find('first',array('conditions'=>array('SopMaster.id'=>$sop_master_id)));
		}
	}

}

?>
