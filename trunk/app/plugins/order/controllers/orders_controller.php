<?php

class OrdersController extends OrderAppController {
	
	var $uses = array('Order.Order', 'Study.StudySummary');
	var $paginate = array('Order'=>array('limit'=>10,'order'=>'Order.order_number'));
	
	function listall( ) {
	
		// Populate Study dropdown from study_summaries table
		$study_summary_list = $this->StudySummary->find('all', array('fields' => array('StudySummary.id', 'StudySummary.title'), 'order' => array('StudySummary.title')));
		foreach ( $study_summary_list as $record ) {
			$study_summary_id_findall[ $record['StudySummary']['id'] ] = $record['StudySummary']['title'];
		}
		$this->set('study_summary_id_findall', $study_summary_id_findall);
	
	
		$this->data = $this->paginate($this->Order, array());
	}

	function add() {
		
		// Populate Study dropdown from study_summaries table
		$study_summary_list = $this->StudySummary->find('all', array('fields' => array('StudySummary.id', 'StudySummary.title'), 'order' => array('StudySummary.title')));
		foreach ( $study_summary_list as $record ) {
			$study_summary_id_findall[ $record['StudySummary']['id'] ] = $record['StudySummary']['title'];
		}
		$this->set('study_summary_id_findall', $study_summary_id_findall);
	
		if ( !empty($this->data) ) {
			if ( $this->Order->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/order/orders/detail/'.$this->Order->id );
			}
		} 
	}
  
	function edit( $order_id=null ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		// Populate Study dropdown from study_summaries table
		$study_summary_list = $this->StudySummary->find('all', array('fields' => array('StudySummary.id', 'StudySummary.title'), 'order' => array('StudySummary.title')));
		foreach ( $study_summary_list as $record ) {
			$study_summary_id_findall[ $record['StudySummary']['id'] ] = $record['StudySummary']['title'];
		}
		$this->set('study_summary_id_findall', $study_summary_id_findall);
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id) );
		
		if ( !empty($this->data) ) {
			$this->Order->id = $order_id;
			if ( $this->Order->save($this->data) ) {
				$this->flash( 'Your data has been updated.','/order/orders/detail/'.$order_id );
			}
		} else {
			$this->data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		}
	}
  
	function detail( $order_id=null ) {
  		if ( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		// Populate Study dropdown from study_summaries table
		$study_summary_list = $this->StudySummary->find('all', array('fields' => array('StudySummary.id', 'StudySummary.title'), 'order' => array('StudySummary.title')));
		foreach ( $study_summary_list as $record ) {
			$study_summary_id_findall[ $record['StudySummary']['id'] ] = $record['StudySummary']['title'];
		}
		$this->set('study_summary_id_findall', $study_summary_id_findall);
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id) );
		$this->data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
	}
  
	function delete( $order_id=null ) {
    
    	if ( !$order_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		if( $this->Order->del( $order_id ) ) {
			$this->flash( 'Your data has been deleted.', '/order/orders/listall/');
		} else {
			$this->flash( 'Your data has been deleted.', '/order/orders/listall/');
		}
  }
 
	function index() {
		$_SESSION['ctrapp_core']['search'] = NULL;
		
		// Populate Study dropdown from study_summaries table
		$study_summary_list = $this->StudySummary->find('all', array('fields' => array('StudySummary.id', 'StudySummary.title'), 'order' => array('StudySummary.title')));
		foreach ( $study_summary_list as $record ) {
			$study_summary_id_findall[ $record['StudySummary']['id'] ] = $record['StudySummary']['title'];
		}
		$this->set('study_summary_id_findall', $study_summary_id_findall);
		
	}
  
	function search( ) {
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		
		$_SESSION['ctrapp_core']['search'] = NULL;
		
		// Populate Study dropdown from study_summaries table
		$study_summary_list = $this->StudySummary->find('all', array('fields' => array('StudySummary.id', 'StudySummary.title'), 'order' => array('StudySummary.title')));
		foreach ( $study_summary_list as $record ) {
			$study_summary_id_findall[ $record['StudySummary']['id'] ] = $record['StudySummary']['title'];
		}
		$this->set('study_summary_id_findall', $study_summary_id_findall);
		
		$this->data = $this->paginate($this->Order, $_SESSION['ctrapp_core']['search']['criteria']);
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Order']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/order/orders/search';
		
	}
}
?>