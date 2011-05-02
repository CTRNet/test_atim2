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
		$this->SampleToAliquotControl = AppModel::atimNew("Inventorymanagement", "SampleToAliquotControl", true);
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
	
	function getPermissibleAliquotsArray($parent_sample_control_id){
		$conditions = array('SampleToAliquotControl.flag_active' => true,
			'SampleToAliquotControl.sample_control_id' => $parent_sample_control_id);
		
		$this->SampleToAliquotControl = AppModel::atimNew("Inventorymanagement", "SampleToAliquotControl", true);
		$controls = $this->SampleToAliquotControl->find('all', array('conditions' => $conditions, 'fields' => array('AliquotControl.*')));
		$aliquot_controls_list = array();
		foreach($controls as $control){
			$aliquot_controls_list[$control['AliquotControl']['id']]['AliquotControl'] = $control['AliquotControl'];	
		}
		return $aliquot_controls_list;
	}
}

?>
