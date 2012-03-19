<?php 
	$structure_links = array(
		'top'=>NULL,
		'bottom'=>array(
			'edit'=>'/ClinicalAnnotation/ConsentMasters/edit/'.$atim_menu_variables['Participant.id'].'/%%ConsentMaster.id%%/',
			'delete'=>'/ClinicalAnnotation/ConsentMasters/delete/'.$atim_menu_variables['Participant.id'].'/%%ConsentMaster.id%%/',
			'list'=>'/ClinicalAnnotation/ConsentMasters/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structure_settings = array('header' => __($consent_type, null), 'actions' => $is_ajax);
			
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'settings'=>$structure_settings);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
	if(!$is_ajax){
		$final_atim_structure = array();
		$final_options['settings']['header'] = __('links to collections');
		$final_options['settings']['actions'] = true;
		$final_options['extras'] = $this->Structures->extraAjaxLink('ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$atim_menu_variables['Participant.id'].'/noActions:/filterModel:ConsentMaster/filterId:'.$atim_menu_variables['ConsentMaster.id']);
		
		$hook_link = $this->Structures->hook('ccl');
		if( $hook_link ) {
			require($hook_link);
		}
		
		$this->Structures->build(array(), $final_options);
	}
