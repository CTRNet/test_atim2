<?php

$ovcare_file_input_data = array();
if(!empty($this->data) && array_key_exists('OvcareFunctionManagement', $this->data)) {
	if(!array_key_exists('file_input', $this->data['OvcareFunctionManagement'])) $this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
	$ovcare_file_input_data = $this->data['OvcareFunctionManagement'];
	unset($this->data['OvcareFunctionManagement']);
}
