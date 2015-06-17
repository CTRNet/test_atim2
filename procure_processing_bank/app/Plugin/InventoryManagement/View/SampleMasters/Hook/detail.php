<?php 

	unset($final_options['links']['bottom']['print barcodes']);
	unset($structure_links['bottom']['print barcodes']);
	//ATiM PROCURE PROCESSING BANK
	if($procure_sample_created_by_system) {
		unset($final_options['links']['bottom']['add derivative']);
		unset($structure_links['bottom']['add derivative']);
		unset($final_options['links']['bottom']['add aliquot']);
		unset($structure_links['bottom']['add aliquot']);
		unset($final_options['links']['bottom']['edit']);
		unset($structure_links['bottom']['edit']);
	}
	//END ATiM PROCURE PROCESSING BANK
	
?>
