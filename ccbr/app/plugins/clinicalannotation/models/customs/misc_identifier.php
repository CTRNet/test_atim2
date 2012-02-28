<?php
// Validations for CCBR Misc Identifiers

class MiscIdentifierCustom extends MiscIdentifier {
	var $name = 'MiscIdentifier';
	var $useTable = 'misc_identifiers';

	var $belongsTo = array(
		'Participant' => array(
			'className' => 'Clinicalannotation.Participant',
			'foreignKey' => 'participant_id'),
		'MiscIdentifierControl' => array(
			'className' => 'Clinicalannotation.MiscIdentifierControl',
			'foreignKey' => 'misc_identifier_control_id'
		)
	);

	function beforeSave($options) {
		// Check that value is set
		// If so, check identifer type
	}
	
}
?>