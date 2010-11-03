<?php

class OrdersController extends OrderAppController {

	var $components = array();
		
	var $uses = array(
		'Order.Order', 
		'Order.OrderLine', 
		'Order.Shipment');
	
	var $paginate = array(
		'Order'=>array('limit' => pagination_amount,'order'=>'Order.date_order_placed DESC'), 
		'OrderLine'=>array('limit'=>pagination_amount,'order'=>'OrderLine.date_required DESC'));
	
	function index() {
		$_SESSION['ctrapp_core']['search'] = null;
		
		// Clear Order session data
		unset($_SESSION['Order']['AliquotIdsToAddToOrder']);
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
  
	function search() {
		$this->set('atim_menu', $this->Menus->get('/order/orders/index'));
			
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
			
		$this->data = $this->paginate($this->Order, $_SESSION['ctrapp_core']['search']['criteria']);
		
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Order']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/order/orders/search';

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function add() {
		// MANAGE DATA

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/order/orders/index'));
			
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}

		// SAVE PROCESS
					
		if ( !empty($this->data) ) {
			$submitted_data_validates = true;

			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}

			if ($submitted_data_validates && $this->Order->save($this->data) ) {
				$this->atimFlash( 'your data has been saved','/order/orders/detail/'.$this->Order->id );
			}
		} 
	}
  
	function detail( $order_id ) {
  		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
	
		// MANAGE DATA
		
		$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		if(empty($order_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }
				
		// Setorder data
		$this->set('order_data', $order_data);
		$this->data = array();
		
		// Set order lines data
		$this->setDataForOrderLinesList($order_id);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id) );
		
		// Set structure for order lines list
		$this->Structures->set('orderlines', 'orderlines_listall_structure');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}

	function edit( $order_id ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }

		// MANAGE DATA
		
		$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		if(empty($order_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id) );
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
				
		// SAVE PROCESS
					
		if ( empty($this->data) ) {
			$this->data = $order_data;
			
		} else {			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			if($submitted_data_validates) {
				$this->Order->id = $order_id;
				if ($this->Order->save($this->data) ) {
					$this->atimFlash( 'your data has been updated','/order/orders/detail/'.$order_id );
				}							
			}
		}
	}
  
	function delete($order_id) {
    	if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
    	
		// MANAGE DATA
		
 		$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		if(empty($order_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->allowOrderDeletion($order_id);
			
		// CUSTOM CODE
				
		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }		
		
		if($arr_allow_deletion['allow_deletion']) {
			if($this->Order->atim_delete($order_id)) {
				$this->atimFlash('your data has been deleted', '/order/orders/index/');
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