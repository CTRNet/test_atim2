<?php

class SampleMaster extends InventorymanagementAppModel {
	
	var $useTable = 'sample_masters';
	
	var $belongsTo = 'SampleControl';
   
   var $actAs = array('MasterDetail');
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['SampleMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('SampleMaster.id'=>$variables['SampleMaster.id'])));
			
			$return = array(
				'Summary' => array(
					'menu'        => array( NULL, $result['SampleMaster']['sample_code'] ),
					'title'		  => array( NULL, $result['SampleMaster']['sample_code'] ),

					'description' => array(
						'product code'      =>  $result['SampleMaster']['product code'],
						'category'	=>	$result['SampleMaster']['sample_category'],
						'type'	=>	$result['SampleMaster']['sample_type']
					)
				)
			);
		}
		
		return $return;
	}
}

?>