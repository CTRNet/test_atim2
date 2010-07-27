<?php

class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';	
	
	function summary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['AliquotMaster.id'])) {
			
			$result = $this->find('first', array('conditions'=>array('AliquotMaster.collection_id'=>$variables['Collection.id'], 'AliquotMaster.sample_master_id'=>$variables['SampleMaster.id'], 'AliquotMaster.id'=>$variables['AliquotMaster.id'])));
					
			$return = array(
				'Summary'	 => array(
					'menu'	        	=> array(null, __($result['AliquotMaster']['aliquot_type'], true) . ' : '. $result['AliquotMaster']['aliquot_label']),
					'title'		  		=> array(null, __($result['AliquotMaster']['aliquot_type'], true) . ' : '. $result['AliquotMaster']['aliquot_label']),

					'description'		=> array(
						__('barcode', true)=> $result['AliquotMaster']['barcode'],
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
