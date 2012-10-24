<?php

class AliquotReviewMasterCustom extends AliquotReviewMaster {

	var $name = 'AliquotReviewMaster';
	var $useTable = 'aliquot_review_masters';
	
		
	function getAliquotListForReview($sample_master_id = null, $specific_aliquot_type = null) {
		$result = array(''=>'');
		
		if(!empty($sample_master_id)) {
			if(!isset($this->AliquotMaster)) {
				$this->AliquotMaster = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
			}
			
			$conditions = array('AliquotMaster.sample_master_id' => $sample_master_id);
			if(!empty($specific_aliquot_type)){
				$conditions['AliquotControl.aliquot_type'] = $specific_aliquot_type;
			}
			
			foreach($this->AliquotMaster->find('all', array('conditions' => $conditions, 'order' => 'AliquotMaster.barcode ASC', 'recursive' => '0')) as $new_aliquot) {
				$result[$new_aliquot['AliquotMaster']['id']] = 
					__($conditions['AliquotControl.aliquot_type']).': '.
					$new_aliquot['AliquotMaster']['qcroc_barcode']. 
					(empty($new_aliquot['AliquotMaster']['aliquot_label'])? '' : ' ['.$new_aliquot['AliquotMaster']['aliquot_label'].']');					
			}
		}
		
		return $result;
	}
		
}

?>
