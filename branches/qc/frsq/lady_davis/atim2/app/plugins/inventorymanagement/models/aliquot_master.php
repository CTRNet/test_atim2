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
                                 
	var $hasMany = array(
		'AliquotUse' => array(
			'className'   => 'Inventorymanagement.AliquotUse',
			'foreignKey'  => 'aliquot_master_id'),
		'RealiquotingParent' => array(
			'className' => 'Inventorymanagement.Realiquoting',
			'foreignKey' => 'child_aliquot_master_id'),
		'RealiquotingChildren' => array(
			'className' => 'Inventorymanagement.Realiquoting',
			'foreignKey' => 'parent_aliquot_master_id'));
	
	var $hasOne = array(
		'SpecimenDetail' => array(
			'className'   => 'Inventorymanagement.SpecimenDetail',
			 	'foreignKey'  => 'sample_master_id',
			 	'dependent' => true)
	);
	
	function summary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['AliquotMaster.id'])) {
			
			$result = $this->find('first', array('conditions'=>array('AliquotMaster.collection_id'=>$variables['Collection.id'], 'AliquotMaster.sample_master_id'=>$variables['SampleMaster.id'], 'AliquotMaster.id'=>$variables['AliquotMaster.id'])));
					
			$return = array(
				'Summary'	 => array(
					'menu'	        	=> array(null, __($result['AliquotMaster']['aliquot_type'], true) . ' : '. $result['AliquotMaster']['barcode']),
					'title'		  		=> array(null, __($result['AliquotMaster']['aliquot_type'], true) . ' : '. $result['AliquotMaster']['barcode']),

					'description'		=> array(
						__('barcode', true)=> $result['AliquotMaster']['barcode'],
						__('product code', true)=> $result['AliquotMaster']['product_code'],
						__('type', true)	    => __($result['AliquotMaster']['aliquot_type'], true).($result['AliquotMaster']['aliquot_type'] == "block" ? " (".__($result['AliquotDetail']['block_type'], true).")": ""),
						__('aliquot in stock', true)		=> __($result['AliquotMaster']['in_stock'], true)
					)
				)
			);
		}
		
		return $return;
	}
	
}

?>
