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
		
	/* 
		Check identifier type and apply validation rules. Three types are defined as:
			MRN - Hospital number, 7 consecutive digits
			PHN - Personal Health Number. 3 sets of 3 digits, with spaces
			COG Registration - 6 characters
	*/

		// Get control ID for current identifier
		$previousMiscIdData = null;
		$miscIdentifierControlId = array_key_exists('misc_identifier_control_id', $this->data['MiscIdentifier'])? $this->data['MiscIdentifier']['misc_identifier_control_id'] : null;
			
		if(is_null($miscIdentifierControlId)) {

			$previousMiscIdData = $this->find('first', array('conditions' => array ('MiscIdentifier.id' => $this->id), 'recursive' => '-1'));
			if(empty($previousMiscIdData)) {
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			$miscIdentifierControlId = $previousMiscIdData['MiscIdentifier']['misc_identifier_control_id'];	
		}
		
		// Get control data for current identifier
		$miscIdentControlModel = AppModel::getInstance("Clinicalannotation", "MiscIdentifierControl", true);
		$miscIdentControlData = $miscIdentControlModel->find('first', array('conditions' => array ('MiscIdentifierControl.id' => $miscIdentifierControlId)));
			
		if (empty($miscIdentControlData)) {
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}	

		// Execute appropriate validation depending on identifier name
		$value_validated = false;
		$error_message = null;
		$identifierValue = $this->data['MiscIdentifier']['identifier_value'];
				
		switch ($miscIdentControlData['MiscIdentifierControl']['misc_identifier_name']) {
			case "MRN":
				// Validate: 7 digits 
				if (preg_match("^\A[\d]{7}$^", $identifierValue)) {
					$value_validated = true;
				} else {
					$this->validationErrors['MiscIdentifier']['identifier_value'] = "ccbr MRN validation error";
					$value_validated = false;
				}
				break;
				
			case "PHN":
				// Validate: 3 sets of 3 digits, with spaces between groups of 3 digits e.g. 111 222 333 ^([\d]{3} ){2}[\d]{3}$
				if (preg_match("^([\d]{3} ){2}[\d]{3}$^", $identifierValue)) {
					$value_validated = true;
				} else {
					$this->validationErrors['MiscIdentifier']['identifier_value'] = "ccbr PHN validation error";
					$value_validated = false;
				}				
				break;
				
			case "COG Registration":
				// Validate: 6 characters 
				if (preg_match("^\A[\w]{6,6}$^", $identifierValue)) {
					$value_validated = true;
				} else {
					$this->validationErrors['MiscIdentifier']['identifier_value'] = "ccbr COG validation error";
					$value_validated = false;
				}				
				break;
				
			default:
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		if (!$value_validated) {
			// Display appropriate validation error message
		}

		return $value_validated;
	}
}
?>