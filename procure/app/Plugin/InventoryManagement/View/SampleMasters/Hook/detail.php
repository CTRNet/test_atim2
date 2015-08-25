<?php 

	unset($final_options['links']['bottom']['print barcodes']);
	unset($structure_links['bottom']['print barcodes']);

	if(Configure::read('procure_atim_version') != 'BANK') {
		if(!$sample_master_data['SampleMaster']['procure_created_by_bank'] != 'p') {
			unset($final_options['links']['bottom']['add derivative']);
			unset($structure_links['bottom']['add derivative']);
			unset($final_options['links']['bottom']['add aliquot']);
			unset($structure_links['bottom']['add aliquot']);
			unset($final_options['links']['bottom']['edit']);
			unset($structure_links['bottom']['edit']);
		}
	}
	
?>
