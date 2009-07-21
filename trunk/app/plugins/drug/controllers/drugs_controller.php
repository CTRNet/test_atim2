<?php

class DrugsController extends DrugAppController {

	var $uses = array('Drug.Drug');
	var $paginate = array('Drug'=>array('limit'=>10,'order'=>'Drug.generic_name ASC')); 

	function index() {
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
	}
	
	function search() {
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->data = $this->paginate($this->Drug, $_SESSION['ctrapp_core']['search']['criteria']);
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Drug']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/drug/drugs/search';
	}
	
	function listall( ) {
		$this->data = $this->paginate($this->Drug, array());
	}

	function add() {	
		if ( !empty($this->data) ) {
			if ( $this->Drug->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/drug/drugs/detail/'.$this->Drug->id );
			}
		}
  	}
  
	function edit( $drug_id=null ) {
		if ( !$drug_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Drug.id'=>$drug_id) );
		
		if ( !empty($this->data) ) {
			$this->Drug->id = $drug_id;
			if ( $this->Drug->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/drug/drugs/detail/'.$drug_id );
			}
		} else {
			$this->data = $this->Drug->find('first',array('conditions'=>array('Drug.id'=>$drug_id)));
		}
  	}
	
	function detail( $drug_id=null ) {
		
		
		if ( !$drug_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Drug.id'=>$drug_id) );
		$this->data = $this->Drug->find('first',array('conditions'=>array('Drug.id'=>$drug_id)));
	}
  
	function delete( $drug_id=null ) {
    
		if ( !$drug_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		if( $this->Drug->del( $drug_id ) ) {
			$this->flash( 'Your data has been deleted.', '/drug/drugs/listall/');
		} else {
			$this->flash( 'Your data has been deleted.', '/drug/drugs/listall/');
		}
  	}

}

?>