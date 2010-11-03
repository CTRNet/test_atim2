<?php

class SampleToAliquotControl extends InventoryManagementAppModel {
	
	var $belongsTo = array(
		'SampleControl' => array(
			'className'   => 'Inventorymanagement.SampleControl',
			'foreignKey'  => 'sample_control_id'),
		'AliquotControl' => array(
			'className'   => 'Inventorymanagement.AliquotControl',
			'foreignKey'  => 'aliquot_control_id'));  	

	/**
	 * Get permissible values array gathering all existing sample aliquot types 
	 * (realtions existing between sample type and aliquot type).
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'SampleControl.id|AliquotControl.id', 'default' => (translated string describing sample aliquot type))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getSampleAliquotTypesPermissibleValues() {
		// Get list of active sample type
		$conditions = array('ParentToDerivativeSampleControl.flag_active' => true);

		App::import("Model", "Inventorymanagement.ParentToDerivativeSampleControl");
		$this->ParentToDerivativeSampleControl = new ParentToDerivativeSampleControl();
		$controls = $this->ParentToDerivativeSampleControl->find('all', array('conditions' => $conditions, 'fields' => array('DerivativeControl.*')));
	
		$specimen_sample_control_ids_list = array();
		foreach($controls as $control){
			$specimen_sample_control_ids_list[] = $control['DerivativeControl']['id'];
		}		
		
		// Build final list
		$result = 
			$this->find('all', array(
				'conditions' => array(
					'SampleToAliquotControl.flag_active' => '1',
					'SampleControl.id' => $specimen_sample_control_ids_list),
				'order' => array('SampleControl.sample_type' => 'asc', 'AliquotControl.aliquot_type' => 'asc')));	

		$working_array = array();
		$last_sample_type = '';
		foreach($result as $new_sample_aliquot) {
			$sample_control_id = $new_sample_aliquot['SampleControl']['id'];
			$aliquot_control_id = $new_sample_aliquot['AliquotControl']['id'];
				
			$sample_type = $new_sample_aliquot['SampleControl']['sample_type'];
			$aliquot_type = $new_sample_aliquot['AliquotControl']['aliquot_type'];
				
			// New Sample Type
			if($last_sample_type != $sample_type) {
				// Add just sample type to the list
				$working_array[$sample_control_id.'|'] = __($sample_type, true);
			}
				
			// New Sample-Aliquot
			$working_array[$sample_control_id.'|'.$aliquot_control_id] = __($sample_type, true) . ' - '. __($aliquot_type, true);
		}
		asort($working_array);
		
		// Build final array
		$final_array = array();
		foreach($working_array as $value => $default) { $final_array[] = array('value' => $value, 'default' => $default); }
		
		return $final_array;
	}
			
}

?>
