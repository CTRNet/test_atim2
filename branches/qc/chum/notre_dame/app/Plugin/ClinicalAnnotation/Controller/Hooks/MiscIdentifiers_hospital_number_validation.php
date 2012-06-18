<?php
//for hospital numbers, validate that they start with the proper hospital letter
$prefix = null;
switch($this->data['MiscIdentifier']['misc_identifier_control_id']){
	case 8:
		$prefix = 'H';
		break;
	case 9:
		$prefix = 'N';
		break;
	case 10:
		$prefix = 'S';
		break;
	default:
}
if($prefix && !preg_match('/^'.$prefix.'[0-9]+$/', $this->data['MiscIdentifier']['identifier_value'])){
	$this->MiscIdentifier->validationErrors['MiscIdentifier.identifier_value'] = sprintf(__('this hospital identifier must start with capital letter %s and be followed by numbers', true), $prefix);
	$submitted_data_validates = false;
}
