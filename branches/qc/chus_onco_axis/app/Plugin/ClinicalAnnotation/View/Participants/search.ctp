<?php 
	require('search_links_n_options.php');		
	// BUILD FORM
	$form = $this->Structures->build( $final_atim_structure, $final_options );
	if(isset($is_ajax)){
		$this->layout = 'json';
		$this->json = array('page' => $form, 'new_search_id' => AppController::getNewSearchId());
	}else{
		echo $form;
	}
?>
