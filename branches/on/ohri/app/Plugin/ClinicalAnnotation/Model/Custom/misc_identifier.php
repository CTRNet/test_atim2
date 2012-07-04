<?php

class MiscIdentifierCustom extends MiscIdentifier
{

	var $useTable = 'misc_identifiers';
	var $name = 'MiscIdentifier';
	
	function isDuplicatedIdentifierValue($misc_identifier_control_id, $identifier_value) {
		$criteria = array(
			'MiscIdentifier.misc_identifier_control_id '=>$misc_identifier_control_id, 
			'MiscIdentifier.identifier_value '=>$identifier_value);
		$misc_identifier_data = $this->find('first', array('conditions'=>$criteria, 'recursive' => '0'));		
		
		return (empty($misc_identifier_data)? true : false);		
	}
}

?>