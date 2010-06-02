<?php

class SampleControl extends InventorymanagementAppModel {

 	/**
	 * Get permissible values array gathering all existing sample types.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'SampleControl.id', 'default' => (translated string describing sample type))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getSampleTypePermissibleValuesFromId() {		
		$result = array();
		$tmp_result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $sample_control) {
			$tmp_result[$sample_control['SampleControl']['id']] = __($sample_control['SampleControl']['sample_type'], true);
		}
		asort($tmp_result);
		
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}
	
 	/**
	 * Get permissible values array gathering all existing sample types.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'SampleControl.type', 'default' => (translated string describing sample type))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getSampleTypePermissibleValues() {		
		$result = array();
		$tmp_result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $sample_control) {
			$tmp_result[$sample_control['SampleControl']['sample_type']] = __($sample_control['SampleControl']['sample_type'], true);
		}
		asort($tmp_result);
		
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}
	
 	/**
	 * Get permissible values array gathering all existing specimen sample types.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'SampleControl.type', 'default' => (translated string describing sample type))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getSpecimenSampleTypePermissibleValues() {		
		$result = array();
		$tmp_result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1', 'sample_category' => 'specimen'))) as $sample_control) {
			$tmp_result[$sample_control['SampleControl']['sample_type']] = __($sample_control['SampleControl']['sample_type'], true);
		}
		asort($tmp_result);
		
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}		
	
}

?>