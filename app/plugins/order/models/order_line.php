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
					'menu'			=>	array( NULL, __('Order Line', TRUE)),
					'title'			=>	array( NULL, NULL),
					'description'	=>	array(
						__('cancer type', TRUE)		=>	__($result['OrderLine']['cancer_type'], TRUE),
						__('quantity ordered', TRUE)=>	__($result['OrderLine']['quantity_ordered'], TRUE),
						__('base price', TRUE)		=>  __($result['OrderLine']['base_price'], TRUE),
						__('status', TRUE)			=>  __($result['OrderLine']['status'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}
}

?>