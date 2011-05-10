<?php

	//build default collection label and collection date	
	$default_label = empty($ccl_data)? '??' : strtoupper(substr($ccl_data['Participant']['first_name'], 0, 1).substr($ccl_data['Participant']['last_name'], 0, 1));
	$default_label .= date('ymd');
	
	$this->set('default_acquisition_label', $default_label);
	$this->set('default_collection_datetime', date('Y-m-d'). ' 00:00');