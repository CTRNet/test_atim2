<?php

class AliquotMaster extends InventoryManagementAppModel {

	var $belongsTo = array(        
		'AliquotControl' => array(            
			'className'    => 'Inventorymanagement.AliquotControl',            
			'foreignKey'    => 'aliquot_control_id'), 
		'Collection' => array(            
			'className'    => 'Inventorymanagement.Collection',            
			'foreignKey'    => 'collection_id'),          
		'SampleMaster' => array(            
			'className'    => 'Inventorymanagement.SampleMaster',            
			'foreignKey'    => 'sample_master_id'),        
		'StorageMaster' => array(            
			'className'    => 'Storagelayout.StorageMaster',            
			'foreignKey'    => 'storage_master_id'));
                                 
	var $hasMany 
		= array('AliquotUse' =>
			array('className'   => 'Inventorymanagement.AliquotUse',
			 	'foreignKey'  => 'aliquot_master_id'));
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['AliquotMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('AliquotMaster.id'=>$variables['AliquotMaster.id'])));
			
			$return = array(
				'Summary'	 => array(
					'menu'	        	=> array( null, __($result['AliquotMaster']['barcode'], true) ),
					'title'		  		=> array( null, __($result['AliquotMaster']['barcode'], true) ),

					'description'		=> array(
						__('product code', true)=> __($result['AliquotMaster']['product_code'], true),
						__('type', true)	    => __($result['AliquotMaster']['aliquot_type'], true),
						__('category', true)	=> __($result['AliquotMaster']['current_volume'].' '.$result['AliquotMaster']['aliquot_volume_unit'], true),
						__('status', true)		=> __($result['AliquotMaster']['status'], true)
					)
				)
			);
		}
		
		return $return;
	}
	
}

?>
