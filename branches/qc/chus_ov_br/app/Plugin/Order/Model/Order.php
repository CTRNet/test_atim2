<?php

class Order extends OrderAppModel {
	
	var $hasMany = array(
		'OrderLine' => array(
			'className'   => 'Order.OrderLine',
			 'foreignKey'  => 'order_id'),
		'Shipment' => array(
			'className'   => 'Order.Shipment',
			 'foreignKey'  => 'order_id')); 
	
	var $belongsTo = array(
		'StudySummary' => array(
			'className'    => 'Study.StudySummary',
			'foreignKey'    => 'default_study_summary_id'));
	
	var $registered_view = array(
		'InventoryManagement.ViewAliquotUse' => array('Order.id')
	);
	
	public static $study_model = null;
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Order.id']) ) {
			$this->warnUnconsentedAliquots($variables['Order.id']);
			
			$result = $this->find('first', array('conditions'=>array('Order.id'=>$variables['Order.id'])));
			
			$return = array(
				'menu'			=>	array( __('order'), ': ' . $result['Order']['order_number']),
				'title'			=>	array( null, __('order') . ': ' . $result['Order']['order_number']),
				'data'			=> $result,
				'structure alias'=>'orders'
			);
		}
		
		return $return;
	}
	
	function validates($options = array()){
	
		$this->validateAndUpdateOrderStudyData();
		
		return parent::validates($options);
	}
	
	
	/**
	 * Check order study definition and set error if required.
	 */
	
	function validateAndUpdateOrderStudyData() {
		$order_data =& $this->data;
	
		// check data structure
		$tmp_arr_to_check = array_values($order_data);
		if((!is_array($order_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['Order']))) {
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
	
		// Launch validation
		if(array_key_exists('FunctionManagement', $order_data) && array_key_exists('autocomplete_order_study_summary_id', $order_data['FunctionManagement'])) {
			$order_data['Order']['study_summary_id'] = null;
			$order_data['FunctionManagement']['autocomplete_order_default_study_summary_id'] = trim($order_data['FunctionManagement']['autocomplete_order_study_summary_id']);
			$this->addWritableField(array('default_study_summary_id'));
			if(strlen($order_data['FunctionManagement']['autocomplete_order_study_summary_id'])) {
				// Load model
				if(self::$study_model == null) self::$study_model = AppModel::getInstance("Study", "StudySummary", true);
					
				// Check the aliquot internal use study definition
				$arr_study_selection_results = self::$study_model->getStudyIdFromStudyDataAndCode($order_data['FunctionManagement']['autocomplete_order_study_summary_id']);
	
				// Set study summary id
				if(isset($arr_study_selection_results['StudySummary'])){
					$order_data['Order']['default_study_summary_id'] = $arr_study_selection_results['StudySummary']['id'];
				}
	
				// Set error
				if(isset($arr_study_selection_results['error'])){
					$this->validationErrors['autocomplete_order_study_summary_id'][] = $arr_study_selection_results['error'];
				}
			}
	
		}
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
	function allowDeletion($order_id){
		// Check no order line exists
		$order_item_model = AppModel::getInstance("Order", "OrderItem", true);
		$returned_nbr = $order_item_model->find('count', array('conditions' => array('OrderItem.order_id' => $order_id), 'recursive' => '-1'));
		if($returned_nbr > 0) {
			return array('allow_deletion' => false, 'msg' => 'order item exists for the deleted order');
		}
		
		// Check no order line exists
		$order_ling_model = AppModel::getInstance("Order", "OrderLine", true);
		$returned_nbr = $order_ling_model->find('count', array('conditions' => array('OrderLine.order_id' => $order_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'order line exists for the deleted order'); 
		}
	
		// Check no order line exists
		$shipment_model = AppModel::getInstance("Order", "Shipment", true);
		$returned_nbr = $shipment_model->find('count', array('conditions' => array('Shipment.order_id' => $order_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'shipment exists for the deleted order'); 
		}
		
		return array('allow_deletion' => true, 'msg' => '');
	}
  
	
	function warnUnconsentedAliquots($order_id){
		$order_item_model = AppModel::getInstance("Order", "OrderItem", true);
		$order_item_data = $order_item_model->find('all', array(
			'conditions' => array('OrderItem.order_id' => $order_id, 'OrderItem.aliquot_master_id IS NOT NULL'),
			'fields' => array('OrderItem.aliquot_master_id'),
			'recursive' => '0'
		));
		
		if(empty($order_item_data)){
			return;
		}
		
		$aliquot_ids = array();
		foreach($order_item_data as $order_item_data_unit){
			$aliquot_ids[] = $order_item_data_unit['OrderItem']['aliquot_master_id'];
		}
		
		if(!empty($aliquot_ids)){
			$aliquot_master_model = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
			$unconsented_aliquots = $aliquot_master_model->getUnconsentedAliquots(array('id' => $aliquot_ids));
			if(!empty($unconsented_aliquots)){
				AppController::addWarningMsg(__('aliquot(s) without a proper consent').": ".count($unconsented_aliquots));
			}
		}
	}
}

?>