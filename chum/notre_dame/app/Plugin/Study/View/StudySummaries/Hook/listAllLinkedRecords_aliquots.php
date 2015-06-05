<?php

	$participant_final_options = array(
		'type' => 'detail',
		'links'	=> array(),
		'settings' => array(
			'header' => __('participants', null),
			'actions'	=> false), 
		'extras' => $link_permissions['participant']? array('end' => $this->Structures->ajaxIndex('Study/StudySummaries/listAllLinkedParticipants/'.$atim_menu_variables['StudySummary.id'])) : __('You are not authorized to access that location.')
	);
	$this->Structures->build( $final_atim_structure, $participant_final_options );	
	
	$consent_final_options = array(
			'type' => 'detail',
			'links'	=> array(),
			'settings' => array(
				'header' => __('consents', null),
				'actions'	=> false),
			'extras' => $link_permissions['consent']? array('end' => $this->Structures->ajaxIndex('Study/StudySummaries/listAllLinkedConsents/'.$atim_menu_variables['StudySummary.id'])) : __('You are not authorized to access that location.')
	);
	$this->Structures->build( $final_atim_structure, $consent_final_options );
	