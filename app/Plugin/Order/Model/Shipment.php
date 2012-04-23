<?php

class Shipment extends OrderAppModel
{
	var $name = 'Shipment';
	var $useTable = 'shipments';
                             
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Shipment.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('Shipment.id'=>$variables['Shipment.id'])));
						
			$return = array(
				'menu'			=>	array( null, __('shipment') . ' : ' . $result['Shipment']['shipment_code']),
				'title'			=>	array( null, __('shipment') . ' : ' . $result['Shipment']['shipment_code']),
				'data'			=> $result,
				'structure alias'=>'shipments'
			);	
		}
		
		return $return;
	}
	
	
	/**
	 * Get array gathering all existing shipments.
	 *
	 * @param $order_id Id of the order linked to the shipments to return (null for all).
	 * 
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 */
	function getShipmentPermissibleValues($order_id = null) {
		$result = array();
		
		$conditions = is_null($order_id)? array() : array('Shipment.order_id' => $order_id);
		foreach($this->find('all', array('conditions' => $conditions, 'order' => 'Shipment.datetime_shipped DESC')) as $shipment) {
			$result[$shipment['Shipment']['id']] = $shipment['Shipment']['shipment_code'];
		}
		
		return $result;
	}
	
	/**
	 * Check if a shipment can be deleted.
	 * 
	 * @param $shipment_id Id of the studied shipment.
	 * 
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 * 
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	 
	function allowDeletion($shipment_id){
		// Check no item is linked to this shipment
		$order_item_model = AppModel::getInstance("Order", "OrderItem", true);
		$returned_nbr = $order_item_model->find('count', array('conditions' => array('OrderItem.shipment_id' => $shipment_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'order item exists for the deleted shipment'); 
		}
		
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	/**
	 * Check if an item can be removed from a shipment.
	 *
	 * @param $order_item_id  Id of the studied item.
	 * @param $shipment_id Id of the studied shipemnt.
	 *
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 *
	 * @author N. Luc
	 * @since 2007-10-16
	 */
	function allowItemRemoveFromShipment($order_item_id, $shipment_id){
		return array('allow_deletion' => true, 'msg' => '');
	}
}

?>