<?php 
	$sidebars->header( $lang );
	$sidebars->cols( $ctrapp_sidebar, $lang );
	$summaries->build( $ctrapp_summary, $lang );
	$menus->tabs( $ctrapp_menu, $lang ); 
?>

<?php

	// -----------------------------
	// 1- Display storage aliquots
	// list
	// -----------------------------

	$form_type = 'index';
	
	$form_model = $storage_aliquots;
	$form_field = $ctrapp_form;
	
	// Add generated fields when we display chidlren storage
	if(isset($storage_coord_x_title) || isset($storage_coord_y_title)) {
		foreach($form_model as $id => $record_data) {
			if(isset($storage_coord_x_title)){
				$form_model[$id]['Generated']['parent_coord_x_title'] = $storage_coord_x_title;
			}
			if(isset($storage_coord_y_title)){
				$form_model[$id]['Generated']['parent_coord_y_title'] = $storage_coord_y_title;	
			}	
		}
	}

	$form_link = array(
		'plugin inventorymanagement aliquot detail' => '/inventorymanagement/aliquot_masters/detailAliquotFromId/',
		'set position' => '/storagelayout/storage_masters/editAliquotPosition/StorageAliquotsList/');
	
	$form_lang = $lang;
	
	$form_pagination = null;	
	$form_override = null;	
	$form_extras = null;
	
	// look for CUSTOM HOOKS, "format"
	if (file_exists($custom_ctrapp_view_hook)) { 
		require($custom_ctrapp_view_hook); 
	}
	
	$forms->build( 
		$form_type, 
		$form_model, 
		$form_field, 
		$form_link, 
		$form_lang, 
		$form_pagination, 
		$form_override, 
		$form_extras); 

	// -----------------------------
	// 2- Display button to manage 
	// aliquots in batch
	// -----------------------------
	
	if(!empty($form_model)){
		
		// manually build ACTION BAR
			
		$action_bar_links = array(
			'manage aliquots in batch'	=>	'/storagelayout/storage_masters/editAliquotPositionInBatch/'.$storage_master_id.'/'
		);
	
		echo $forms->generate_links_list( array(), $action_bar_links, $lang );
		
	}
	
?>

<?php echo $sidebars->footer($lang); ?>
