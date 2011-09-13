<?php

	//build default collection label and collection date	
	$this->set('default_acquisition_label', (empty($ccl_data)? '??' : $ccl_data['Participant']['qc_ldov_initals']).date('ymd'));
	$this->set('default_collection_datetime', date('Y-m-d'). ' 00:00');