<?php

class Collection extends InventorymanagementAppModel {
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['Collection.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('Collection.id'=>$variables['Collection.id'])));
			
			$return = array(
				'Summary' => array(
					'menu' => array( NULL, $result['Collection']['acquisition_label'] ),
					'title' => array( NULL, $result['Collection']['acquisition_label'] ),
					
					'description' => array(
						'Bank' => $result['Collection']['bank'],
						'Collection Date/Time' => $result['Collection']['collection_datetime'],
						'Reception Date' => $result['Collection']['reception_datetime'])));
						
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
