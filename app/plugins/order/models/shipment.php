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
				'menu'			=>	array( null, __('shipment',true) . ' : ' . $result['Shipment']['shipment_code']),
				'title'			=>	array( null, __('shipment',true) . ' : ' . $result['Shipment']['shipment_code']),
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
}

?>