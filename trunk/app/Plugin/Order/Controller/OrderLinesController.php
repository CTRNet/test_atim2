<?php

class OrderLinesController extends OrderAppController {

	var $uses = array(
		'Order.Order', 
		'Order.OrderLine', 
		'Order.OrderItem', 
		'Order.Shipment' 
	);
	
	var $paginate = array('OrderLine'=>array('limit'=>pagination_amount,'order'=>'OrderLine.date_required DESC'));

	function listall( $order_id ) {
		// MANAGE DATA
		$order_data = $this->Order->getOrRedirect($order_id);

		// Set data
		$this->request->data = $this->paginate($this->OrderLine, array('OrderLine.order_id'=>$order_id, 'OrderLine.deleted' => 0));

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/Order/OrderLines/detail/%%Order.id%%/'));

		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}

	function add( $order_id ) {
		if ( !$order_id ) { 
			$this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}

		// MANAGE DATA
		
		// Check order
		$order_data = $this->Order->getOrRedirect($order_id);
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/Order/OrderLines/detail/%%Order.id%%/'));

		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));

		// SAVE PROCESS
					
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}

		if ( !empty($this->request->data) ) {
			// Set sample and aliquot control id
			if(empty($this->request->data['FunctionManagement']['sample_aliquot_control_id'])){
				$this->OrderLine->set($this->request->data);
				$this->OrderLine->validates();
				//manual error on custom field
				$this->OrderLine->validationErrors['sample_aliquot_control_id'][] = __('this field is required')." (".__('product type').")";
			}else{
				$product_controls = explode("|", $this->request->data['FunctionManagement']['sample_aliquot_control_id']);
				if(sizeof($product_controls) != 2)  { 
					$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
				}
				$this->request->data['OrderLine']['sample_control_id'] = $product_controls[0];
				$this->request->data['OrderLine']['aliquot_control_id'] = $product_controls[1];
					
				// Set order id
				$this->request->data['OrderLine']['order_id'] = $order_id;
				$this->request->data['OrderLine']['status'] = 'pending';
					
				$submitted_data_validates = true;
				
				$hook_link = $this->hook('presave_process');
				if($hook_link){
					require($hook_link);
				}
					
				if ($submitted_data_validates) {
					$this->OrderLine->addWritableField(array('sample_control_id', 'aliquot_control_id', 'order_id', 'status'));
					if( $this->OrderLine->save($this->request->data) ) {
						$hook_link = $this->hook('postsave_process');
						if( $hook_link ) {
							require($hook_link);
						}
						$this->atimFlash( 'your data has been saved','/Order/OrderLines/detail/'.$order_id.'/'.$this->OrderLine->id );
					}
				}
			} 
		}else{
			$this->request->data = array('OrderLine' => array(
				'study_summary_id'			=> $order_data['Order']['default_study_summary_id'],
				'date_required'				=> $order_data['Order']['default_required_date'],
				'date_required_accuracy'	=> $order_data['Order']['default_required_date_accuracy']
			));
		}
	}

	function edit( $order_id, $order_line_id ) {
		if (( !$order_id ) || ( !$order_line_id )) { 
			$this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}

		// MANAGE DATA
		
		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id)));
		if(empty($order_line_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}

		// Set value for 'FunctionManagement.sample_aliquot_control_id' field
		$order_line_data['FunctionManagement']['sample_aliquot_control_id'] = $order_line_data['OrderLine']['sample_control_id'] . '|' . (empty($order_line_data['OrderLine']['aliquot_control_id'])? '': $order_line_data['OrderLine']['aliquot_control_id']);

		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id) );

		// SAVE PROCESS
					
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}

		if ( empty($this->request->data) ) {
			$this->request->data = $order_line_data;

		} else {
			// Set sample and aliquot control id
			$product_controls = explode("|", $this->request->data['FunctionManagement']['sample_aliquot_control_id']);
			if(sizeof($product_controls) != 2)  { $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); }
			$this->request->data['OrderLine']['sample_control_id'] = $product_controls[0];
			$this->request->data['OrderLine']['aliquot_control_id'] = $product_controls[1];
				
			$this->OrderLine->addWritableField(array('sample_control_id', 'aliquot_control_id'));
			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if($hook_link){
				require($hook_link);
			}
			
			if ($submitted_data_validates) {
				$this->OrderLine->id = $order_line_id;
				if($this->OrderLine->save($this->request->data)) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) { 
						require($hook_link); 
					}
					$this->atimFlash( 'your data has been updated','/Order/OrderLines/detail/'.$order_id.'/'.$order_line_id );
				}
			}
		}
	}

	function detail( $order_id, $order_line_id ) {
		if (( !$order_id ) || ( !$order_line_id )) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }

		// MANAGE DATA
		
		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id)));
		if(empty($order_line_data)) { 
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}
		$this->request->data = $order_line_data;

		$shipments_list = $this->Shipment->find('all', array('conditions'=>array('Shipment.order_id'=>$order_id), 'recursive' => '-1'));
		$this->set('shipments_list',$shipments_list);
		
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id, 'OrderLine.id'=>$order_line_id) );

		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}

	function delete( $order_id, $order_line_id ) {
		if (( !$order_id ) || ( !$order_line_id )) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true ); }

		// MANAGE DATA
		
		$order_line_data = $this->OrderLine->find('first',array('conditions'=>array('OrderLine.id'=>$order_line_id, 'OrderLine.order_id'=>$order_id)));
		if(empty($order_line_data)){
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true ); 
		}

		// Check deletion is allowed
		$arr_allow_deletion = $this->OrderLine->allowDeletion($order_line_id);
		
		$hook_link = $this->hook('delete');
		if($hook_link){
			require($hook_link);
		}
			
		if($arr_allow_deletion['allow_deletion']) {
			if($this->OrderLine->atimDelete($order_line_id)) {
				$this->atimFlash('your data has been deleted', 'javascript:history.go(-1)');
			} else {
				$this->flash('error deleting data - contact administrator', 'javascript:history.go(-1)');
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], 'javascript:history.go(-1)');
		}
	}
}

?>