<?php

class MaterialsController extends AppController {
	var $uses = array('Materials');
	var $paginate = array('Materials'=>array('limit'=>10,'order'=>'Materials.item_name'));
	
	function listall( ) {
		$this->data = $this->paginate($this->Materials, array());
	}

	function add() {	
		if ( !empty($this->data) ) {
			if ( $this->Materials->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/material/materials/detail/'.$this->Materials->id );
			}
		}
  	}
  
	function edit( $material_id=null ) {
		if ( !$material_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Materials.id'=>$material_id) );
		
		if ( !empty($this->data) ) {
			$this->Materials->id = $material_id;
			if ( $this->Materials->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/material/materials/detail/'.$material_id );
			}
		} else {
			$this->data = $this->Materials->find('first',array('conditions'=>array('Materials.id'=>$material_id)));
		}
  	}
	
	function detail( $material_id=null ) {
		
		
		if ( !$material_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Materials.id'=>$material_id) );
		$this->data = $this->Materials->find('first',array('conditions'=>array('Materials.id'=>$material_id)));
	}
  
	function delete( $material_id=null ) {
    
		if ( !$material_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		if( $this->Materials->del( $material_id ) ) {
			$this->flash( 'Your data has been deleted.', '/material/materials/listall/');
		} else {
			$this->flash( 'Your data has been deleted.', '/material/materials/listall/');
		}
  	}

}

?>