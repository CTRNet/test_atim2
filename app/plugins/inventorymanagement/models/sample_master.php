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
				'Summary'	 => array(
					'menu'     	=> array( NULL, $result['SampleMaster']['sample_code'] ),
					'title'	  	=> array( NULL, $result['SampleMaster']['sample_code'] ),

					'description' => array(
						__('product code', TRUE)		=>  __($result['SampleMaster']['product code'], TRUE),
						__('category', TRUE)			=>	__($result['SampleMaster']['sample_category'], TRUE),
						__('type', TRUE)				=>	__($result['SampleMaster']['sample_type'], TRUE)
					)
				)
			);
		}
		
		return $return;
	}
}

?>