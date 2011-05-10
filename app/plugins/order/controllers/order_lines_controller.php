<?php

class OrderLinesController extends OrderAppController {

	var $uses = array(
		'Order.Order', 
		'Order.OrderLine', 
		'Order.OrderItem', 
	);
	
	var $paginate = array('OrderLine'=>array('limit'=>pagination_amount,'order'=>'OrderLine.date_required DESC'));

	function listall( $order_id ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }

		// MANAGE DATA
	
		$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		if(empty($order_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }

		// Set data
		$this->data = $this->paginate($this->OrderLine, array('OrderLine.order_id'=>$order_id, 'OrderLine.deleted' => 0));

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/order/order_lines/listall/%%Order.id%%/'));

		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}

	function add( $order_id ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }

		// MANAGE DATA
		
		// Check order
		$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		if(empty($order_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }		
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/order/order_lines/listall/%%Order.id%%/'));

		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));

		// SAVE PROCESS
					
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}

		if ( !empty($this->data) ) {
			// Set sample and aliquot control id
			$product_controls = explode("|", $this->data['FunctionManagement']['sample_aliquot_control_id']);
			if(sizeof($product_controls) != 2)  { $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
			$this->data['OrderLine']['sample_control_id'] = $product_controls[0];
			$this->data['OrderLine']['aliquot_control_id'] = $product_controls[1];
				
			// Set order id
			$this->data['OrderLine']['order_id'] = $order_id;
			$this->data['OrderLine']['status'] = 'pending';
				
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
				
			if ($submitted_data_validates) {
				if( $this->OrderLine->save($this->data) ) {
					$this->atimFlash( 'your data has been saved','/order/order_lines/detail/'.$order_id.'/'.$this->OrderLine->id );
				}
			} 
		}
	}

	function edit( $order_id, $order_line_id ) {
		if (( !$order_id ) || ( !$order_line_id )) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }

		// MANAGE DATA
		
		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id)));
		if(empty($order_line_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }

		// Set value for 'FunctionManagement.sample_aliquot_control_id' field
		$order_line_data['FunctionManagement']['sample_aliquot_control_id'] = $order_line_data['OrderLine']['sample_control_id'] . '|' . (empty($order_line_data['OrderLine']['aliquot_control_id'])? '': $order_line_data['OrderLine']['aliquot_control_id']);

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id) );

		// SAVE PROCESS
					
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}

		if ( empty($this->data) ) {
			$this->data = $order_line_data;

		} else {
			// Set sample and aliquot control id
			$product_controls = explode("|", $this->data['FunctionManagement']['sample_aliquot_control_id']);
			if(sizeof($product_controls) != 2)  { $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
			$this->data['OrderLine']['sample_control_id'] = $product_controls[0];
			$this->data['OrderLine']['aliquot_control_id'] = $product_controls[1];
				
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			if ($submitted_data_validates) {
				$this->OrderLine->id = $order_line_id;
				if($this->OrderLine->save($this->data)) {
					$this->atimFlash( 'your data has been updated','/order/order_lines/detail/'.$order_id.'/'.$order_line_id );
				}
			}
		}
	}

	function detail( $order_id, $order_line_id ) {
		if (( !$order_id ) || ( !$order_line_id )) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }

		// MANAGE DATA
		
		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id)));
		if(empty($order_line_data)) { $this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); }
		$this->data = $order_line_data;

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id) );

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}

	function delete( $order_id, $order_line_id ) {
		if (( !$order_id ) || ( !$order_line_id )) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }

		// MANAGE DATA
		
		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id)));
		if(empty($order_line_data)){
			$this->redirect( '/pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}

		// Check deletion is allowed
		$arr_allow_deletion = $this->allowOrderLineDeletion($order_line_id);
		
		$hook_link = $this->hook('delete');
		if($hook_link){
			require($hook_link);
		}
			
		if($arr_allow_deletion['allow_deletion']) {
			if($this->OrderLine->atim_delete($order_line_id)) {
				$this->atimFlash('your data has been deleted', '/order/order_lines/listall/'.$order_id);
			} else {
				$this->flash('error deleting data - contact administrator', '/order/order_lines/listall/'.$order_id);
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/order/order_lines/detail/' . $order_id . '/' . $order_line_id);
		}
	}

	/* --------------------------------------------------------------------------
	 * ADDITIONAL FUNCTIONS
	 * -------------------------------------------------------------------------- */

	/**
	 * Check if an order line can be deleted.
	 *
	 * @param $order_line_id Id of the studied order line.
	 *
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 *
	 * @author N. Luc
	 * @since 2007-10-16
	 */

	function allowOrderLineDeletion($order_line_id){
		// Check no order item exists
		$returned_nbr = $this->OrderItem->find('count', array('conditions' => array('OrderItem.order_line_id' => $order_line_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { return array('allow_deletion' => false, 'msg' => 'item exists for the deleted order line'); }

		return array('allow_deletion' => true, 'msg' => '');
	}	
	
}

?>