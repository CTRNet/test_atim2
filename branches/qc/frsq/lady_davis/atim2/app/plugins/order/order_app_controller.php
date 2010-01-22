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
		$sample_controls_list = $this->SampleControl->find('all', array('recursive' => '-1'));
		$sample_controls_list = empty($sample_controls_list)? array(): $sample_controls_list;
		$aliquot_controls_list = $this->AliquotControl->find('all', array('recursive' => '-1'));
		$aliquot_controls_list = empty($aliquot_controls_list)? array(): $aliquot_controls_list;

		$this->set('sample_controls_list', $sample_controls_list);
		$this->set('aliquot_controls_list', $aliquot_controls_list);	
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
	
	
	
	
}

?>