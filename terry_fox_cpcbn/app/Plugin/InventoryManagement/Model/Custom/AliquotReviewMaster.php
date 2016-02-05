<?php
class AliquotReviewMasterCustom extends AliquotReviewMaster {

	var $useTable = 'aliquot_review_masters';	
	var $name = 'AliquotReviewMaster';	
	
	function generateLabelOfReviewedAliquot($aliquot_master_id, $aliquot_data = null) {
		if(!$aliquot_data || !isset($aliquot_data['ViewAliquot'])) {
			$ViewAliquotModel = AppModel::getInstance('InventoryManagement', 'ViewAliquot', true);
			$aliquot_data = $ViewAliquotModel->find('first', array('conditions' => array('ViewAliquot.aliquot_master_id' => $aliquot_master_id), 'recursive' => '-1'));
		}
		return $aliquot_data['ViewAliquot']['barcode'].' ['.$aliquot_data['ViewAliquot']['procure_generated_label_for_display'].']';
	}
}

?>
