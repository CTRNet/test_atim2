<?php

class AliquotMaster extends InventoryManagementAppModel {

	var $useTable = 'aliquot_masters';
	
	var $belongsTo = 'AliquotControl';
   
   var $actAs = array('MasterDetail');
	
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
/*
    var $name = 'AliquotMaster';
    
	var $useTable = 'aliquot_masters';

	var $belongsTo 
		= array('StorageMaster' =>
			array('className'  => 'StorageMaster',
                 'conditions' => '',
                 'order'      => '',
                 'foreignKey' => 'storage_master_id'));
                                 
	var $hasMany 
		= array('AliquotUse' =>
			array('className'   => 'AliquotUse',
			 	'conditions'  => '',
			 	'order'       => '',
			 	'limit'       => '',
			 	'foreignKey'  => 'aliquot_master_id',
			 	'dependent'   => true,
			 	'exclusive'   => false,
			 	'finderSql'   => ''));
		
	var $validate = array();
*/
}

?>
