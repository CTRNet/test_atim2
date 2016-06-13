<?php
 	$settings = array('return' => true);
	if(isset($is_ccl_ajax)){
		$structure_links = array('radiolist' => array("Collection.id" => "%%ViewCollection.collection_id%%"));
		$final_options = array(
			'type' => 'index', 
			'data' => $this->request->data, 
			'links' => $structure_links, 
			'settings' => array('pagination' => false, 'actions' => false, 'return' => true)
		);
		if(isset($overflow)){
			?>
			<ul class="error">
				<li><?php echo(__("the query returned too many results").". ".__("try refining the search parameters")); ?>.</li>
			</ul>
			<?php 
		}
		
	}else{
		if(isset($is_ajax)){
			$settings['actions'] = false;
		}else{
			$settings['header'] = array(
				'title' => __('search type', null).': '.__('collections', null),
				'description' => __("more information about the types of samples and aliquots are available %s here", $help_url)
			);
		}
		include('search_links_n_options.php');
	}
	
	$final_atim_structure = $atim_structure;
	
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	$form = $this->Structures->build( $final_atim_structure, $final_options );
	if(isset($is_ajax) && !isset($is_ccl_ajax)){
		$this->layout = 'json';
		$this->json = array('page' => $form, 'new_search_id' => AppController::getNewSearchId());
	}else{
		echo $form;
	}
				
?>
