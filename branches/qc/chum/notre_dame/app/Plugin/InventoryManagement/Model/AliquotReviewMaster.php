<?php

class AliquotReviewMaster extends InventoryManagementAppModel {

	var $belongsTo = array(
		'AliquotMaster' => array(
			'className'	=> 'InventoryManagement.AliquotMaster',
			'foreignKey' => 'aliquot_master_id'        
		), 'AliquotReviewControl' => array(            
			'className'    => 'InventoryManagement.AliquotReviewControl',            
			'foreignKey'    => 'aliquot_review_control_id'
		), 'SpecimenReviewMaster' => array(
			'className' => 'InventoryManagement.SpecimenReviewMaster',
			'foreignKey' => 'specimen_review_master_id'
		)
	);
	
	var $registered_view = array(
			'InventoryManagement.ViewAliquotUse' => array('AliquotReviewMaster.id')
	);
		
	/**
	 * Get permissible values array gathering all existing aliquots that could be used for review.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
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
					$result[$new_aliquot['AliquotMaster']['id']] = $this->generateLabelOfReviewedAliquot($new_aliquot['AliquotMaster']['id'], $new_aliquot);					
			}
		}
		
		return $result;
	}
	
	function generateLabelOfReviewedAliquot($aliquot_master_id, $aliquot_data = null) {
		if(!($aliquot_data && isset($aliquot_data['AliquotMaster']))) {		
			if(!isset($this->AliquotMaster)) {
				$this->AliquotMaster = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
			}
			$aliquot_data = $this->AliquotMaster->getOrRedirect($aliquot_master_id);
		}
		return $aliquot_data['AliquotMaster']['barcode'];
	}
	
	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);	
		foreach($results as &$new_review) {
			$new_review['Generated']['reviewed_aliquot_label_for_display'] = (isset($new_review['AliquotMaster']) && $new_review['AliquotMaster']['id'])? $this->generateLabelOfReviewedAliquot($new_review['AliquotMaster']['id'], $new_review) : '';
		}
		return $results;
	}
	
		
}

?>
