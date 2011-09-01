<?php

class AliquotControl extends InventorymanagementAppModel {

 	/**
	 * Get permissible values array gathering all existing aliquot types.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getAliquotTypePermissibleValuesFromId() {
		return $this->getAliquotsTypePermissibleValues(true, null);
	}
	
	/**
	 * Get permissible values array gathering all existing aliquot types.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getAliquotTypePermissibleValues() {
		return $this->getAliquotsTypePermissibleValues(false, null);
	}
	
	function getAliquotsTypePermissibleValues($use_id, $parent_sample_control_id){
		$result = array();
		
		// Build tmp array to sort according translation
		$conditions = array('AliquotControl.flag_active' => 1);
		if($parent_sample_control_id != null){
			$conditions['AliquotControl.sample_control_id'] = $parent_sample_control_id;
		}
		
		if($use_id){
			$this->bindModel(
				array('belongsTo' => array(
					'SampleControl'	=> array(
						'className'  	=> 'Inventorymanagement.SampleControl',
						'foreignKey'	=> 'sample_control_id'))));
			$aliquot_controls = $this->find('all', array('conditions' => $conditions));
			foreach($aliquot_controls as $aliquot_control) {
				$aliquot_type_precision = $aliquot_control['AliquotControl']['aliquot_type_precision'];
				$result[$aliquot_control['AliquotControl']['id']] = __($aliquot_control['AliquotControl']['aliquot_type'], true) 
					. ' ['.__($aliquot_control['SampleControl']['sample_type'], true)
					. (empty($aliquot_type_precision)? '' :  ' - ' . __($aliquot_type_precision, true)) . ']';
			}
		}else{
			$aliquot_controls = $this->find('all', array('conditions' => $conditions));
			foreach($aliquot_controls as $aliquot_control) {
				$result[$aliquot_control['AliquotControl']['aliquot_type']] = __($aliquot_control['AliquotControl']['aliquot_type'], true);
			}
		}
		asort($result);
		
		return $result;
	}
	
	function getPermissibleAliquotsArray($parent_sample_control_id){
		$conditions = array('AliquotControl.flag_active' => true,
			'AliquotControl.sample_control_id' => $parent_sample_control_id);
		
		$controls = $this->find('all', array('conditions' => $conditions));
		$aliquot_controls_list = array();
		foreach($controls as $control){
			$aliquot_controls_list[$control['AliquotControl']['id']]['AliquotControl'] = $control['AliquotControl'];	
		}
		return $aliquot_controls_list;
	}
	
	/**
	 * Get permissible values array gathering all existing sample aliquot types 
	 * (realtions existing between sample type and aliquot type).
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getSampleAliquotTypesPermissibleValues() {
		// Get list of active sample type
		$conditions = array('ParentToDerivativeSampleControl.flag_active' => true);

		$this->ParentToDerivativeSampleControl = AppModel::getInstance("Inventorymanagement", "ParentToDerivativeSampleControl", true);
		$controls = $this->ParentToDerivativeSampleControl->find('all', array('conditions' => $conditions, 'fields' => array('DerivativeControl.*')));
	
		$specimen_sample_control_ids_list = array();
		foreach($controls as $control){
			$specimen_sample_control_ids_list[] = $control['DerivativeControl']['id'];
		}		
		
		// Build final list
		$this->bindModel(
			array('belongsTo' => array(
				'SampleControl'	=> array(
					'className'  	=> 'Inventorymanagement.SampleControl',
					'foreignKey'	=> 'sample_control_id'))));
		$result = 
			$this->find('all', array(
				'conditions' => array(
					'AliquotControl.flag_active' => '1',
					'AliquotControl.sample_control_id' => $specimen_sample_control_ids_list),
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
		
		return $working_array;
	}
}

?>
