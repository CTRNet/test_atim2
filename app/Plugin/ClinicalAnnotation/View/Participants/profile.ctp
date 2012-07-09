<?php
	$identifiers_menu = array();
	$link_availability = AppController::checkLinkPermission('/ClinicalAnnotation/MiscIdentifiers/reuse/');
	$sort_0 = array();
	$sort_1 = array();
	foreach($identifier_controls_list as &$option){
		$option['MiscIdentifierControl']['misc_identifier_name'] = __($option['MiscIdentifierControl']['misc_identifier_name']);
		$sort_0[] = $option['MiscIdentifierControl']['display_order'];
		$sort_1[] = $option['MiscIdentifierControl']['misc_identifier_name']; 
	}
	array_multisort($sort_0, SORT_ASC, $sort_1, SORT_ASC, $identifier_controls_list);
		
	foreach($identifier_controls_list as $new_option){
		$identifiers_menu[$new_option['MiscIdentifierControl']['misc_identifier_name']] =
		isset($new_option['reusable']) && $link_availability ?
		'javascript:miscIdPopup('.$atim_menu_variables['Participant.id'].' ,'.$new_option['MiscIdentifierControl']['id'].');' :
		'/ClinicalAnnotation/MiscIdentifiers/add/'.$atim_menu_variables['Participant.id'].'/'.$new_option['MiscIdentifierControl']['id'].'/';
	}
	
	if(empty($identifiers_menu)){
		$identifiers_menu = '/underdev/';
	}

	// 1- PARTICIPANT PROFILE
	$structure_links = array(
		'index'=>array(),
		'bottom'=>array(
			'edit'			=> '/ClinicalAnnotation/Participants/edit/'.$atim_menu_variables['Participant.id'],
			'delete'		=> '/ClinicalAnnotation/Participants/delete/'.$atim_menu_variables['Participant.id'],
			'add identifier'=> $identifiers_menu
		)
	);
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'detail',
		'links'	=> $structure_links, 
		'settings' => array('actions' => false)
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
	
if(!$is_ajax){	
	
	// 2- PARTICIPANT IDENTIFIER
	$structure_links['index'] = array(
		'edit'		=> '/ClinicalAnnotation/MiscIdentifiers/edit/'.$atim_menu_variables['Participant.id'].'/%%MiscIdentifier.id%%/',
		'delete'	=> '/ClinicalAnnotation/MiscIdentifiers/delete/'.$atim_menu_variables['Participant.id'].'/%%MiscIdentifier.id%%/',
	);
	
	
	$final_options = array(
		'links'	=> $structure_links, 
		'settings' => array('header' => __('misc identifiers', null)),
	);
	if(AppController::checkLinkPermission('ClinicalAnnotation/MiscIdentifiers/listall/')){
		$final_options['type'] = 'index';
		$final_options['data'] = $participant_identifiers_data;
		$final_atim_structure = $atim_structure_for_misc_identifiers;
	}else{
		$final_atim_structure = $empty_structure;
		$final_options['type'] = 'detail';
		$final_options['data'] = array();
		$final_options['extras'] = '<div>'.__('You are not authorized to access that location.').'</div>';
	}
		
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('identifiers');
	if( $hook_link ) { 
		require($hook_link); 
	}

	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	

}
?>
<script>
var STR_MISC_IDENTIFIER_REUSE = "<?php echo __('misc_identifier_reuse'); ?>";
var STR_NEW = "<?php echo __('new'); ?>";
var STR_REUSE = "<?php echo __('reuse'); ?>";
</script>