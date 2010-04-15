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
				'Summary'		=> array(
					'menu'			=>	array( null, __('shipment',true) . ' : ' . $result['Shipment']['shipment_code']),
					'title'			=>	array( null, __('shipment',true) . ' : ' . $result['Shipment']['shipment_code']),
					'description'	=>	array(
						__('shipping code', true)			=>	$result['Shipment']['shipment_code'],
						__('recipient', true)				=>	$result['Shipment']['recipient'],
						__('facility', true)		=>	$result['Shipment']['facility'],
						__('order_datetime_shipped', true)	=>  $result['Shipment']['datetime_shipped']
					)
				)
			);	
		}
		
		return $return;
	}
}

?>