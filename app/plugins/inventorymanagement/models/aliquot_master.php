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
				'Summary' => array(
					'menu'        => array( NULL, $result['AliquotMaster']['barcode'] ),
					'title'		  => array( NULL, $result['AliquotMaster']['barcode'] ),

					'description' => array(
						'product code' => $result['AliquotMaster']['product_code'],
						'type'      =>  $result['AliquotMaster']['aliquot_type'],
						'category'	=>	$result['AliquotMaster']['current_volume'].' '.$result['AliquotMaster']['aliquot_volume_unit'],
						'status'	=>	$result['AliquotMaster']['status']
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
