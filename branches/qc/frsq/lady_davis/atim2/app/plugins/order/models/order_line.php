<?php

class OrderLine extends OrderAppModel {
	
	var $hasMany = array(
		'OrderItem' => array(
			'className'   => 'Order.OrderItem',
			 'foreignKey'  => 'order_line_id'));
	
	var $belongsTo = array(       
		'Order' => array(           
			'className'    => 'Order.Order',            
			'foreignKey'    => 'order_id'));
	
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
				'menu'			=>	array('line', ':' . $line_title),
				'title'			=>	array(null, __('order line', null). ' : '.$line_title),
				'data'			=> $result,
				'structure alias'=>'orderlines'
			);
		}
		
		return $return;
	}
	
	
	
	function afterFind($results){
		$results = parent::afterFind($results);
		
		if(isset($results['0']['OrderItem'])) {
			foreach($results as &$new_order_line) {
				$shipped_counter = 0;
				$items_counter = 0;
				foreach($new_order_line['OrderItem'] as $new_item) {
					++ $items_counter;	
					if($new_item['status'] == 'shipped'){
						++ $shipped_counter; 
					}
				}
				$new_order_line['Generated']['order_line_completion'] = empty($items_counter)? 'n/a': $shipped_counter.'/'.$items_counter;
			}
		}		

		return $results;
	}
	
}

?>