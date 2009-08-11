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
					'menu'			=>	array( NULL, __('Shipment',TRUE)),
					'title'			=>	array( NULL, NULL),
					'description'	=>	array(
						__('shipping code', TRUE)			=>	__($result['Shipment']['shipment_code'], TRUE),
						__('recipient', TRUE)				=>	__($result['Shipment']['recipient'], TRUE),
						__('shipping company', TRUE)		=>	__($result['Shipment']['shipping_company'], TRUE),
						__('shipping account number', TRUE)	=>  __($result['Shipment']['shipping_account_nbr'], TRUE)
					)
				)
			);	
		}
		
		return $return;
	}
}

?>