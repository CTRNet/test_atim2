<?php

	$add_links = array();
	
	foreach ($lab_book_controls_list as $control) {
		$add_links[__($control['LabBookControl']['book_type'])] = '/labbook/LabBookMasters/add/' . $control['LabBookControl']['id'];
	}
	ksort($add_links);
	
	$structure_links = array(
		'index' => array('detail' => '/labbook/LabBookMasters/detail/%%LabBookMaster.id%%'),
		'bottom' => array(
			'new search' => array('link' => '/labbook/LabBookMasters/index', 'icon' => 'search'), 
			'add' => $add_links
		)
	);
	
	$settings = array('return' => true);
	if(isset($is_ajax)){
		$settings['actions'] = false;
	}
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'index', 
		'links' => $structure_links,
		'settings' => $settings
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$form = $this->Structures->build( $final_atim_structure, $final_options );
	if(isset($is_ajax)){
		echo json_encode(array(
			'page' => $this->Shell->validationHtml().$form, 
			'new_search_id' => AppController::getNewSearchId()
		));
	}else{
		echo $form;
	}
	
?>