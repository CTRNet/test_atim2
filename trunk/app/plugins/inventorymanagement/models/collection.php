<?php

class Collection extends InventorymanagementAppModel {

	var $hasMany = array(
		'SampleMaster' => array(
			'className'   => 'Inventorymanagement.SampleMaster',
			 	'foreignKey'  => 'collection_id'));  	

	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			
			$this->bindModel(array('belongsTo' => array('Bank' => array('className' => 'Administrates.Bank', 'foreignKey' => 'bank_id'))));	
			$result = $this->find('first', array('conditions'=>array('Collection.id'=>$variables['Collection.id'])));
			
			$return = array(
				'Summary' => array(
					'menu' => array(NULL, $result['Collection']['acquisition_label']),
					'title' => array(NULL, $result['Collection']['acquisition_label']),
					
					'description'=> array(
						__('collection bank', TRUE) => $result['Bank']['name'],
						__('collection datetime', TRUE) => $result['Collection']['collection_datetime'],
						__('Reception Date', TRUE) 		 => $result['Collection']['reception_datetime']
					)
				)
			);			
		}
		
		return $return;
	}
	
}

?>
