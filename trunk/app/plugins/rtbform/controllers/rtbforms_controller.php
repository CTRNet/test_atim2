<?php

class RtbformsController extends RtbformAppController {
	
	var $uses = array('Rtbform.Rtbform');
	var $paginate = array('Rtbform'=>array('limit'=>10,'order'=>'Rtbform.frmTitle'));
  
	function index() {
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
	}
  
	function search() {
		$this->set( 'atim_menu', $this->Menus->get('/rtbform/rtbforms/index') );
		
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->data = $this->paginate($this->Rtbform, $_SESSION['ctrapp_core']['search']['criteria']);
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Rtbform']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/rtbform/rtbforms/search';
	}
	
	function profile( $rtbform_id=null ) {
		if ( !$rtbform_id ) { $this->redirect( '/pages/err_rtb_no_rtbform_id', NULL, TRUE ); }
  
		$this->set( 'atim_menu_variables', array('Rtbform.id'=>$rtbform_id) );
		$this->data = $this->Rtbform->find('first',array('conditions'=>array('Rtbform.id'=>$rtbform_id)));
	}
  

	function add() {
		if ( !empty($this->data) ) {
			if ( $this->Rtbform->save($this->data) ) $this->flash( 'Your data has been updated.','/rtbform/rtbforms/profile/'.$this->Rtbform->id );
		}
	}
  

	function edit( $rtbform_id=null ) {
		if ( !$rtbform_id ) { $this->redirect( '/pages/err_rtb_no_rtbform_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Rtbform.id'=>$rtbform_id) );
		
		if ( !empty($this->data) ) {
			$this->Rtbform->id = $rtbform_id;
			if ( $this->Rtbform->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/rtbform/rtbforms/profile/'.$rtbform_id );
			}
		} else {
			$this->data = $this->Rtbform->find('first',array('conditions'=>array('Rtbform.id'=>$rtbform_id)));
		}
	}
  
	function delete( $rtbform_id=null ) {
		if ( !$rtbform_id ) { $this->redirect( '/pages/err_rtb_no_rtbform_id', NULL, TRUE ); }
		
		if( $this->Rtbform->del( $rtbform_id ) ) {
			$this->flash( 'Your data has been deleted.', '/rtbform/rtbforms/search/');
		} else {
			$this->flash( 'Your data has been deleted.', '/rtbform/rtbforms/search/');
		}
	}
  
}

?>