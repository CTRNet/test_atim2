<?php 
$atim_final_structure = $atim_structure;
if(empty($this->data)){
	$final_options = array(
		'type' => 'search',
		'links' => array(
			'top' => '/administrate/users/search/'.AppController::getNewSearchId()
		), 'settings' => array(
			'header' => __('search type', true).": ".__('users', true),
			'actions' => false,
			'return' => true
		)
	);
	
	$final_atim_structure2 = $empty_structure;
	$final_options2 = array(
			'links'		=> array('bottom' => array('new search' => '/administrate/users/search/')),
			'extras'	=> '<div class="ajax_search_results"></div>'
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
			'header' => __('search type', true).": ".__('users', true),
			'return' => true
		)
	);
	
	if(isset($is_ajax)){
		$final_options['settings']['actions'] = false;
	}
	
	$hook_link = $structures->hook('results');
	if( $hook_link ) {
		require($hook_link);
	}
}

$form = $structures->build($atim_final_structure, $final_options);
if(isset($is_ajax)){
	echo json_encode(array('page' => $form, 'new_search_id' => AppController::getNewSearchId()));
}else{
	echo $form;
}

if(isset($final_atim_structure2)){
	$structures->build( $final_atim_structure2, $final_options2 );
}