<?php

class SpecimenReviewControl extends InventoryManagementAppModel {
	
	var $master_form_alias = 'specimen_review_masters';
	
	var $belongsTo = array(       
		'AliquotReviewControl' => array(           
			'className'    => 'InventoryManagement.AliquotReviewControl',            
			'foreignKey'    => 'aliquot_review_control_id'),
		'SampleControl' => array(
			'className'   => 'InventoryManagement.SampleControl',
			 	'foreignKey'  => 'sample_control_id'));
	
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
			$result[$new_control['SpecimenReviewControl']['sample_control_id']] = __($new_control['SampleControl']['sample_type']);
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
			$result[$new_control['SpecimenReviewControl']['review_type']] = __($new_control['SpecimenReviewControl']['review_type']);
		}
				
		return $result;
	}
}

?>
