<?php

//TODO 2013-02-13 temporary control before to hide all cap reports
$this->set('hide_edit_button', ((strpos($this->request->data['EventControl']['event_type'], 'cap report') !== false)? true : false));
	
?>