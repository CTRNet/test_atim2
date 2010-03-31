<?php

class MaterialsController extends MaterialAppController {
	var $uses = array('Material.Material');
	var $paginate = array('Material'=>array('limit'=>10,'order'=>'Material.item_name'));
	
	function index(){
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
	}
	
	function search(){
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->hook();
		
		$this->data = $this->paginate($this->Material, $_SESSION['ctrapp_core']['search']['criteria']);
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Material']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/material/materials/search';
	}
	
	function listall( ) {
		$this->hook();
	
		$this->data = $this->paginate($this->Material, array());
	}

	function add() {
		$this->hook();
	
		if ( !empty($this->data) ) {
			if ( $this->Material->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/material/materials/detail/'.$this->Material->id );
			}
		}
  	}
  
	function edit( $material_id=null ) {
		if ( !$material_id ) { $this->redirect( '/pages/err_mat_funct_param_missing', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Material.id'=>$material_id) );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->Material->id = $material_id;
			if ( $this->Material->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/material/materials/detail/'.$material_id );
			}
		} else {
			$this->data = $this->Material->find('first',array('conditions'=>array('Material.id'=>$material_id)));
		}
  	}
	
	function detail( $material_id=null ) {
		if ( !$material_id ) { $this->redirect( '/pages/err_mat_funct_param_missing', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Material.id'=>$material_id) );
		
		$this->hook();
		
		$this->data = $this->Material->find('first',array('conditions'=>array('Material.id'=>$material_id)));
	}
  
	function delete( $material_id=null ) {
		if ( !$material_id ) { $this->redirect( '/pages/err_mat_funct_param_missing', NULL, TRUE ); }
		
		$this->hook();
		
		if( $this->Material->atim_delete( $material_id ) ) {
			$this->flash( 'Your data has been deleted.', '/material/materials/listall/');
		} else {
			$this->flash( 'Error deleting data - Contact administrator.', '/material/materials/listall/');
		}
  	}

}

?>