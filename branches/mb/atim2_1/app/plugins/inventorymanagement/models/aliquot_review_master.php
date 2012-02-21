<?php

class AliquotReviewMaster extends InventoryManagementAppModel {

	var $belongsTo = array(        
		'AliquotReviewControl' => array(            
			'className'    => 'Inventorymanagement.AliquotReviewControl',            
			'foreignKey'    => 'aliquot_review_control_id'));
		
	/**
	 * Get permissible values array gathering all existing aliquots that could be used for review.
	 *
	 * @return Array having following structure:
	 * 	if $is_for_override = false		
	 * 		array ('value' => 'AliquotMaster.id', 'default' => (translated string describing aliquot))
	 * 	if $is_for_override = true		
	 * 		array (AliquotMaster.id => (translated string describing aliquot)
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getAliquotListForReview($is_for_override = false, $sample_master_id = null, $specific_aliquot_type = null) {
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
				if($is_for_override) {
					$result[$new_aliquot['AliquotMaster']['id']] = $new_aliquot['AliquotMaster']['barcode'];					
				} else {
					$result[] = array(
						'value' => $new_aliquot['AliquotMaster']['id'],
						'default' => $new_aliquot['AliquotMaster']['barcode'], true);					
				}
			}
		}
		
		return $result;
	}
		
}

?>
