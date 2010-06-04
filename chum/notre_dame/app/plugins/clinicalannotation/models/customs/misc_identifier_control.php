<?php
class MiscIdentifierControlCustom extends MiscIdentifierControl {

	var $useTable = 'misc_identifier_controls';
	var $name = 'MiscIdentifierControl';
		
	function getMisIdentPermissibleValuesFromId() {
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
	
}

?>