<?php
$final_atim_structure = $atim_structure;
$final_options = null; 
if(empty($this->data)){
	$final_options = array(
		'type' => 'search',
		'links' => array(
			'top' => '/clinicalannotation/participant_messages/search/'.AppController::getNewSearchId(),
			'bottom' => array('new search' => ClinicalannotationAppController::$search_links)
		)
	);
	
	$hook_link = $structures->hook('form');
	if( $hook_link ) {
		require($hook_link);
	}
}else{
	$final_options = array(
		'type' => 'index',
		'links' => array(
			'index' => '/clinicalannotation/participant_messages/detail/%%ParticipantMessage.participant_id%%/%%ParticipantMessage.id%%/'
		)
	);
	
	$hook_link = $structures->hook('results');
	if( $hook_link ) {
		require($hook_link);
	}
}

$structures->build($final_atim_structure, $final_options);