<?php

class SampleControl extends InventoryManagementAppModel {
	
	var $master_form_alias = 'sample_masters';

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

	function getParentSampleTypePermissibleValuesFromId() {		
		return $this->getSamplesPermissibleValues(true, false, false);
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
	
	function getParentSampleTypePermissibleValues() {
		return $this->getSamplesPermissibleValues(false, false, false);
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
	
	function getSamplesPermissibleValues($by_id, $only_specimen, $all = true){
		$result = array();
		
		// Build tmp array to sort according translation
		$this->ParentToDerivativeSampleControl = AppModel::getInstance("InventoryManagement", "ParentToDerivativeSampleControl", true);
		$conditions = array('ParentToDerivativeSampleControl.flag_active' => true);
		if($only_specimen){
			$conditions['DerivativeControl.sample_category'] = 'specimen';
		}
		$controls = null;
		$model_name = null;
		if($all){
			$model_name = 'DerivativeControl';
			$controls = $this->ParentToDerivativeSampleControl->find('all', array('conditions' => $conditions, 'fields' => array('DerivativeControl.*')));
		}else{
			$model_name = 'ParentSampleControl';
			$conditions['NOT'] = array('ParentToDerivativeSampleControl.parent_sample_control_id' => NULL);
			$controls = $this->ParentToDerivativeSampleControl->find('all', array(
				'conditions' => $conditions,
				'fields' => array('ParentSampleControl.id', 'ParentSampleControl.sample_type'))
			);
		}
		
		if($by_id){
			foreach($controls as $control){
				$result[$control[$model_name]['id']] = __($control[$model_name]['sample_type']);
			}
		}else{
			foreach($controls as $control){
				$result[$control[$model_name]['sample_type']] = __($control[$model_name]['sample_type']);
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
		
		$this->ParentToDerivativeSampleControl = AppModel::getInstance("InventoryManagement", "ParentToDerivativeSampleControl", true);
		$controls = $this->ParentToDerivativeSampleControl->find('all', array('conditions' => $conditions, 'fields' => array('DerivativeControl.*')));
		$specimen_sample_controls_list = array();
		foreach($controls as $control){
			$specimen_sample_controls_list[$control['DerivativeControl']['id']]['SampleControl'] = $control['DerivativeControl'];	
		}
		return $specimen_sample_controls_list;
	}
	
}

?>