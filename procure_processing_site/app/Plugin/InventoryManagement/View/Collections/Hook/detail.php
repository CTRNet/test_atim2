<?php 
	unset($structure_links['bottom']['print barcodes']);
	unset($final_options['links']['bottom']['print barcodes']);
	
	if(Configure::read('procure_atim_version') != 'BANK') {
		unset($structure_links['bottom']['add specimen']);
		unset($final_options['links']['bottom']['add specimen']);
	}
