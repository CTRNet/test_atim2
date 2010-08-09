<?php
class MiscIdentifierControl extends ClinicalannotationAppModel {
	
 	/**
	 * Get permissible values array gathering all existing misc identifier names.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'MiscIdentifierControl.misc_identifier_name', 'default' => (translated string describing misc identifier name))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getMiscIdentifierNamePermissibleValues() {
		$result = array();
		$tmp_result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $ident_ctrl) {
			$tmp_result[$ident_ctrl['MiscIdentifierControl']['id']] = __($ident_ctrl['MiscIdentifierControl']['misc_identifier_name'], true);
		}
		asort($tmp_result);
		
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}
	
 	/**
	 * Get permissible values array gathering all existing misc identifier abreviation.
	 *
	 * @return Array having following structure:
	 * 	array ('value' => 'MiscIdentifierControl.misc_identifier_name_abbrev', 'default' => (translated string describing misc identifier name abreviation))
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getMiscIdentifierNameAbrevPermissibleValues() {
		$result = array();
		$tmp_result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $ident_ctrl) {
			$tmp_result[$ident_ctrl['MiscIdentifierControl']['misc_identifier_name_abbrev']] = __($ident_ctrl['MiscIdentifierControl']['misc_identifier_name_abbrev'], true);
		}
		asort($tmp_result);
		
		// Build final array
		foreach($tmp_result as $value => $default) { $result[] = array('value' => $value, 'default' => $default); }
		
		return $result;
	}	
	
}

?>