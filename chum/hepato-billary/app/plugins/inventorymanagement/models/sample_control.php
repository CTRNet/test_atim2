<?php

class SampleControl extends InventorymanagementAppModel {

 	/**
	 * Get permissible values array gathering all existing sample types.
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getSampleTypePermissibleValuesFromId() {		
		return $this->getSamplesPermissibleValues(true, false);
	}
	
 	/**
	 * Get permissible values array gathering all existing sample types.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getSampleTypePermissibleValues() {
		return $this->getSamplesPermissibleValues(false, false);
	}
	
 	/**
	 * Get permissible values array gathering all existing specimen sample types.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getSpecimenSampleTypePermissibleValues() {		
		return $this->getSamplesPermissibleValues(false, true);
	}
	
 	/**
	 * Get permissible values array gathering all existing specimen sample types.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getSpecimenSampleTypePermissibleValuesFromId() {		
		return $this->getSamplesPermissibleValues(true, true);
	}
	
	function getSamplesPermissibleValues($by_id, $only_specimen){
		$result = array();
		
		// Build tmp array to sort according translation
		$this->ParentToDerivativeSampleControl = AppModel::atimNew("Inventorymanagement", "ParentToDerivativeSampleControl", true);
		$conditions = array('ParentToDerivativeSampleControl.flag_active' => true);
		if($only_specimen){
			$conditions['DerivativeControl.sample_category'] = 'specimen';
		}
		$controls = $this->ParentToDerivativeSampleControl->find('all', array('conditions' => $conditions, 'fields' => array('DerivativeControl.*')));
		if($by_id){
			foreach($controls as $control){
				$result[$control['DerivativeControl']['id']] = __($control['DerivativeControl']['sample_type'], true);
			}
		}else{
			foreach($controls as $control){
				$result[$control['DerivativeControl']['sample_type']] = __($control['DerivativeControl']['sample_type'], true);
			}
		}
		asort($result);
		
		return $result;
	}
	
	/**
	 * Gets a list of sample types that could be created from a sample type.
	 *
	 * @param $sample_control_id ID of the sample control linked to the studied sample.
	 * 
	 * @return List of allowed aliquot types stored into the following array:
	 * 	array('aliquot_control_id' => 'aliquot_type')
	 * 
	 * @author N. Luc
	 * @since 2009-11-01
	 * @author FMLH 2010-08-04 (new flag_active policy)
	 */
	function getPermissibleSamplesArray($parent_id){
		$conditions = array('ParentToDerivativeSampleControl.flag_active' => true);
		if($parent_id == null){
			$conditions[] = 'ParentToDerivativeSampleControl.parent_sample_control_id IS NULL';
		}else{
			$conditions['ParentToDerivativeSampleControl.parent_sample_control_id'] = $parent_id;
		}
		
		$this->ParentToDerivativeSampleControl = AppModel::atimNew("Inventorymanagement", "ParentToDerivativeSampleControl", true);
		$controls = $this->ParentToDerivativeSampleControl->find('all', array('conditions' => $conditions, 'fields' => array('DerivativeControl.*')));
		$specimen_sample_controls_list = array();
		foreach($controls as $control){
			$specimen_sample_controls_list[$control['DerivativeControl']['id']]['SampleControl'] = $control['DerivativeControl'];	
		}
		return $specimen_sample_controls_list;
	}
	
}

?>