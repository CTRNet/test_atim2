<?php

class AliquotReviewMaster extends InventoryManagementAppModel {

	var $belongsTo = array(        
		'AliquotReviewControl' => array(            
			'className'    => 'Inventorymanagement.AliquotReviewControl',            
			'foreignKey'    => 'aliquot_review_control_id'));
		
	/**
	 * Get permissible values array gathering all existing aliquots that could be used for review.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getAliquotListForReview($sample_master_id = null, $specific_aliquot_type = null) {
		$result = array();
		
		if(!empty($sample_master_id)) {
			if(!isset($this->AliquotMaster)) {
				App::import("Model", "Inventorymanagement.AliquotMaster");
				$this->AliquotMaster = new AliquotMaster();
			}
			
			$conditions = array('AliquotMaster.sample_master_id' => $sample_master_id);
			if(!empty($specific_aliquot_type)){
				$conditions['AliquotMaster.aliquot_type'] = $specific_aliquot_type;
			}
			
			foreach($this->AliquotMaster->find('all', array('conditions' => $conditions, 'order' => 'AliquotMaster.barcode ASC', 'recursive' => '-1')) as $new_aliquot) {
					$result[$new_aliquot['AliquotMaster']['id']] = $new_aliquot['AliquotMaster']['barcode'];					
			}
		}
		
		return $result;
	}
		
}

?>
