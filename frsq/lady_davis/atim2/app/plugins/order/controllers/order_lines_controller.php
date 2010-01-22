<?php

class OrderLinesController extends OrderAppController {

	var $uses = array(
		'Order.Order', 
		'Order.OrderLine', 
		'Order.OrderItem', 

		'Inventorymanagement.SampleToAliquotControl',
		'Inventorymanagement.SampleControl',
		'Inventorymanagement.AliquotControl'
	);
	
	var $paginate = array('OrderLine'=>array('limit'=>'10','order'=>'OrderLine.date_required DESC'));

	function listall( $order_id ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }

		// MANAGE DATA
	
		$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		if(empty($order_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }

		// Set data
		$this->setDataForOrderLinesList($order_id);
		$this->data = array();

		// Populate both sample and aliquot control
		$sample_controls_list = $this->SampleControl->find('all', array('recursive' => '-1'));
		$sample_controls_list = empty($sample_controls_list)? array(): $sample_controls_list;
		$aliquot_controls_list = $this->AliquotControl->find('all', array('recursive' => '-1'));
		$aliquot_controls_list = empty($aliquot_controls_list)? array(): $aliquot_controls_list;

		$this->set('sample_controls_list', $sample_controls_list);
		$this->set('aliquot_controls_list', $aliquot_controls_list);

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/order/order_lines/listall/%%Order.id%%/'));

		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}

	function add( $order_id ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }

		// MANAGE DATA
		
