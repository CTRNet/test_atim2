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
		
	var $paginate = array('OrderLine'=>array('limit'=>'10','order'=>'OrderLine.date_required'));
	
	function listall( $order_id ) {
		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }

		$order_data = $this->Order->find('first',array('conditions'=>array('Order.id'=>$order_id)));
		if(empty($order_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }
		
		$data = $this->paginate($this->OrderLine, array('OrderLine.order_id'=>$order_id)); 
		
		// Add completion information
		foreach($data as $key => $new_order_line) {
			$shipped_counter = 0;
			foreach($new_order_line['OrderItem'] as $new_item) { if($new_item['status'] == 'shipped') { $shipped_counter++; } }
			$completion = empty($new_order_line['OrderItem'])? 'n/a': $shipped_counter.'/'.sizeof($new_order_line['OrderItem']);
			$data[$key]['Generated']['order_line_completion'] = $completion;
		}
		
		$this->data = $data;
		
		// Populate both sample and aliquot control
		$sample_controls_list = $this->SampleControl->find('all', array('recursive' => '-1'));
		$sample_controls_list = empty($sample_controls_list)? array(): $sample_controls_list;
		$aliquot_controls_list = $this->AliquotControl->find('all', array('recursive' => '-1'));
		$aliquot_controls_list = empty($aliquot_controls_list)? array(): $aliquot_controls_list;
		
		$this->set('sample_controls_list', $sample_controls_list);
		$this->set('aliquot_controls_list', $aliquot_controls_list);

		$this->set('atim_menu', $this->Menus->get('/order/order_lines/listall/%%Order.id%%/'));
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));
	}

 	function add( $order_id ) {
 		if ( !$order_id ) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }
		
		// Generate data for product type dropdown
		$sample_aliquot_controls_list = $this->generateSampleAliquotControlList();
		$this->set('sample_aliquot_controls_list', $sample_aliquot_controls_list);		
	
		$this->set('atim_menu', $this->Menus->get('/order/order_lines/listall/%%Order.id%%/'));
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));
		
		if ( !empty($this->data) ) {
			// Set sample and aliquot control id
			$product_controls = explode("|", $this->data['FunctionManagement']['sample_aliquot_control_id']);			
			if(sizeof($product_controls) != 2)  { $this->redirect('/pages/err_order_system_error', null, true); }
			$this->data['OrderLine']['sample_control_id'] = $product_controls[0];
			$this->data['OrderLine']['aliquot_control_id'] = $product_controls[1];
			
			// Set order id
			$this->data['OrderLine']['order_id'] = $order_id;
			
			if ( $this->OrderLine->save($this->data) ) {
				$this->flash( 'your data has been updated','/order/order_lines/detail/'.$order_id.'/'.$this->OrderLine->id );
			}
		}
 	}
  
	function edit( $order_id, $order_line_id ) {
  		if (( !$order_id ) || ( !$order_line_id )) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }

		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id)));
		if(empty($order_line_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }
		
		// Set value for 'FunctionManagement.sample_aliquot_control_id' field
		$order_line_data['FunctionManagement']['sample_aliquot_control_id'] = $order_line_data['OrderLine']['sample_control_id'] . '|' . (empty($order_line_data['OrderLine']['aliquot_control_id'])? '': $order_line_data['OrderLine']['aliquot_control_id']);
		
		// Generate data for product type dropdown
		$sample_aliquot_controls_list = $this->generateSampleAliquotControlList();
		$this->set('sample_aliquot_controls_list', $sample_aliquot_controls_list);
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id) );
		
		if ( !empty($this->data) ) {
			// Set sample and aliquot control id
			$product_controls = explode("|", $this->data['FunctionManagement']['sample_aliquot_control_id']);			
			if(sizeof($product_controls) != 2)  { $this->redirect('/pages/err_order_system_error', null, true); }
			$this->data['OrderLine']['sample_control_id'] = $product_controls[0];
			$this->data['OrderLine']['aliquot_control_id'] = $product_controls[1];
			
			$this->OrderLine->id = $order_line_id;
			if ( $this->OrderLine->save($this->data) ) {
				$this->flash( 'your data has been updated','/order/order_lines/detail/'.$order_id.'/'.$order_line_id );
			}
		} else {
			$this->data = $order_line_data;
		}
	}
  
 	function detail( $order_id, $order_line_id ) {
  		if (( !$order_id ) || ( !$order_line_id )) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }

		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id)));
		if(empty($order_line_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }
		
		// Add completion information
		$shipped_counter = 0;
		foreach($order_line_data['OrderItem'] as $new_item) { if($new_item['status'] == 'shipped') { $shipped_counter++; } }
		$completion = empty($order_line_data['OrderItem'])? 'n/a': $shipped_counter.'/'.sizeof($order_line_data['OrderItem']);
		$order_line_data['Generated']['order_line_completion'] = $completion;
	
		$this->data = $order_line_data;
			
		// Populate both sample and aliquot control
		$sample_controls_list = $this->SampleControl->find('all', array('condition' => array('id' => $order_line_data['OrderLine']['sample_control_id']), 'recursive' => '-1'));
		$sample_controls_list = empty($sample_controls_list)? array(): $sample_controls_list;
		$aliquot_controls_list = $this->AliquotControl->find('all', array('condition' => array('id' => $order_line_data['OrderLine']['aliquot_control_id']), 'recursive' => '-1'));
		$aliquot_controls_list = empty($aliquot_controls_list)? array(): $aliquot_controls_list;

		$this->set('sample_controls_list', $sample_controls_list);
		$this->set('aliquot_controls_list', $aliquot_controls_list);
				
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id) );
	}
	
	function delete( $order_id, $order_line_id ) {
  		if (( !$order_id ) || ( !$order_line_id )) { $this->redirect( '/pages/err_order_funct_param_missing', null, true ); }

		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id)));
		if(empty($order_line_data)) { $this->redirect( '/pages/err_order_no_data', null, true ); }
		
		
		// Check deletion is allowed
		$arr_allow_deletion = $this->allowOrderLineDeletion($order_line_id);
			
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
	
	function addAliquotToOrder(){
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
	}
}

?>