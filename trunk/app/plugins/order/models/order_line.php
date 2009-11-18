<?php

class OrderLine extends OrderAppModel {
	
	var $hasMany = array(
		'OrderItem' => array(
			'className'   => 'Order.OrderItem',
			 'foreignKey'  => 'order_line_id'));
	
	function summary( $variables=array() ) {
		
		$return = false;
		
		if ( isset($variables['OrderLine.id']) && isset($variables['Order.id']) ) {
			
			$this->bindModel(
				  array('belongsTo' => array(
							 'SampleControl'	=> array(
									'className'  	=> 'Inventorymanagement.SampleControl',
									'foreignKey'	=> 'sample_control_id'),
							 'AliquotControl'	=> array(
									'className'  	=> 'Inventorymanagement.AliquotControl',
									'foreignKey'	=> 'aliquot_control_id'))));						
			$result = $this->find('first', array('conditions'=>array('OrderLine.id'=>$variables['OrderLine.id'],'OrderLine.order_id'=>$variables['Order.id'])));
				
			$line_title = __($result['SampleControl']['sample_type'], true) . (empty($result['AliquotControl']['aliquot_type'])? '': ' '.__($result['AliquotControl']['aliquot_type'], true));			
			$return = array(
				'Summary' => array(
					'menu'			=>	array('line', ':' . $line_title),
					'title'			=>	array(null, __('order line', null). ' : '.$line_title),
					'description'	=>	array(
						__('sample type', true)		=>	__($result['SampleControl']['sample_type'], true),
						__('aliquot type', true)=>	__($result['AliquotControl']['aliquot_type'], true),
						__('product code', true)		=>  __($result['OrderLine']['product_code'], true),
						__('status', true)			=>  __($result['OrderLine']['status'], true)
					)
				)
			);
		}
		
		return $return;
	}
	
}

?>