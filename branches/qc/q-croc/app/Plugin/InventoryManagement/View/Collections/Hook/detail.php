<?php 
	unset($structure_links['bottom']['print barcodes']);
	unset($final_options['links']['bottom']['print barcodes']);
	
	$tmp_batch_actions = array();
	if(isset($tissue_tubes_for_transfering)) $tmp_batch_actions['batch aliquots processing']['tissue tubes transferring'] = array('icon' => 'aliquot', 'link' => '/InventoryManagement/Collections/detail/'.$atim_menu_variables['Collection.id'].'/batchsetVar:tissue_tubes_for_transfering');
	if(isset($tissue_tubes_for_embedding)) $tmp_batch_actions['batch aliquots processing']['oct embedding of biopsies'] = array('icon' => 'aliquot', 'link' => '/InventoryManagement/Collections/detail/'.$atim_menu_variables['Collection.id'].'/batchsetVar:tissue_tubes_for_embedding');
	if(isset($tissue_blocks_for_sampling_and_processing)) $tmp_batch_actions['batch aliquots processing']['sampling or processing of oct embedded biopsies'] = array('icon' => 'aliquot', 'link' => '/InventoryManagement/Collections/detail/'.$atim_menu_variables['Collection.id'].'/batchsetVar:tissue_blocks_for_sampling_and_processing');
	if($tmp_batch_actions) $final_options['links']['bottom'] = array_merge($final_options['links']['bottom'], $tmp_batch_actions);
	