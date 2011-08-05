<?php 
$atim_final_structure = $atim_structure;
if(empty($this->data)){
	$final_options = array(
		'type' => 'search',
		'links' => array(
			'top' => '/administrate/users/search/'.AppController::getNewSearchId()
		), 'settings' => array(
			'header' => __('search type', true).": ".__('users', true)
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
			'bottom' => array('new search' => '/administrate/users/search/'),
			'index' => array('detail' => '/administrate/users/detail/%%User.group_id%%/%%User.id%%/')
	), 'settings' => array(
			'header' => __('search type', true).": ".__('users', true)
		)
	);
	
	$hook_link = $structures->hook('results');
	if( $hook_link ) {
		require($hook_link);
	}
}

$structures->build($atim_final_structure, $final_options);