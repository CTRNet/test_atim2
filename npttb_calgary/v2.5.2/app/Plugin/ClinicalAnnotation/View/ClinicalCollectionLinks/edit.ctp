<?php 
	$structure_links = array(
		'top'=> '/ClinicalAnnotation/ClinicalCollectionLinks/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'],
		'radiolist' => array(
				'Collection.id'=>'%%Collection.id%%'
			),
	);
	$structure_settings = array(
		'form_bottom'	=> false, 
		'form_inputs'	=> false,
		'actions'		=> false,
		'pagination'	=> false,
		'header' 	=> __('collection')
	);
	
	// ************** 1- COLLECTION **************
	
	
	$final_atim_structure = $atim_structure_collection_detail; 
	$final_options = array(
		'type'		=> 'index', 
		'data'		=> array($collection_data), 
		'settings'	=> $structure_settings, 
		'links'		=> $structure_links, 
	);

	// CUSTOM CODE
	$hook_link = $this->Structures->hook('collection_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options ); 
	
	require('add_edit.php');
?>
<script>
var treeView = true;
</script>