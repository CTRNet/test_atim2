<?php 
	$sidebars->header( $lang );
	$sidebars->cols( $ctrapp_sidebar, $lang );
	$summaries->build( $ctrapp_summary, $lang );
	$menus->tabs( $ctrapp_menu, $lang ); 
?>
	
<?php 

	// -----------------------------
	// 1- Display the form
	// -----------------------------

	$form_type = 'datagrid';

	$form_model = isset($this->params['data']) ? array($this->params['data']) : array($data);
	$form_field = $ctrapp_form_position;
	
	// Add generated fields
	if(isset($parent_coord_x_title) || isset($parent_coord_y_title)) {
		foreach($form_model[0] as $id => $record_data) {
			if(isset($parent_coord_x_title)){
				$form_model[0][$id]['Generated']['parent_coord_x_title'] = $parent_coord_x_title;
			}
			if(isset($parent_coord_y_title)){
				$form_model[0][$id]['Generated']['parent_coord_y_title'] = $parent_coord_y_title;	
			}	
		}
	}
		
	$form_link = array('datagrid' => '/storagelayout/storage_masters/editAliquotPositionInBatch/');

	$form_lang = $lang;

	$form_override = array();
	if(isset($a_coord_x_liste)){
		$form_override['AliquotMaster/storage_coord_x'] = $a_coord_x_liste;
	}
	if(isset($a_coord_y_liste)){
		$form_override['AliquotMaster/storage_coord_y'] = $a_coord_y_liste;
	}
	
	$form_extras = NULL;
	$form_pagination = NULL;
	
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

?>  
		
<?php echo $sidebars->footer($lang); ?>
