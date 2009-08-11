<?php

class Collection extends InventorymanagementAppModel {
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Collection.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('Collection.id'=>$variables['Collection.id'])));
			
			$return = array(
				'Summary'	 => array(
					'menu'		 => array( NULL, __($result['Collection']['acquisition_label'], TRUE) ),
					'title'		 => array( NULL, __($result['Collection']['acquisition_label'], TRUE) ),
					
					'description'=> array(
						// __('Bank', TRUE) => __($result['Collection']['bank_id'], TRUE),
						__('Collection Date/Time', TRUE) => __($result['Collection']['collection_datetime'], TRUE),
						__('Reception Date', TRUE) 		 => __($result['Collection']['reception_datetime'], TRUE)
					)
				)
			);			
		}
		
		return $return;
	}
	
//	var $hasMany 
//		= array('SampleMaster' =>
//	         array('className'   => 'SampleMaster',
//	               'conditions'  => '',
//	               'order'       => '',
//	               'limit'       => '',
//	               'foreignKey'  => 'collection_id',
//	               'dependent'   => true,
//	               'exclusive'   => false,
//	               'finderSql'   => ''));
	
}

?>
