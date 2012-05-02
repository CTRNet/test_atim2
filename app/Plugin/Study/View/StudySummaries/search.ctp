<?php 
	$structure_links = array(
		'index'=>array('detail' => '/Study/StudySummaries/detail/%%StudySummary.id%%'),
		'bottom' => array(
			'add'=> '/Study/StudySummaries/add/'
		)
	);
	
	$settings = array('return' => true);
	if(isset($is_ajax)){
		$settings['actions'] = false;
	}else{
		$settings['header'] = __('search type', null).': '.__('study and project', null);
	}
	
	// Set form structure and option 
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
		echo json_encode(array('page' => $this->Shell->validationHtml().$form, 'new_search_id' => AppController::getNewSearchId()));
	}else{
		echo $form;
	}
?>
