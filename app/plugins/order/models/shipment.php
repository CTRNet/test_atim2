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
				'Summary' => array(
					'menu'			=>	array( NULL, 'Shipment'),
					'title'			=>	array( NULL, NULL),
					'description'	=>	array(
						'shipping code'			=>	$result['Shipment']['shipment_code'],
						'recipient'				=>	$result['Shipment']['recipient'],
						'shipping company'		=>	$result['Shipment']['shipping_company'],
						'shipping account number'				=>  $result['Shipment']['shipping_account_nbr']
					)
				)
			);
		}
		
		return $return;
	}
}

?>