		// Check order
		$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		if(empty($order_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }		
	
		// Generate data for product type dropdown
		$sample_aliquot_controls_list = $this->generateSampleAliquotControlList();
		$this->set('sample_aliquot_controls_list', $sample_aliquot_controls_list);

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
			if(sizeof($product_controls) != 2)  { $this->redirect('/pages/err_order_system_error', null, true); }
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
					$this->flash( 'your data has been saved','/order/order_lines/detail/'.$order_id.'/'.$this->OrderLine->id );
				}
			} 
		}
	}

	function edit( $order_id, $order_line_id ) {
		if (( !$order_id ) || ( !$order_line_id )) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }

		// MANAGE DATA
		
		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id)));
		if(empty($order_line_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }

		// Set value for 'FunctionManagement.sample_aliquot_control_id' field
		$order_line_data['FunctionManagement']['sample_aliquot_control_id'] = $order_line_data['OrderLine']['sample_control_id'] . '|' . (empty($order_line_data['OrderLine']['aliquot_control_id'])? '': $order_line_data['OrderLine']['aliquot_control_id']);

		// Generate data for product type dropdown
		$sample_aliquot_controls_list = $this->generateSampleAliquotControlList();
		$this->set('sample_aliquot_controls_list', $sample_aliquot_controls_list);

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
			if(sizeof($product_controls) != 2)  { $this->redirect('/pages/err_order_system_error', null, true); }
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
					$this->flash( 'your data has been updated','/order/order_lines/detail/'.$order_id.'/'.$order_line_id );
				}
			}
		}
	}

	function detail( $order_id, $order_line_id ) {
		if (( !$order_id ) || ( !$order_line_id )) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }

		// MANAGE DATA
		
		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id)));
		if(empty($order_line_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }

		// Add completion information
		$shipped_counter = 0;
		$items_counter = 0;
		foreach($order_line_data['OrderItem'] as $new_item) {
			++ $items_counter;
			if($new_item['status'] == 'shipped'){
				++ $shipped_counter;
			}
		 }
		 
		$completion = empty($order_line_data['OrderItem'])? 'n/a': $shipped_counter.'/'.$items_counter;
		$order_line_data['Generated']['order_line_completion'] = $completion;

		$this->data = $order_line_data;

		// Populate both sample and aliquot control
		$sample_controls_list = $this->SampleControl->find('all', array('condition' => array('id' => $order_line_data['OrderLine']['sample_control_id']), 'recursive' => '-1'));
		$sample_controls_list = empty($sample_controls_list)? array(): $sample_controls_list;
		$aliquot_controls_list = $this->AliquotControl->find('all', array('condition' => array('id' => $order_line_data['OrderLine']['aliquot_control_id']), 'recursive' => '-1'));
		$aliquot_controls_list = empty($aliquot_controls_list)? array(): $aliquot_controls_list;

		$this->set('sample_controls_list', $sample_controls_list);
		$this->set('aliquot_controls_list', $aliquot_controls_list);

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id) );

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}

	function delete( $order_id, $order_line_id ) {
		if (( !$order_id ) || ( !$order_line_id )) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }

		// MANAGE DATA
		
		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id)));
		if(empty($order_line_data)){
			$this->redirect( '/pages/err_order_no_data', null, true ); 
		}

		// Check deletion is allowed
		$arr_allow_deletion = $this->allowOrderLineDeletion($order_line_id);
		
		$hook_link = $this->hook('delete');
		if($hook_link){
			require($hook_link);
		}
			
		if($arr_allow_deletion['allow_deletion']) {
			if($this->OrderLine->atim_delete($order_line_id)) {
				$this->flash('your data has been deleted', '/order/order_lines/listall/'.$order_id);
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
	 * Get array gathering all unions existing between sample type and aliquot type.
	 *
	 * @return Array gathering existing union between sample type and aliquot type and having following structure:
	 * 	array'$sample_control_id|$aliquot_control_id' => array(
	 * 		'sample_control_id' => $sample_control_id,
	 * 		'sample_type' => $sample_type,
	 * 		'aliquot_control_id' => $aliquot_control_id,
	 * 		'aliquot_type' => $aliquot_type))
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */

	function generateSampleAliquotControlList() {
		$result = $this->SampleToAliquotControl->find('all',
		array('conditions' => array('SampleToAliquotControl.status' => 'active',
				'SampleControl.status' => 'active',
				'AliquotControl.status' => 'active'),
			'order' => array('SampleControl.sample_type' => 'asc', 'AliquotControl.aliquot_type' => 'asc')));	

		$final_array = array();
		$last_sample_type = '';
		foreach($result as $new_sample_aliquot) {
			$sample_control_id = $new_sample_aliquot['SampleControl']['id'];
			$aliquot_control_id = $new_sample_aliquot['AliquotControl']['id'];
				
			$sample_type = $new_sample_aliquot['SampleControl']['sample_type'];
			$aliquot_type = $new_sample_aliquot['AliquotControl']['aliquot_type'];
				
			// New Sample Type
			if($last_sample_type != $sample_type) {
				// Add just sample type to the list
				$final_array[$sample_control_id.'|'] = array(
				'sample_control_id' => $sample_control_id,
				'sample_type' => $new_sample_aliquot['SampleControl']['sample_type'],
				'aliquot_control_id' => null,
				'aliquot_type' => null);	
				$last_sample_type	= 	$sample_type;
			}
				
			// New Sample-Aliquot
			$final_array[$sample_control_id.'|'.$aliquot_control_id] = array(
			'sample_control_id' => $sample_control_id,
			'sample_type' => $new_sample_aliquot['SampleControl']['sample_type'],
			'aliquot_control_id' => $aliquot_control_id,
			'aliquot_type' => $new_sample_aliquot['AliquotControl']['aliquot_type']);
		}

		return $final_array;
	}

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

	function addAliquotToOrder($aliquot_id = null){
		//TODO Review addAliquotToOrder
		$this->data = $this->Order->find('all');

		$atim_structure = array();
		$atim_structure['Order'] = $this->Structures->get('form', 'orders');
		$atim_structure['OrderLine'] = $this->Structures->get('form', 'orderlines');
		foreach($this->data as &$var){
			$var['children'] = $var['OrderLine'];
			unset($var['OrderLine']);
			foreach($var['children'] as $key => &$var2){
				$var['children'][$key] = array('OrderLine' => $var2);
			}
			unset($var['Shipment']);
		}
		$this->set('atim_structure', $atim_structure);
		$this->set('aliquot_master_id', $aliquot_id);
		$this->set('atim_menu', $this->Menus->get("/order/orders/index/"));
		
		//TODO test hook works during review
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
}

?>