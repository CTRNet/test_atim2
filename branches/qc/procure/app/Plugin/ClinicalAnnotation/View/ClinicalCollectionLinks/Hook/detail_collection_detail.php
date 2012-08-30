<?php
	$final_options['settings']['actions'] = true;
	$final_options['settings']['form_bottom'] = true;
	$final_options['links']['bottom'] = array(
			'delete'	=> '/ClinicalAnnotation/ClinicalCollectionLinks/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'],
			'list'		=> '/ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$atim_menu_variables['Participant.id'].'/',
			'details' => array('collection'=> '/InventoryManagement/Collections/detail/'.$atim_menu_variables['Collection.id']),
			'copy for new collection'	=> array('link' => '/InventoryManagement/collections/add/0/'.$atim_menu_variables['Collection.id'], 'icon' => 'copy')
	);