<?php

class OrdersController extends OrderAppController {

	var $components = array('Study.StudySummaries');
		
	var $uses = array(
		'Order.Order', 
		'Order.OrderLine', 
		'Order.Shipment', 
		
		'Study.StudySummary');
	
	var $paginate = array('Order'=>array('limit'=>10,'order'=>'Order.order_number'));

	function index() {
		$_SESSION['ctrapp_core']['search'] = null;
		
		// Set list of studies
		$this->set('arr_studies', $this->getStudiesList());
	}
  
	function search() {
		$this->set('atim_menu', $this->Menus->get('/order/orders/index'));
			
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
			
		$this->data = $this->paginate($this->Order, $_SESSION['ctrapp_core']['search']['criteria']);
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Order']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/order/orders/search';
		
		// Set list of studies
		$this->set('arr_studies', $this->getStudiesList());
	}
	
	function add() {
		$this->set('atim_menu', $this->Menus->get('/order/orders/index'));
			
		// Set list of studies
		$this->set('arr_studies', $this->getStudiesList());

		if ( !empty($this->data) ) {
			if ( $this->Order->save($this->data) ) {
				$this->flash( 'your data has been saved','/order/orders/detail/'.$this->Order->id );
			}
		} 
	}
  
	function detail( $order_id ) {
  		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		
		$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		if(empty($order_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }
				
		$this->data = $order_data;
				
		// Set list of studies
		$this->set('arr_studies', $this->getStudiesList());
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id) );
	}

	function edit( $order_id ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }

		$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		if(empty($order_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }
		
		// Set list of studies
		$this->set('arr_studies', $this->getStudiesList());
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id) );
		
		if ( !empty($this->data) ) {
			$this->Order->id = $order_id;
			if ( $this->Order->save($this->data) ) {
				$this->flash( 'your data has been updated','/order/orders/detail/'.$order_id );
			}
		} else {
			$this->data = $order_data;
		}
	}
  
	function delete($order_id) {
    	if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
    	
 		$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		if(empty($order_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->allowOrderDeletion($order_id);
			
		if($arr_allow_deletion['allow_deletion']) {
			if($this->Order->atim_delete($order_id)) {
				$this->flash('your data has been deleted', '/order/orders/index/');
			} else {
				$this->flash('error deleting data - contact administrator', '/order/orders/index/');
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/order/orders/detail/' . $order_id);
		}
  }
  	
	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */
	
	/**
	 * Get list of Studies existing into the system.
	 * 
	 * Note: Function to allow bank to customize this function when they don't use 
	 * Study module.
	 *
	 * @return Array gathering all studies
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function getStudiesList() {
		return $this->StudySummaries->getStudiesList();
	}
	
	/**
	 * Check if an order can be deleted.
	 * 
	 * @param $order_id Id of the studied order.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowOrderDeletion($order_id){
		// Check no order line exists
		$returned_nbr = $this->OrderLine->find('count', array('conditions' => array('OrderLine.order_id' => $order_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'order line exists for the deleted order'); }
	
		// Check no order line exists
		$returned_nbr = $this->Shipment->find('count', array('conditions' => array('Shipment.order_id' => $order_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'shipment exists for the deleted order'); }
		
		return array('allow_deletion' => true, 'msg' => '');
	}
  
}
?>