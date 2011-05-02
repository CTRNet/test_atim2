<?php

class SpecimenReviewControl extends InventoryManagementAppModel {
	
	var $belongsTo = array(       
		'AliquotReviewControl' => array(           
			'className'    => 'Inventorymanagement.AliquotReviewControl',            
			'foreignKey'    => 'aliquot_review_control_id'));
	
	/**
	 * Get permissible values array gathering all existing specimen type of reviews.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getSpecimenTypePermissibleValues() {
		$result = array();

		foreach($this->find('all', array('conditions' => array('SpecimenReviewControl.flag_active' => 1))) as $new_control) {
			$result[$new_control['SpecimenReviewControl']['specimen_sample_type']] = __($new_control['SpecimenReviewControl']['specimen_sample_type'], true);
		}
				
		return $result;
	}

	/**
	 * Get permissible values array gathering all existing specimen review type.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getReviewTypePermissibleValues() {
		$result = array();

		foreach($this->find('all', array('conditions' => array('SpecimenReviewControl.flag_active' => 1))) as $new_control) {
			$result[$new_control['SpecimenReviewControl']['review_type']] = __($new_control['SpecimenReviewControl']['review_type'], true);
		}
				
		return $result;
	}
}

?>
