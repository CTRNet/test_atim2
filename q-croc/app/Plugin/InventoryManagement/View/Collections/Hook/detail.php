<?php 
	unset($structure_links['bottom']['print barcodes']);
	unset($final_options['links']['bottom']['print barcodes']);
	
	if(!empty($tissue_tubes_for_embedding) || !empty($tissue_blocks_for_sampling_and_processing)) {
		if(!empty($tissue_tubes_for_embedding)) $final_options['links']['bottom']['batch aliquots processing']['oct embedding of biopsies'] = array('icon' => 'aliquot', 'link' => '/InventoryManagement/Collections/detail/'.$atim_menu_variables['Collection.id'].'/batchsetVar:tissue_tubes_for_embedding');
		if(!empty($tissue_blocks_for_sampling_and_processing)) $final_options['links']['bottom']['batch aliquots processing']['sampling or processing of oct embedded biopsies'] = array('icon' => 'aliquot', 'link' => '/InventoryManagement/Collections/detail/'.$atim_menu_variables['Collection.id'].'/batchsetVar:tissue_blocks_for_sampling_and_processing');
	}
	