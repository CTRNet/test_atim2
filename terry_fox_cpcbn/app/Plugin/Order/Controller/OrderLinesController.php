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
		} else if(Configure::read('order_item_to_order_objetcs_link_setting') == 3) {
			$this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, null, true );
		}

		// MANAGE DATA
		
		// Check order
		$order_data = $this->Order->getOrRedirect($order_id);
		$this->set('override_data', array(
			'OrderLine.study_summary_id' => $order_data['Order']['default_study_summary_id'],
			'OrderLine.date_required' => $order_data['Order']['default_required_date']? substr($order_data['Order']['default_required_date'], 0, (str_replace(array('', 'y','m','d','c'), array('c',4,4,7,10),$order_data['Order']['default_required_date_accuracy']))) : ''));
	
		// MANAGE FORM, MENU AND ACTION BUTTONS
		
		$this->set('atim_menu', $this->Menus->get('/Order/OrderLines/detail/%%Order.id%%/'));

		$this->set( 'atim_menu_variables', array('Order.id'=>$order_id));

		// SAVE PROCESS
					
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
		
		if (empty($this->request->data) ) {
			$this->request->data = array(array());
		
			$hook_link = $this->hook('initial_display');
			if($hook_link){
				require($hook_link);
			}
		} else {
			
			$errors_tracking = array();
			
			// Validation
			
			$row_counter = 0;
			foreach($this->request->data as &$data_unit){
				$row_counter++;
				//Set control id
				if(empty($data_unit['FunctionManagement']['sample_aliquot_control_id'])) {
					$errors_tracking['sample_aliquot_control_id'][__('this field is required')." (".__('product type').")"][] = $row_counter;
				} else {
					//Set sample/aliquot control id
					$product_controls = explode("|", $data_unit['FunctionManagement']['sample_aliquot_control_id']);
					if(sizeof($product_controls) != 2) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
					$data_unit['OrderLine']['sample_control_id'] = $product_controls[0];
					$data_unit['OrderLine']['aliquot_control_id'] = $product_controls[1];
				}
				$this->OrderLine->id = null;
				$this->OrderLine->set($data_unit);
				if(!$this->OrderLine->validates()){
					foreach($this->OrderLine->validationErrors as $field => $msgs) {
						$msgs = is_array($msgs)? $msgs : array($msgs);
						foreach($msgs as $msg) $errors_tracking[$field][$msg][] = $row_counter;
					}
				}
				$data_unit = $this->OrderLine->data;
			}
			unset($data_unit);
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) {
				require($hook_link);
			}
			
			// Launch Save Process
			
			if(empty($errors_tracking)){
				$this->OrderLine->addWritableField(array('sample_control_id', 'aliquot_control_id', 'order_id', 'status'));
				AppModel::acquireBatchViewsUpdateLock();
				//save all
				foreach($this->request->data as $new_data_to_save) {
					//Set order id
					$new_data_to_save['OrderLine']['order_id'] = $order_id;
					$new_data_to_save['OrderLine']['status'] = 'pending';
					//Save new recrod
					$this->OrderLine->id = null;
					$this->OrderLine->data = array();
					if(!$this->OrderLine->save($new_data_to_save, false)) $this->redirect( '/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
				}
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				AppModel::releaseBatchViewsUpdateLock();
				$this->atimFlash(__('your data has been saved'), '/Order/Orders/detail/'.$order_id);
			} else {
				$this->OrderLine->validationErrors = array();
				foreach($errors_tracking as $field => $msg_and_lines) {
					foreach($msg_and_lines as $msg => $lines) {
						$this->OrderLine->validationErrors[$field][] = $msg . ' - ' . str_replace('%s', implode(",", $lines), __('see line %s'));
					}
				}
			}
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
					$this->atimFlash(__('your data has been updated'),'/Order/OrderLines/detail/'.$order_id.'/'.$order_line_id );
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
				$this->atimFlash(__('your data has been deleted'), '/Order/Orders/detail/'.$order_id);
			} else {
				$this->flash(__('error deleting data - contact administrator'), 'javascript:history.go(-1)');
			}
		} else {
			$this->flash(__($arr_allow_deletion['msg']), 'javascript:history.go(-1)');
		}
	}
}

?>