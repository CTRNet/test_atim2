<?php
class MiscIdentifierControl extends ClinicalannotationAppModel {
	private $confidential_ids = null;
	
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

	function getConfidentialIds(){
		if($this->confidential_ids == null){
			$misc_controls = $this->find('all', array('fields' => array('MiscIdentifierControl.id'), 'conditions' => array('flag_confidential' => 1)));
			$this->confidential_ids = array();
			foreach($misc_controls as $misc_control){
				$this->confidential_ids[] = $misc_control['MiscIdentifierControl']['id'];
			}
		}
		return $this->confidential_ids;
	}
	
}

?>