<?php

class AliquotReviewMasterCustom extends AliquotReviewMaster {

	var $useTable = 'aliquot_review_masters';	
	var $name = 'AliquotReviewMaster';	
		
	function generateLabelOfReviewedAliquot($aliquot_master_id, $aliquot_data = null) {
		if(!($aliquot_data && isset($aliquot_data['AliquotMaster']))) {		
			if(!isset($this->AliquotMaster)) {
				$this->AliquotMaster = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
			}
			$aliquot_data = $this->AliquotMaster->getOrRedirect($aliquot_master_id);
		}
		return $aliquot_data['AliquotMaster']['aliquot_label'].' ['.(isset($aliquot_data['AliquotControl']['aliquot_type'])? __($aliquot_data['AliquotControl']['aliquot_type']) : '').' - '.$aliquot_data['AliquotMaster']['barcode'].']';
	}
}

?>
