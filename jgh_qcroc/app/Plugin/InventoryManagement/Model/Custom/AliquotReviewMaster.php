<?php

class AliquotReviewMasterCustom extends AliquotReviewMaster {

	var $name = "AliquotReviewMaster";
	var $useTable = "aliquot_review_masters";
	
	function generateLabelOfReviewedAliquot($aliquot_master_id, $aliquot_data = null) {
		if(!($aliquot_data && isset($aliquot_data['AliquotMaster']))) {		
			if(!isset($this->AliquotMaster)) {
				$this->AliquotMaster = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
			}
			$aliquot_data = $this->AliquotMaster->getOrRedirect($aliquot_master_id);
		}
		return $aliquot_data['AliquotMaster']['aliquot_label'].' ['.$aliquot_data['AliquotMaster']['barcode'].']';
	}	
}

?>
