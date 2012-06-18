<?php
if(isset($this->data['MiscIdentifierControl']['id'])){
	if($this->data['MiscIdentifierControl']['id'] == 10){
		$final_options['override'] = array('MiscIdentifier.identifier_value' => 'NEO-');
	}else if($this->data['MiscIdentifierControl']['id'] == 11){
		$final_options['override'] = array('MiscIdentifier.identifier_value' => 'MET-');
	}
}