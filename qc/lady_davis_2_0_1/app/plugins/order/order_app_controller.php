<?php

class OrderAppController extends AppController {	
	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->actionPath = 'controllers/Order/';
	}
	
	/**
	 * Set all data used to display a list of order lines of a specific order. 
	 * (aliquots_data, banks, etc).
	 *
	 *	@param $order_id Id of the order
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function setDataForOrderLinesList($order_id) {
		$data = $this->paginate($this->OrderLine, array('OrderLine.order_id'=>$order_id, 'OrderLine.deleted' => 0));
		
		// Add completion information
		foreach($data as $key => $new_order_line) {
			$shipped_counter = 0;
			$items_counter = 0;
			foreach($new_order_line['OrderItem'] as $new_item){
				++ $items_counter;	
				if($new_item['status'] == 'shipped'){
					++ $shipped_counter; 
				}
			}
			$completion = empty($new_order_line['OrderItem'])? 'n/a': $shipped_counter.'/'.$items_counter;
			$data[$key]['Generated']['order_line_completion'] = $completion;
		}

		$this->set('order_lines_data', $data);

		// Populate both sample and aliquot control
		$this->set('sample_controls_list', $this->getSampleControlsList());
		$this->set('aliquot_controls_list', $this->getAliquotControlsList());	
	}
	
	/**
	 * Get formatted list of exitsing sample controls.
	 * 
	 * @return Sample controls list into array having following structure: 
	 * 	array($sample_control_id => $sample_control_title_built_by_function)
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
		 
	function getSampleControlsList() {
		$sample_controls_list = $this->SampleControl->find('all', array('recursive' => '-1'));
		$sample_controls_list = empty($sample_controls_list)? array(): $sample_controls_list;
		
		// Build formatted array
		$formatted_data = array();
		if(!empty($sample_controls_list)) {
			foreach($sample_controls_list as $new_control) { 
				$formatted_data[$new_control['SampleControl']['id']] = __($new_control['SampleControl']['sample_type'], null);
			}
		}
		
		return $formatted_data;		
	}
	
	/**
	 * Get formatted list of exitsing aliquot controls.
	 *
	 * @param $aliquot_control_id Id of the studied aliquot control
	 * 
	 * @return aliquot controls list into array having following structure: 
	 * 	array($aliquot_control_id => $aliquot_control_title_built_by_function)
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
		 
	function getAliquotControlsList($aliquot_control_id = null) {
		$aliquot_controls_list = $this->AliquotControl->find('all', array('recursive' => '-1'));
		$aliquot_controls_list = empty($aliquot_controls_list)? array(): $aliquot_controls_list;
		
		// Build formatted array
		$formatted_data = array();
		if(!empty($aliquot_controls_list)) {
			foreach($aliquot_controls_list as $new_control) { 
				$formatted_data[$new_control['AliquotControl']['id']] = __($new_control['AliquotControl']['aliquot_type'], null);
			}
		}
		
		return $formatted_data;		
	}		
	
	/**
	 * Set all data used to display a list of order items for a specific order line. 
	 * (aliquots_data, banks, etc).
	 *
	 *	@param $order_line_id Id of the order line
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	 
	function setDataForOrderItemsList($order_line_id) {	
		$data = $this->paginate($this->OrderItem, array('OrderItem.order_line_id'=>$order_line_id));	
		$this->set('order_items_data', $data);				
	}
	
	/**
	 * Get formatted list of all shipments of an order.
	 * 
	 * @param $order_id Studied Order id
	 * 
	 * @return Shipments list into array having following structure: 
	 * 	array($shipment_id => $shipment_control_title_built_by_function)
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
		 
	function getOrderShipmentList($order_id = null) {
		$shipments = $this->Shipment->find('all', array('condtions' => array('Shipment.order_id'=>$order_id), 'order'=>'Shipment.datetime_shipped DESC'));
		
		// Build formatted array
		$formatted_data = array();
		if(!empty($shipments)) {
			foreach($shipments as $new_shipment) { 
				$formatted_data[$new_shipment['Shipment']['id']] = $new_shipment['Shipment']['shipment_code'];			
			}
		}
		
		return $formatted_data;		
	}
}

?>