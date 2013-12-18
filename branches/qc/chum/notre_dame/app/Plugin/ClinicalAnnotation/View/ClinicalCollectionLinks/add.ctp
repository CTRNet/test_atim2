<?php
	//Collection-------------
	$structure_links = array(
		'top'=> '/ClinicalAnnotation/ClinicalCollectionLinks/add/'.$atim_menu_variables['Participant.id'].'/',
		'radiolist' => array(
				'Collection.id'=>'%%Collection.id%%'
			),
		'bottom' => array('cancel' => '/ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$atim_menu_variables['Participant.id'].'/')
	);
	$structure_settings = array(
		'form_bottom'	=> false, 
		'form_inputs'	=> false,
		'actions'		=> false,
		'pagination'	=> false,
		'header'		=> __('collection to link', null)
	);
	$structure_override = array();

	$final_options = array(
		'settings' => $structure_settings, 
		'links' => $structure_links, 
		'override' => $structure_override, 
		'extras' => array(
			'start' => '<input type="radio" id="collection_new" name="data[Collection][id]" value="" data-json="'.htmlentities('{"id" : "'.$collection_id.'"}').'"/>'.__('new collection').'<div id="collection_frame"></div>
			<div class="loading">'.__('loading').'</div>',
			'end'	=> '<span class="button"><a id="collection_search" href="#">'.__('search').'</a></span>'
		)
	);

	// CUSTOM CODE
	$hook_link = $this->Structures->hook('collection_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $empty_structure, $final_options );
	
	require('add_edit.php');
?>

<div id="popup" class="std_popup question">
	
</div>

<script>
var ccl = true;
var treeView = true;
</script>