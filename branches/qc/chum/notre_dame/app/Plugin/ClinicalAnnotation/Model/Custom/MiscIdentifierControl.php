<?php
class MiscIdentifierControlCustom extends MiscIdentifierControl {
	var $useTable = 'misc_identifier_controls';
	var $name = "MiscIdentifierControl";
		
	function getIcmBankIdentifierNamesFromId() {
		$result = array();
		 
		$conditions = array('flag_active = 1', "misc_identifier_name LIKE '%bank no lab'");
		foreach($this->find('all', array('conditions' => $conditions)) as $ident_ctrl) {
			$result[$ident_ctrl['MiscIdentifierControl']['id']] = __($ident_ctrl['MiscIdentifierControl']['misc_identifier_name'], true);
		}
		asort($result);
		
		return $result;
	}
	
}

?>