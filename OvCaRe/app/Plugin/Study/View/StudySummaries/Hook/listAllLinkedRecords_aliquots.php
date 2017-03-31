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
	