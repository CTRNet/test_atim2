<?php
// Validations for Calgary brain bank misc identifiers

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

	function beforeSave($options) {
		
	/* 
		Check identifier type and apply validation rules.	
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
			case "Pathology Case Number":
				// Validate: SF 00-00000
				// 	Two letters usual possibilities are SF, SA, AA, BM
				// 	First two zeros indicate year of procedure
				// 	Five zeros after the hyphen indicate number assigned by hospital usually a chronological logging of procedures for the year
				if (preg_match("^\A\w{2}\s{1}\d{2}(-)\d{5}$^", $identifierValue)) {
					$value_validated = true;
				} else {
					$this->validationErrors['MiscIdentifier']['identifier_value'] = "npbttb Pathology Case Number validation error";
					$value_validated = false;
				}
				break;
				
			case "TTB Number":
				// Validate: 3 digit number
				if (preg_match("^\A\d{3}$^", $identifierValue)) {
					$value_validated = true;
				} else {
					$this->validationErrors['MiscIdentifier']['identifier_value'] = "npbttb TTB validation error";
					$value_validated = false;
				}				
				break;

			case "Medical Record Number":
				// Validate: 12 digits
				if (preg_match("^\A\d{12}$^", $identifierValue)) {
					$value_validated = true;
				} else {
					$this->validationErrors['MiscIdentifier']['identifier_value'] = "npbttb MRN validation error";
					$value_validated = false;
				}				
				break;

			case "MRN (Pre-2008)":
				// Validate: No validation
				if (preg_match("^[0-9]+$^", $identifierValue)) {
					$value_validated = true;
				} else {
					$this->validationErrors['MiscIdentifier']['identifier_value'] = "npbttb MRN (Pre-2008) validation error";
					$value_validated = false;
				}				
				break;								
			default:
				echo "DEFAULT";
				AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		return $value_validated;
	}
}
?>