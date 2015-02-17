<?php
// Validations for CCBR Misc Identifiers

class MiscIdentifierCustom extends MiscIdentifier {
	var $name = 'MiscIdentifier';
	var $useTable = 'misc_identifiers';

	var $belongsTo = array(
		'Participant' => array(
			'className' => 'ClinicalAnnotation.Participant',
			'foreignKey' => 'participant_id'),
		'MiscIdentifierControl' => array(
			'className' => 'ClinicalAnnotation.MiscIdentifierControl',
			'foreignKey' => 'misc_identifier_control_id'
		)
	);

	function beforeSave($options = Array()) {
		
	/* 
		Check identifier type and apply validation rules. Three types are defined as:
			MRN - Hospital number, 7 consecutive digits
			PHN - Personal Health Number. 3 sets of 3 digits, with spaces
			COG Registration - 6 characters
	*/

		// Get control ID for current identifier
		$previousMiscIdData = null;
		$miscIdentifierControlId = array_key_exists('misc_identifier_control_id', $this->data['MiscIdentifier'])? $this->data['MiscIdentifier']['misc_identifier_control_id'] : null;
		
		$previousMiscIdData = null;
			
		if(is_null($miscIdentifierControlId)) {

			$previousMiscIdData = $this->find('first', array('conditions' => array ('MiscIdentifier.id' => $this->id), 'recursive' => '-1'));
			if(empty($previousMiscIdData)) {
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
			$miscIdentifierControlId = $previousMiscIdData['MiscIdentifier']['misc_identifier_control_id'];	
		}	
		
		// Get control data for current identifier
		$miscIdentControlData = array();
		$miscIdentControlModel = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifierControl", true);
		$miscIdentControlData = $miscIdentControlModel->find('first', array('conditions' => array ('MiscIdentifierControl.id' => $miscIdentifierControlId)));
			
		if (empty($miscIdentControlData)) {
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}	

		// Execute appropriate validation depending on identifier name
		$value_validated = false;
		$identifierValue = null;

		$deleted = array_key_exists('deleted', $this->data['MiscIdentifier'])? $this->data['MiscIdentifier']['deleted'] : null;
			
		if ($deleted) {
			$identifierValue = $previousMiscIdData['MiscIdentifier']['identifier_value'];
		} else {
			$identifierValue = $this->data['MiscIdentifier']['identifier_value'];
		}		
		
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
				// Validate: DDDD DDD DDD
				if (preg_match("^\d{4}\s{1}\d{3}\s{1}\d{3}$^", $identifierValue)) {
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

			case "CCBR Identifier":
				// Validate: Starts with 'CCBR' then any number of digits
				if (preg_match("^\ACCBR[0-9]+$^", $identifierValue)) {
					$value_validated = true;
				} else {
					$this->validationErrors['MiscIdentifier']['identifier_value'] = "ccbr validation error";
					$value_validated = false;
				}				
				break;
								
			default:
				echo "No defined validation! See administrator!";
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		return $value_validated;
	}
}
?>