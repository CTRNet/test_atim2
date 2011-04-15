<?php
if($this->data['MiscIdentifier']['misc_identifier_control_id'] == 9){
	//collection identifier, forbid deletion
	unset($final_options['links']['bottom']['delete']);
}