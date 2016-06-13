<?php

class OrderLine extends OrderAppModel {
	
	var $hasMany = array(
		'OrderItem' => array(
			'className'   => 'Order.OrderItem',
			 'foreignKey'  => 'order_line_id'));
	
	var $belongsTo = array(       
		'Order' => array(           
			'className'    => 'Order.Order',            
			'foreignKey'    => 'order_id'));
	
	var $registered_view = array(
			'InventoryManagement.ViewAliquotUse' => array('OrderLine.id')
	);
	
	public static $study_model = null;
	
	function summary( $variables=array() ) {
		
		$return = false;
		
		if ( isset($variables['OrderLine.id']) && isset($variables['Order.id']) ) {
			
			$this->bindModel(
				  array('belongsTo' => array(
							 'SampleControl'	=> array(
									'className'  	=> 'InventoryManagement.SampleControl',
									'foreignKey'	=> 'sample_control_id'),
							 'AliquotControl'	=> array(
									'className'  	=> 'InventoryManagement.AliquotControl',
									'foreignKey'	=> 'aliquot_control_id'))));						
			$result = $this->find('first', array('conditions'=>array('OrderLine.id'=>$variables['OrderLine.id'],'OrderLine.order_id'=>$variables['Order.id'])));
				
			$line_title = __($result['SampleControl']['sample_type']) . (empty($result['AliquotControl']['aliquot_type'])? '': ' '.__($result['AliquotControl']['aliquot_type']));			
			$return = array(
				'menu'			=>	array(null, $line_title),
				'title'			=>	array(null, __('order line', null). ' : '.$line_title),
				'data'			=> $result,
				'structure alias'=>'orderlines'
			);
		}
		
		return $return;
	}
	
	function validates($options = array()){
	
		$this->validateAndUpdateOrderLineStudyData();
	
		parent::validates($options);
	
		return empty($this->validationErrors);
	}
	
	/**
	 * Check order line study definition and set error if required.
	 */
	
	function validateAndUpdateOrderLineStudyData() {
		$order_line_data =& $this->data;
	
		// check data structure
		$tmp_arr_to_check = array_values($order_line_data);
		if((!is_array($order_line_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['OrderLine']))) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		// Launch validation
		if(array_key_exists('FunctionManagement', $order_line_data) && array_key_exists('autocomplete_order_line_study_summary_id', $order_line_data['FunctionManagement'])) {
			$order_line_data['OrderLine']['study_summary_id'] = null;
			$order_line_data['FunctionManagement']['autocomplete_order_line_study_summary_id'] = trim($order_line_data['FunctionManagement']['autocomplete_order_line_study_summary_id']);
			if(strlen($order_line_data['FunctionManagement']['autocomplete_order_line_study_summary_id'])) {
				// Load model
				if(self::$study_model == null) self::$study_model = AppModel::getInstance("Study", "StudySummary", true);
					
				// Check the aliquot internal use study definition
				$arr_study_selection_results = self::$study_model->getStudyIdFromStudyDataAndCode($order_line_data['FunctionManagement']['autocomplete_order_line_study_summary_id']);
	
				// Set study summary id
				if(isset($arr_study_selection_results['StudySummary'])){
					$order_line_data['OrderLine']['study_summary_id'] = $arr_study_selection_results['StudySummary']['id'];
					$this->addWritableField(array('study_summary_id'));
				}
	
				// Set error
				if(isset($arr_study_selection_results['error'])){
					$this->validationErrors['autocomplete_order_line_study_summary_id'][] = $arr_study_selection_results['error'];
				}
			}
	
		}
	}
	
	function afterFind($results, $primary = false) {
		$results = parent::afterFind($results, $primary);
		
		if(isset($results['0']['OrderLine'])) {
			$OrderItem = null;
			foreach($results as &$new_order_line) {
				$shipped_counter = 0;
				$items_counter = 0;
				if(isset($new_order_line['OrderItem'])) {				
					foreach($new_order_line['OrderItem'] as $new_item) {
						++ $items_counter;
						if(in_array($new_item['status'], array('shipped', 'shipped & returned'))){
							++ $shipped_counter;
						}
					}					
				} else if(isset($new_order_line['OrderLine']['id'])) {
					if(!$OrderItem) $OrderItem = AppModel::getInstance('Order', 'OrderItem', true);
					$items_counter = $OrderItem->find('count', array('conditions' => array('OrderItem.order_line_id' => $new_order_line['OrderLine']['id']), 'recursive' => '-1'));
					if($items_counter) $shipped_counter = $OrderItem->find('count', array('conditions' => array('OrderItem.order_line_id' => $new_order_line['OrderLine']['id'], 'OrderItem.status' => array('shipped', 'shipped & returned')), 'recursive' => '-1'));				
				}
				$new_order_line['Generated']['order_line_completion'] = empty($items_counter)? 'n/a': $shipped_counter.'/'.$items_counter;		
			}
		}		
		return $results;
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
	function allowDeletion($order_line_id){
		// Check no order item exists
		$order_item_model = AppModel::getInstance("Order", "OrderItem", true);
		$returned_nbr = $order_item_model->find('count', array('conditions' => array('OrderItem.order_line_id' => $order_line_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'item exists for the deleted order line'); 
		}

		return array('allow_deletion' => true, 'msg' => '');
	}	
	
	
}

?>