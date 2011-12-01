<?php
//Put the prefix letter associated to each hospital number
$control_id = isset($this->data['MiscIdentifierControl']['id']) ? $this->data['MiscIdentifierControl']['id'] : $this->data['MiscIdentifier']['misc_identifier_control_id']; 
switch($control_id){
	case 8:
		$final_options['override']['MiscIdentifier.identifier_value'] = 'H';
		break;
	case 9:
		$final_options['override']['MiscIdentifier.identifier_value'] = 'N';
		break;
	case 10:
		$final_options['override']['MiscIdentifier.identifier_value'] = 'S';
		break;
	default:
		
}