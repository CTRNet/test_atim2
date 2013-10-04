<?php

class StructuresController extends AdministrateAppController {
	
	var $uses = array('Structure');
	var $paginate = array('Structure'=>array('limit' => pagination_amount,'order'=>'Structure.alias ASC')); 
	
	function index() {
		$this->hook();
	
		$this->request->data = $this->paginate($this->Structure);
	}
	
	function detail( $structure_id ) {
		$this->set( 'atim_menu_variables', array('Structure.id'=>$structure_id) );
		
		$this->hook();
		
		$this->request->data = $this->Structure->find('first',array('conditions'=>array('Structure.id'=>$structure_id)));
	}
	
	function edit( $structure_id ) {
		$this->set( 'atim_menu_variables', array('v.id'=>$structure_id) );
		
		$this->hook();
		
		if ( !empty($this->request->data) ) {
			if ( $this->Structure->save($this->request->data) ) $this->atimFlash( 'your data has been updated','/Administrate/Structure/detail/'.$structure_id );
		} else {
			$this->request->data = $this->Structure->find('first',array('conditions'=>array('Structure.id'=>$structure_id)));
		}
	}
}

?>