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
	
	function getAliquotsTypePermissibleValues($use_id, $parent_sample_id){
		$result = array();
		
		// Build tmp array to sort according translation
		App::import("Model", "Inventorymanagement.SampleToAliquotControl");
		$this->SampleToAliquotControl = new SampleToAliquotControl();
		$conditions = array('SampleToAliquotControl.flag_active' => 1);
		if($parent_sample_id != null){
			$conditions['SampleToAliquotControl.sample_control_id'] = $parent_sample_id;
		}
		$aliquot_controls = $this->SampleToAliquotControl->find('all', array('conditions' => $conditions, 'group' => array('SampleToAliquotControl.aliquot_control_id'), 'field' => array('AliquotControl.*')));
		if($use_id){
			foreach($aliquot_controls as $aliquot_control) {
				$aliquot_type_precision = $aliquot_control['AliquotControl']['aliquot_type_precision'];
				$result[$aliquot_control['AliquotControl']['id']] = __($aliquot_control['AliquotControl']['aliquot_type'], true) 
					. (empty($aliquot_type_precision)? '' :  ' [' . __($aliquot_type_precision, true) . ']');
			}
		}else{
			foreach($aliquot_controls as $aliquot_control) {
				$result[$aliquot_control['AliquotControl']['aliquot_type']] = __($aliquot_control['AliquotControl']['aliquot_type'], true);
			}
		}
		asort($result);
		
		return $result;
	}
	
	/**
	 * Get Aliquot data to display into aliquots list view:
	 *   - Will poulate fields
	 *         . GeneratedParentSample.*
	 *         . Generated.aliquot_use_counter 
	 *         . Generated.realiquoting_data 
	 *
	 *	@param $criteria Aliquot Search Criteria
	 *
	 * @return aliquot_data
	 *
	 * @author N. Luc
	 * @since 2009-09-11
	 * @updated N. Luc
	 * @author FMLH - 2010-08-04 (new flag_active policy) 
	 */
	
	function getPermissibleAliquotsArray($parent_sample_control_id){
		$conditions = array('SampleToAliquotControl.flag_active' => true,
			'SampleToAliquotControl.sample_control_id' => $parent_sample_control_id);
		
		App::import("Model", "Inventorymanagement.SampleToAliquotControl");
		$this->SampleToAliquotControl = new SampleToAliquotControl();
		$controls = $this->SampleToAliquotControl->find('all', array('conditions' => $conditions, 'fields' => array('AliquotControl.*')));
		$aliquot_controls_list = array();
		foreach($controls as $control){
			$aliquot_controls_list[$control['AliquotControl']['id']]['AliquotControl'] = $control['AliquotControl'];	
		}
		return $aliquot_controls_list;
	}
}

?>
