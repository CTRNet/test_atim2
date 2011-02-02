<?php
class MiscIdentifierControl extends ClinicalannotationAppModel {
	
 	/**
	 * Get permissible values array gathering all existing misc identifier names.
	 * 
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getMiscIdentifierNamePermissibleValues() {
		$result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $ident_ctrl) {
			$result[$ident_ctrl['MiscIdentifierControl']['misc_identifier_name']] = __($ident_ctrl['MiscIdentifierControl']['misc_identifier_name'], true);
		}
		asort($result);
		
		return $result;
	}
	
 	/**
	 * Get permissible values array gathering all existing misc identifier names.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getMiscIdentifierNamePermissibleValuesFromId() {
		$result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $ident_ctrl) {
			$result[$ident_ctrl['MiscIdentifierControl']['id']] = __($ident_ctrl['MiscIdentifierControl']['misc_identifier_name'], true);
		}
		asort($result);
		
		return $result;
	}
	
 	/**
	 * Get permissible values array gathering all existing misc identifier abreviation.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getMiscIdentifierNameAbrevPermissibleValues() {
		$result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('conditions' => array('flag_active = 1'))) as $ident_ctrl) {
			$result[$ident_ctrl['MiscIdentifierControl']['misc_identifier_name_abbrev']] = __($ident_ctrl['MiscIdentifierControl']['misc_identifier_name_abbrev'], true);
		}
		asort($result);

		return $result;
	}	
	
}

?>