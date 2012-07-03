<?php 

	$structure_links = array(
		'top'=>'/Datamart/BatchSets/deleteInBatch/',
		'checklist'=>array('BatchSet.ids][' => '%%BatchSet.id%%'),
		'bottom'=>array('cancel'=>'/Datamart/BatchSets/index/user')
	);
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index', 'data'=>$user_batchsets, 'settings'=>array('header' => __('select batchsets to delete'), 'pagination'=>false, 'form_inputs'=>false), 'links' => $structure_links, 'override' => $structure_override);

	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	

?>