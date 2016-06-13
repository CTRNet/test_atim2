<?php 

	$add_links = array();
	foreach ( $review_controls as $review_control ) {
		$add_links[ __($review_control['SampleControl']['sample_type']).' - '.__($review_control['SpecimenReviewControl']['review_type']) ] =  '/InventoryManagement/SpecimenReviews/add/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$review_control['SpecimenReviewControl']['id'];
	}
	ksort($add_links);

	$structure_links = array('index'=>array(), 'bottom'=>array());
	$structure_links['index']['detail'] = '/InventoryManagement/SpecimenReviews/detail/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/%%SpecimenReviewMaster.id%%';
	if(!empty($add_links))  { $structure_links['bottom']['add'] = $add_links; }

	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index', 'links'=>$structure_links);
			
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
		
?>