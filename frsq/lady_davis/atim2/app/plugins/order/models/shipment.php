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
					'menu'			=>	array( null, __('Shipment',true)),
					'title'			=>	array( null, null),
					'description'	=>	array(
						__('shipping code', true)			=>	__($result['Shipment']['shipment_code'], true),
						__('recipient', true)				=>	__($result['Shipment']['recipient'], true),
						__('shipping company', true)		=>	__($result['Shipment']['shipping_company'], true),
						__('shipping account number', true)	=>  __($result['Shipment']['shipping_account_nbr'], true)
					)
				)
			);	
		}
		
		return $return;
	}
}

?>