<?php 
$atim_final_structure = $atim_structure;
if(empty($this->request->data) && !$search_id){
	$final_options = array(
		'type' => 'search',
		'links' => array(
			'top' => '/Administrate/AdminUsers/search/'.AppController::getNewSearchId()
		), 'settings' => array(
			'header' => __('search type').": ".__('users'),
			'actions' => false,
			'return' => true
		)
	);
	
	$final_atim_structure2 = $empty_structure;
	$final_options2 = array(
			'links'		=> array('bottom' => array()),
			'extras'	=> '<div class="ajax_search_results"></div>'
	);
	
	$hook_link = $this->Structures->hook('form');
	if( $hook_link ) {
		require($hook_link);
	}
	
}else{
	$final_options = array(
		'type' => 'index',
		'links' => array(
			'bottom' => array(),
			'index' => array('detail' => '/Administrate/AdminUsers/detail/%%User.group_id%%/%%User.id%%/')
		), 'settings' => array(
			'return' => true
		)
	);
	
	if(isset($is_ajax)){
		$final_options['settings']['actions'] = false;
	}
	
	$hook_link = $this->Structures->hook('results');
	if( $hook_link ) {
		require($hook_link);
	}
}

$form = $this->Structures->build($atim_final_structure, $final_options);
if(isset($is_ajax)){
	$this->layout = 'json';
	$this->json = array('page' => $form, 'new_search_id' => AppController::getNewSearchId());
}else{
	echo $form;
}

if(isset($final_atim_structure2)){
	$this->Structures->build( $final_atim_structure2, $final_options2 );
}