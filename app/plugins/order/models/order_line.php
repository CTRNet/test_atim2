<?php

class OrderLine extends OrderAppModel
{
	var $name = 'OrderLine';
	var $useTable = 'order_lines';
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['OrderLine.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('OrderLine.id'=>$variables['OrderLine.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'			=>	array( NULL, 'Order Line'),
					'title'			=>	array( NULL, NULL),
					'description'	=>	array(
						'cancer type'			=>	$result['OrderLine']['cancer_type'],
						'quantity ordered'		=>	$result['OrderLine']['quantity_ordered'],
						'base price'  			=>  $result['OrderLine']['base_price'],
						'status'				=>  $result['OrderLine']['status']
					)
				)
			);
		}
		
		return $return;
	}
}

?>